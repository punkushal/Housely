// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum MessageStatus { sending, sent, delivered, read, failed }

class Message extends Equatable {
  final String messageId;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final MessageStatus status;
  final String? replyToMessageId;

  const Message({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.status = .sent,
    this.replyToMessageId,
    required this.chatId,
  });

  bool get isSending => status == MessageStatus.sending;
  bool get isFailed => status == MessageStatus.failed;

  @override
  List<Object?> get props => [
    messageId,
    senderId,
    text,
    timestamp,
    isRead,
    status,
    replyToMessageId,
  ];

  Message copyWith({
    String? messageId,
    String? senderId,
    String? chatId,
    String? text,
    DateTime? timestamp,
    bool? isRead,
    MessageStatus? status,
    String? replyToMessageId,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      chatId: chatId ?? this.chatId,
    );
  }
}
