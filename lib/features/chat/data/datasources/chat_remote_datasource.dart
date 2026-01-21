import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housely/features/chat/data/models/chat_room_model.dart';
import 'package:housely/features/chat/data/models/message_model.dart';
import 'package:housely/features/chat/domain/entity/message.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRemoteDataSource({required this.firestore, required this.auth});

  String get currentUid => auth.currentUser!.uid;

  // LISTEN TO CHAT LIST (Inbox)
  Stream<List<ChatRoomModel>> getChatRooms() {
    return firestore
        .collection('chat_rooms')
        .where('participantIds', arrayContains: currentUid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatRoomModel.fromSnapshot(doc, currentUid))
              .toList(),
        );
  }

  // LISTEN TO MESSAGES (Real-time receiving)
  Stream<List<Message>> getMessages(String roomId, int limit) async* {
    yield* firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromFirestore(doc))
              .toList(),
        );
  }

  // SEND MESSAGE (Updates room AND adds message)
  Future<void> sendMessage({
    required ChatRoomModel chatRoom,
    required MessageModel message,
  }) async {
    final batch = firestore.batch();
    final roomRef = firestore.collection('chat_rooms').doc(chatRoom.roomId);
    final msgRef = roomRef.collection('messages').doc();

    final updateMessage = message.copyWith(senderId: currentUid);
    batch.set(msgRef, updateMessage.toJson());

    final updateRoom = chatRoom.copyWith(
      lastMessage: updateMessage.text,
      lastMessageTime: DateTime.now(),
    );

    batch.update(roomRef, updateRoom.toJson());

    await batch.commit();
  }

  String getChatRoomId({required String secondUserUid}) {
    List<String> ids = [currentUid, secondUserUid];
    ids.sort();
    return ids.join('_');
  }
}
