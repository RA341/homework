import 'package:flutter/material.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/generated/sdk/content/v1/content.pb.dart';
import 'package:homework/pages/home/utils.dart';

class ContentCard extends StatefulWidget {
  final Content item;
  final VoidCallback? onTap;

  const ContentCard({super.key, required this.item, this.onTap});

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final type = widget.item.type.toLowerCase();
    Color accentColor;
    IconData typeIcon;

    if (type.contains('video')) {
      accentColor = AppColors.primary;
      typeIcon = Icons.movie_creation_outlined;
    } else if (type.contains('image')) {
      accentColor = Colors.cyanAccent;
      typeIcon = Icons.image_outlined;
    } else if (type.contains('subtitle') || type.contains('sub')) {
      accentColor = Colors.purpleAccent;
      typeIcon = Icons.subtitles_outlined;
    } else if (type.contains('audio')) {
      accentColor = Colors.lightGreenAccent;
      typeIcon = Icons.audiotrack_outlined;
    } else {
      accentColor = AppColors.onSurfaceVariant;
      typeIcon = Icons.insert_drive_file_outlined;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.level2 : AppColors.level1,
            borderRadius: AppShapes.radiusLg,
            border: Border.all(
              color: _isHovered
                  ? accentColor.withValues(alpha: 0.5)
                  : const Color(0xFF2C2928),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: AppShapes.radiusLg,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.gutter / 1.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(typeIcon, color: accentColor, size: 18),
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
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  widget.item.type.toUpperCase(),
                                  style: AppTypography.labelMd.copyWith(
                                    color: accentColor.withValues(alpha: 0.8),
                                    fontSize: 9,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.base * 1.5),
                      Expanded(
                        child: Text(
                          widget.item.description.isNotEmpty
                              ? widget.item.description
                              : 'No description provided for this asset.',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.8,
                            ),
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.base * 1.5),
                      const Divider(color: Color(0xFF2C2928), height: 1),
                      const SizedBox(height: AppSpacing.base * 1.2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 11,
                                color: AppColors.onSurfaceVariant.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                formatDate(widget.item.createdAt),
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.onSurfaceVariant.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: 10.5,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.level0,
                              borderRadius: AppShapes.radiusSm,
                              border: Border.all(
                                color: const Color(0xFF2C2928),
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              '#${widget.item.id}',
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.onSurfaceVariant.withValues(
                                  alpha: 0.8,
                                ),
                                fontSize: 9.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
