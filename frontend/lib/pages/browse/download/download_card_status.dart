import 'package:flutter/material.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.pb.dart';


class StatusChip extends StatelessWidget {
  final DownloadState state;

  const StatusChip({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;
    IconData icon;

    switch (state) {
      case DownloadState.DOWNLOAD_STATE_QUEUED:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        label = 'Queued';
        icon = Icons.hourglass_empty;
      case DownloadState.DOWNLOAD_STATE_DOWNLOADING:
        backgroundColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        label = 'Downloading';
        icon = Icons.downloading;
      case DownloadState.DOWNLOAD_STATE_SUCCESS:
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        label = 'Success';
        icon = Icons.check_circle_outline;
      case DownloadState.DOWNLOAD_STATE_ERROR:
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        label = 'Error';
        icon = Icons.error_outline;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        label = 'Unknown';
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withAlpha(51)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
