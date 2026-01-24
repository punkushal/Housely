import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/features/chat/domain/entity/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.messageId,
    required super.senderId,
    required super.chatId,
    required super.text,
    required super.timestamp,
    super.status,
    super.isRead,
    super.replyToMessageId,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      messageId: doc.id,
      senderId: data['senderId'],
      chatId: data['chatId'],
      text: data['text'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      status: .sent,
      replyToMessageId: data['replyToMessageId'],
    );
  }

  factory MessageModel.fromEntity(Message entity) {
    return MessageModel(
      messageId: entity.messageId,
      senderId: entity.senderId,
      chatId: entity.chatId,
      text: entity.text,
      timestamp: entity.timestamp,
      status: entity.status,
      isRead: entity.isRead,
      replyToMessageId: entity.replyToMessageId,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'replyToMessageId': replyToMessageId,
    };
  }

  @override
  MessageModel copyWith({
    String? messageId,
    String? senderId,
    String? chatId,
    String? text,
    DateTime? timestamp,
    bool? isRead,
    MessageStatus? status,
    String? replyToMessageId,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      chatId: chatId ?? this.chatId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
    );
  }
}
