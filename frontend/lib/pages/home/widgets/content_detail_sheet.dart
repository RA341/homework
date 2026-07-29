import 'package:flutter/material.dart';
import 'package:homework/common/theme/design_system.dart';
import 'package:homework/generated/sdk/content/v1/content.pb.dart';
import 'package:homework/pages/home/utils.dart';

void showContentDetailSheet(BuildContext context, Content item) {
  final type = item.type.toLowerCase();
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

  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.level2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: AppShapes.radiusXl.topLeft),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(typeIcon, color: accentColor, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.base * 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppTypography.headlineLgMobile.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.type.toUpperCase(),
                          style: AppTypography.labelMd.copyWith(
                            color: accentColor,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.base * 3),
              const Divider(color: Color(0xFF2C2928), height: 1),
              const SizedBox(height: AppSpacing.base * 3),
              Text(
                'Description',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                item.description.isNotEmpty
                    ? item.description
                    : 'No description provided for this asset.',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onSurface,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.base * 3),
              // Metadata Table
              Container(
                padding: const EdgeInsets.all(AppSpacing.base * 1.5),
                decoration: BoxDecoration(
                  color: AppColors.level1,
                  borderRadius: AppShapes.radiusDefault,
                  border: Border.all(
                    color: const Color(0xFF2C2928),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    _buildMetaRow('Asset ID', item.id.toString()),
                    const Divider(color: Color(0xFF2C2928), height: 12),
                    _buildMetaRow('Created At', formatDate(item.createdAt)),
                    const Divider(color: Color(0xFF2C2928), height: 12),
                    _buildMetaRow('Updated At', formatDate(item.updatedAt)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.base * 4),
              // Mock actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Downloading "${item.title}"...'),
                            backgroundColor: AppColors.primaryContainer,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: accentColor,
                        side: BorderSide(color: accentColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.base * 2),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Opening media preview for "${item.title}"',
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Preview'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: AppColors.level0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildMetaRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: AppTypography.labelMd.copyWith(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
        ),
      ),
      Text(
        value,
        style: AppTypography.bodySm.copyWith(
          color: AppColors.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
