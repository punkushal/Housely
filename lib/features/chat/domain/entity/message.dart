// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final bool isDeleted;
  final List<String> deletedBy;

  const Message({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.isDeleted,
    required this.deletedBy,
  });

  bool isDeletedByUser(String userId) {
    return deletedBy.contains(userId);
  }

  @override
  List<Object> get props => [
    messageId,
    senderId,
    receiverId,
    message,
    timestamp,
    isRead,
    isDeleted,
    deletedBy,
  ];

  Message copyWith({
    String? messageId,
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    bool? isDeleted,
    List<String>? deletedBy,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isDeleted: isDeleted ?? this.isDeleted,
      isRead: isRead ?? this.isRead,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }
}
