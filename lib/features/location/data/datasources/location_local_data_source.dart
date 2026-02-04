import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:housely/core/error/exception.dart';
import 'package:housely/features/location/domain/entities/location.dart'
    as user_location;

abstract interface class LocationLocalDataSource {
  Future<user_location.Location> getCurrentLocation();
  Future<bool> requestLocationPermission();
  Future<bool> checkLocationPermission();
  Future<bool> isServiceEnabled();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  @override
  Future<user_location.Location> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: .high),
      );

      List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      return user_location.Location(
        latitude: position.latitude,
        longitude: position.longitude,
        address: "${placemark[0].name},  ${placemark[0].administrativeArea}",
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
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == .denied) {
        return false;
      } else if (permission == .deniedForever) {
        return false;
      }
      return permission == .always || permission == .whileInUse;
    } on PermissionDeniedException catch (e) {
      throw PermissionException(e.message ?? e.toString());
    } on PermissionRequestInProgressException catch (e) {
      throw PermissionException(e.message ?? e.toString());
    } catch (e) {
      throw PermissionException();
    }
  }

  @override
  Future<bool> isServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
