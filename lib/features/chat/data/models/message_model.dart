import 'dart:developer';

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
    try {
      final data = doc.data() as Map<String, dynamic>?;

      if (data == null) {
        throw Exception('Message document data is null');
      }

      // Parse timestamp with null safety
      DateTime timestamp;
      try {
        final timestampData = data['timestamp'];
        if (timestampData is Timestamp) {
          timestamp = timestampData.toDate();
        } else if (timestampData is int) {
          // Handle case where timestamp might be stored as milliseconds
          timestamp = DateTime.fromMillisecondsSinceEpoch(timestampData);
        } else {
          timestamp = DateTime.now();
        }
      } catch (e) {
        log('Error parsing timestamp: $e');
        timestamp = DateTime.now();
      }

      return MessageModel(
        messageId: doc.id,
        senderId: data['senderId']?.toString() ?? '',
        chatId: data['chatId']?.toString() ?? '',
        text: data['text']?.toString() ?? '',
        timestamp: timestamp,
        isRead: data['isRead'], // Explicit boolean check
        status: MessageStatus.sent, // Default status
        replyToMessageId: data['replyToMessageId']?.toString(),
      );
    } catch (e) {
      log('Error parsing MessageModel from Firestore: $e');
      rethrow;
    }
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
      'chatId': chatId,
      // Note: chatId is not stored in the document as it's part of the path
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
