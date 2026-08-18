import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:homework/common/api/media/media.provider.dart';
import 'package:homework/common/api/runner.dart';
import 'package:homework/common/result/result.dart';
import 'package:homework/common/theme/design_system.dart';
import 'package:homework/generated/sdk/media/v1/media.pb.dart';
import 'package:homework/pages/browse/download/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddDownloadDialog extends HookConsumerWidget {
  const AddDownloadDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = ref.watch(mediaApiProvider);

    final nameField = useTextEditingController();
    final descField = useTextEditingController();
    final downloadLinkField = useTextEditingController();
    final filepathField = useTextEditingController();

    final contentType = useState<ContentType>(ContentType.CONTENT_TYPE_VIDEO);
    final assetType = useState<AssetType>(AssetType.ASSET_TYPE_VIDEO);
    final assetRole = useState<AssetRole>(AssetRole.ASSET_ROLE_MAIN);

    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    void clearError() {
      errorMessage.value = null;
    }

    Future<void> handleAdd() async {
      isLoading.value = true;
      clearError();

      final request = AddAndDownloadRequest(
        media: CreateMedia(
          content: CreateContent(
            title: nameField.text,
            desc: descField.text,
            contentType: contentType.value,
          ),
          asset: CreateAsset(
            filepath: filepathField.text,
            assetType: assetType.value,
            assetRole: assetRole.value,
          ),
        ),
        downloadLink: downloadLinkField.text,
      );

      final result = await runReq(() => media.addAndDownload(request));
      if (context.mounted) {
        isLoading.value = false;
        switch (result) {
          case Ok():
            Navigator.of(context).pop(true);
          case Error(error: final err):
            errorMessage.value = err;
        }
      }
    }

    return Dialog(
      backgroundColor: AppColors.level2,
      shape: RoundedRectangleBorder(
        borderRadius: AppShapes.radiusLg,
        side: const BorderSide(color: AppColors.outlineVariant, width: 1.0),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.download_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.base * 1.5),
                    Text(
                      'Add Download',
                      style: AppTypography.headlineLgMobile.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.base * 3),
                TextField(
                  controller: nameField,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter file or task name',
                    prefixIcon: Icon(
                      Icons.drive_file_rename_outline_rounded,
                      color: AppColors.outline,
                    ),
                  ),
                  onChanged: (_) => clearError(),
                ),
                const SizedBox(height: AppSpacing.base * 2.5),
                TextField(
                  controller: descField,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter a short description',
                    prefixIcon: Icon(
                      Icons.description_rounded,
                      color: AppColors.outline,
                    ),
                  ),
                  onChanged: (_) => clearError(),
                ),
                const SizedBox(height: AppSpacing.base * 2.5),
                DropdownButtonFormField<ContentType>(
                  initialValue: contentType.value,
                  decoration: const InputDecoration(
                    labelText: 'Content Type',
                    prefixIcon: Icon(
                      Icons.category_rounded,
                      color: AppColors.outline,
                    ),
                  ),
                  dropdownColor: AppColors.level2,
                  items: ContentType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(getContentTypeName(type)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      contentType.value = val;
                      clearError();
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.base * 2.5),
                TextField(
                  controller: downloadLinkField,
                  decoration: const InputDecoration(
                    labelText: 'Download Link',
                    hintText: 'e.g., https://example.com/file.mp4',
                    prefixIcon: Icon(
                      Icons.link_rounded,
                      color: AppColors.outline,
                    ),
                  ),
                  onChanged: (_) => clearError(),
                ),
                const SizedBox(height: AppSpacing.base * 2.5),
                TextField(
                  controller: filepathField,
                  decoration: const InputDecoration(
                    labelText: 'Download Path',
                    hintText: 'e.g., downloads/file.mp4',
                    prefixIcon: Icon(
                      Icons.folder_open_rounded,
                      color: AppColors.outline,
                    ),
                  ),
                  onChanged: (_) => clearError(),
                ),
                const SizedBox(height: AppSpacing.base * 2.5),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<AssetType>(
                        initialValue: assetType.value,
                        decoration: const InputDecoration(
                          labelText: 'Asset Type',
                          prefixIcon: Icon(
                            Icons.extension_rounded,
                            color: AppColors.outline,
                          ),
                        ),
                        dropdownColor: AppColors.level2,
                        items: AssetType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(getAssetTypeName(type)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            assetType.value = val;
                            clearError();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base * 2),
                    Expanded(
                      child: DropdownButtonFormField<AssetRole>(
                        initialValue: assetRole.value,
                        decoration: const InputDecoration(
                          labelText: 'Asset Role',
                          prefixIcon: Icon(
                            Icons.label_rounded,
                            color: AppColors.outline,
                          ),
                        ),
                        dropdownColor: AppColors.level2,
                        items: AssetRole.values.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(getAssetRoleName(role)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            assetRole.value = val;
                            clearError();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.base * 3),
                if (errorMessage.value != null) ...[
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
                          Icons.error_outline_rounded,
                          color: AppColors.error,
                          size: 16,
                        ),
                        const SizedBox(width: AppSpacing.base * 1.5),
                        Expanded(
                          child: Text(
                            errorMessage.value!,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.error,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base * 3),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: isLoading.value
                          ? null
                          : Navigator.of(context).pop,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.onSurfaceVariant,
                        textStyle: AppTypography.labelMd.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.base * 1.5),
                    ElevatedButton(
                      onPressed: isLoading.value ? null : handleAdd,
                      child: isLoading.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.onPrimary,
                              ),
                            )
                          : const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
