// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UploadJob _$UploadJobFromJson(Map<String, dynamic> json) => _UploadJob(
  id: json['id'] as String,
  dto: UploadDto.fromJson(json['dto'] as Map<String, dynamic>),
  progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
  status: json['status'] as String? ?? 'pending',
  error: json['error'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UploadJobToJson(_UploadJob instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dto': instance.dto,
      'progress': instance.progress,
      'status': instance.status,
      'error': instance.error,
      'createdAt': instance.createdAt.toIso8601String(),
    };
