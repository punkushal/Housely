import 'package:equatable/equatable.dart';

class ChatUser extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String? profileImage;
  final bool isOnline;
  final bool isOwner;
  final DateTime? lastSeen;
  final String? fcmToken;

  const ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImage,
    this.isOnline = false,
    this.isOwner = false,
    this.lastSeen,
    this.fcmToken,
  });

  ChatUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileImage,
    bool? isOnline,
    bool? isOwner,
    DateTime? lastSeen,
    String? fcmToken,
  }) {
    return ChatUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      isOwner: isOwner ?? this.isOwner,
      email: email ?? this.email,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    profileImage,
    isOnline,
    isOwner,
    lastSeen,
    fcmToken,
  ];
}
