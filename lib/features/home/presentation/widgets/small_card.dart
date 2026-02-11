import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/context_extension.dart';
import 'package:housely/core/extensions/number_extension.dart';
import 'package:housely/core/extensions/string_extension.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/favorites/presentation/widgets/favorite_toggle_button.dart';
import 'package:housely/features/property/domain/entities/property.dart';

class SmallCard extends StatelessWidget {
  const SmallCard({
    super.key,
    this.favoriteToggle,
    this.height,
    this.navigateTo,
    required this.property,
  });

  /// favorite toggle function
  final void Function()? favoriteToggle;

  /// height of the card
  final double? height;

  /// navigation to detail page
  final void Function()? navigateTo;

  /// property
  final Property property;

  @override
  Widget build(BuildContext context) {
    final isMonth =
        property.type.name.toLowerCase() ==
        PropertyType.house.name.toLowerCase();
    return GestureDetector(
      onTap: navigateTo,
      child: Container(
        height: height ?? context.responsive(84),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.sp16),
        ),
        child: Row(
          crossAxisAlignment: .end,
          spacing: context.sp12,
          children: [
            // image container
            ClipRRect(
              borderRadius: BorderRadius.circular(context.sp8),
              child: CustomCacheContainer(
                imageUrl: property.media.coverImage['url'],
                width: 80,
                height: 74,
              ),
            ),

            // Property detail section
            SizedBox(
              width: context.responsive(152),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .end,
                spacing: context.responsive(5),
                children: [
                  // Property name
                  Text(
                    property.name.capitalize,
                    overflow: .ellipsis,
                    style: AppTextStyle.bodySemiBold(context),
                  ),

                  // Property location
                  Row(
                    mainAxisSize: .min,
                    spacing: context.responsive(4),
                    children: [
                      SvgPicture.asset(ImageConstant.locationIcon),
                      SizedBox(
                        width: context.responsive(112),
                        child: Text(
                          property.location.address,
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
                  SizedBox(height: context.responsive(5)),
                  // Property price
                  Text(
                    "Rs${property.price.amount.toInt().toCompact}/${isMonth ? "month" : "night"}",
                    style: AppTextStyle.labelSemiBold(
                      context,
                      fontSize: 10,
                      lineHeight: 14,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            // favorite + rating section
            Column(
              mainAxisAlignment: .end,
              children: [
                // favorite section
                FavoriteToggleButton(property: property),
                Spacer(),

                // rating container
                Container(
                  width: context.sp40,
                  height: context.responsive(26),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.sp4,
                    vertical: context.responsive(6),
                  ),
                  decoration: BoxDecoration(
                    color: property.rating.averageRating == 0
                        ? Colors.transparent
                        : AppColors.rating,
                    borderRadius: ResponsiveDimensions.borderRadiusMedium(
                      context,
                    ),
                  ),
                  child: property.rating.averageRating == 0
                      ? const SizedBox.shrink() // Empty but container still takes space
                      : Row(
                          children: [
                            SvgPicture.asset(
                              ImageConstant.starIcon,
                              width: context.sp12,
                              height: context.sp12,
                            ),

                            // rating
                            Text(
                              property.rating.averageRating.toStringAsFixed(1),
                              style: AppTextStyle.labelBold(
                                context,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
