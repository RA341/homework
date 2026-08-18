// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload.provider.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UploadDto _$UploadDtoFromJson(Map<String, dynamic> json) => _UploadDto(
  title: json['title'] as String,
  desc: json['desc'] as String,
  fileName: json['fileName'] as String,
  assetType: json['assetType'] as String,
  assetRole: json['assetRole'] as String,
  contentType: json['contentType'] as String,
  filePath: json['filePath'] as String,
);

Map<String, dynamic> _$UploadDtoToJson(_UploadDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'desc': instance.desc,
      'fileName': instance.fileName,
      'assetType': instance.assetType,
      'assetRole': instance.assetRole,
      'contentType': instance.contentType,
      'filePath': instance.filePath,
    };
