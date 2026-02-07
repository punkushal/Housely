import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/number_extension.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/favorites/presentation/widgets/favorite_toggle_button.dart';
import 'package:housely/features/property/domain/entities/property.dart';

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.property, this.navigateTo});

  /// property
  final Property property;

  /// navigation to detail page
  final void Function()? navigateTo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateTo,
      child: Container(
        width: ResponsiveDimensions.getSize(context, 224),
        height: ResponsiveDimensions.getSize(context, 164),
        decoration: BoxDecoration(
          borderRadius: ResponsiveDimensions.borderRadiusLarge(context),
        ),
        child: Stack(
          children: [
            // later image will come from network
            ClipRRect(
              borderRadius: ResponsiveDimensions.borderRadiusLarge(context),
              child: CustomCacheContainer(
                imageUrl: property.media.coverImage['url'],
                width: .infinity,
                height: .infinity,
              ),
            ),
            Padding(
              padding: ResponsiveDimensions.paddingOnly(
                context,
                left: 16,
                top: 16,
                bottom: 24,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: .end,
                children: [
                  // price container
                  Container(
                    height: ResponsiveDimensions.getSize(context, 26),
                    padding: ResponsiveDimensions.paddingSymmetric(
                      context,
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: ResponsiveDimensions.borderRadiusSmall(
                        context,
                      ),
                      color: AppColors.surface,
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: "Rs${property.price.amount.toInt().toCompact}",
                        style: AppTextStyle.labelBold(
                          context,
                          color: AppColors.primaryPressed,
                        ),
                        children: [
                          TextSpan(
                            text: property.type.name == 'house'
                                ? '/month'
                                : '/night',
                            style: AppTextStyle.labelRegular(
                              context,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            // property name
                            SizedBox(
                              width: ResponsiveDimensions.getSize(context, 124),
                              child: Text(
                                property.name,
                                style: AppTextStyle.bodySemiBold(
                                  context,
                                  color: AppColors.surface,
                                ),
                                overflow: .ellipsis,
                              ),
                            ),

                            // location
                            Row(
                              mainAxisSize: .min,
                              children: [
                                SvgPicture.asset(ImageConstant.locationIcon),
                                SizedBox(
                                  width: ResponsiveDimensions.getSize(
                                    context,
                                    124,
                                  ),
                                  child: Text(
                                    property.location.address,
                                    style: AppTextStyle.bodyRegular(
                                      context,
                                      color: AppColors.border,
                                    ),
                                    overflow: .ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // favorite button
                      FavoriteToggleButton(property: property),
                    ],
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
