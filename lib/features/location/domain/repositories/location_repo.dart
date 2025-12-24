import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/location/domain/entities/location.dart';

abstract interface class LocationRepo {
  // get current location
  ResultFuture<Location> getCurrentLocation();

  // request location permission
  ResultFuture<bool> requestLocationPermission();

  // check location permission
  ResultFuture<bool> checkLocationPermission();
}
