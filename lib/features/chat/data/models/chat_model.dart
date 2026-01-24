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
      text: map['text'],
      senderId: map['senderId'],
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
    final data = doc.data() as Map<String, dynamic>;

    // Parse participant details
    final participantDetailsMap =
        data['participantDetails'] as Map<String, dynamic>;
    final participantDetails = <String, ChatUser>{};

    participantDetailsMap.forEach((userId, details) {
      participantDetails[userId] = ChatUserModel.fromMap(
        details as Map<String, dynamic>,
        userId,
      );
    });

    // Parse last message
    LastMessageModel? lastMessage;
    if (data['lastMessage'] != null) {
      lastMessage = LastMessageModel.fromMap(
        data['lastMessage'] as Map<String, dynamic>,
      );
    }
    return ChatModel(
      chatId: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      participantDetails: participantDetails,
      lastMessage: lastMessage,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    final participantDetailsMap = <String, dynamic>{};
    participantDetails.forEach((userId, user) {
      participantDetailsMap[userId] = ChatUserModel.fromEntity(
        user,
      ).toParticipantMap();
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
