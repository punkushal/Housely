import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/context_extension.dart';
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
import 'package:housely/features/property/presentation/bloc/fetch/property_list_bloc.dart';
import 'package:housely/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:housely/features/location/presentation/cubit/location_cubit.dart';
import 'package:housely/injection_container.dart';
import 'package:housely/features/home/presentation/widgets/nearby/nearby_list.dart';

@RoutePage()
class TabWrapper extends StatelessWidget {
  const TabWrapper({super.key, this.address});
  final String? address;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<NotificationCubit>()..loadNotifications(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => sl<LocationCubit>()..checkSavedLocation(),
          lazy: false,
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
                  blurRadius: context.sp8,
                ),
              ],
            ),
            padding: EdgeInsets.only(bottom: context.sp20),
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
      context.read<PropertyListBloc>().add(
        GetMyProperties(
          userId: (context.read<AuthCubit>().state as Authenticated)
              .currentUser!
              .uid,
        ),
      );
      context.read<FavoritesBloc>().add(LoadFavoritesRequested());
      if (context.mounted) {
        context.read<NotificationCubit>().loadNotifications();
      }
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
                centerTitle: false,
                title: Text('Housely'),

                actionsPadding: EdgeInsets.only(right: context.responsive(18)),
                actions: [
                  BlocBuilder<NotificationCubit, NotificationState>(
                    builder: (context, state) {
                      int count = 0;
                      if (state is NotificationLoaded) {
                        count = state.notifications
                            .where((n) => !n.isRead)
                            .length;
                        count = state.notifications.length;
                      }
                      return IconWrapper(
                        iconPath: ImageConstant.notificationIcon,
                        notificationCount: count,
                        onTap: () async {
                          await context.router.push(NotificationRoute());
                          if (context.mounted) {
                            context
                                .read<NotificationCubit>()
                                .loadNotifications();
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(width: context.sp8),
                  IconWrapper(
                    iconPath: ImageConstant.chatIcon,
                    onTap: () => context.router.push(ChatListRoute()),
                  ),
                ],
              ),

              // content
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: context.sp24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      spacing: context.sp16,
                      children: [
                        SizedBox(height: context.sp16),

                        // Search section
                        CustomTextField(
                          prefixIcon: SvgPicture.asset(
                            ImageConstant.searchIcon,
                            height: context.sp24,
                            width: context.sp24,
                            fit: .scaleDown,
                          ),
                          hintText: "Search Property",
                          readOnly: true,
                          onTap: () => context.router.push(ExploreRoute()),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: context.sp16,
                            vertical: context.responsive(14),
                          ),
                        ),

                        // banner section
                        BannerSection(),

                        // recommended section
                        RecommendedSection(),

                        BlocConsumer<LocationCubit, LocationState>(
                          listener: (context, state) {
                            if (state is LocationLoaded) {
                              context.read<PropertyListBloc>().add(
                                GetNearbyProperties(
                                  latitude: state.location.latitude,
                                  longitude: state.location.longitude,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is LocationLoaded) {
                              return NearbyList(
                                latitude: state.location.latitude,
                                longitude: state.location.longitude,
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
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
