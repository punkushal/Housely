import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';
import 'package:housely/features/property/domain/repository/owner_repo.dart';

class CreateOwnerProfile implements UseCase<void, OwnerParam> {
  final OwnerRepo repo;

  CreateOwnerProfile(this.repo);
  @override
  ResultFuture<void> call(params) async {
    return await repo.createOwnerProfile(owner: params.owner);
  }
}

class OwnerParam extends Equatable {
  final PropertyOwner owner;

  const OwnerParam({required this.owner});
  @override
  List<Object?> get props => [owner];
}
