import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/presentation/cubit/property_cubit.dart';
import 'package:housely/features/property/presentation/cubit/property_form_cubit.dart';

class ImagesGridView extends StatelessWidget {
  const ImagesGridView({
    super.key,
    required this.localImages,
    required this.networkImages,
    this.property,
  });
  final List<File> localImages;

  /// network image urls for other properties
  final List<dynamic> networkImages;

  /// to update the gallery images from it
  final Property? property;

  @override
  Widget build(BuildContext context) {
    final totalCount = networkImages.length + localImages.length;
    return BlocListener<PropertyCubit, PropertyState>(
      listener: (context, state) {
        if (state is PropertyImageDeleted) {
          SnackbarHelper.showSuccess(
            context,
            "Network image deleted",
            showTop: true,
          );
        } else if (state is PropertyError) {
          SnackbarHelper.showError(context, state.message, showTop: true);
        }
      },
      child: GridView.builder(
        itemCount: totalCount,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          // Determining if current index is a Network Image or Local File
          final isNetworkImage = index < networkImages.length;

          // Calculating the correct index for the specific list
          // If it's local, we subtract the network length offset
          final fileIndex = isNetworkImage
              ? index
              : index - networkImages.length;
          return Stack(
            children: [
              // image display
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: isNetworkImage
                      ? CustomCacheContainer(
                          imageUrl: networkImages[fileIndex]['url'],
                          width: ResponsiveDimensions.getSize(context, 98),
                          height: ResponsiveDimensions.getSize(context, 68),
                        )
                      : Image.file(
                          localImages[fileIndex],
                          fit: .cover,
                          width: ResponsiveDimensions.getSize(context, 98),
                          height: ResponsiveDimensions.getSize(context, 68),
                        ),
                ),
              ),
              Positioned(
                right: ResponsiveDimensions.spacing8(context),
                top: ResponsiveDimensions.spacing4(context),
                child: GestureDetector(
                  onTap: () {
                    if (isNetworkImage) {
                      if (property != null) {
                        context.read<PropertyCubit>().deleteGalleryImage(
                          fileId: networkImages[fileIndex]['id'],
                          property: property!,
                        );
                      }
                    } else {
                      context.read<PropertyFormCubit>().removeImage(fileIndex);
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
