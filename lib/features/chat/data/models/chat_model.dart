import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/features/chat/data/models/chat_user_model.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';

class LastMessageModel extends LastMessage {
  const LastMessageModel({
    required super.text,
    required super.senderId,
    required super.timestamp,
    required super.isRead,
  });

  factory LastMessageModel.fromMap(Map<String, dynamic> map) {
    return LastMessageModel(
      text: map['text'] ?? '', // Handle null with default empty string
      senderId: map['senderId'] ?? '', // Handle null with default empty string
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }
}

class ChatModel extends Chat {
  const ChatModel({
    required super.chatId,
    required super.participants,
    required super.participantDetails,
    required super.lastMessage,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc, String currentUserId) {
    try {
      final data = doc.data() as Map<String, dynamic>?;

      // Handle case where document data is null
      if (data == null) {
        throw Exception('Chat document data is null');
      }

      // Parse participant details with null safety
      final participantDetailsMap =
          data['participantDetails'] as Map<String, dynamic>? ?? {};
      final participantDetails = <String, ChatUser>{};

      participantDetailsMap.forEach((userId, details) {
        try {
          if (details != null && details is Map<String, dynamic>) {
            participantDetails[userId] = ChatUserModel.fromMap(details, userId);
          }
        } catch (e) {
          log('Error parsing participant $userId: $e');
          // Skip this participant if there's an error
        }
      });

      // Parse last message with null safety
      LastMessageModel? lastMessage;
      if (data['lastMessage'] != null) {
        try {
          lastMessage = LastMessageModel.fromMap(
            data['lastMessage'] as Map<String, dynamic>,
          );
        } catch (e) {
          log('Error parsing last message: $e');
          // lastMessage remains null if parsing fails
        }
      }

      // Parse participants list with null safety
      final participantsList = data['participants'];
      List<String> participants = [];

      if (participantsList is List) {
        participants = participantsList
            .where((p) => p != null)
            .map((p) => p.toString())
            .toList();
      }

      // Parse timestamps with null safety
      DateTime createdAt;
      try {
        createdAt =
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
      } catch (e) {
        log('Error parsing createdAt: $e');
        createdAt = DateTime.now();
      }

      DateTime updatedAt;
      try {
        updatedAt =
            (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now();
      } catch (e) {
        log('Error parsing updatedAt: $e');
        updatedAt = DateTime.now();
      }

      return ChatModel(
        chatId: doc.id,
        participants: participants,
        participantDetails: participantDetails,
        lastMessage: lastMessage,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      log('Error parsing ChatModel from Firestore: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    final participantDetailsMap = <String, dynamic>{};
    participantDetails.forEach((userId, user) {
      try {
        participantDetailsMap[userId] = ChatUserModel.fromEntity(
          user,
        ).toParticipantMap();
      } catch (e) {
        log('Error converting participant $userId to map: $e');
      }
    });

    return {
      'participants': participants,
      'participantDetails': participantDetailsMap,
      'lastMessage': lastMessage != null
          ? LastMessageModel(
              text: lastMessage!.text,
              senderId: lastMessage!.senderId,
              timestamp: lastMessage!.timestamp,
              isRead: lastMessage!.isRead,
            ).toMap()
          : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
