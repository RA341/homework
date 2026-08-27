import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/services/upload/upload.provider.dto.dart';
import 'package:homework/common/services/upload/upload_queue_provider.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/pages/browse/+layout.dart';

class UploadPage extends ConsumerStatefulWidget {
  const UploadPage({super.key});

  @override
  ConsumerState<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String? _selectedFilePath;
  String? _selectedFileName;
  int _selectedFileSize = 0;
  String _selectedAssetType = 'Video'; // Default selection
  String _selectedContentType = 'Video'; // Default selection
  String _selectedAssetRole = 'Main'; // Default selection
  String? _validationError;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String? _detectAssetType(String fileName) {
    final parts = fileName.split('.');
    if (parts.length < 2) return null;
    final ext = parts.last.toLowerCase();

    if (const [
      'mp4',
      'mkv',
      'avi',
      'mov',
      'webm',
      'flv',
      'm4v',
    ].contains(ext)) {
      return 'Video';
    }
    if (const [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'svg',
      'bmp',
    ].contains(ext)) {
      return 'Image';
    }
    if (const ['srt', 'vtt', 'ass', 'sub'].contains(ext)) {
      return 'Subtitle';
    }
    if (const ['mp3', 'wav', 'm4a', 'ogg', 'flac', 'aac'].contains(ext)) {
      return 'Audio';
    }
    return null;
  }

