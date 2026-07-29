import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/transport_provider.dart';
import 'package:homework/generated/sdk/content/v1/content.connect.client.dart';

final contentApiProvider = Provider<ContentServiceClient>((ref) {
  final transport = ref.watch(transportProvider);
  return ContentServiceClient(transport);
});
