import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class GetChatList
    implements UseCaseStreamWithParam<List<Chat>, GetChatsParams> {
  final ChatRepository chatRepository;

  GetChatList(this.chatRepository);
  @override
  ResultStream<List<Chat>> call(params) {
    return chatRepository.getChatList(params.userId);
  }
}

class GetChatsParams extends Equatable {
  final String userId;

  const GetChatsParams(this.userId);

  @override
  List<Object?> get props => [userId];
}
