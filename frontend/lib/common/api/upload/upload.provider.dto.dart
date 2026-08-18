import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload.provider.dto.freezed.dart';
part 'upload.provider.dto.g.dart';

@freezed
abstract class UploadDto with _$UploadDto {
  const factory UploadDto({
    required String title,
    required String desc,
    required String fileName,
    required String assetType,
    required String assetRole,
    required String contentType,
    required String filePath,
  }) = _UploadDto;

  factory UploadDto.fromJson(Map<String, dynamic> json) =>
      _$UploadDtoFromJson(json);
}
