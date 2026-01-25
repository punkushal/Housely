import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class DeleteChatUseCase implements UseCase<void, DeleteChatParam> {
  final ChatRepository chatRepository;

  DeleteChatUseCase(this.chatRepository);
  @override
  ResultFuture<void> call(params) async {
    return await chatRepository.deleteChat(chatId: params.chatId);
  }
}

class DeleteChatParam extends Equatable {
  final String chatId;

  const DeleteChatParam(this.chatId);

  @override
  List<Object> get props => [chatId];
}
