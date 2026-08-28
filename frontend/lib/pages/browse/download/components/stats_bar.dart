import 'package:flutter/material.dart';
import 'package:homework/common/services/download/download.provider.stats.dart';
import 'package:homework/common/utils/formatters.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.pb.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DownloadStatsBar extends ConsumerWidget {
  const DownloadStatsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(downloadStatsProvider);

    return statsAsync.when(
      data: (stats) => _StatsContent(stats: stats),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _StatsContent extends StatelessWidget {
  final StatsResponse stats;

  const _StatsContent({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final avgTime = Duration(seconds: stats.avgTimeLeft.toInt());

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withAlpha(40)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 500;

          if (isCompact) {
            return Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.speed_rounded,
                  label: 'Speed',
                  value: '${formatBytes(stats.sumSpeed.toInt())}/s',
                  color: Colors.blue,
                ),
                _StatItem(
                  icon: Icons.downloading_rounded,
                  label: 'Tasks',
                  value: '${stats.count}',
                  color: Colors.orange,
                ),
                _StatItem(
                  icon: Icons.timer_outlined,
                  label: 'Avg Time Left',
                  value: formatDuration(avgTime),
                  color: Colors.green,
                ),
                _StatItem(
                  icon: Icons.data_usage_rounded,
                  label: 'Total Size',
                  value: formatBytes(stats.totalBytes.toInt()),
                  color: Colors.purple,
                ),
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.downloading_rounded,
                label: 'Downloads',
                value: '${stats.count}',
                color: Colors.orange,
              ),
              _Divider(),
              _StatItem(
                icon: Icons.speed_rounded,
                label: 'Total Speed',
                value: '${formatBytes(stats.sumSpeed.toInt())}/s',
                color: Colors.blue,
              ),
              _Divider(),
              _StatItem(
                icon: Icons.timer_outlined,
                label: 'Avg Time Left',
                value: formatDuration(avgTime),
                color: Colors.green,
              ),
              _Divider(),
              _StatItem(
                icon: Icons.data_usage_rounded,
                label: 'Total Data',
                value: formatBytes(stats.totalBytes.toInt()),
                color: Colors.purple,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 1,
      color: Theme.of(context).dividerColor.withAlpha(40),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(150),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
