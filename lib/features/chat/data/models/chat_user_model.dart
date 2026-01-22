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
  });

  factory ChatUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatUserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImage: data['profileImage'],
      isOnline: data['isOnline'] ?? false,
      lastSeen: data['lastSeen'] != null
          ? (data['lastSeen'] as Timestamp).toDate()
          : null,
      fcmToken: data['fcmToken'],
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
    };
  }
}
