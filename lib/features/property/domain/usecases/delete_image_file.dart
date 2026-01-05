import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class DeleteImageFile implements UseCase<void, DeleteParam> {
  final PropertyRepo repo;

  DeleteImageFile({required this.repo});
  @override
  ResultFuture<void> call(params) async {
    return await repo.deleteImageFile(fileId: params.fileId);
  }
}

class DeleteParam extends Equatable {
  final String fileId;

  const DeleteParam({required this.fileId});

  @override
  List<Object?> get props => [fileId];
}
