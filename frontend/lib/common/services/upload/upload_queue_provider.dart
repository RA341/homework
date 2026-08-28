import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/prefs/prefs.dart';
import 'package:homework/common/services/upload/job.dart';
import 'package:homework/common/services/upload/upload.provider.dart';
import 'package:homework/common/services/upload/upload.provider.dto.dart';
import 'package:homework/common/utils/result.dart';

final uploadQueueProvider =
    NotifierProvider<UploadQueueNotifier, List<UploadJob>>(
      UploadQueueNotifier.new,
    );

class UploadQueueNotifier extends Notifier<List<UploadJob>> {
  bool _isProcessing = false;

  @override
  List<UploadJob> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final list = prefs.getStringList('upload_queue') ?? [];

    final jobs = list
        .map((item) {
          try {
            return UploadJob.fromJson(jsonDecode(item) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<UploadJob>()
        .toList();

    // Auto-resume processing if there are remaining pending uploads.
    Future.microtask(() => _processNextJob());

    return jobs;
  }

  Future<void> addJob(UploadDto dto) async {
    final job = UploadJob(
      id: '${DateTime.now().millisecondsSinceEpoch}_${dto.filePath.hashCode}',
      dto: dto,
      createdAt: DateTime.now(),
    );

    state = [...state, job];
    await _saveQueue();
    _processNextJob();
  }

  Future<void> _saveQueue() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final list = state.map((job) => jsonEncode(job.toJson())).toList();
    await prefs.setStringList('upload_queue', list);
  }

  Future<void> removeJob(String id) async {
    state = state.where((j) => j.id != id).toList();
    await _saveQueue();
  }

  Future<void> clearCompleted() async {
    state = state.where((j) => j.status != 'completed').toList();
    await _saveQueue();
  }

  Future<void> retryJob(String id) async {
    state = state.map((j) {
      if (j.id == id) {
        return j.copyWith(status: 'pending', progress: 0.0, error: null);
      }
      return j;
    }).toList();
    await _saveQueue();
    _processNextJob();
  }

  Future<void> _processNextJob() async {
    if (_isProcessing) return;

    final nextJobIndex = state.indexWhere((j) => j.status == 'pending');
    if (nextJobIndex == -1) {
      return;
    }

    _isProcessing = true;
    final job = state[nextJobIndex];

    state = state.map((j) {
      if (j.id == job.id) {
        return j.copyWith(status: 'uploading', progress: 0.0);
      }
      return j;
    }).toList();
    await _saveQueue();

    final uploadService = ref.read(uploadServiceProvider);

    final result = await uploadService.upload(
      dto: job.dto,
      onProgress: (bytesSent, totalBytes) {
        final progress = totalBytes > 0 ? bytesSent / totalBytes : 0.0;
        state = state.map((j) {
          if (j.id == job.id) {
            return j.copyWith(progress: progress);
          }
          return j;
        }).toList();
      },
    );

    switch (result) {
      case Ok():
        state = state.map((j) {
          if (j.id == job.id) {
            return j.copyWith(status: 'completed', progress: 1.0);
          }
          return j;
        }).toList();
      case Error(:final error):
        final err = error.replaceFirst('Exception: ', '');
        state = state.map((j) {
          if (j.id == job.id) {
            return j.copyWith(status: 'failed', error: err);
          }
          return j;
        }).toList();
    }

    await _saveQueue();
    _isProcessing = false;
    // Yield execution then process the next one
    Future.delayed(const Duration(milliseconds: 100), () => _processNextJob());
  }
}
