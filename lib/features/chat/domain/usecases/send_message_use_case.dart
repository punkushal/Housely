import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/message.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class SendMessageUseCase implements UseCase<void, SendMessageParams> {
  final ChatRepository chatRepository;

  SendMessageUseCase(this.chatRepository);
  @override
  ResultFuture<Message> call(params) async {
    return await chatRepository.sendMessage(
      chatId: params.chatId,
      senderId: params.senderId,
      replyToMessageId: params.replyToMessageId,
      text: params.message,
    );
  }
}

class SendMessageParams extends Equatable {
  final String chatId;
  final String senderId;
  final String? replyToMessageId;
  final String message;

  const SendMessageParams({
    required this.chatId,
    required this.senderId,
    this.replyToMessageId,
    required this.message,
  });

  @override
  List<Object?> get props => [chatId, senderId, replyToMessageId, message];
}
