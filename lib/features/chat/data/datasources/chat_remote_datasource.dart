import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/utils/chat_utils.dart';
import 'package:housely/features/chat/data/models/chat_model.dart';
import 'package:housely/features/chat/data/models/chat_user_model.dart';
import 'package:housely/features/chat/data/models/message_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRemoteDataSource({required this.firestore, required this.auth});

  String get currentUid => auth.currentUser!.uid;

  Future<ChatModel> createOrGetChat({
    required String currentUserId,
    required String otherUserId,
    required String currentUserName,
    String? currentUserProfileImage,
    required String otherUserName,
    String? otherUserProfileImage,
  }) async {
    try {
      final chatId = ChatUtils.generateChatId(currentUserId, otherUserId);
      final chatRef = firestore.collection(TextConstants.chats).doc(chatId);

      final chatDoc = await chatRef.get();

      if (!chatDoc.exists) {
        final now = DateTime.now();
        final newChat = ChatModel(
          chatId: chatId,
          participants: [currentUserId, otherUserId],
          participantDetails: {
            currentUserId: ParticipantInfoModel(
              name: currentUserName,
              profileImage: currentUserProfileImage,
            ),
            otherUserId: ParticipantInfoModel(
              name: otherUserName,
              profileImage: otherUserProfileImage,
            ),
          },
          lastMessage: '',
          lastMessageTime: now,
          lastMessageSenderId: '',
          createdAt: now,
          updatedAt: now,
        );

        await chatRef.set(newChat.toFirestore());
        return newChat;
      }

      return ChatModel.fromFirestore(chatDoc);
    } catch (e) {
      throw Exception('Failed to create or get chat: $e');
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      final messageRef = firestore
          .collection(TextConstants.chats)
          .doc(chatId)
          .collection(TextConstants.messages)
          .doc();

      final now = DateTime.now();
      final newMessage = MessageModel(
        messageId: messageRef.id,
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: now,
        isRead: false,
        isDeleted: false,
        deletedBy: [],
      );

      // Send message
      await messageRef.set(newMessage.toJson());

      // Update chat last message
      await firestore.collection(TextConstants.chats).doc(chatId).update({
        'lastMessage': message,
        'lastMessageTime': Timestamp.fromDate(now),
        'lastMessageSenderId': senderId,
        'updatedAt': Timestamp.fromDate(now),
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Stream<List<MessageModel>> getMessages({
    required String chatId,
    required String currentUserId,
    int? limit,
    MessageModel? lastMessage,
  }) {
    try {
      Query query = firestore
          .collection(TextConstants.chats)
          .doc(chatId)
          .collection(TextConstants.messages)
          .orderBy('timestamp', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (lastMessage != null) {
        query = query.startAfter([Timestamp.fromDate(lastMessage.timestamp)]);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc))
            .where((message) => !message.isDeletedByUser(currentUserId))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  Stream<List<ChatModel>> getChatList(String userId) {
    try {
      return firestore
          .collection(TextConstants.chats)
          .where('participants', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => ChatModel.fromFirestore(doc))
                .where((chat) => chat.lastMessage.isNotEmpty)
                .toList();
          });
    } catch (e) {
      throw Exception('Failed to get chat list: $e');
    }
  }

  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
    required String userId,
  }) async {
    try {
      final messageRef = firestore
          .collection(TextConstants.chats)
          .doc(chatId)
          .collection(TextConstants.messages)
          .doc(messageId);

      await messageRef.update({
        'deletedBy': FieldValue.arrayUnion([userId]),
      });

      // Check if both users deleted the message
      final messageDoc = await messageRef.get();
      final deletedBy = List<String>.from(
        messageDoc.data()?['deletedBy'] ?? [],
      );

      if (deletedBy.length >= 2) {
        await messageRef.update({'isDeleted': true});
      }
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  Future<void> markMessagesAsRead({
    required String chatId,
    required String userId,
  }) async {
    try {
      final messagesRef = firestore
          .collection(TextConstants.chats)
          .doc(chatId)
          .collection(TextConstants.messages);

      final unreadMessages = await messagesRef
          .where('receiverId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  Future<void> updateUserStatus({
    required String userId,
    required bool isOnline,
  }) async {
    try {
      await firestore.collection(TextConstants.users).doc(userId).update({
        'isOnline': isOnline,
        'lastSeen': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update user status: $e');
    }
  }

  Stream<ChatUserModel> getUserStatus(String userId) {
    try {
      return firestore
          .collection(TextConstants.users)
          .doc(userId)
          .snapshots()
          .map((doc) => ChatUserModel.fromFirestore(doc));
    } catch (e) {
      throw Exception('Failed to get user status: $e');
    }
  }
}
