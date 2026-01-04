import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class UpdateImageFile implements UseCase<String, UpdateParam> {
  final PropertyRepo repo;

  UpdateImageFile({required this.repo});
  @override
  ResultFuture<String> call(params) async {
    return await repo.updateImageFile(
      bucketId: params.bucketId,
      fileId: params.fileId,
    );
  }
}

class UpdateParam extends Equatable {
  final String bucketId;
  final String fileId;

  const UpdateParam({required this.bucketId, required this.fileId});

  @override
  List<Object?> get props => [bucketId, fileId];
}
