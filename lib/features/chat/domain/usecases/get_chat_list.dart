import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class GetChatListUseCase
    implements UseCaseStreamWithParam<List<Chat>, GetChatListParams> {
  final ChatRepository chatRepository;

  GetChatListUseCase(this.chatRepository);
  @override
  ResultStream<List<Chat>> call(params) {
    return chatRepository.getChatListStream(
      userId: params.userId,
      limit: params.limit,
      lastChat: params.lastChat,
    );
  }
}

class GetChatListParams extends Equatable {
  final String userId;
  final int limit;
  final Chat? lastChat;

  const GetChatListParams({
    required this.userId,
    this.limit = 20,
    this.lastChat,
  });

  @override
  List<Object?> get props => [userId, limit, lastChat];
}
