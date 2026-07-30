import 'package:homework/common/result/result.dart';

Future<ErrorResult<T>> runReq<T>(Future<T> Function() runner,) async {
  try {
    final value = await runner();
    return Ok(value);
  } catch (e) {
     return Error(e.toString());
  }
}