import 'package:flutter/material.dart';
import 'package:homework/common/utils/formatters.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.pb.dart';

class DownloadProgressDisplay extends StatelessWidget {
  const DownloadProgressDisplay({super.key, required this.progress});

  final DownloadProgress progress;

  @override
  Widget build(BuildContext context) {
    var left = 0;
    var progressState = 0.0;

    if (progressState > 0) {
      left = progress.total.toInt() - progress.complete.toInt();
      progressState = progress.complete.toDouble() / progress.total.toDouble();
    }

    final time = Duration(seconds: progress.timeLeftSecs.toInt());

    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          spacing: 10,
          mainAxisAlignment: .spaceBetween,
          children: [
            Text("Time: ${formatDuration(time)}"),
            Text("Total: ${formatBytes(progress.total.toInt())}"),
            Text(
              "Speed: ${formatBytes(progress.downloadBytesPerSecond.toInt()).toLowerCase()}/s",
            ),
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
                Text('${formatBytes(left)} left'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
