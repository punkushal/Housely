import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/chat_room.dart';
import 'package:housely/features/chat/domain/entity/message.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class SendMessageUseCase implements UseCase<void, SendParams> {
  final ChatRepository chatRepository;

  SendMessageUseCase(this.chatRepository);
  @override
  ResultFuture<void> call(params) async {
    return await chatRepository.sendMessage(
      chatRoom: params.chatRoom,
      message: params.message,
    );
  }
}

class SendParams extends Equatable {
  final Message message;
  final ChatRoom chatRoom;

  const SendParams({required this.message, required this.chatRoom});

  @override
  List<Object?> get props => [message, chatRoom];
}
