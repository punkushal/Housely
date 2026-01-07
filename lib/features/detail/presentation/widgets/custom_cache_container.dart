import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class CustomCacheContainer extends StatelessWidget {
  const CustomCacheContainer({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  /// image url
  final String imageUrl;

  /// image width
  final double width;

  /// image height
  final double height;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => Container(color: AppColors.divider),
      imageUrl: imageUrl,
      fit: .cover,
      width: ResponsiveDimensions.getSize(context, 80),
      height: ResponsiveDimensions.getHeight(context, 74),
    );
  }
}
