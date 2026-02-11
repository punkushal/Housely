import 'dart:io';
import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';

import '../../../../core/extensions/context_extension.dart';

class ImagesGridView extends StatelessWidget {
  const ImagesGridView({
    super.key,
    required this.localImages,
    this.networkImages = const [],
    required this.onRemoveLocal,
    this.onRemoveNetwork,
  });
  final List<File> localImages;
  final List<String> networkImages;
  final Function(int index) onRemoveLocal;
  final Function(int index)? onRemoveNetwork;

  @override
  Widget build(BuildContext context) {
    final totalCount = networkImages.length + localImages.length;
    return GridView.builder(
      itemCount: totalCount,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: context.sp8,
        mainAxisSpacing: context.sp8,
      ),
      itemBuilder: (context, index) {
        // Determining if current index is a Network Image or Local File
        final isNetworkImage = index < networkImages.length;

        // Calculating the correct index for the specific list
        // If it's local, we subtract the network length offset
        final fileIndex = isNetworkImage ? index : index - networkImages.length;
        return Stack(
          children: [
            // image display
            Positioned.fill(
              child: ClipRRect(
                borderRadius: .circular(context.sp8),
                child: isNetworkImage
                    ? CustomCacheContainer(
                        imageUrl: networkImages[fileIndex],
                        width: context.responsive(98),
                        height: context.responsive(68),
                      )
                    : Image.file(
                        localImages[fileIndex],
                        fit: .cover,
                        width: context.responsive(98),
                        height: context.responsive(68),
                      ),
              ),
            ),
            Positioned(
              right: context.sp8,
              top: context.sp4,
              child: GestureDetector(
                onTap: () {
                  if (isNetworkImage) {
                    onRemoveNetwork?.call(fileIndex);
                  } else {
                    onRemoveLocal(fileIndex);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: .circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.surface,
                    size: context.sp16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
