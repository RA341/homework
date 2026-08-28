import 'package:flutter/material.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/generated/sdk/content/v1/content.pb.dart';
import 'package:homework/pages/home/utils.dart';

class ContentListTile extends StatefulWidget {
  final Content item;
  final VoidCallback? onTap;

  const ContentListTile({super.key, required this.item, this.onTap});

  @override
  State<ContentListTile> createState() => _ContentListTileState();
}

class _ContentListTileState extends State<ContentListTile> {
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.level2 : AppColors.level1,
          borderRadius: AppShapes.radiusDefault,
          border: Border.all(
            color: _isHovered
                ? accentColor.withValues(alpha: 0.5)
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.gutter / 1.5,
                  vertical: AppSpacing.base * 1.5,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(typeIcon, color: accentColor, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.base * 2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.item.title,
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formatDate(widget.item.createdAt),
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.onSurfaceVariant.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                widget.item.type.toUpperCase(),
                                style: AppTypography.labelMd.copyWith(
                                  color: accentColor.withValues(alpha: 0.8),
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.item.description.isNotEmpty
                                      ? widget.item.description
                                      : 'No description',
                                  style: AppTypography.labelMd.copyWith(
                                    color: AppColors.onSurfaceVariant
                                        .withValues(alpha: 0.7),
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
