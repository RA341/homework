import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:homework/common/theme/design_system.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String title;
  final String videoUrl;

  const VideoPlayerScreen({
    super.key,
    required this.title,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final Player player;
  late final VideoController controller;
  bool hasError = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);

    // Listen to errors
    player.stream.error.listen((error) {
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = error.toString();
        });
      }
    });

    // Open media
    player.open(Media(widget.videoUrl));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: AppTypography.bodyMd.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black.withAlpha(128),
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: hasError
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.gutter),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.error,
                        size: 48,
                      ),
                      const SizedBox(height: AppSpacing.base * 2),
                      Text(
                        'Failed to load video',
                        style: AppTypography.headlineLgMobile.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.base),
                      Text(
                        errorMessage ?? 'An unknown error occurred while playing media.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.base * 3),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            hasError = false;
                            errorMessage = null;
                          });
                          player.open(Media(widget.videoUrl));
                        },
                        icon: const Icon(Icons.replay_rounded),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : Video(
                  controller: controller,
                ),
        ),
      ),
    );
  }
}
