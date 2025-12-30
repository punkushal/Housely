import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/home/presentation/cubit/favorite_toggle_cubit.dart';

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.price,
    required this.imagePath,
    required this.propertyName,
    required this.location,
    this.onFavorite,
    this.navigateTo,
  });

  /// per month price
  final double price;

  /// image path
  final String imagePath;

  /// property name
  final String propertyName;

  /// location
  final String location;

  /// favorite toggle function
  final void Function()? onFavorite;

  /// navigation to detail page
  final void Function()? navigateTo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateTo,
      child: Container(
        width: ResponsiveDimensions.getSize(context, 224),
        height: ResponsiveDimensions.getHeight(context, 164),
        decoration: BoxDecoration(
          borderRadius: ResponsiveDimensions.borderRadiusLarge(context),
        ),
        child: Stack(
          children: [
            // later image will come from network
            ClipRRect(
              borderRadius: ResponsiveDimensions.borderRadiusLarge(context),
              child: Image.asset(imagePath),
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
                    height: ResponsiveDimensions.getHeight(context, 26),
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
                        text: "\$${price.toString()}",
                        style: AppTextStyle.labelBold(
                          context,
                          color: AppColors.primaryPressed,
                        ),
                        children: [
                          TextSpan(
                            text: "/month",
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
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          // property name
                          Text(
                            propertyName,
                            style: AppTextStyle.bodySemiBold(
                              context,
                              color: AppColors.surface,
                            ),
                          ),

                          // location
                          Row(
                            children: [
                              SvgPicture.asset(ImageConstant.locationIcon),
                              Text(
                                location,
                                style: AppTextStyle.bodyRegular(
                                  context,
                                  color: AppColors.border,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // favorite button
                      GestureDetector(
                        onTap: onFavorite,
                        child: Container(
                          width: ResponsiveDimensions.getSize(context, 24),
                          height: ResponsiveDimensions.getHeight(context, 24),
                          padding: ResponsiveDimensions.paddingAll4(context),
                          decoration: BoxDecoration(
                            shape: .circle,
                            color: AppColors.surface,
                          ),
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
                                    width: ResponsiveDimensions.getSize(
                                      context,
                                      16,
                                    ),
                                    height: ResponsiveDimensions.getHeight(
                                      context,
                                      16,
                                    ),
                                    fit: .scaleDown,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.error,
                                      .srcIn,
                                    ),
                                  );
                                },
                              ),
                        ),
                      ),
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
