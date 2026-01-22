import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String chatId;
  final List<String> participants;
  final Map<String, ParticipantInfo> participantDetails;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Chat({
    required this.chatId,
    required this.participants,
    required this.participantDetails,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSenderId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    chatId,
    participants,
    participantDetails,
    lastMessage,
    lastMessageTime,
    lastMessageSenderId,
    createdAt,
    updatedAt,
  ];
}

class ParticipantInfo extends Equatable {
  final String name;
  final String? profileImage;

  const ParticipantInfo({required this.name, this.profileImage});

  @override
  List<Object?> get props => [name, profileImage];
}
