import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/basepath_provider.dart';

final assetServiceProvider = Provider<AssetService>((ref) {
  final basePath = ref.watch(basePathProvider);
  return AssetService(basePath: basePath);
});

class AssetService {
  final String basePath;

  static const assetBase = "/assets";

  AssetService({required this.basePath});

  String load({required int contentId, required String assetRole}) {
    final base = Uri.parse('$basePath$assetBase/load');
    final params = {"contentId": contentId, "assetRole": assetRole};
    final uri = base.replace(
      queryParameters: params.map((k, v) => MapEntry(k, v.toString())),
    );

    return uri.toString();
  }
}
