import 'package:homework/generated/sdk/media/v1/media.pbenum.dart';

String pbEnumToStr(String raw, String prefix) {
  raw = raw.replaceFirst(prefix, "");
  raw = raw[0] + raw.substring(1).toLowerCase();
  return raw;
}

String getContentTypeName(ContentType type) {
  return pbEnumToStr(type.name, "CONTENT_TYPE_");
}

String getAssetTypeName(AssetType type) {
  return pbEnumToStr(type.name, "ASSET_TYPE_");
}

String getAssetRoleName(AssetRole role) {
  return pbEnumToStr(role.name, "ASSET_ROLE_");
}
