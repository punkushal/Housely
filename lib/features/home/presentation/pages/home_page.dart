import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/home/presentation/cubit/favorite_toggle_cubit.dart';
import 'package:housely/features/home/presentation/widgets/custom_tab_item.dart';
import 'package:housely/features/home/presentation/widgets/heading_section.dart';
import 'package:housely/features/home/presentation/widgets/icon_wrapper.dart';
import 'package:housely/features/home/presentation/widgets/nearby_list.dart';
import 'package:housely/features/home/presentation/widgets/recommended_list.dart';
import 'package:housely/features/home/presentation/widgets/small_card.dart';
import 'package:housely/features/home/presentation/widgets/top_location_card.dart';

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
          BookingRoute(),
          ProfileRoute(),
        ],
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
              children: [
                GestureDetector(
                  onTap: () => tabsRouter.setActiveIndex(0),
                  child: CustomBottomNavItem(
                    iconPath: ImageConstant.homeIcon,
                    filledIconPath: ImageConstant.homeFilledIcon,
                    label: 'Home',
                    isActive: tabsRouter.activeIndex == 0,
                  ),
                ),
                GestureDetector(
                  onTap: () => tabsRouter.setActiveIndex(1),
                  child: CustomBottomNavItem(
                    iconPath: ImageConstant.discoveryIcon,
                    filledIconPath: ImageConstant.discoveryFilledIcon,
                    label: 'Explore',
                    isActive: tabsRouter.activeIndex == 1,
                  ),
                ),
                GestureDetector(
                  onTap: () => tabsRouter.setActiveIndex(2),
                  child: CustomBottomNavItem(
                    iconPath: ImageConstant.documentIcon,
                    filledIconPath: ImageConstant.documentFilledIcon,
                    label: 'My Booking',
                    isActive: tabsRouter.activeIndex == 2,
                  ),
                ),
                GestureDetector(
                  onTap: () => tabsRouter.setActiveIndex(3),
                  child: CustomBottomNavItem(
                    iconPath: ImageConstant.personIcon,
                    filledIconPath: ImageConstant.personFilledIcon,
                    label: 'Profile',
                    isActive: tabsRouter.activeIndex == 3,
                  ),
                ),
              ],
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
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
                // ask dai to whether should i make this field tappable
                CustomTextField(
                  prefixIcon: SvgPicture.asset(
                    ImageConstant.searchIcon,
                    height: ResponsiveDimensions.getHeight(context, 24),
                    width: ResponsiveDimensions.getSize(context, 24),
                    fit: .scaleDown,
                  ),
                  suffixIcon: SvgPicture.asset(
                    ImageConstant.filterIcon,
                    height: ResponsiveDimensions.getHeight(context, 24),
                    width: ResponsiveDimensions.getSize(context, 24),
                    fit: .scaleDown,
                  ),
                  hintText: "Search Property",
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
                // TODO : i have to make it tappable and changes it's appearance
                HeadingSection(title: "Top Locations", onTapText: "See all"),
                Row(
                  spacing: ResponsiveDimensions.getSize(context, 12),
                  children: [
                    TopLocationCard(location: "Pokhara"),
                    TopLocationCard(location: "Lumbini"),
                  ],
                ),
                SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),
                HeadingSection(title: "Popular for you", onTapText: "See all"),

                // TODO: later i will create reusable list widget for it
                SizedBox(
                  height: ResponsiveDimensions.getHeight(context, 400),
                  child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: ResponsiveDimensions.paddingSymmetric(
                          context,
                          vertical: 12,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: .min,
                            spacing: ResponsiveDimensions.getHeight(
                              context,
                              12,
                            ),
                            children: [
                              SmallCard(
                                height: ResponsiveDimensions.getHeight(
                                  context,
                                  72,
                                ),
                              ),
                              Divider(color: AppColors.divider),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
