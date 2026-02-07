// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  final String roomId;
  final List<String> participantIds;
  final String lastMessage;
  final DateTime lastMessageTime;
  // receiver metadata (the person the current user is talking to)
  final String otherUserName;
  final String? otherUserPhoto;
  final bool isOnline;

  const ChatRoom({
    required this.roomId,
    required this.participantIds,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.otherUserName,
    this.otherUserPhoto,
    required this.isOnline,
  });

  @override
  List<Object?> get props => [roomId, lastMessage, isOnline];

  ChatRoom copyWith({
    String? roomId,
    List<String>? participantIds,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? otherUserName,
    String? otherUserPhoto,
    bool? isOnline,
  }) {
    return ChatRoom(
      roomId: roomId ?? this.roomId,
      participantIds: participantIds ?? this.participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserPhoto: otherUserPhoto ?? this.otherUserPhoto,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
