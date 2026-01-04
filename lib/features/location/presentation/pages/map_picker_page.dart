import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/location/presentation/cubit/location_cubit.dart';
import 'package:housely/features/location/presentation/widgets/drop_shadow.dart';
import 'package:housely/features/location/presentation/widgets/location_detail.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class MapPickerPage extends StatelessWidget {
  MapPickerPage({super.key, this.isOwner = false});

  /// check whether a normal user or property owner visits
  /// the map page. Default to normal user
  /// and if not then it is property owner
  final bool isOwner;
  final myLocation = LatLng(27.6983, 83.4653);

  Future<void> setMarker(LatLng position, BuildContext context) async {
    final cubit = context.read<LocationCubit>();

    List<Placemark> placemark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemark.isNotEmpty) {
      cubit.updateLocationFromMap(
        position.latitude,
        position.longitude,
        address: "${placemark[0].name},  ${placemark[0].administrativeArea}",
      );
    }
  }

  // handle back navigation
  void _handleBackNavigation(BuildContext context) {
    final state = context.read<LocationCubit>().state;
    if (state is LocationLoaded && state.location.address != null && isOwner) {
      context.pop(state.location);
    } else if (state is LocationLoaded && state.location.address != null) {
      context.router.replaceAll([TabWrapper(address: state.location.address)]);
    } else {
      SnackbarHelper.showInfo(context, "Please pick your location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LocationCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: myLocation,
                      zoom: 14,
                    ),
                    zoomControlsEnabled: false,
                    markers: {
                      Marker(
                        markerId: MarkerId('my home'),
                        draggable: true,
                        position: myLocation,
                        onDragEnd: (value) {
                          setMarker(value, context);
                        },
                      ),
                    },
                  ),

                  // location detail
                  BlocBuilder<LocationCubit, LocationState>(
                    builder: (context, state) {
                      if (state is LocationLoaded) {
                        return Positioned(
                          bottom: ResponsiveDimensions.getHeight(context, 160),
                          left: 0,
                          child: DropShadow(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 24),
                                blurRadius: ResponsiveDimensions.radiusXLarge(
                                  context,
                                  size: 48,
                                ),
                                spreadRadius: ResponsiveDimensions.radiusMedium(
                                  context,
                                  size: -12,
                                ),
                                color: Color(0x1F2A372E),
                              ),
                            ],
                            child: LocationDetail(
                              address:
                                  state.location.address ?? "no location found",
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),

                  Positioned(
                    bottom: ResponsiveDimensions.getHeight(context, 80),
                    left: ResponsiveDimensions.getSize(context, 24),
                    right: ResponsiveDimensions.getSize(context, 24),
                    child: CustomButton(
                      onTap: () => _handleBackNavigation(context),
                      buttonLabel: "Confirm location",
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
