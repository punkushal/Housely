import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/error/exception.dart';
import 'package:housely/core/utils/chat_utils.dart';
import 'package:housely/features/chat/data/models/chat_model.dart';
import 'package:housely/features/chat/data/models/chat_user_model.dart';
import 'package:housely/features/chat/data/models/message_model.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';
import 'package:housely/features/chat/domain/entity/message.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRemoteDataSource({required this.firestore, required this.auth});

  String get currentUid => auth.currentUser!.uid;

  CollectionReference get _chatsCollection =>
      firestore.collection(TextConstants.chatsCollection);

  CollectionReference get _usersCollection =>
      firestore.collection(TextConstants.users);

  CollectionReference _messagesCollection(String chatId) =>
      _chatsCollection.doc(chatId).collection(TextConstants.messagesCollection);

  Future<ChatModel> createOrGetChat({
    required ChatUser currentUser,
    required ChatUser otherUser,
  }) async {
    try {
      final chatId = ChatUtils.generateChatId(currentUser.uid, otherUser.uid);

      // check if chat exists
      final existingChat = await firestore
          .collection(TextConstants.chatsCollection)
          .doc(chatId)
          .get();

      if (existingChat.exists) {
        return ChatModel.fromFirestore(existingChat, currentUser.uid);
      }

      // Create new chat
      final now = DateTime.now();
      final currentUserModel = ChatUserModel.fromEntity(currentUser);
      final otherUserModel = ChatUserModel.fromEntity(otherUser);

      final chatData = {
        'participants': [currentUser.uid, otherUser.uid],
        'participantDetails': {
          currentUser.uid: currentUserModel.toParticipantMap(),
          otherUser.uid: otherUserModel.toParticipantMap(),
        },
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'lastMessage': null,
      };

      await _chatsCollection.doc(chatId).set(chatData);

      final newChatDoc = await _chatsCollection.doc(chatId).get();

      return ChatModel.fromFirestore(newChatDoc, currentUser.uid);
    } catch (e) {
      throw ServerException('Failed to create or get chat: $e');
    }
  }

  Future<MessageModel> sendMessage({
    required String chatId,
    required String senderId,
    String? replyToMessageId,
    required String message,
  }) async {
    try {
      final now = DateTime.now();

      final messageData = {
        'senderId': senderId,
        'text': message,
        'timestamp': Timestamp.fromDate(now),
        'isRead': false,
        'replyToMessageId': replyToMessageId,
      };

      // add message
      final messageRef = await firestore
          .collection(TextConstants.chatsCollection)
          .doc(chatId)
          .collection(TextConstants.messagesCollection)
          .add(messageData);

      // Update chat with last message
      await firestore
          .collection(TextConstants.chatsCollection)
          .doc(chatId)
          .update({
            'lastMessage': {
              'text': message,
              'senderId': senderId,
              'timestamp': Timestamp.fromDate(now),
              'isRead': false,
            },
            'updatedAt': Timestamp.fromDate(now),
          });

      return MessageModel(
        messageId: messageRef.id,
        chatId: chatId,
        senderId: senderId,
        text: message,
        timestamp: now,
        isRead: false,
        status: MessageStatus.sent,
        replyToMessageId: replyToMessageId,
      );
    } catch (e) {
      throw ServerException('Failed to send message: $e');
    }
  }

  Stream<List<MessageModel>> getMessagesStream({
    required String chatId,
    int limit = TextConstants.messagePageSize,
    Message? lastMessage,
  }) {
    try {
      Query query = firestore
          .collection(TextConstants.chatsCollection)
          .doc(chatId)
          .collection(TextConstants.messagesCollection)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (lastMessage != null) {
        query = query.startAfter([Timestamp.fromDate(lastMessage.timestamp)]);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      throw ServerException('Failed to get messages stream: $e');
    }
  }

  Stream<List<ChatModel>> getChatListStream({
    required String userId,
    int limit = TextConstants.chatListPageSize,
    Chat? lastChat,
  }) {
    try {
      Query query = firestore
          .collection(TextConstants.chatsCollection)
          .where(TextConstants.participantsField, arrayContains: userId)
          .orderBy(TextConstants.updatedAtField, descending: true)
          .limit(limit);

      if (lastChat != null) {
        query = query.startAfter([Timestamp.fromDate(lastChat.updatedAt)]);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => ChatModel.fromFirestore(doc, userId))
            .toList();
      });
    } catch (e) {
      throw ServerException('Failed to get chat list stream: $e');
    }
  }

  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      await _messagesCollection(chatId).doc(messageId).delete();
    } catch (e) {
      throw ServerException('Failed to delete message: $e');
    }
  }

  Future<void> markMessagesAsRead({
    required String chatId,
    required String userId,
  }) async {
    try {
      // Get unread messages not sent by current user
      final unreadMessages = await _messagesCollection(chatId)
          .where('senderId', isNotEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw ServerException('Failed to mark messages as read: $e');
    }
  }

  Future<void> updateOnlineStatus({
    required String userId,
    required bool isOnline,
  }) async {
    try {
      await _usersCollection.doc(userId).set({
        'isOnline': isOnline,
        'lastSeen': Timestamp.fromDate(DateTime.now()),
      }, SetOptions(merge: true));
    } catch (e) {
      throw ServerException('Failed to update user status: $e');
    }
  }

  Stream<ChatUserModel> getUserStatusStream(String userId) {
    try {
      return _usersCollection.doc(userId).snapshots().map((doc) {
        return ChatUserModel.fromFirestore(doc);
      });
    } catch (e) {
      throw ServerException('Failed to get user status stream: $e');
    }
  }

  Future<ChatUserModel> getUserDetails({required String userId}) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) {
        throw ServerException('User not found');
      }
      return ChatUserModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Failed to get user details: $e');
    }
  }

  Future<void> deleteChat({required String chatId}) async {
    try {
      // Delete all messages
      final messages = await _messagesCollection(chatId).get();
      final batch = firestore.batch();

      for (final doc in messages.docs) {
        batch.delete(doc.reference);
      }

      // Delete chat document
      batch.delete(_chatsCollection.doc(chatId));

      await batch.commit();
    } catch (e) {
      throw ServerException('Failed to delete chat: $e');
    }
  }
}
