import 'package:fixnum/fixnum.dart';

const months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatDate(Int64 seconds) {
  if (seconds == Int64.ZERO) return 'Unknown Date';
  final int val = seconds.toInt();
  final DateTime dt = val > 1000000000000
      ? DateTime.fromMillisecondsSinceEpoch(val)
      : DateTime.fromMillisecondsSinceEpoch(val * 1000);

  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
}
