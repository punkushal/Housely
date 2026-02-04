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
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:housely/features/home/data/bottom_nav_list.dart';
import 'package:housely/features/home/presentation/widgets/banner/banner_section.dart';
import 'package:housely/features/home/presentation/widgets/custom_tab_item.dart';
import 'package:housely/features/home/presentation/widgets/icon_wrapper.dart';
import 'package:housely/features/home/presentation/widgets/popular/popular_section.dart';
import 'package:housely/features/home/presentation/widgets/recommended/recommended_section.dart';
import 'package:housely/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:housely/features/property/presentation/bloc/fetch/property_list_bloc.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class TabWrapper extends StatelessWidget {
  const TabWrapper({super.key, this.address});
  final String? address;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<PropertyListBloc>()),
        BlocProvider(
          create: (context) => sl<ProfileCubit>()
            ..setProfileUrl(
              (context.read<AuthCubit>().state as Authenticated).currentUser!,
            ),
        ),
      ],
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PropertyListBloc>().add(GetAllProperties());
      context.read<PropertyListBloc>().add(GetRecommendedProperties());
      context.read<FavoritesBloc>().add(LoadFavoritesRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PropertyListBloc, PropertyListState>(
        builder: (context, state) {
          if (state is PropertyListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "Location",
                      style: AppTextStyle.labelMedium(
                        context,
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
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
                            widget.address != null
                                ? widget.address!
                                : 'Home page',
                            overflow: .ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                actionsPadding: ResponsiveDimensions.paddingOnly(
                  context,
                  right: 18,
                ),
                actions: [
                  IconWrapper(iconPath: ImageConstant.notificationIcon),
                  ResponsiveDimensions.gapW8(context),
                  IconWrapper(
                    iconPath: ImageConstant.chatIcon,
                    onTap: () => context.router.push(ChatListRoute()),
                  ),
                ],
              ),

              // content
              SliverPadding(
                padding: ResponsiveDimensions.paddingSymmetric(
                  context,
                  horizontal: 24,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      spacing: ResponsiveDimensions.getHeight(context, 16),
                      children: [
                        SizedBox(
                          height: ResponsiveDimensions.getHeight(context, 16),
                        ),

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

                        // banner section
                        BannerSection(),

                        // recommended section
                        RecommendedSection(),

                        // SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),
                        // // nearby section : later data fetched from internet with current logged in near properties
                        // HeadingSection(title: 'Nearby', onTapText: "See all"),
                        // NearbyList(),
                        SizedBox(
                          height: ResponsiveDimensions.getSize(context, 8),
                        ),

                        // popular section
                        PopularSection(),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
