import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class SendPushNotificationUseCase
    implements UseCase<void, SendNotificationParam> {
  final ChatRepository chatRepository;

  SendPushNotificationUseCase(this.chatRepository);
  @override
  ResultVoid call(params) async {
    return await chatRepository.sendPushNotification(
      chatId: params.chatId,
      senderName: params.senderName,
      message: params.message,
      targetUserId: params.targetUserId,
      senderId: params.senderId,
    );
  }
}

class SendNotificationParam extends Equatable {
  final String chatId;
  final String senderName;
  final String message;
  final String targetUserId;
  final String senderId;

  const SendNotificationParam({
    required this.chatId,
    required this.senderName,
    required this.message,
    required this.targetUserId,
    required this.senderId,
  });
  @override
  List<Object?> get props => [
    chatId,
    senderName,
    message,
    targetUserId,
    senderId,
  ];
}
