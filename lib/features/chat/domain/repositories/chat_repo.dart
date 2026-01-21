import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/chat_room.dart';
import 'package:housely/features/chat/domain/entity/message.dart';

abstract interface class ChatRepository {
  // Stream to listen for the list of chats (Inbox)
  ResultStream<List<ChatRoom>> getChatRooms();

  // Stream to listen for messages in a specific room with pagination support
  ResultStream<List<Message>> getMessages({
    required String roomId,
    int limit = 20,
  });

  // Method to fetch MORE messages (Pagination)
  ResultFuture<List<Message>> getMoreMessages({
    required String roomId,
    required DateTime lastMessageTime,
    int limit = 20,
  });

  // Action to send a message
  ResultVoid sendMessage({
    required ChatRoom chatRoom,
    required Message message,
  });

  // Update online/offline status
  ResultVoid updatePresence(bool isOnline);

  // get chat room id
  String getChatRoomId(String secondUserUid);
}
