import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/chat_room.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class GetChatRoomsUseCase implements UseCaseWithStream<List<ChatRoom>> {
  final ChatRepository chatRepository;

  GetChatRoomsUseCase(this.chatRepository);
  @override
  ResultStream<List<ChatRoom>> call() {
    return chatRepository.getChatRooms();
  }
}
