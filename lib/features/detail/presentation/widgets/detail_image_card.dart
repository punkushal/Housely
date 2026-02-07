import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class DetailImageCard extends StatelessWidget {
  const DetailImageCard({
    super.key,
    this.width,
    this.height,
    required this.imgPath,
    this.imgWidth,
    this.imgHeight,
    this.fit,
    this.radius,
  });

  /// width of this container
  final double? width;

  /// height of this container
  final double? height;

  /// image path
  final String imgPath;

  /// width of this container
  final double? imgWidth;

  /// width of this container
  final double? imgHeight;

  /// Boxfit of the image
  final BoxFit? fit;

  /// Optional border radius
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: ResponsiveDimensions.paddingAll4(context),
      decoration: BoxDecoration(
        borderRadius: ResponsiveDimensions.borderRadiusMedium(
          context,
          size: radius,
        ),
      ),
      child: ClipRRect(
        borderRadius: ResponsiveDimensions.borderRadiusMedium(
          context,
          size: radius,
        ),
        child: CachedNetworkImage(
          placeholder: (context, url) => Container(color: AppColors.divider),
          imageUrl: imgPath,
          width: imgWidth,
          height: imgHeight,
          fit: fit,
        ),
      ),
    );
  }
}
