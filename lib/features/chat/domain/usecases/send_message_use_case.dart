import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class SendMessageUseCase implements UseCase<void, SendMessageParams> {
  final ChatRepository chatRepository;

  SendMessageUseCase(this.chatRepository);
  @override
  ResultFuture<void> call(params) async {
    return await chatRepository.sendMessage(
      chatId: params.chatId,
      senderId: params.senderId,
      receiverId: params.receiverId,
      message: params.message,
    );
  }
}

class SendMessageParams extends Equatable {
  final String chatId;
  final String senderId;
  final String receiverId;
  final String message;

  const SendMessageParams({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.message,
  });

  @override
  List<Object?> get props => [chatId, senderId, receiverId, message];
}