  Future<void> _pickFile() async {
    try {
      setState(() {
        _validationError = null;
      });

      final result = await FilePicker.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result.isNotEmpty) {
        final file = result.first;
        if (file.path != null) {
          setState(() async {
            _selectedFilePath = file.path;
            _selectedFileName = file.name;
            _selectedFileSize = await file.length();

            // Auto-populate Title if empty
            if (_titleController.text.isEmpty) {
              final lastDotIndex = file.name.lastIndexOf('.');
              final nameWithoutExtension = lastDotIndex != -1
                  ? file.name.substring(0, lastDotIndex)
                  : file.name;
              _titleController.text = nameWithoutExtension;
            }

            // Auto-detect Asset Type & Content Type
            final detectedType = _detectAssetType(file.name);
            if (detectedType != null) {
              _selectedAssetType = detectedType;
              if (detectedType == 'Video') {
                _selectedContentType = 'Video';
              } else if (detectedType == 'Image') {
                _selectedContentType = 'Image';
              } else if (detectedType == 'Audio') {
                _selectedContentType = 'Unknown';
              }
            }

            // Auto-detect Asset Role
            final nameLower = file.name.toLowerCase();
            if (nameLower.contains('thumbnail')) {
              _selectedAssetRole = 'Thumbnail';
            } else if (nameLower.contains('backdrop') ||
                nameLower.contains('fanart')) {
              _selectedAssetRole = 'Backdrop';
            } else if (nameLower.contains('poster')) {
              _selectedAssetRole = 'Poster';
            } else if (nameLower.contains('trailer')) {
              _selectedAssetRole = 'Trailer';
            } else {
              _selectedAssetRole = 'Main';
            }
          });
        }
      }
    } catch (e) {
      setState(() {
        _validationError = 'Failed to pick file: $e';
      });
    }
  }

  void _clearSelectedFile() {
    setState(() {
      _selectedFilePath = null;
      _selectedFileName = null;
      _selectedFileSize = 0;
      _titleController.clear();
      _descController.clear();
      _selectedAssetType = 'Video';
      _selectedContentType = 'Video';
      _selectedAssetRole = 'Main';
      _validationError = null;
    });
  }

  void _handleSubmit() {
    setState(() {
      _validationError = null;
    });

    if (_selectedFilePath == null) {
      setState(() {
        _validationError = 'Please select a file to upload';
      });
      return;
    }

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() {
        _validationError = 'Please enter a title for the asset';
      });
      return;
    }

    final desc = _descController.text.trim();

    // Add job to provider queue
    ref
        .read(uploadQueueProvider.notifier)
        .addJob(
          UploadDto(
            title: title,
            desc: desc,
            filePath: _selectedFilePath!,
            fileName: _selectedFileName!,
            assetType: _selectedAssetType,
            assetRole: _selectedAssetRole,
            contentType: _selectedContentType,
          ),
        );

    // Reset selection form
    _clearSelectedFile();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File added to upload queue'),
        backgroundColor: AppColors.primaryContainer,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  IconData _getAssetIcon(String assetType) {
    switch (assetType) {
      case 'Video':
        return Icons.movie_creation_outlined;
      case 'Image':
        return Icons.image_outlined;
      case 'Subtitle':
        return Icons.subtitles_outlined;
      case 'Audio':
        return Icons.audiotrack_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(uploadQueueProvider);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 800;

    Widget buildFormPane() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Asset',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.base * 2),
            Card(
              color: AppColors.level1,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // File Selection Zone
                      if (_selectedFilePath == null)
                        InkWell(
                          onTap: _pickFile,
                          borderRadius: AppShapes.radiusMd,
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: AppColors.level0.withAlpha(120),
                              borderRadius: AppShapes.radiusMd,
                              border: Border.all(
                                color: AppColors.outlineVariant,
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.cloud_upload_outlined,
                                  color: AppColors.primary,
                                  size: 40,
                                ),
                                const SizedBox(height: AppSpacing.base),
                                Text(
                                  'Select a file',
                                  style: AppTypography.bodyMd.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.base / 2),
                                Text(
                                  'Supports Video, Image, Subtitle & Audio',
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.onSurfaceVariant.withAlpha(
                                      150,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(
                            AppSpacing.gutter / 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.level0.withAlpha(120),
                            borderRadius: AppShapes.radiusMd,
                            border: Border.all(
                              color: AppColors.primary.withAlpha(100),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getAssetIcon(_selectedAssetType),
                                color: AppColors.primary,
                                size: 32,
                              ),
                              const SizedBox(width: AppSpacing.base * 2),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedFileName ?? 'Selected File',
                                      style: AppTypography.bodySm.copyWith(
                                        color: AppColors.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: AppSpacing.base / 2),
                                    Text(
                                      _formatFileSize(_selectedFileSize),
                                      style: AppTypography.labelMd.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  color: AppColors.error,
                                ),
                                onPressed: _clearSelectedFile,
                                tooltip: 'Remove file',
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: AppSpacing.base * 3),

                      // Title field
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter asset title',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.base * 3),

                      // Description field
                      TextField(
                        controller: _descController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Optional description of this asset',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.base * 3),

                      // Asset Type Selection Row
                      Text(
                        'Asset Type',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.base),
                      Wrap(
                        spacing: AppSpacing.base,
                        runSpacing: AppSpacing.base,
                        children: ['Video', 'Image', 'Subtitle', 'Audio'].map((
                          type,
                        ) {
                          final isSelected = _selectedAssetType == type;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedAssetType = type;
                              });
                            },
                            borderRadius: AppShapes.radiusDefault,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.level0,
                                borderRadius: AppShapes.radiusDefault,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.outlineVariant,
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                type,
                                style: AppTypography.labelMd.copyWith(
                                  color: isSelected
                                      ? AppColors.onPrimary
                                      : AppColors.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.base * 3),

                      // Content Type Selection Row
                      Text(
                        'Content Type',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.base),
                      Wrap(
                        spacing: AppSpacing.base,
                        runSpacing: AppSpacing.base,
                        children:
                            [
                              'Unknown',
                              'Movie',
                              'Series',
                              'Episode',
                              'Video',
                              'Image',
                              'Gallery',
                            ].map((type) {
                              final isSelected = _selectedContentType == type;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedContentType = type;
                                  });
                                },
                                borderRadius: AppShapes.radiusDefault,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.level0,
                                    borderRadius: AppShapes.radiusDefault,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.outlineVariant,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Text(
                                    type,
                                    style: AppTypography.labelMd.copyWith(
                                      color: isSelected
                                          ? AppColors.onPrimary
                                          : AppColors.onSurfaceVariant,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.base * 3),

                      // Asset Role Selection Row
                      Text(
                        'Asset Role',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.base),
                      Wrap(
                        spacing: AppSpacing.base,
                        runSpacing: AppSpacing.base,
                        children:
                            [
                              {'display': 'Main Role', 'value': 'Main'},
                              {'display': 'Thumbnail', 'value': 'Thumbnail'},
                              {'display': 'Backdrop', 'value': 'Backdrop'},
                              {'display': 'Trailer', 'value': 'Trailer'},
                              {'display': 'Poster', 'value': 'Poster'},
                            ].map((role) {
                              final value = role['value']!;
                              final display = role['display']!;
                              final isSelected = _selectedAssetRole == value;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedAssetRole = value;
                                  });
                                },
                                borderRadius: AppShapes.radiusDefault,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.level0,
                                    borderRadius: AppShapes.radiusDefault,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.outlineVariant,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Text(
                                    display,
                                    style: AppTypography.labelMd.copyWith(
                                      color: isSelected
                                          ? AppColors.onPrimary
                                          : AppColors.onSurfaceVariant,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.base * 4),

                      // Validation Error Block
                      if (_validationError != null) ...[
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
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 18,
                              ),
                              const SizedBox(width: AppSpacing.base * 1.5),
                              Expanded(
                                child: Text(
                                  _validationError!,
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.base * 3),
                      ],

                      // Upload Button
                      ElevatedButton(
                        onPressed: _handleSubmit,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Add to Upload Queue'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildQueuePane() {
      final activeCount = queue
          .where((j) => j.status == 'uploading' || j.status == 'pending')
          .length;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upload Queue${activeCount > 0 ? ' ($activeCount active)' : ''}',
                  style: AppTypography.headlineLgMobile.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (queue.any((j) => j.status == 'completed'))
                  TextButton.icon(
                    onPressed: () {
                      ref.read(uploadQueueProvider.notifier).clearCompleted();
                    },
                    icon: const Icon(
                      Icons.cleaning_services_outlined,
                      size: 16,
                    ),
                    label: const Text('Clear Done'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.base * 2),
            if (queue.isEmpty)
              Card(
                color: AppColors.level1,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.gutter * 2),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.hourglass_empty_rounded,
                        color: AppColors.outline,
                        size: 48,
                      ),
                      const SizedBox(height: AppSpacing.base * 2),
                      Text(
                        'Queue is empty',
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.base),
                      Text(
                        'Select a file and enter details above to add it to the upload queue.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: queue.length,
                itemBuilder: (context, index) {
                  final job = queue[index];
                  final isUploading = job.status == 'uploading';
                  final isFailed = job.status == 'failed';
                  final isCompleted = job.status == 'completed';

                  Color statusColor;
                  String statusText;
                  IconData statusIcon;

                  if (isUploading) {
                    statusColor = AppColors.primary;
                    statusText =
                        'Uploading ${(job.progress * 100).toStringAsFixed(0)}%';
                    statusIcon = Icons.sync;
                  } else if (isFailed) {
                    statusColor = AppColors.error;
                    statusText = 'Failed';
                    statusIcon = Icons.error_outline_rounded;
                  } else if (isCompleted) {
                    statusColor = Colors.green;
                    statusText = 'Completed';
                    statusIcon = Icons.check_circle_outline_rounded;
                  } else {
                    statusColor = AppColors.onSurfaceVariant;
                    statusText = 'Queued';
                    statusIcon = Icons.schedule_rounded;
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.base * 2),
                    color: AppColors.level1,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.gutter / 1.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: statusColor.withAlpha(25),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getAssetIcon(job.dto.assetType),
                                  color: statusColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.base * 2),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      job.dto.title,
                                      style: AppTypography.bodySm.copyWith(
                                        color: AppColors.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: AppSpacing.base / 3),
                                    Text(
                                      job.dto.fileName,
                                      style: AppTypography.labelMd.copyWith(
                                        color: AppColors.onSurfaceVariant
                                            .withAlpha(150),
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.base),
                              // Remove Button
                              IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                onPressed: () {
                                  ref
                                      .read(uploadQueueProvider.notifier)
                                      .removeJob(job.id);
                                },
                                tooltip: 'Cancel job',
                              ),
                            ],
                          ),
                          if (isUploading) ...[
                            const SizedBox(height: AppSpacing.base * 2),
                            ClipRRect(
                              borderRadius: AppShapes.radiusFull,
                              child: LinearProgressIndicator(
                                value: job.progress,
                                backgroundColor: AppColors.level0,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                          if (isFailed && job.error != null) ...[
                            const SizedBox(height: AppSpacing.base * 1.5),
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.base),
                              decoration: BoxDecoration(
                                color: AppColors.errorContainer.withAlpha(20),
                                borderRadius: AppShapes.radiusSm,
                              ),
                              child: Text(
                                job.error!,
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.error,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: AppSpacing.base * 1.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (isUploading)
                                    const SizedBox(
                                      height: 12,
                                      width: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppColors.primary,
                                            ),
                                      ),
                                    )
                                  else
                                    Icon(
                                      statusIcon,
                                      color: statusColor,
                                      size: 14,
                                    ),
                                  const SizedBox(width: 6),
                                  Text(
                                    statusText,
                                    style: AppTypography.labelMd.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (isFailed)
                                TextButton.icon(
                                  onPressed: () {
                                    ref
                                        .read(uploadQueueProvider.notifier)
                                        .retryJob(job.id);
                                  },
                                  icon: const Icon(
                                    Icons.replay_rounded,
                                    size: 14,
                                  ),
                                  label: const Text('Retry'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      );
    }

    return BrowseLayout(
      activeTab: 1,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: buildFormPane()),
                    const SizedBox(width: AppSpacing.gutter),
                    Expanded(flex: 7, child: buildQueuePane()),
                  ],
                )
              : Column(
                  children: [
                    buildFormPane(),
                    const SizedBox(height: AppSpacing.gutter * 1.5),
                    buildQueuePane(),
                  ],
                ),
        ),
      ),
    );
  }
}
