import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/message.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class GetMessagesStreamUseCase
    implements UseCaseStreamWithParam<List<Message>, GetMessagesParams> {
  final ChatRepository chatRepository;

  GetMessagesStreamUseCase(this.chatRepository);
  @override
  ResultStream<List<Message>> call(params) {
    return chatRepository.getMessages(
      chatId: params.chatId,
      limit: params.limit,
      lastMessage: params.lastMessage,
    );
  }
}

class GetMessagesParams extends Equatable {
  final String chatId;
  final int limit;
  final Message? lastMessage;

  const GetMessagesParams({
    required this.chatId,
    required this.limit,
    this.lastMessage,
  });

  @override
  List<Object?> get props => [chatId, limit, lastMessage];
}
