import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:homework/common/theme/design_system.dart';
import 'package:homework/generated/sdk/content/v1/content.pb.dart';
import 'package:homework/pages/home/utils.dart';
import 'package:homework/common/api/endpoints/asset_provider.dart';
import 'package:homework/pages/home/content_browser_provider.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final Content initialItem;
  final String initialVideoUrl;

  const VideoPlayerScreen({
    super.key,
    required this.initialItem,
    required this.initialVideoUrl,
  });

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late final Player player;
  late final VideoController controller;
  bool hasError = false;
  String? errorMessage;

  late Content currentItem;
  late String currentVideoUrl;

  @override
  void initState() {
    super.initState();
    currentItem = widget.initialItem;
    currentVideoUrl = widget.initialVideoUrl;
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
    player.open(Media(currentVideoUrl));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _playVideo(Content item) {
    final videoUrl = ref.read(assetServiceProvider).load(
          contentId: item.id.toInt(),
          assetRole: 'Main',
        );
    setState(() {
      currentItem = item;
      currentVideoUrl = videoUrl;
      hasError = false;
      errorMessage = null;
    });
    player.open(Media(videoUrl));
  }

  @override
  Widget build(BuildContext context) {
    final browserState = ref.watch(contentBrowserProvider);
    final videoRecommendations = browserState.items.where((item) {
      return item.type.toLowerCase().contains('video') &&
          item.id != currentItem.id;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.level0,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktopLayout = constraints.maxWidth >= 800;

            if (isDesktopLayout) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Player & Info
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.gutter),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.base * 2),
                          _buildPlayer(context, isDesktopLayout),
                          const SizedBox(height: AppSpacing.base * 3),
                          _buildVideoDetails(context),
                        ],
                      ),
                    ),
                  ),
                  // Vertical divider
                  Container(
                    width: 1,
                    height: double.infinity,
                    color: const Color(0xFF2C2928),
                  ),
                  // Right Column: Recommendations Sidebar
                  SizedBox(
                    width: 380,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.base * 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.gutter,
                          ),
                          child: Text(
                            'Up Next',
                            style: AppTypography.bodySm.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.base * 2),
                        Expanded(
                          child: _buildRecommendationsList(
                            context,
                            videoRecommendations,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              // Mobile Layout (Vertical Flow)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPlayer(context, isDesktopLayout),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.gutter,
                        vertical: AppSpacing.base * 2.5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildVideoDetails(context),
                          const SizedBox(height: AppSpacing.base * 4),
                          const Divider(color: Color(0xFF2C2928), height: 1),
                          const SizedBox(height: AppSpacing.base * 3),
                          Text(
                            'Recommendations',
                            style: AppTypography.bodySm.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.base * 2),
                          _buildRecommendationsListMobile(
                            context,
                            videoRecommendations,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPlayer(BuildContext context, bool isDesktopLayout) {
    final borderRadius =
        isDesktopLayout ? AppShapes.radiusLg : BorderRadius.zero;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              if (hasError)
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.gutter),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.error,
                            size: 40,
                          ),
                          const SizedBox(height: AppSpacing.base * 1.5),
                          Text(
                            'Failed to load video',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            errorMessage ?? 'An unknown error occurred.',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.onSurfaceVariant.withValues(
                                alpha: 0.6,
                              ),
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.base * 2.5),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                hasError = false;
                                errorMessage = null;
                              });
                              player.open(Media(currentVideoUrl));
                            },
                            icon: const Icon(Icons.replay_rounded, size: 16),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Video(
                  controller: controller,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Video Title
        Text(
          currentItem.title,
          style: AppTypography.headlineLgMobile.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.base),

        // Metadata (Date & ID)
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
            Text(
              formatDate(currentItem.createdAt),
              style: AppTypography.bodySm.copyWith(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(width: AppSpacing.base * 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.level1,
                borderRadius: AppShapes.radiusSm,
                border: Border.all(
                  color: const Color(0xFF2C2928),
                ),
              ),
              child: Text(
                'ID: ${currentItem.id}',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.base * 3),

        // Description Section
        Text(
          'Description',
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.gutter / 1.5),
          decoration: BoxDecoration(
            color: AppColors.level1,
            borderRadius: AppShapes.radiusDefault,
            border: Border.all(
              color: const Color(0xFF2C2928),
              width: 1.0,
            ),
          ),
          child: Text(
            currentItem.description.isNotEmpty
                ? currentItem.description
                : 'No description provided for this video.',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurface,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsList(
    BuildContext context,
    List<Content> videoRecommendations,
  ) {
    if (videoRecommendations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.gutter),
        child: Center(
          child: Text(
            'No recommendations available',
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      itemCount: videoRecommendations.length,
      itemBuilder: (context, index) {
        final item = videoRecommendations[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.base * 1.5),
          child: RecommendationTile(
            item: item,
            onTap: () => _playVideo(item),
          ),
        );
      },
    );
  }

  Widget _buildRecommendationsListMobile(
    BuildContext context,
    List<Content> videoRecommendations,
  ) {
    if (videoRecommendations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.gutter),
        child: Center(
          child: Text(
            'No recommendations available',
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videoRecommendations.length,
      itemBuilder: (context, index) {
        final item = videoRecommendations[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.base * 1.5),
          child: RecommendationTile(
            item: item,
            onTap: () => _playVideo(item),
          ),
        );
      },
    );
  }
}

class RecommendationTile extends StatefulWidget {
  final Content item;
  final VoidCallback onTap;

  const RecommendationTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<RecommendationTile> createState() => _RecommendationTileState();
}

class _RecommendationTileState extends State<RecommendationTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.level2 : AppColors.level1,
          borderRadius: AppShapes.radiusDefault,
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.5)
                : const Color(0xFF2C2928),
            width: 1.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: AppShapes.radiusDefault,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A mock thumbnail representing the video
                    SizedBox(
                      width: 120,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.level0,
                            borderRadius: AppShapes.radiusSm,
                            border: Border.all(color: const Color(0xFF2C2928)),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.play_circle_outline_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base * 1.5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.title,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.item.description.isNotEmpty
                                ? widget.item.description
                                : 'No description provided.',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.onSurfaceVariant.withValues(
                                alpha: 0.6,
                              ),
                              fontWeight: FontWeight.normal,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatDate(widget.item.createdAt),
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.onSurfaceVariant.withValues(
                                    alpha: 0.4,
                                  ),
                                  fontSize: 9.5,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.level0,
                                  borderRadius: AppShapes.radiusSm,
                                ),
                                child: Text(
                                  '#${widget.item.id}',
                                  style: AppTypography.labelMd.copyWith(
                                    color: AppColors.onSurfaceVariant.withValues(
                                      alpha: 0.5,
                                    ),
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
