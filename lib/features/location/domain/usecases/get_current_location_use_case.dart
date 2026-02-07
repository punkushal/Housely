import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/location/domain/entities/location.dart';
import 'package:housely/features/location/domain/repositories/location_repo.dart';

class GetCurrentLocationUseCase implements UseCaseWithoutParams<Location> {
  final LocationRepo locationRepo;

  GetCurrentLocationUseCase({required this.locationRepo});
  @override
  ResultFuture<Location> call() async {
    return await locationRepo.getCurrentLocation();
  }
}
