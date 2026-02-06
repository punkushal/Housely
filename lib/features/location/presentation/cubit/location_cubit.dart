import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/location/domain/entities/location.dart';
import 'package:housely/features/location/domain/usecases/check_location_permission_use_case.dart';
import 'package:housely/features/location/domain/usecases/check_service_enabled_use_case.dart';
import 'package:housely/features/location/domain/usecases/get_current_location_use_case.dart';
import 'package:housely/features/location/domain/usecases/request_location_permission_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final CheckLocationPermissionUseCase checkLocationPermissionUseCase;
  final RequestLocationPermissionUseCase requestLocationPermissionUseCase;
  final CheckServiceEnabledUseCase checkServiceEnabledUseCase;
  
  static const String _locationKey = 'location_data';
  static const String _skippedKey = 'location_skipped';

  LocationCubit({
    required this.getCurrentLocationUseCase,
    required this.checkLocationPermissionUseCase,
    required this.checkServiceEnabledUseCase,
    required this.requestLocationPermissionUseCase,
  }) : super(LocationInitial());

  // Check for saved location or skipped state on startup
  Future<void> checkSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final bool skipped = prefs.getBool(_skippedKey) ?? false;
    
    if (skipped) {
      emit(LocationSkipped());
      return;
    }

    final String? locationJson = prefs.getString(_locationKey);
    if (locationJson != null) {
      try {
        final location = Location.fromJson(jsonDecode(locationJson));
        emit(LocationLoaded(location: location));
      } catch (e) {
        emit(LocationInitial());
      }
    } else {
      emit(LocationInitial());
    }
  }

  // Skip location selection
  Future<void> skipLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_skippedKey, true);
    await prefs.remove(_locationKey);
    emit(LocationSkipped());
  }

  // Save location to preferences
  Future<void> saveLocation(Location location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_locationKey, jsonEncode(location.toJson()));
    await prefs.remove(_skippedKey); // If user selects location, remove skipped flag
    emit(LocationLoaded(location: location));
  }

  // get location
  Future<void> getCurrentLocation() async {
    emit(LocationLoading());
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
                emit(PermissionDenied("Location permission denied"));
              }
            },
          );
        } else {
          await _fetchLocation();
        }
      },
    );
  }

  Future<void> _fetchLocation() async {
    final result = await getCurrentLocationUseCase();
    result.fold(
      (failure) => emit(LocationFailure(failure.message)),
      (location) async {
        await saveLocation(location);
      },
    );
  }

  void updateLocationFromMap(
    double latitude,
    double longitude, {
    String? address,
  }) {
    final location = Location(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
    saveLocation(location);
  }

  void reset() {
    emit(LocationInitial());
  }
}
