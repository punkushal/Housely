import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class UpdateImageFile implements UseCase<Map<String, String>, UpdateParam> {
  final PropertyRepo repo;

  UpdateImageFile({required this.repo});
  @override
  ResultFuture<Map<String, String>> call(params) async {
    return await repo.updateImageFile(fileId: params.fileId);
  }
}

class UpdateParam extends Equatable {
  final String fileId;

  const UpdateParam({required this.fileId});

  @override
  List<Object?> get props => [fileId];
}
