import 'package:flutter/material.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';

class ReviewerPhotos extends StatelessWidget {
  const ReviewerPhotos({super.key, required this.imageUrls});
  final List<dynamic> imageUrls;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveDimensions.getSize(context, 150),
      child: ListView.builder(
        scrollDirection: .horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: ResponsiveDimensions.paddingOnly(context, right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomCacheContainer(
                imageUrl: imageUrls[index]['url'],
                width: ResponsiveDimensions.getSize(context, 140),
                height: ResponsiveDimensions.getSize(context, 140),
              ),
            ),
          );
        },
      ),
    );
  }
}
