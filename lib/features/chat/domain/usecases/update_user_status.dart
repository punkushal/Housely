import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class UpdateOnlineStatusUseCase implements UseCase<void, UpdateStatusParams> {
  final ChatRepository chatRepository;

  UpdateOnlineStatusUseCase(this.chatRepository);
  @override
  ResultFuture<void> call(params) async {
    return await chatRepository.updateOnlineStatus(
      isOnline: params.isOnline,
      userId: params.userId,
    );
  }
}

class UpdateStatusParams extends Equatable {
  final bool isOnline;
  final String userId;

  const UpdateStatusParams({required this.isOnline, required this.userId});

  @override
  List<Object?> get props => [isOnline, userId];
}
