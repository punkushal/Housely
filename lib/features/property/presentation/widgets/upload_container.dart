import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/property/presentation/cubit/property_form_cubit.dart';
import 'package:housely/features/property/presentation/widgets/default_upload_content.dart';
import 'package:housely/features/property/presentation/widgets/images_grid_view.dart';
import 'package:image_picker/image_picker.dart';

class UploadContainer extends StatelessWidget {
  UploadContainer({
    super.key,
    required this.labelText,
    this.hasMany = false,
    this.coverUrl,
    required this.imageUrls,
  });

  /// existed cover image network url
  final String? coverUrl;

  /// other property images url
  final List<dynamic> imageUrls;

  /// Label text
  final String labelText;

  /// Checker to enable multiple image selection
  final bool hasMany;

  final _picker = ImagePicker();

  // handle single image selection
  Future<void> pickSingleImage(BuildContext context) async {
    final image = await _picker.pickImage(source: .gallery);

    if (image != null && context.mounted) {
      context.read<PropertyFormCubit>().setSingleImage(File(image.path));
    }
  }

  // handle multiple image selection
  Future<void> pickMultipleImages(BuildContext context) async {
    final List<File> pickedImages = [];
    final images = await _picker.pickMultiImage(limit: 4);

    if (images.isNotEmpty && context.mounted) {
      pickedImages.addAll(images.map((xfile) => File(xfile.path)));
      context.read<PropertyFormCubit>().setMultipleImages(pickedImages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyFormCubit, PropertyFormState>(
      listenWhen: (prev, curr) {
        return prev.imageError != curr.imageError && curr.imageError != null;
      },
      listener: (context, state) {
        SnackbarHelper.showError(context, state.imageError!);
      },

      child: Column(
        crossAxisAlignment: .start,
        spacing: ResponsiveDimensions.getSize(context, 8),
        children: [
          // label
          Text(labelText, style: AppTextStyle.bodySemiBold(context)),

          // image upload container
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              padding: .zero,
              radius: Radius.circular(
                ResponsiveDimensions.radiusSmall(context),
              ),
              dashPattern: [4, 5],
              color: AppColors.border,
            ),
            child: GestureDetector(
              onTap: () {
                hasMany
                    ? pickMultipleImages(context)
                    : pickSingleImage(context);
              },
              child: Container(
                // to take up all the available width provided by parent widget
                width: double.infinity,
                height: ResponsiveDimensions.getHeight(context, 188),
                decoration: BoxDecoration(
                  borderRadius: ResponsiveDimensions.borderRadiusMedium(
                    context,
                  ),
                  border: Border.all(style: .none),
                ),
                child: BlocBuilder<PropertyFormCubit, PropertyFormState>(
                  builder: (context, state) {
                    if (coverUrl != null) {
                      return ClipRRect(
                        borderRadius: ResponsiveDimensions.borderRadiusSmall(
                          context,
                        ),
                        child: CustomCacheContainer(
                          imageUrl: coverUrl!,
                          height: 0,
                          width: 0,
                        ),
                      );
                    } else if (state.image != null && !hasMany) {
                      return ClipRRect(
                        borderRadius: ResponsiveDimensions.borderRadiusSmall(
                          context,
                        ),
                        child: Image.file(state.image!, fit: .cover),
                      );
                    } else if (hasMany) {
                      return ImagesGridView(
                        multipleImages: state.imageList,
                        imageUrls: imageUrls,
                      );
                    }
                    return DefaultUploadContent();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
