import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class CreateOrGetChatUseCase implements UseCase<Chat, CreateOrGetChatParams> {
  final ChatRepository repository;

  CreateOrGetChatUseCase(this.repository);

  @override
  ResultFuture<Chat> call(CreateOrGetChatParams params) async {
    return await repository.createOrGetChat(
      currentUser: params.currentUser,
      otherUser: params.otherUser,
    );
  }
}

class CreateOrGetChatParams extends Equatable {
  final ChatUser currentUser;
  final ChatUser otherUser;

  const CreateOrGetChatParams({
    required this.currentUser,
    required this.otherUser,
  });

  @override
  List<Object?> get props => [currentUser, otherUser];
}
