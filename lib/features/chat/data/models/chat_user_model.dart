import 'dart:developer';

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
    try {
      final data = doc.data() as Map<String, dynamic>?;

      if (data == null) {
        throw Exception('User document data is null');
      }

      return ChatUserModel(
        uid: doc.id,
        name: data['name']?.toString() ?? 'Unknown User',
        email: data['email']?.toString() ?? '',
        profileImage: data['profileImage']?.toString(),
        isOnline: data['isOnline'] == true, // Explicit boolean check
        lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
        fcmToken: data['fcmToken']?.toString(),
        isOwner: data['isOwner'] == true, // Explicit boolean check
      );
    } catch (e) {
      log('Error parsing ChatUserModel from Firestore: $e');
      // Return a default user instead of throwing
      return ChatUserModel(
        uid: doc.id,
        name: 'Unknown User',
        email: '',
        isOnline: false,
      );
    }
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
    try {
      return ChatUserModel(
        uid: uid,
        name: map['name']?.toString() ?? 'Unknown User',
        profileImage: map['profileImage']?.toString(),
        isOnline: map['isOnline'] == true, // Explicit boolean check
        lastSeen: (map['lastSeen'] as Timestamp?)?.toDate(),
        isOwner: map['isOwner'] == true, // Explicit boolean check
        email: map['email']?.toString() ?? '', // Provide default empty string
      );
    } catch (e) {
      log('Error parsing ChatUserModel from map: $e');
      // Return a default user instead of throwing
      return ChatUserModel(
        uid: uid,
        name: 'Unknown User',
        email: '',
        isOnline: false,
      );
    }
  }

  Map<String, dynamic> toParticipantMap() {
    return {
      'name': name,
      'profileImage': profileImage,
      'isOwner': isOwner,
      'email': email, // Include email in participant map
    };
  }
}
