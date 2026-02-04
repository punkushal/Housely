import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class FetchAllProperties
    implements
        UseCase<
          ({List<Property> data, DocumentSnapshot? lastDoc}),
          FetchParam
        > {
  final PropertyRepo repo;

  FetchAllProperties(this.repo);
  @override
  ResultFuture<({List<Property> data, DocumentSnapshot? lastDoc})> call(
    param,
  ) async {
    return await repo.fetchAllProperties(lastDoc: param.lastDoc);
  }
}

class FetchParam extends Equatable {
  final DocumentSnapshot? lastDoc;

  const FetchParam(this.lastDoc);

  @override
  List<Object?> get props => [lastDoc];
}
