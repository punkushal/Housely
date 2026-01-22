import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/features/chat/domain/entity/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.messageId,
    required super.senderId,
    required super.receiverId,
    required super.message,
    required super.timestamp,
    required super.isDeleted,
    required super.isRead,
    required super.deletedBy,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      messageId: doc.id,
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      message: data['message'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      isDeleted: data['isDeleted'] ?? false,
      deletedBy: List<String>.from(data['deletedBy'] ?? []),
    );
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      messageId: message.messageId,
      senderId: message.senderId,
      receiverId: message.receiverId,
      message: message.message,
      timestamp: message.timestamp,
      isDeleted: message.isDeleted,
      isRead: message.isRead,
      deletedBy: message.deletedBy,
    );
  }

  Map<String, dynamic> toJson() => {
    'senderId': senderId,
    'receiverId': receiverId,
    'text': message,
    'timestamp': FieldValue.serverTimestamp(),
  };

  @override
  MessageModel copyWith({
    String? messageId,
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    bool? isDeleted,
    List<String>? deletedBy,
  }) {
    return MessageModel(
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
