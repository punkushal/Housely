import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';
import 'package:housely/features/chat/domain/entity/message.dart';

abstract interface class ChatRepository {
  ResultFuture<Chat> createOrGetChat({
    required String currentUserId,
    required String otherUserId,
    required String currentUserName,
    String? currentUserProfileImage,
    required String otherUserName,
    String? otherUserProfileImage,
  });

  // Stream to listen for the list of chats (Inbox)
  ResultStream<List<Chat>> getChatList(String userId);

  // Stream to listen for messages in a specific room with pagination support
  ResultStream<List<Message>> getMessages({
    required String chatId,
    required String currentUserId,
    int? limit,
    Message? lastMessage,
  });

  // Action to send a message
  ResultVoid sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  });

  ResultVoid deleteMessage({
    required String chatId,
    required String messageId,
    required String userId,
  });

  ResultVoid markMessagesAsRead({
    required String chatId,
    required String userId,
  });

  ResultVoid updateUserStatus({required String userId, required bool isOnline});

  ResultStream<ChatUser> getUserStatus(String userId);
}
