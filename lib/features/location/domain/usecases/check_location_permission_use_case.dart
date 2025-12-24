import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/location/domain/repositories/location_repo.dart';

class CheckLocationPermissionUseCase implements UseCaseWithoutParams<bool> {
  final LocationRepo locationRepo;

  CheckLocationPermissionUseCase({required this.locationRepo});
  @override
  ResultFuture<bool> call() async {
    return await locationRepo.checkLocationPermission();
  }
}
