import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class GetChatRoomIdUseCase {
  final ChatRepository chatRepository;

  GetChatRoomIdUseCase(this.chatRepository);
  String call(String secondUserUid) {
    return chatRepository.getChatRoomId(secondUserUid);
  }
}
