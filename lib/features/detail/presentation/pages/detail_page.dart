import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/custom_carousel_slider.dart';
import 'package:housely/features/detail/presentation/widgets/image_list.dart';
import 'package:housely/features/detail/presentation/widgets/property_detail_section.dart';
import 'package:housely/features/home/presentation/cubit/favorite_toggle_cubit.dart';

@RoutePage()
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteToggleCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Details'),
              actionsPadding: ResponsiveDimensions.paddingOnly(
                context,
                left: 24,
              ),
              actions: [
                // favorite icon button
                GestureDetector(
                  onTap: () {
                    context.read<FavoriteToggleCubit>().toggleFavorite();
                  },
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
                          bool isFavorite = state;
                          return SvgPicture.asset(
                            isFavorite
                                ? ImageConstant.favoriteFilledIcon
                                : ImageConstant.favoriteIcon,
                            width: ResponsiveDimensions.getSize(context, 24),
                            height: ResponsiveDimensions.getHeight(context, 24),
                            colorFilter: ColorFilter.mode(
                              isFavorite
                                  ? AppColors.error
                                  : AppColors.textPrimary,
                              .srcIn,
                            ),
                          );
                        },
                      ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: ResponsiveDimensions.paddingSymmetric(
                  context,
                  horizontal: 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: ResponsiveDimensions.getHeight(context, 12),
                    children: [
                      // property image carousel
                      CustomCarouselSlider(),

                      // images list
                      ImageList(),

                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 12),
                      ),

                      // Detail section
                      PropertyDetailSection(),

                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
