import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';
import 'package:housely/features/chat/domain/entity/message.dart';

abstract interface class ChatRepository {
  ResultFuture<Chat> createOrGetChat({
    required ChatUser currentUser,
    required ChatUser otherUser,
  });

  // Stream to listen for the list of chats (Inbox)
  ResultStream<List<Chat>> getChatListStream({
    required String userId,
    int limit,
    Chat? lastChat,
  });

  // Stream to listen for messages in a specific room with pagination support
  ResultStream<List<Message>> getMessages({
    required String chatId,
    int limit,
    Message? lastMessage,
  });

  // Action to send a message
  ResultFuture<Message> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? replyToMessageId,
  });

  /// Delete a message
  ResultVoid deleteMessage({required String chatId, required String messageId});

  /// Delete a chat
  ResultVoid deleteChat({required String chatId});

  /// Mark message as read
  ResultVoid markMessagesAsRead({
    required String chatId,
    required String userId,
  });

  /// Update user online status
  ResultVoid updateOnlineStatus({
    required String userId,
    required bool isOnline,
  });

  /// Stream of user online status
  ResultStream<ChatUser> getUserStatusStream(String userId);

  /// Get user details
  ResultFuture<ChatUser> getUserDetails(String userId);
}
