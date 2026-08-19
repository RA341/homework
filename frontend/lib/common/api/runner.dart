import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:homework/common/utils/result.dart';

Future<ErrorResult<T>> runReq<T>(Future<T> Function() runner,) async {
  try {
    final value = await runner();
    return Ok(value);
  } catch (e) {
     return Error(e.toString());
  }
}

class RunnerResult<T> {
  final T? data;
  final Object? error;
  final bool loading;
  final Future<void> Function(Future<T> Function()) execute;

  RunnerResult({
    required this.data,
    required this.error,
    required this.loading,
    required this.execute,
  });
}

RunnerResult<T> useRunner<T>() {
  final data = useState<T?>(null);
  final error = useState<Object?>(null);
  final loading = useState(false);

  final execute = useCallback((Future<T> Function() task) async {
    loading.value = true;
    error.value = null;
    try {
      data.value = await task();
    } catch (e) {
      error.value = e;
    } finally {
      loading.value = false;
    }
  }, []);

  return RunnerResult(
    data: data.value,
    error: error.value,
    loading: loading.value,
    execute: execute,
  );
}