import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

import '../../entities/property.dart';

class GetPropertyByIdUseCase implements UseCase<Property, GetPropertyParam> {
  final PropertyRepo propertyRepo;

  GetPropertyByIdUseCase(this.propertyRepo);
  @override
  ResultFuture<Property> call(param) async {
    return await propertyRepo.fetchPropertyById(param.propertyId);
  }
}

class GetPropertyParam extends Equatable {
  final String propertyId;

  const GetPropertyParam(this.propertyId);
  @override
  List<Object?> get props => [propertyId];
}
