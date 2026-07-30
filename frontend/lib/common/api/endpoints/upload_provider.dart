import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/basepath_provider.dart';
import 'package:homework/common/api/runner.dart';
import 'package:homework/common/result/result.dart';
import 'package:homework/common/http/http_client_progress.dart';
import 'package:homework/common/api/endpoints/upload_dto.dart';
import 'package:http/http.dart' as http;

final uploadServiceProvider = Provider<UploadService>((ref) {
  final basePath = ref.watch(basePathProvider);
  return UploadService(basePath: basePath);
});

class UploadService {
  final String basePath;

  UploadService({required this.basePath});

  Future<ErrorResult<void>> upload({
    required UploadDto dto,
    required void Function(int bytesSent, int totalBytes) onProgress,
  }) async {
    return runReq(() async {
      final file = File(dto.filePath);
      if (!file.existsSync()) {
        throw Exception("File not found at path: ${dto.filePath}");
      }

      final url = Uri.parse('$basePath/upload/file');

      final request = MultipartRequestWithProgress(
        'POST',
        url,
        onProgress: onProgress,
      );

      request.fields['title'] = dto.title;
      request.fields['desc'] = dto.desc;
      request.fields['filename'] = dto.fileName;
      request.fields['assetType'] = dto.assetType;
      request.fields['assetRole'] = dto.assetRole;
      request.fields['contentType'] = dto.contentType;

      final multipartFile = await http.MultipartFile.fromPath(
        'uploadFile',
        dto.filePath,
      );
      request.files.add(multipartFile);

      final response = await request.send();

      if (response.statusCode != 200) {
        final body = await response.stream.bytesToString();
        throw Exception('Server error (${response.statusCode}): $body');
      }
    });
  }
}
