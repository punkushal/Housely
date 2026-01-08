import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/custom_carousel_slider.dart';
import 'package:housely/features/detail/presentation/widgets/image_list.dart';
import 'package:housely/features/detail/presentation/widgets/property_detail_section.dart';
import 'package:housely/features/home/presentation/cubit/favorite_toggle_cubit.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/presentation/cubit/owner_cubit.dart';

@RoutePage()
class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.property});

  /// actual property data
  final Property property;
  @override
  Widget build(BuildContext context) {
    final urls = (property.media.gallery['images'] as List)
        .where((element) => element.containsKey("url"))
        .map((item) => item['url'] as String)
        .toList();
    return BlocProvider(
      create: (context) => FavoriteToggleCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text('Details'),
              actionsPadding: ResponsiveDimensions.paddingOnly(
                context,
                right: 24,
              ),
              actions: [
                // favorite icon button
                BlocBuilder<OwnerCubit, OwnerState>(
                  builder: (context, state) {
                    if (state is OwnerLoaded && state.owner != null) {
                      return SizedBox.shrink();
                    }
                    return GestureDetector(
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
                                width: ResponsiveDimensions.getSize(
                                  context,
                                  24,
                                ),
                                height: ResponsiveDimensions.getHeight(
                                  context,
                                  24,
                                ),
                                colorFilter: ColorFilter.mode(
                                  isFavorite
                                      ? AppColors.error
                                      : AppColors.textPrimary,
                                  .srcIn,
                                ),
                              );
                            },
                          ),
                    );
                  },
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
                      CustomCarouselSlider(
                        imageUrls: [property.media.coverImage['url'], ...urls],
                      ),

                      // images list
                      ImageList(imageUrls: urls),

                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 12),
                      ),

                      // Detail section
                      PropertyDetailSection(property: property),

                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: IconButton(
              onPressed: () {
                context.router.push(CreateNewPropertyRoute(property: property));
              },
              icon: Container(
                padding: ResponsiveDimensions.paddingAll8(context),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.edit_rounded, color: AppColors.background),
              ),
            ),
          );
        },
      ),
    );
  }
}
