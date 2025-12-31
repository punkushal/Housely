import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';

class NearbyCard extends StatelessWidget {
  const NearbyCard({super.key, this.height, this.width, this.navigateTo});

  /// height of this card
  final double? height;

  /// width of this card
  final double? width;

  /// navigation to detail page
  final void Function()? navigateTo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateTo,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: ResponsiveDimensions.borderRadiusLarge(context),
        ),
        child: Row(
          crossAxisAlignment: .end,
          spacing: ResponsiveDimensions.getSize(context, 12),
          children: [
            // image container
            ClipRRect(
              borderRadius: ResponsiveDimensions.borderRadiusSmall(context),
              child: Image.asset(
                ImageConstant.thirdVilla,
                width: ResponsiveDimensions.getSize(context, 80),
                height: ResponsiveDimensions.getHeight(context, 74),
                fit: .cover,
              ),
            ),
            // Property detail section
            Column(
              crossAxisAlignment: .start,

              spacing: ResponsiveDimensions.getHeight(context, 5),
              children: [
                // Property name
                Text(
                  "Takatea Homestay",
                  style: AppTextStyle.bodySemiBold(context),
                ),

                // Property location
                Row(
                  spacing: ResponsiveDimensions.getSize(context, 4),
                  children: [
                    SvgPicture.asset(ImageConstant.locationIcon),
                    SizedBox(
                      width: ResponsiveDimensions.getSize(context, 112),
                      child: Text(
                        "Jl. Tentara Pelajar No.47, RW.001",
                        style: AppTextStyle.bodyRegular(
                          context,
                          fontSize: 10,
                          lineHeight: 14,
                          color: AppColors.textHint,
                        ),
                        overflow: .ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveDimensions.getHeight(context, 5)),
                // Property price
                Text(
                  "\$120/night",
                  style: AppTextStyle.labelSemiBold(
                    context,
                    fontSize: 10,
                    lineHeight: 14,
                  ),
                ),
              ],
            ),

            // rating container
            Container(
              width: ResponsiveDimensions.getSize(context, 47),
              height: ResponsiveDimensions.getHeight(context, 26),
              padding: ResponsiveDimensions.paddingSymmetric(
                context,
                horizontal: 8,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.rating,
                borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    ImageConstant.starIcon,
                    width: ResponsiveDimensions.getSize(context, 12),
                    height: ResponsiveDimensions.getHeight(context, 12),
                    fit: .scaleDown,
                  ),

                  // rating
                  Text(
                    '4.5',
                    style: AppTextStyle.labelBold(context, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
