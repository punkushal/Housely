import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class DeleteProperty implements UseCase<void, DeletePropertyParam> {
  final PropertyRepo repo;

  DeleteProperty(this.repo);
  @override
  ResultFuture<void> call(params) async {
    return await repo.deleteProperty(params.propertyId);
  }
}

class DeletePropertyParam extends Equatable {
  final String propertyId;

  const DeletePropertyParam(this.propertyId);
  @override
  List<Object?> get props => [propertyId];
}
