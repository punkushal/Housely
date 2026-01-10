import 'package:flutter/material.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/detail/presentation/widgets/detail_image_card.dart';

class ImageList extends StatelessWidget {
  const ImageList({super.key, required this.imageUrls});

  /// image url list
  final List<String> imageUrls;

  // handle image preview
  void _previewImage(String imgPath, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: .zero,
        content: ClipRRect(
          borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
          child: CustomCacheContainer(
            imageUrl: imgPath,
            height: 188,
            width: 282,
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
        scrollDirection: .horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _previewImage(imageUrls[index], context);
            },
            child: DetailImageCard(
              imgPath: imageUrls[index],
              width: ResponsiveDimensions.getSize(context, 76),
              height: ResponsiveDimensions.getHeight(context, 72),
              fit: .cover,
              radius: 8,
            ),
          );
        },
      ),
    );
  }
}
