import 'package:flutter/material.dart';
import 'package:homework/common/utils/formatters.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.pb.dart';

class DownloadProgressDisplay extends StatelessWidget {
  const DownloadProgressDisplay({super.key, required this.progress});

  final DownloadProgress progress;

  @override
  Widget build(BuildContext context) {
    final total = progress.complete.toInt() + progress.left.toInt();
    final progressState = total > 0
        ? progress.complete.toDouble() / total
        : 0.0;

    final time = Duration(seconds: progress.timeLeftSecs.toInt());

    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          spacing: 10,
          mainAxisAlignment: .spaceBetween,
          children: [
            Text("Time: ${formatDuration(time)}"),
            Text("Total: ${formatBytes(total)}"),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: progressState),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${formatBytes(progress.complete.toInt())} complete'),
                Text('${formatBytes(progress.left.toInt())} left'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
