import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class CreateProperty implements UseCase<void, CreateParam> {
  final PropertyRepo repo;

  CreateProperty({required this.repo});
  @override
  ResultFuture<void> call(params) async {
    return await repo.createProperty(params.property);
  }
}

class CreateParam extends Equatable {
  final Property property;

  const CreateParam({required this.property});

  @override
  List<Object?> get props => [property];
}
