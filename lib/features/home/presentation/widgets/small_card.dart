import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/string_extension.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/home/presentation/cubit/favorite_toggle_cubit.dart';
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
        height: height ?? ResponsiveDimensions.getHeight(context, 84),
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
              child: CustomCacheContainer(
                imageUrl: property.media.coverImage['url'],
                width: 80,
                height: 74,
              ),
            ),

            // Property detail section
            SizedBox(
              width: ResponsiveDimensions.getSize(context, 152),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .end,
                spacing: ResponsiveDimensions.getHeight(context, 5),
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
                    spacing: ResponsiveDimensions.getSize(context, 4),
                    children: [
                      SvgPicture.asset(ImageConstant.locationIcon),
                      SizedBox(
                        width: ResponsiveDimensions.getSize(context, 112),
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
                  SizedBox(height: ResponsiveDimensions.getHeight(context, 5)),
                  // Property price
                  Text(
                    "\$${property.price.amount}/${isMonth ? "month" : "night"}",
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
                GestureDetector(
                  onTap: favoriteToggle,
                  child:
                      BlocSelector<
                        FavoriteToggleCubit,
                        FavoriteToggleState,
                        bool
                      >(
                        selector: (state) {
                          return state.isSelected;
                        },
                        builder: (context, state) {
                          return SvgPicture.asset(
                            state
                                ? ImageConstant.favoriteFilledIcon
                                : ImageConstant.favoriteIcon,
                            width: ResponsiveDimensions.getSize(context, 24),
                            height: ResponsiveDimensions.getHeight(context, 24),
                            fit: .scaleDown,
                            colorFilter: ColorFilter.mode(
                              AppColors.error,
                              .srcIn,
                            ),
                          );
                        },
                      ),
                ),
                Spacer(),
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
                    borderRadius: ResponsiveDimensions.borderRadiusMedium(
                      context,
                    ),
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
          ],
        ),
      ),
    );
  }
}
