import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:housely/features/chat/data/models/chat_room_model.dart';
import 'package:housely/features/chat/data/models/message_model.dart';
import 'package:housely/features/chat/domain/entity/chat_room.dart';
import 'package:housely/features/chat/domain/entity/message.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class ChatRepoImpl implements ChatRepository {
  final ChatRemoteDataSource dataSource;

  ChatRepoImpl(this.dataSource);
  @override
  ResultStream<List<ChatRoom>> getChatRooms() {
    return dataSource.getChatRooms();
  }

  @override
  ResultStream<List<Message>> getMessages({
    required String roomId,
    int limit = 20,
  }) {
    return dataSource.getMessages(roomId, limit);
  }

  @override
  ResultVoid sendMessage({
    required ChatRoom chatRoom,
    required Message message,
  }) async {
    try {
      final messageModel = MessageModel.fromEntity(message);
      final chatRoomModel = ChatRoomModel.fromEntity(chatRoom);
      await dataSource.sendMessage(
        chatRoom: chatRoomModel,
        message: messageModel,
      );

      return Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to send message"));
    }
  }

  @override
  ResultVoid updatePresence(bool isOnline) async {
    // TODO: implement updatePresence
    throw UnimplementedError();
  }

  @override
  ResultFuture<List<Message>> getMoreMessages({
    required String roomId,
    required DateTime lastMessageTime,
    int limit = 20,
  }) async {
    // TODO: implement getMoreMessages
    throw UnimplementedError();
  }

  @override
  String getChatRoomId(String secondUserUid) {
    return dataSource.getChatRoomId(secondUserUid: secondUserUid);
  }
}
