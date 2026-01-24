import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';

class ChatUserModel extends ChatUser {
  const ChatUserModel({
    required super.uid,
    required super.name,
    required super.email,
    super.profileImage,
    required super.isOnline,
    super.lastSeen,
    super.fcmToken,
    super.isOwner,
  });

  factory ChatUserModel.fromEntity(ChatUser entity) {
    return ChatUserModel(
      uid: entity.uid,
      name: entity.name,
      profileImage: entity.profileImage,
      isOnline: entity.isOnline,
      lastSeen: entity.lastSeen,
      isOwner: entity.isOwner,
      email: entity.email,
      fcmToken: entity.fcmToken,
    );
  }

  factory ChatUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatUserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImage: data['profileImage'],
      isOnline: data['isOnline'] ?? false,
      lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
      fcmToken: data['fcmToken'],
      isOwner: data['isOwner'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'isOnline': isOnline,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
      'fcmToken': fcmToken,
      'isOwner': isOwner,
    };
  }

  factory ChatUserModel.fromMap(Map<String, dynamic> map, String uid) {
    return ChatUserModel(
      uid: uid,
      name: map['name'] ?? '',
      profileImage: map['profileImage'],
      isOnline: map['isOnline'] ?? false,
      lastSeen: (map['lastSeen'] as Timestamp?)?.toDate(),
      isOwner: map['isOwner'] ?? false,
      email: map['email'],
    );
  }

  Map<String, dynamic> toParticipantMap() {
    return {'name': name, 'profileImage': profileImage, 'isOwner': isOwner};
  }
}
