import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/services/browser/browser.provider.dart';
import 'package:homework/common/api/runner.dart';
import 'package:homework/common/utils/result.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/components/copy_text.dart';
import 'package:homework/generated/sdk/browser/v1/browser.pb.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenBrowserDialog extends ConsumerStatefulWidget {
  const OpenBrowserDialog({super.key, required this.downloadLink});

  final String downloadLink;

  @override
  ConsumerState<OpenBrowserDialog> createState() => _OpenBrowserDialogState();
}

class _OpenBrowserDialogState extends ConsumerState<OpenBrowserDialog> {
  int _currentStep = 0;
  bool _browserStarted = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    if (_browserStarted) {
      _fireAndForgetStop();
    }
    super.dispose();
  }

  void _fireAndForgetStop() async {
    // _browserStarted = false;
    // try {
    //   await ref.read(browserApiProvider).stop(StopRequest());
    // } catch (_) {}
  }

  Future<void> _startBrowser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
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
        setState(() {
          _browserStarted = true;
          _currentStep = 1;
        });
      case Error(:final error):
        setState(() {
          _errorMessage = "Failed to start browser: $error";
        });
    }
  }

  Future<void> _stopBrowser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
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
        setState(() {
          _browserStarted = false;
        });
        Navigator.of(context).pop();
      case Error(:final error):
        setState(() {
          _errorMessage = "Failed to stop browser: $error";
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isLoading,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && _browserStarted) {
          _fireAndForgetStop();
        }
      },
      child: Dialog(
        backgroundColor: AppColors.level2,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.radiusLg,
          side: const BorderSide(color: AppColors.outlineVariant, width: 1.0),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: AppSpacing.base * 2.5),
                _buildStepProgressBar(),
                const SizedBox(height: AppSpacing.base * 3),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                  child: Container(
                    key: ValueKey<int>(_currentStep),
                    constraints: const BoxConstraints(minHeight: 180),
                    child: _buildStepContent(),
                  ),
                ),
                const SizedBox(height: AppSpacing.base * 2.5),
                if (_errorMessage != null) ...[
                  _buildErrorContainer(),
                  const SizedBox(height: AppSpacing.base * 2.5),
                ],
                _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.open_in_browser_rounded,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.base * 1.5),
            Text(
              'Browser Assistant',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, color: AppColors.outline),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildStepProgressBar() {
    String stepTitle = '';
    switch (_currentStep) {
      case 0:
        stepTitle = 'Step 1: Start the Browser';
      case 1:
        stepTitle = 'Step 2: Copy URL';
      case 2:
        stepTitle = 'Step 3: Paste & Solve';
      case 3:
        stepTitle = 'Step 4: Stop the Browser';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            final isActive = index == _currentStep;
            final isCompleted = index < _currentStep;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : isCompleted
                            ? AppColors.primary.withAlpha(120)
                            : AppColors.outlineVariant,
                        borderRadius: AppShapes.radiusFull,
                      ),
                    ),
                  ),
                  if (index < 3) const SizedBox(width: 6),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          stepTitle,
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStepStartBrowser();
      case 1:
        return _buildStepCopyUrl();
      case 2:
        return _buildStepLaunchBrowser();
      case 3:
        return _buildStepStopBrowser();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStepStartBrowser() {
    return Column(
      key: const ValueKey('step_0'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Start Browser Session',
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'A server-side browser instance is required to access the download. Click "Start Browser" to boot up the browser environment.',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.base * 3),
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _browserStarted
                      ? Colors.green.withAlpha(20)
                      : AppColors.outlineVariant.withAlpha(40),
                  borderRadius: AppShapes.radiusDefault,
                  border: Border.all(
                    color: _browserStarted
                        ? Colors.green.withAlpha(120)
                        : AppColors.outlineVariant,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _browserStarted
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: _browserStarted ? Colors.green : AppColors.outline,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.base),
                    Text(
                      _browserStarted
                          ? 'Browser is Running'
                          : 'Browser is Idle',
                      style: AppTypography.labelMd.copyWith(
                        color: _browserStarted
                            ? Colors.green
                            : AppColors.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.base * 3),
              if (!_browserStarted)
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _startBrowser,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : const Icon(Icons.power_rounded),
                  label: Text(_isLoading ? 'Starting...' : 'Start Browser'),
                )
              else
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentStep = 1;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primary,
                  ),
                  label: const Text(
                    'Proceed to Next Step',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepCopyUrl() {
    return Column(
      key: const ValueKey('step_1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Copy the Download URL',
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Copy the URL below to your clipboard. You will paste this URL in the browser window once it is launched.',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.base * 3),
        Center(
          child: CopyableText(
            text: widget.downloadLink,
            textStyle: AppTypography.bodySm.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepLaunchBrowser() {
    final browserVncLink = ref.watch(browserVncLinkProvider);
    return Column(
      key: const ValueKey('step_2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Launch Browser & Initiate Download',
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Click the button below to open the remote browser window. Once open, paste the link in the address bar and solve any required captchas or prompts to start downloading.',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.base * 3),
        Center(
          child: ElevatedButton.icon(
            onPressed: () async {
              if (!await launchUrl(browserVncLink)) {
                setState(() {
                  _errorMessage =
                      "Could not launch the browser window URL: $browserVncLink";
                });
              }
            },
            icon: const Icon(Icons.launch_rounded),
            label: const Text('Launch Browser Window'),
          ),
        ),
      ],
    );
  }

  Widget _buildStepStopBrowser() {
    return Column(
      key: const ValueKey('step_3'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Stop Browser Session',
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'CRITICAL: You must stop the browser to complete the process. Leaving the browser running can consume unnecessary resources or cause download failures.',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.error,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.base * 3),
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer.withAlpha(20),
                  borderRadius: AppShapes.radiusDefault,
                  border: Border.all(color: AppColors.error.withAlpha(120)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.base),
                    Text(
                      'Browser Session is Active',
                      style: AppTypography.labelMd.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.base * 3),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _stopBrowser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.onError,
                ),
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onError,
                        ),
                      )
                    : const Icon(Icons.stop_rounded),
                label: Text(
                  _isLoading ? 'Stopping...' : 'Stop Browser & Close',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorContainer() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base * 1.5),
      decoration: BoxDecoration(
        color: AppColors.errorContainer.withAlpha(35),
        borderRadius: AppShapes.radiusDefault,
        border: Border.all(color: AppColors.error.withAlpha(80), width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
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
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentStep > 0)
          TextButton.icon(
            onPressed: _isLoading
                ? null
                : () {
                    setState(() {
                      _currentStep--;
                      _errorMessage = null;
                    });
                  },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
              textStyle: AppTypography.labelMd.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: const Text('Back'),
          )
        else
          const SizedBox.shrink(),
        Row(
          children: [
            if (_currentStep < 3)
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.onSurfaceVariant,
                  textStyle: AppTypography.labelMd.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Cancel'),
              ),
            if (_currentStep < 3) const SizedBox(width: AppSpacing.base * 1.5),
            if (_currentStep < 3)
              ElevatedButton(
                onPressed:
                    (_isLoading || (_currentStep == 0 && !_browserStarted))
                    ? null
                    : () {
                        setState(() {
                          _currentStep++;
                          _errorMessage = null;
                        });
                      },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Next'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
