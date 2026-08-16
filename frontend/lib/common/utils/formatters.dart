import 'dart:math';

String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);

  final secs = '${s}s';
  if (m == 0) {
    return secs;
  }

  final minSecs = '${m}m $secs';
  if (h == 0) {
    return minSecs;
  }

  return '${h}h $minSecs';
}

String formatBytes(int bytes, [int decimals = 1]) {
  if (bytes <= 0) return '0 B';
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  final i = (log(bytes) / log(1024)).floor();
  final size = bytes / pow(1024, i);
  return '${size.toStringAsFixed(i == 0 ? 0 : decimals)} ${units[i]}';
}
