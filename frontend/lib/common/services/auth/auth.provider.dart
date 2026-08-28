import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/transport.provider.dart';
import 'package:homework/generated/sdk/auth/v1/auth.connect.client.dart';

final authApiProvider = Provider<AuthServiceClient>((ref) {
  final transport = ref.watch(publicTransportProvider);
  return AuthServiceClient(transport);
});
