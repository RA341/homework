import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/transport_provider.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.connect.client.dart';

final downloaderApiProvider = Provider<DownloaderServiceClient>((ref) {
  final transport = ref.watch(transportProvider);
  return DownloaderServiceClient(transport);
});
