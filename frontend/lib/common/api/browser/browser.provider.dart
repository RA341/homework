import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/basepath_provider.dart';
import 'package:homework/common/api/transport_provider.dart';
import 'package:homework/generated/sdk/browser/v1/browser.connect.client.dart';

final browserApiProvider = Provider<BrowserServiceClient>((ref) {
  final transport = ref.watch(protectedTransportProvider);
  return BrowserServiceClient(transport);
});

final browserVncLinkProvider = Provider<Uri>((ref) {
  final transport = ref.watch(basePathProvider);
  final l = "$transport/browser/vnc";

  return Uri.parse(l);
});

