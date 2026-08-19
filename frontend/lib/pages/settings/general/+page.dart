import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/basepath.provider.dart';
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
    final currentPath = ref.read(basePathProvider);
    _controller = TextEditingController(text: currentPath);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = ref.watch(basePathProvider);

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

                            final result = await ref.read(basePathProvider.notifier).setBasePath(text);
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
            color: AppColors.level1.withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: AppSpacing.base * 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active Backend URL',
                          style: AppTypography.bodySm.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.base),
                        SelectableText(
                          currentPath,
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.primary,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
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
