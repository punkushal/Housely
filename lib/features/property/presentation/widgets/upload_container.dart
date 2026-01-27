import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/property/presentation/widgets/default_upload_content.dart';
import 'package:housely/features/property/presentation/widgets/images_grid_view.dart';
import 'package:image_picker/image_picker.dart';

class UploadContainer extends StatelessWidget {
  UploadContainer({
    super.key,
    required this.labelText,
    this.hasMany = false,
    this.coverUrl,
    this.singleImage,
    required this.imageList,
    required this.networkImages,
    this.onImagesSelected,
    this.onImageSelected,
    this.onRemoveLocal,
    this.onRemoveNetwork,
    // this.property,
  });

  /// existed cover image network url
  final String? coverUrl;

  /// Label text
  final String labelText;

  /// Checker to enable multiple image selection
  final bool hasMany;

  // Data passed from parent Cubit state
  final File? singleImage;
  final List<File> imageList;
  final List<String> networkImages;

  // Generic Callbacks
  final Function(List<File>)? onImagesSelected;
  final Function(File)? onImageSelected;
  final Function(int)? onRemoveLocal;
  final Function(int)? onRemoveNetwork;

  // final Property? property;

  final _picker = ImagePicker();

  // handle single image selection
  Future<void> pickSingleImage(BuildContext context) async {
    final image = await _picker.pickImage(source: .gallery);

    if (image != null && context.mounted) {
      onImageSelected?.call(File(image.path));
    }
  }

  // handle multiple image selection
  Future<void> pickMultipleImages(BuildContext context) async {
    final images = await _picker.pickMultiImage(limit: 4);

    if (images.isNotEmpty && context.mounted) {
      onImagesSelected?.call(images.map((x) => File(x.path)).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: ResponsiveDimensions.getSize(context, 8),
      children: [
        // label
        Text(labelText, style: AppTextStyle.bodySemiBold(context)),

        // image upload container
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            padding: .zero,
            radius: Radius.circular(ResponsiveDimensions.radiusSmall(context)),
            dashPattern: [4, 5],
            color: AppColors.border,
          ),
          child: GestureDetector(
            onTap: () {
              hasMany ? pickMultipleImages(context) : pickSingleImage(context);
            },
            child: Container(
              // to take up all the available width provided by parent widget
              width: double.infinity,
              height: ResponsiveDimensions.getHeight(context, 188),
              decoration: BoxDecoration(
                borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
                border: Border.all(style: .none),
              ),
              child: _buildContent(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    // Single Image Display
    if (!hasMany && singleImage != null) {
      return ClipRRect(
        borderRadius: ResponsiveDimensions.borderRadiusSmall(context),
        child: Image.file(singleImage!, fit: BoxFit.cover),
      );
    }

    // Multiple Images Display
    if (hasMany && (imageList.isNotEmpty || networkImages.isNotEmpty)) {
      return ImagesGridView(
        localImages: imageList,
        networkImages: networkImages,
        onRemoveLocal: (index) => onRemoveLocal?.call(index),
        onRemoveNetwork: (index) => onRemoveNetwork?.call(index),
      );
    }

    return const DefaultUploadContent();
  }
}
