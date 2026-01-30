import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/auth/presentation/cubit/logout_cubit.dart';
import 'package:housely/features/profile/presentation/widgets/option_tile.dart';
import 'package:housely/features/profile/presentation/widgets/profile_section.dart';
import 'package:housely/features/property/presentation/cubit/owner_cubit.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LogoutCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<LogoutCubit, LogoutState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                context.router.replace(LoginRoute());
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await context.read<LogoutCubit>().logout();
                    },
                    icon: Icon(Icons.logout),
                  ),
                ],
              ),
              body: Padding(
                padding: ResponsiveDimensions.paddingSymmetric(
                  context,
                  horizontal: 22,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: ResponsiveDimensions.spacing12(context),
                    children: [
                      ProfileSection(),
                      SizedBox(height: ResponsiveDimensions.spacing16(context)),
                      Divider(color: AppColors.divider),

                      OptionTile(
                        label: "Payments",
                        iconPath: ImageConstant.payIcon,
                        onTap: () {},
                      ),

                      OptionTile(
                        label: "Notifications",
                        iconPath: ImageConstant.notificationIcon,
                        onTap: () {},
                      ),

                      OptionTile(
                        label: "Favorites",
                        iconPath: ImageConstant.favoriteIcon,
                        onTap: () {},
                      ),

                      OptionTile(
                        label: "Edit profile",
                        iconPath: ImageConstant.personIcon,
                        onTap: () {
                          context.router.push(EditProfileRoute());
                        },
                      ),

                      BlocBuilder<OwnerCubit, OwnerState>(
                        builder: (context, state) {
                          if (state is OwnerLoaded && state.owner != null) {
                            return Column(
                              children: [
                                OptionTile(
                                  label: "My properties list",
                                  iconPath: ImageConstant.hospitalIcon,
                                  onTap: () {
                                    context.router.push(MyPropertyListRoute());
                                  },
                                ),

                                OptionTile(
                                  label: "Booking request",
                                  iconPath: ImageConstant.infoSquareIcon,
                                  onTap: () {
                                    context.router.push(BookingRequestRoute());
                                  },
                                ),
                              ],
                            );
                          }
                          return SizedBox.shrink();
                        },
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
