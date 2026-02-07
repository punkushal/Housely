import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

import '../../entities/property.dart';

class GetMyPropertiesUseCase
    implements
        UseCase<
          ({List<Property> data, DocumentSnapshot? lastDoc}),
          MyPropertyParam
        > {
  final PropertyRepo propertyRepo;

  GetMyPropertiesUseCase(this.propertyRepo);
  @override
  ResultFuture<({List<Property> data, DocumentSnapshot? lastDoc})> call(
    param,
  ) async {
    return await propertyRepo.fetchMyProperties(
      userId: param.userId,
      lastDoc: param.lastDoc,
    );
  }
}

class MyPropertyParam extends Equatable {
  final String userId;
  final DocumentSnapshot? lastDoc;

  const MyPropertyParam({required this.userId, this.lastDoc});
  @override
  List<Object?> get props => [userId, lastDoc];
}
