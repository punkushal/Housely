import 'package:geolocator/geolocator.dart';
import 'package:housely/core/error/exception.dart';
import 'package:housely/features/location/domain/entities/location.dart';

abstract interface class LocationLocalDataSource {
  Future<Location> getCurrentLocation();
  Future<bool> requestLocationPermission();
  Future<bool> checkLocationPermission();
  Future<bool> isServiceEnabled();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  @override
  Future<Location> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: .high),
      );
      return Location(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      throw PermissionException("Couldn't get the current location: $e");
    }
  }

  @override
  Future<bool> checkLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      return permission == .always || permission == .whileInUse;
    } catch (e) {
      throw PermissionException("Couldn't check the location permission: $e");
    }
  }

  @override
  Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == .denied) {
        return false;
      } else if (permission == .deniedForever) {
        return false;
      }
      return permission == .always || permission == .whileInUse;
    } on PermissionDeniedException catch (e) {
      throw PermissionException(e.message!);
    } on PermissionRequestInProgressException catch (e) {
      throw PermissionException(e.message!);
    } catch (e) {
      throw PermissionException();
    }
  }

  @override
  Future<bool> isServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
