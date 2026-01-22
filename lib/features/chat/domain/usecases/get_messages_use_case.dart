import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/message.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class GetMessagesUseCase
    implements UseCaseStreamWithParam<List<Message>, GetMessagesParams> {
  final ChatRepository chatRepository;

  GetMessagesUseCase(this.chatRepository);
  @override
  ResultStream<List<Message>> call(params) {
    return chatRepository.getMessages(
      chatId: params.chatId,
      currentUserId: params.currentUserId,
      limit: params.limit,
      lastMessage: params.lastMessage,
    );
  }
}

class GetMessagesParams extends Equatable {
  final String chatId;
  final String currentUserId;
  final int? limit;
  final Message? lastMessage;

  const GetMessagesParams({
    required this.chatId,
    required this.currentUserId,
    this.limit,
    this.lastMessage,
  });

  @override
  List<Object?> get props => [chatId, currentUserId, limit, lastMessage];
}
