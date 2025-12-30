import 'package:flutter/material.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/detail_image_card.dart';

class ImageList extends StatelessWidget {
  const ImageList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveDimensions.getHeight(context, 72),
      child: ListView.builder(
        // TODO: later data will be dynamic
        scrollDirection: .horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: ResponsiveDimensions.paddingOnly(context, right: 8),
            child: DetailImageCard(
              imgPath: ImageConstant.secondVilla,
              width: ResponsiveDimensions.getSize(context, 76),
              height: ResponsiveDimensions.getHeight(context, 72),
              fit: .cover,
            ),
          );
        },
      ),
    );
  }
}
