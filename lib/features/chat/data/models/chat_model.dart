import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.chatId,
    required super.participants,
    required super.participantDetails,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.lastMessageSenderId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final participantDetailsMap =
        data['participantDetails'] as Map<String, dynamic>;
    final participantDetails = participantDetailsMap.map(
      (key, value) => MapEntry(
        key,
        ParticipantInfoModel.fromMap(value as Map<String, dynamic>),
      ),
    );

    return ChatModel(
      chatId: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      participantDetails: participantDetails,
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
      lastMessageSenderId: data['lastMessageSenderId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    final participantDetailsMap = participantDetails.map(
      (key, value) =>
          MapEntry(key, ParticipantInfoModel.fromEntity(value).toMap()),
    );

    return {
      'chatId': chatId,
      'participants': participants,
      'participantDetails': participantDetailsMap,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'lastMessageSenderId': lastMessageSenderId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

class ParticipantInfoModel extends ParticipantInfo {
  const ParticipantInfoModel({required super.name, super.profileImage});

  factory ParticipantInfoModel.fromMap(Map<String, dynamic> map) {
    return ParticipantInfoModel(
      name: map['name'] ?? '',
      profileImage: map['profileImage'],
    );
  }

  factory ParticipantInfoModel.fromEntity(ParticipantInfo entity) {
    return ParticipantInfoModel(
      name: entity.name,
      profileImage: entity.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'profileImage': profileImage};
  }
}
