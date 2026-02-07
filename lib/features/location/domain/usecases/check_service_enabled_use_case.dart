import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/location/domain/repositories/location_repo.dart';

class CheckServiceEnabledUseCase implements UseCaseWithoutParams<bool> {
  final LocationRepo locationRepo;

  CheckServiceEnabledUseCase({required this.locationRepo});
  @override
  ResultFuture<bool> call() async {
    return await locationRepo.checkSeriviceEnabled();
  }
}
