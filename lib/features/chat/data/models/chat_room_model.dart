import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housely/features/chat/domain/entity/chat_room.dart';

class ChatRoomModel extends ChatRoom {
  const ChatRoomModel({
    required super.roomId,
    required super.participantIds,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.otherUserName,
    required super.isOnline,
    super.otherUserPhoto,
  });

  /// Factory to convert Firestore Document to Model
  /// [currentUserId] is required to determine who the "Other User" is
  factory ChatRoomModel.fromSnapshot(
    DocumentSnapshot doc,
    String currentUserId,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    // Identify the ID of the other participant
    final List<dynamic> ids = data['participantIds'] ?? [];
    final otherId = ids.firstWhere(
      (roomId) => roomId != currentUserId,
      orElse: () => '',
    );

    // Extract metadata for the other participant
    final Map<String, dynamic> names = data['participantNames'] ?? {};
    final Map<String, dynamic> photos = data['participantPhotos'] ?? {};

    return ChatRoomModel(
      roomId: data['roomId'],
      participantIds: List<String>.from(ids),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime:
          (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      otherUserName: names[otherId] ?? 'Unknown User',
      otherUserPhoto: photos[otherId],
      // This is usually synced via a separate stream or updated via cloud functions
      isOnline: data['isOnline']?[otherId] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'participantIds': participantIds,
      'lastMessage': lastMessage,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'otherUserName': otherUserName,
      'isOnline': isOnline,
      'otherUserPhoto': otherUserPhoto,
    };
  }

  factory ChatRoomModel.fromEntity(ChatRoom room) {
    return ChatRoomModel(
      roomId: room.roomId,
      participantIds: room.participantIds,
      lastMessage: room.lastMessage,
      lastMessageTime: room.lastMessageTime,
      otherUserName: room.otherUserName,
      isOnline: room.isOnline,
    );
  }

  @override
  ChatRoomModel copyWith({
    String? roomId,
    List<String>? participantIds,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? otherUserName,
    String? otherUserPhoto,
    bool? isOnline,
  }) {
    return ChatRoomModel(
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
