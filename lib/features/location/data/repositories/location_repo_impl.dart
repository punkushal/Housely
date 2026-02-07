import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:housely/core/error/exception.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/location/data/datasources/location_local_data_source.dart';
import 'package:housely/features/location/domain/entities/location.dart';
import 'package:housely/features/location/domain/repositories/location_repo.dart';

class LocationRepoImpl implements LocationRepo {
  final LocationLocalDataSource dataSource;

  LocationRepoImpl({required this.dataSource});
  @override
  ResultFuture<bool> checkLocationPermission() async {
    try {
      final result = await dataSource.checkLocationPermission();
      return Right(result);
    } catch (e) {
      return Left(PermissionFailure("Couldn't check the permission: $e"));
    }
  }

  @override
  ResultFuture<bool> checkSeriviceEnabled() async {
    try {
      final result = await dataSource.isServiceEnabled();
      return Right(result);
    } catch (e) {
      return Left(PermissionFailure("Location service not enable"));
    }
  }

  @override
  ResultFuture<Location> getCurrentLocation() async {
    try {
      final result = await dataSource.getCurrentLocation();
      return Right(result);
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.message));
    } catch (e) {
      return Left(PermissionFailure("Couldn't get the current location: $e"));
    }
  }

  @override
  ResultFuture<bool> requestLocationPermission() async {
    try {
      final result = await dataSource.requestLocationPermission();
      return Right(result);
    } on PermissionDeniedException catch (e) {
      return Left(PermissionFailure(e.message ?? e.toString()));
    } on PermissionRequestInProgressException catch (e) {
      return Left(PermissionFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(
        PermissionFailure("Couldn't get the location permissiona: $e"),
      );
    }
  }
}
