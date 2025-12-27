import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/home/presentation/cubit/favorite_toggle_cubit.dart';

class SmallCard extends StatelessWidget {
  /// for now there is hard coded value , later i'll implement
  /// dynamic values
  const SmallCard({super.key, this.onTap, this.height});

  /// favorite toggle function
  final void Function()? onTap;

  /// height of the card
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Image.asset(
              ImageConstant.fourthVilla,
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
          Spacer(),
          // favorite + rating section
          Column(
            mainAxisAlignment: .spaceBetween,
            children: [
              // favorite section
              GestureDetector(
                onTap: onTap,
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
    );
  }
}
