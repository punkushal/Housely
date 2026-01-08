import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/property/presentation/cubit/property_cubit.dart';
import 'package:housely/features/property/presentation/cubit/property_form_cubit.dart';

class ImagesGridView extends StatelessWidget {
  const ImagesGridView({
    super.key,
    required this.multipleImages,
    required this.imageUrls,
  });
  final List<File> multipleImages;

  /// network image urls for other properties
  final List<dynamic> imageUrls;

  /// get image url list of network
  List<String> getImageUrls(List<dynamic> gallery) {
    final urls = gallery
        .where((element) => element.containsKey("url"))
        .map((item) => item['url'] as String)
        .toList();

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    final actualImagesUrl = getImageUrls(imageUrls);
    final totalCount = actualImagesUrl.length + multipleImages.length;
    return BlocListener<PropertyCubit, PropertyState>(
      listener: (context, state) {
        if (state is PropertyLoading) {
          SnackbarHelper.showInfo(
            context,
            "Deleting network image can take some time...",
          );
        } else if (state is PropertyImageDeleted) {
          SnackbarHelper.showSuccess(context, "Network image deleted");
        } else if (state is PropertyError) {
          SnackbarHelper.showError(context, state.message);
        }
      },
      child: GridView.builder(
        itemCount: totalCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          // Determining if current index is a Network Image or Local File
          final isNetworkImage = index < actualImagesUrl.length;

          // Calculating the correct index for the specific list
          // If it's local, we subtract the network length offset
          final fileIndex = isNetworkImage
              ? index
              : index - actualImagesUrl.length;
          return Stack(
            children: [
              isNetworkImage
                  ? CustomCacheContainer(
                      imageUrl: actualImagesUrl[fileIndex],
                      width: ResponsiveDimensions.getSize(context, 98),
                      height: ResponsiveDimensions.getSize(context, 68),
                    )
                  : Image.file(
                      multipleImages[fileIndex],
                      fit: .cover,
                      width: ResponsiveDimensions.getSize(context, 98),
                      height: ResponsiveDimensions.getSize(context, 68),
                    ),

              Positioned(
                right: ResponsiveDimensions.spacing8(context),
                top: ResponsiveDimensions.spacing4(context),
                child: GestureDetector(
                  onTap: () {
                    if (isNetworkImage) {
                      context.read<PropertyCubit>().deleteImage(
                        fileId: imageUrls[fileIndex]['id'],
                      );
                    }
                    context.read<PropertyFormCubit>().removeImage(fileIndex);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: .circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.surface,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
