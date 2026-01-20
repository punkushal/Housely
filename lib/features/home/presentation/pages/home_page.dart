import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/home/data/bottom_nav_list.dart';
import 'package:housely/features/home/presentation/cubit/favorite_toggle_cubit.dart';
import 'package:housely/features/home/presentation/widgets/custom_tab_item.dart';
import 'package:housely/features/home/presentation/widgets/heading_section.dart';
import 'package:housely/features/home/presentation/widgets/icon_wrapper.dart';
import 'package:housely/features/home/presentation/widgets/nearby_list.dart';
import 'package:housely/features/home/presentation/widgets/recommended_list.dart';
import 'package:housely/features/home/presentation/widgets/top_location_list.dart';

@RoutePage()
class TabWrapper extends StatelessWidget {
  const TabWrapper({super.key, this.address});
  final String? address;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteToggleCubit(),
      child: AutoTabsScaffold(
        routes: [
          HomeRoute(address: address),
          ExploreRoute(),
          MyBookingRoute(),
          ProfileRoute(),
        ],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pushRoute<bool>(CreateNewPropertyRoute());
          },
          shape: RoundedRectangleBorder(
            borderRadius: ResponsiveDimensions.borderRadiusLarge(
              context,
              size: 28,
            ),
          ),
          child: Icon(Icons.add),
        ),
        bottomNavigationBuilder: (_, tabsRouter) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.05),
                  blurRadius: ResponsiveDimensions.radiusSmall(context),
                ),
              ],
            ),
            padding: ResponsiveDimensions.paddingOnly(context, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navList.length, (index) {
                final navItem = navList[index];
                return GestureDetector(
                  onTap: () => tabsRouter.setActiveIndex(index),
                  child: CustomBottomNavItem(
                    label: navItem.label,
                    isActive: tabsRouter.activeIndex == index,
                    iconPath: navItem.iconPath,
                    filledIconPath: navItem.iconFilledPath,
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.address});
  final String? address;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: .min,
          children: [
            Row(
              children: [
                Text(
                  "Location",
                  style: AppTextStyle.labelMedium(
                    context,
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primaryPressed,
                ),
              ],
            ),
            Row(
              spacing: ResponsiveDimensions.getSize(context, 2),
              children: [
                SvgPicture.asset(
                  ImageConstant.locationFilledIcon,
                  height: ResponsiveDimensions.getSize(context, 24),
                ),
                SizedBox(
                  width: ResponsiveDimensions.getSize(context, 92),
                  child: Text(
                    widget.address != null ? widget.address! : 'Home page',
                    overflow: .ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconWrapper(iconPath: ImageConstant.notificationIcon),
          ResponsiveDimensions.gapW8(context),
          IconWrapper(iconPath: ImageConstant.chatIcon),
          ResponsiveDimensions.gapW24(context),
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
              spacing: ResponsiveDimensions.getHeight(context, 16),
              children: [
                SizedBox(height: ResponsiveDimensions.getHeight(context, 16)),

                // Search section
                CustomTextField(
                  prefixIcon: SvgPicture.asset(
                    ImageConstant.searchIcon,
                    height: ResponsiveDimensions.getHeight(context, 24),
                    width: ResponsiveDimensions.getSize(context, 24),
                    fit: .scaleDown,
                  ),
                  hintText: "Search Property",
                  readOnly: true,
                  onTap: () => context.router.push(ExploreRoute()),
                  contentPadding: ResponsiveDimensions.paddingSymmetric(
                    context,
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),

                // banner section which i will ask dai and then work on it

                // recommended section
                HeadingSection(
                  title: 'Recommended',
                  onTapText: "See all",
                  onTap: () => context.router.push(
                    SeeAllListRoute(appBarTitle: "Recommended"),
                  ),
                ),
                RecommendedList(),
                SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),
                // nearby section : later data fetched from internet with current logged in near properties
                HeadingSection(title: 'Nearby', onTapText: "See all"),
                NearbyList(),
                SizedBox(height: ResponsiveDimensions.getHeight(context, 4)),

                // top location section
                HeadingSection(title: "Top Locations", onTapText: "See all"),
                TopLocationList(),

                SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),
                HeadingSection(title: "Popular for you", onTapText: "See all"),

                // Popular property list
                // SizedBox(
                //   height: ResponsiveDimensions.getHeight(context, 400),
                //   child: PropertyList(horizontal: 0),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
