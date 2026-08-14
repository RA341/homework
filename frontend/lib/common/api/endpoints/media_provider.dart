
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/transport_provider.dart';
import 'package:homework/generated/sdk/media/v1/media.connect.client.dart';

final mediaApiProvider = Provider<MediaServiceClient>((ref) {
  final transport = ref.watch(transportProvider);
  return MediaServiceClient(transport);
});
