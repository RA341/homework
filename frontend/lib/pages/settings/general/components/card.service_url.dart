import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:homework/common/api/basepath.provider.notifier.dart';
import 'package:homework/common/utils/result.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CardServiceUrl extends HookConsumerWidget {
  const CardServiceUrl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = ref.watch(basePathNotifierProvider);
    final controller = useTextEditingController(text: currentPath);

    // Keep the text field in sync if the base path changes externally (e.g. cleared)
    useEffect(() {
      controller.text = currentPath;
      return null;
    }, [currentPath]);

    return Card(
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
              controller: controller,
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
                      final text = controller.text.trim();
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

                      final result = await ref
                          .read(basePathNotifierProvider.notifier)
                          .setBasePath(text);
                      if (context.mounted) {
                        switch (result) {
                          case Ok(:final value):
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'API Base Path updated successfully to: $value',
                                ),
                                backgroundColor: AppColors.surfaceContainerHigh,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          case Error(:final error):
                            final errorMsg = error.toString().replaceFirst(
                              'Exception: ',
                              '',
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Failed to update base path: $errorMsg',
                                ),
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
    );
  }
}
