import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

import '../../entities/property.dart';

class GetRecommendedPropertiesUseCase
    implements
        UseCase<
          ({List<Property> data, DocumentSnapshot? lastDoc}),
          GetRecommendedParam
        > {
  final PropertyRepo propertyRepo;

  GetRecommendedPropertiesUseCase(this.propertyRepo);
  @override
  ResultFuture<({List<Property> data, DocumentSnapshot? lastDoc})> call(
    param,
  ) async {
    return await propertyRepo.fetchRecommendedProperties(
      lastDoc: param.lastDoc,
    );
  }
}

class GetRecommendedParam extends Equatable {
  final DocumentSnapshot? lastDoc;

  const GetRecommendedParam(this.lastDoc);
  @override
  List<Object?> get props => [lastDoc];
}
