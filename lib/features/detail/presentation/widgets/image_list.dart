import 'package:flutter/material.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/detail_image_card.dart';

class ImageList extends StatelessWidget {
  const ImageList({super.key});

  // handle image preview
  void _previewImage(String imgPath, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: .zero,
        content: ClipRRect(
          borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
          child: Image.asset(
            imgPath,
            height: ResponsiveDimensions.getSize(context, 188),
            width: ResponsiveDimensions.getSize(context, 282),
            fit: .cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveDimensions.getHeight(context, 86),
      child: ListView.builder(
        // TODO: later data will be dynamic
        scrollDirection: .horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: ResponsiveDimensions.paddingOnly(
              context,
              // right: 8,
              // bottom: 6,
            ),
            child: GestureDetector(
              onTap: () {
                _previewImage(ImageConstant.fourthVilla, context);
              },
              child: DetailImageCard(
                imgPath: ImageConstant.fourthVilla,
                width: ResponsiveDimensions.getSize(context, 76),
                height: ResponsiveDimensions.getHeight(context, 72),
                fit: .cover,
                radius: 8,
              ),
            ),
          );
        },
      ),
    );
  }
}
