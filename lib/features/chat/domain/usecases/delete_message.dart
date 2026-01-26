import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class DeleteMessage implements UseCase<void, DeleteMessageParams> {
  final ChatRepository chatRepository;

  DeleteMessage(this.chatRepository);
  @override
  ResultFuture<void> call(params) async {
    return await chatRepository.deleteMessage(
      chatId: params.chatId,
      messageId: params.messageId,
      // userId: params.userId,
    );
  }
}

class DeleteMessageParams extends Equatable {
  final String chatId;
  final String messageId;

  const DeleteMessageParams({required this.chatId, required this.messageId});

  @override
  List<Object?> get props => [chatId, messageId];
}
