import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class UpdateProperty implements UseCase<void, UpdateParams> {
  final PropertyRepo repo;

  UpdateProperty(this.repo);
  @override
  ResultVoid call(params) async {
    return await repo.updateProperty(params.property);
  }
}

class UpdateParams extends Equatable {
  final Property property;

  const UpdateParams(this.property);

  @override
  List<Object?> get props => [property];
}
