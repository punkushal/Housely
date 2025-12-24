import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/location/domain/entities/location.dart';
import 'package:housely/features/location/domain/usecases/check_location_permission_use_case.dart';
import 'package:housely/features/location/domain/usecases/check_service_enabled_use_case.dart';
import 'package:housely/features/location/domain/usecases/get_current_location_use_case.dart';
import 'package:housely/features/location/domain/usecases/request_location_permission_use_case.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final CheckLocationPermissionUseCase checkLocationPermissionUseCase;
  final RequestLocationPermissionUseCase requestLocationPermissionUseCase;
  final CheckServiceEnabledUseCase checkServiceEnabledUseCase;
  LocationCubit({
    required this.getCurrentLocationUseCase,
    required this.checkLocationPermissionUseCase,
    required this.checkServiceEnabledUseCase,
    required this.requestLocationPermissionUseCase,
  }) : super(LocationInitial());

  // get location
  Future<void> getCurrentLocation() async {
    final permissionResult = await checkLocationPermissionUseCase();

    permissionResult.fold(
      (failure) => emit(PermissionDenied(failure.message)),
      (hasPermission) async {
        if (!hasPermission) {
          final requestResult = await requestLocationPermissionUseCase();

          requestResult.fold(
            (failure) => emit(PermissionDenied(failure.message)),
            (granted) async {
              if (granted) {
                await _fetchLocation();
              } else {
                emit(PermissionDenied("Permission denied"));
              }
            },
          );
        }
      },
    );
  }

  Future<void> _fetchLocation() async {
    final result = await getCurrentLocationUseCase();
    result.fold(
      (failure) => emit(LocationFailure(failure.message)),
      (location) => emit(LocationLoaded(location: location)),
    );
  }
}
