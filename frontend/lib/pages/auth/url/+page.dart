import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:homework/common/api/basepath.provider.notifier.dart';
import 'package:homework/common/api/runner.dart';
import 'package:homework/common/utils/result.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginUrlPage extends HookConsumerWidget {
  const LoginUrlPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Default to the current path stored/configured (or empty)
    final currentBase = ref.watch(basePathNotifierProvider);
    final controller = useTextEditingController(
      text: currentBase.isEmpty ? 'http://localhost:9911' : currentBase,
    );

    // Rebuild widget when text controller changes to update clear suffix icon visibility
    useListenable(controller);

    final runner = useRunner<ErrorResult<String>>();
    final errorMessage = useState<String?>(null);

    final handleConnect = useCallback(() async {
      final text = controller.text.trim();
      if (text.isEmpty) {
        errorMessage.value = 'Connection URL cannot be empty';
        return;
      }

      errorMessage.value = null;

      await runner.execute(() async {
        final result = await ref
            .read(basePathNotifierProvider.notifier)
            .setBasePath(text);
        if (context.mounted) {
          switch (result) {
            case Ok(:final value):
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully connected to: $value'),
                  backgroundColor: AppColors.primaryContainer,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            case Error(:final error):
              errorMessage.value = error.toString().replaceFirst(
                'Exception: ',
                '',
              );
          }
        }
        return result;
      });
    }, [controller, runner]);

    final displayError = errorMessage.value ?? runner.error?.toString();
    final isLoading = runner.loading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Heading
        Text(
          'Connect Homework Server',
          style: AppTypography.headlineLg.copyWith(color: AppColors.onSurface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Enter the base path of your instance. We will ping the server to verify connectivity.',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.base * 4),
        TextField(
          controller: controller,
          enabled: !isLoading,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => handleConnect(),
          decoration: InputDecoration(
            labelText: 'API Base URL',
            hintText: 'e.g., localhost:9911 or http://10.0.2.2:9911',
            prefixIcon: const Icon(Icons.link, color: AppColors.outline),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      controller.clear();
                    },
                  )
                : null,
          ),
          onChanged: (_) {
            if (errorMessage.value != null) {
              errorMessage.value = null;
            }
          },
        ),
        if (displayError != null) ...[
          const SizedBox(height: AppSpacing.base * 2),
          Container(
            padding: const EdgeInsets.all(AppSpacing.base * 1.5),
            decoration: BoxDecoration(
              color: AppColors.errorContainer.withAlpha(35),
              borderRadius: AppShapes.radiusDefault,
              border: Border.all(
                color: AppColors.error.withAlpha(80),
                width: 1.0,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.base * 1.5),
                Expanded(
                  child: Text(
                    displayError,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.error,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.base * 4),
        ElevatedButton(
          onPressed: isLoading ? null : handleConnect,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.onPrimary,
                      ),
                    ),
                  )
                : const Text('Connect to Server'),
          ),
        ),
      ],
    );
  }
}
