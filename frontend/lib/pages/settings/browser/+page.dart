import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/runner.dart';
import 'package:homework/common/services/browser/browser.provider.dart';
import 'package:homework/common/utils/result.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/generated/sdk/browser/v1/browser.pb.dart';

class SettingsBrowserPage extends ConsumerStatefulWidget {
  const SettingsBrowserPage({super.key});

  @override
  ConsumerState<SettingsBrowserPage> createState() => _SettingsBrowserPageState();
}

class _SettingsBrowserPageState extends ConsumerState<SettingsBrowserPage> {
  bool _isLoading = false;

  Future<void> _startBrowser() async {
    setState(() {
      _isLoading = true;
    });

    final resp = await runReq(
      () => ref.read(browserApiProvider).start(StartRequest()),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    switch (resp) {
      case Ok():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Browser started successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      case Error(:final error):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start browser: $error'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
          ),
        );
    }
  }

  Future<void> _stopBrowser() async {
    setState(() {
      _isLoading = true;
    });

    final resp = await runReq(
      () => ref.read(browserApiProvider).stop(StopRequest()),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    switch (resp) {
      case Ok():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Browser stopped successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      case Error(:final error):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to stop browser: $error'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure internal browser settings and preferences.',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.base * 4),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Browser Session Control',
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base * 2),
                  Text(
                    'Manage the background browser process.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base * 3),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _startBrowser,
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Start Browser'),
                      ),
                      const SizedBox(width: AppSpacing.base * 2),
                      OutlinedButton.icon(
                        onPressed: _isLoading ? null : _stopBrowser,
                        icon: const Icon(Icons.stop_rounded),
                        label: const Text('Stop Browser'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
