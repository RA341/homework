import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:homework/common/api/upload/upload.provider.dto.dart';

part 'job.freezed.dart';
part 'job.g.dart';

@freezed
abstract class UploadJob with _$UploadJob {
  const factory UploadJob({
    required String id,
    required UploadDto dto,
    @Default(0.0) double progress,
    @Default('pending') String status,
    String? error,
    required DateTime createdAt,
  }) = _UploadJob;

  factory UploadJob.fromJson(Map<String, dynamic> json) =>
      _$UploadJobFromJson(json);
}
