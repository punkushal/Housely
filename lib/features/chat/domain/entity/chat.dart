import 'package:equatable/equatable.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';

class LastMessage extends Equatable {
  final String text;
  final String senderId;
  final DateTime timestamp;
  final bool isRead;

  const LastMessage({
    required this.text,
    required this.senderId,
    required this.timestamp,
    required this.isRead,
  });

  @override
  List<Object?> get props => [text, senderId, timestamp, isRead];
}

class Chat extends Equatable {
  final String chatId;
  final List<String> participants;
  final Map<String, ChatUser> participantDetails;
  final LastMessage? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Chat({
    required this.chatId,
    required this.participants,
    required this.participantDetails,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    chatId,
    participants,
    participantDetails,
    lastMessage,
    createdAt,
    updatedAt,
  ];
}
