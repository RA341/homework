import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/basepath.provider.dart';
import 'package:homework/common/utils/result.dart';
import 'package:homework/components/theme/design_system.dart';

class LoginUrlPage extends ConsumerStatefulWidget {
  const LoginUrlPage({super.key});

  @override
  ConsumerState<LoginUrlPage> createState() => _LoginUrlPageState();
}

class _LoginUrlPageState extends ConsumerState<LoginUrlPage> {
  late final TextEditingController _controller;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Default to the current path stored/configured (or empty)
    final currentPath = ref.read(basePathProvider);
    _controller = TextEditingController(text: currentPath == 'http://localhost:9911' ? '' : currentPath);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleConnect() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorMessage = 'Connection URL cannot be empty';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await ref.read(basePathProvider.notifier).setBasePath(text);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      switch (result) {
        case Ok(:final value):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully connected to: $value'),
              backgroundColor: AppColors.primaryContainer,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // GoRouter will automatically redirect since isUrlVerifiedProvider updates to true.
        case Error(:final error):
          setState(() {
            _errorMessage = error.toString().replaceFirst('Exception: ', '');
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Heading
        Text(
          'Connect Backend',
          style: AppTypography.headlineLg.copyWith(
            color: AppColors.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Enter the base path of your API service. We will ping the server to verify connectivity.',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.base * 4),
        TextField(
          controller: _controller,
          enabled: !_isLoading,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _handleConnect(),
          decoration: InputDecoration(
            labelText: 'API Base URL',
            hintText: 'e.g., localhost:9911 or http://10.0.2.2:9911',
            prefixIcon: const Icon(Icons.link, color: AppColors.outline),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _controller.clear();
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (_) {
            if (_errorMessage != null) {
              setState(() {
                _errorMessage = null;
              });
            }
          },
        ),
        if (_errorMessage != null) ...[
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
                    _errorMessage!,
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
          onPressed: _isLoading ? null : _handleConnect,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: _isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                    ),
                  )
                : const Text('Connect to Server'),
          ),
        ),
        const SizedBox(height: AppSpacing.base * 3),
        // Footer details
        Center(
          child: Text(
            'Default: http://localhost:9911',
            style: AppTypography.labelMd.copyWith(
              color: AppColors.onSurfaceVariant.withAlpha(120),
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
