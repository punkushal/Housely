import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/location/presentation/cubit/location_cubit.dart';
import 'package:housely/features/location/presentation/widgets/drop_shadow.dart';
import 'package:housely/features/onboarding/presentation/widgets/skip_button.dart';
import 'package:housely/injection_container.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  void _getCurrentLocation(BuildContext context) async {
    await context.read<LocationCubit>().getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LocationCubit>(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            SkipButton(onTap: () => context.router.replace(HomeRoute())),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: .center,
              spacing: ResponsiveDimensions.spacing16(context),
              children: [
                SizedBox(height: ResponsiveDimensions.getHeight(context, 40)),
                Padding(
                  padding: ResponsiveDimensions.paddingSymmetric(
                    context,
                    horizontal: 38,
                  ),
                  child: Column(
                    spacing: ResponsiveDimensions.spacing16(context),
                    children: [
                      //location image
                      Image.asset(ImageConstant.searchLocationImg),

                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 14),
                      ),
                      // welcome message
                      Text(
                        "Hi, Nice to meet you !",
                        style: AppTextStyle.bodySemiBold(
                          context,
                          fontSize: 20,
                          lineHeight: 26,
                        ),
                      ),

                      // info message
                      Text(
                        "Choose your location to find property around you",
                        style: AppTextStyle.bodyRegular(
                          context,
                          fontSize: 14,
                          color: AppColors.textHint,
                        ),
                        textAlign: .center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.getHeight(context, 60)),
                // current location button
                DropShadow(
                  child: BlocConsumer<LocationCubit, LocationState>(
                    listener: (context, state) {
                      if (state is LocationFailure) {
                        SnackbarHelper.showError(context, state.message);
                      } else if (state is PermissionDenied) {
                        SnackbarHelper.showWarning(
                          context,
                          state.message,
                          action: SnackBarAction(
                            label: 'Enable',
                            onPressed: () async {
                              await openAppSettings();
                            },
                          ),
                        );
                      } else if (state is LocationLoaded) {
                        SnackbarHelper.showSuccess(
                          context,
                          state.location.address ?? "no address found",
                        );
                        context.router.replace(
                          HomeRoute(address: state.location.address),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is LocationLoading;
                      return CustomButton(
                        onTap: () =>
                            isLoading ? null : _getCurrentLocation(context),
                        buttonLabel: "Use current location",
                        horizontal: 24,
                        isLoading: isLoading,
                      );
                    },
                  ),
                ),
                DropShadow(
                  child: CustomButton(
                    onTap: () async {
                      context.router.push(LocationWrapper());
                    },
                    buttonLabel: "Select it manually",
                    horizontal: 24,
                    isOutlined: true,
                    textColor: AppColors.primary,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.getHeight(context, 48)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
