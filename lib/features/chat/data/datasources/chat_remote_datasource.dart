import 'dart:convert';
import 'dart:developer';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

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
      await firestore.collection(TextConstants.chatsCollection).doc(chatId).set(
        {
          'lastMessage': {
            'text': message,
            'senderId': senderId,
            'timestamp': Timestamp.fromDate(now),
            'isRead': false,
          },
          'updatedAt': Timestamp.fromDate(now),
        },
        SetOptions(merge: true),
      );

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
      log("getChatListStream called with userId: $userId, limit: $limit");
      Query query = firestore
          .collection(TextConstants.chatsCollection)
          .where(TextConstants.participantsField, arrayContains: userId)
          .orderBy(TextConstants.updatedAtField, descending: true)
          .limit(limit);

      if (lastChat != null) {
        query = query.startAfter([Timestamp.fromDate(lastChat.updatedAt)]);
      }

      return query.snapshots().map((snapshot) {
        log(
          "ChatListStream snapshot received with ${snapshot.docs.length} documents",
        );
        return snapshot.docs.map((doc) {
          log("doc id: ${doc.id}, exists: ${doc.exists}, data: ${doc.data()}");
          return ChatModel.fromFirestore(doc, userId);
        }).toList();
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

  Future<void> sendPushNotification({
    required String chatId,
    required String senderName,
    required String message,
    required String targetUserId,
    required String senderId,
  }) async {
    try {
      // Get Target User FCM Token
      final userDoc = await _usersCollection.doc(targetUserId).get();
      if (!userDoc.exists) return;

      final userData = userDoc.data() as Map<String, dynamic>;
      final fcmToken = userData['fcmToken'];

      if (fcmToken == null || fcmToken is! String) return;

      // Get Access Token
      final serviceAccountJson = {
        "type": "service_account",
        "project_id": "housely-f074b",
        "private_key_id": "263055b55fd1de7db2f1887e8516539d114a4fdf",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDRhfNVVcIY9S2q\nXDMAUNpjnkbvCw9r2uU6PMB7WyQn7irFx1pAtOb+KjExIs93CQvD2Z5USUUYqy88\nDb6CFG4uILSueFkgEKTliwm5VDoqfLjYEJJznGHidathaKFJ+KTdjnpRXWOGdETD\n2O+b4gV0UCVnvmRYKdCK0IrZkXWPMFeqkof60YQPWsQSe2lUViBjUO9H2AtOf+es\nWejt7mCKFqyw42auNGgrf4yzzIuHEoqUQpw32GmlHhGa3VfDCRNCH/AopsE33u8T\nLwRv6dyldZ1GgbDucVg2T5x7m/lBowvwspLRFBe6lghm6/RPTWp8izUuqsU/yf4q\n8cFyfQ/lAgMBAAECggEAXuqYrmrYMCg51LhJ3nXCSWi1Z6sSBGE4gOZuqDNEsNYj\nCE/kIfYRwshoWoMTizBM5R9bq4E5zRAXqNPtHs6Uj07/qx4X+f+wQ9B1ykBOzVqM\n/kybm8YXTdjSl6Enl/QM89WMsfllkc5wLGzFN0/v+p4oI9RLbukacRhCHofXwtJo\nsKOS3dnbnlmhtdW3g6I6ZVgg3z4hZhFDjXzoMbh6Nan6SAFK/ewsSzGBKdIg3+hA\nBfsdYJoytxreOoyxVxNSbUI8dI4xE0m5qovMtXesICBmJmU+O2Ld4I9tkpnxki4V\n8xAgoMishaPJ6rgRxn2J+T6xskYTldE05utm5fU/zQKBgQDs31Cxc5L3XUHMpDHB\n0jtu/OolBeUwee4zJ9QEziE16X71JAHBLws5K6l8mD4W8KvFMQ6fn1ynv0HME8MS\nHiM5jnLU21tNLNZuSA67bmMO+8GiKFv+//9bYrdFS+JWf579TUvCYQKqnw75MXFR\n6jfJEe3dzAt/Na7rPGHwtuQoxwKBgQDicUSnPNUmZw1D1S3RMjDsDjH3JPEZTxM4\nwgQscjqW5tCBuAQV7TGqnsNorWyuzs01p0LSxO24oDfimHyZD/XiY3h1chdHx02v\nABMBBWu224d8PHYa6pBuolkb56tSELxS2fLDfu5YqQy08R5DdDBUwyfU1mbC8MYk\nfsqbTaXN8wKBgDGqHPQn5F+jGQG8R4Z4+ucpdjpvAv/oAM6PAkBDq+ju3SSu+QM1\nRugkxHOQRCxxJ8K/p25GbpnpWvVcC2GIGiCeQmto1rrWtNsIlrYrze89T/sc9TUB\nHdxeVUjdQUabmY1IoKLPzkxR70TGXhkrv6iT7si7WInCirtdvLdI0YvPAoGAEewL\nFf1vlVmEqEDAHpWNX7GD7N6kom8qw0w/zlDAKF9eU1YAJMggLTPhnXBUcMV3Ym65\nkDr74af0pF+TRP4JZQCgcRM1mn3AvUARQPxv2QopAAE9C8ZS5h69VMMSQS2H6jrL\nxwNN1ACVO+D1lzsj9CF6DpNlkLpDxHGwkXgkzlcCgYEAy0WsKfB8QVHeU5Aeb4q/\ntsGwmZmzg3Ieaw/XDJ7GlY0dyMoy1V2/BBFKvqZXwJYfNIQ98V6gNnA0sWpQn21Q\ndWhUgtEo6jaOYSNbtoF8/d+GckAXbMPFxNOK4LOqxUaVZEpE7FARnCOsuqzL101s\nh3kJwLVyO7bssxMjgYCE/g4=\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@housely-f074b.iam.gserviceaccount.com",
        "client_id": "106781560994983846136",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40housely-f074b.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      };

      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
      );

      final credentials = await obtainAccessCredentialsViaServiceAccount(
        ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client,
      );

      client.close();
      final accessToken = credentials.accessToken.data;

      //  Send Message
      final String fcmEndpoint =
          'https://fcm.googleapis.com/v1/projects/${serviceAccountJson['project_id']}/messages:send';

      final Map<String, dynamic> fcmMessage = {
        'message': {
          'token': fcmToken,
          'notification': {'title': senderName, 'body': message},
          'data': {
            'chatId': chatId,
            'senderId': senderId, // Needed for navigation
            'senderName': senderName,
            'type': 'chat_message',
          },
        },
      };

      final http.Response response = await http.post(
        Uri.parse(fcmEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(fcmMessage),
      );

      if (response.statusCode == 200) {
        log('FCM message sent successfully');
      } else {
        log(
          'Failed to send FCM message: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      log("Failed to send push notification: $e");
    }
  }
}
