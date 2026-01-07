import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class FetchAllProperties implements UseCaseWithoutParams {
  final PropertyRepo repo;

  FetchAllProperties(this.repo);
  @override
  ResultFuture<List<Property>> call() async {
    return await repo.fetchAllProperties();
  }
}
