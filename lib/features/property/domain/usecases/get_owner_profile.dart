import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';
import 'package:housely/features/property/domain/repository/owner_repo.dart';

class GetOwnerProfile implements UseCaseWithoutParams {
  final OwnerRepo repo;

  GetOwnerProfile(this.repo);
  @override
  ResultFuture<PropertyOwner?> call() async {
    return await repo.getOwnerProfile();
  }
}
