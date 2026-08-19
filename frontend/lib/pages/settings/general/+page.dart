import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/basepath.provider.notifier.dart';
import 'package:homework/common/api/token.provider.dart';
import 'package:homework/common/utils/result.dart';
import 'package:homework/components/theme/design_system.dart';

class SettingsGeneralPage extends ConsumerStatefulWidget {
  const SettingsGeneralPage({super.key});

  @override
  ConsumerState<SettingsGeneralPage> createState() => _SettingsGeneralPageState();
}

class _SettingsGeneralPageState extends ConsumerState<SettingsGeneralPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final currentPath = ref.read(basePathNotifierProvider);
    _controller = TextEditingController(text: currentPath);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure app settings and connection preferences.',
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
                    'API Configuration',
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base * 2),
                  Text(
                    'Enter the base path for your backend service.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base * 3),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'API Base Path',
                      hintText: 'e.g., localhost:9911 or http://10.0.2.2:9911',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base * 4),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final text = _controller.text.trim();
                            if (text.isEmpty) return;

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Verifying connection...'),
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }

                            final result = await ref.read(basePathNotifierProvider.notifier).setBasePath(text);
                            if (context.mounted) {
                              switch (result) {
                                case Ok(:final value):
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('API Base Path updated successfully to: $value'),
                                      backgroundColor: AppColors.surfaceContainerHigh,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                case Error(:final error):
                                  final errorMsg = error.toString().replaceFirst('Exception: ', '');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to update base path: $errorMsg'),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                              }
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Save Changes'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                    'Local Data',
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base * 2),
                  Text(
                    'Clear all cached local data, including the API base path and your authentication token.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base * 4),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: AppColors.onError,
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColors.level2,
                                title: const Text('Clear Local Data'),
                                content: const Text(
                                  'Are you sure you want to clear all local data? '
                                  'This will reset your API base path and remove your authentication token.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.error,
                                    ),
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Clear'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true && context.mounted) {
                              await ref.read(basePathNotifierProvider.notifier).clear();
                              await ref.read(authTokenProvider.notifier).clear();
                              _controller.text = ref.read(basePathNotifierProvider);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Local data cleared successfully'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Clear Local Data'),
                          ),
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
