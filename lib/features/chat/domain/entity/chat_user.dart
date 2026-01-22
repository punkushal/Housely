// lib/features/chat/domain/entities/chat_user.dart

import 'package:equatable/equatable.dart';

class ChatUser extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String? profileImage;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? fcmToken;

  const ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImage,
    required this.isOnline,
    this.lastSeen,
    this.fcmToken,
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    profileImage,
    isOnline,
    lastSeen,
    fcmToken,
  ];
}
