import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/exception.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';
import 'package:housely/features/chat/domain/entity/message.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class ChatRepoImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepoImpl(this.remoteDataSource);

  @override
  ResultFuture<Chat> createOrGetChat({
    required ChatUser currentUser,
    required ChatUser otherUser,
  }) async {
    try {
      final chat = await remoteDataSource.createOrGetChat(
        currentUser: currentUser,
        otherUser: otherUser,
      );
      return Right(chat);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  ResultStream<List<Message>> getMessages({
    required String chatId,
    int limit = 30,
    Message? lastMessage,
  }) {
    try {
      return remoteDataSource
          .getMessagesStream(
            chatId: chatId,
            limit: limit,
            lastMessage: lastMessage,
          )
          .map((messages) => Right<Failure, List<Message>>(messages));
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  ResultFuture<Message> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? replyToMessageId,
  }) async {
    try {
      final message = await remoteDataSource.sendMessage(
        chatId: chatId,
        senderId: senderId,
        replyToMessageId: replyToMessageId,
        message: text,
      );
      return Right(message);
    } catch (e) {
      return Left(ServerFailure("Failed to send message"));
    }
  }

  @override
  ResultVoid deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      await remoteDataSource.deleteMessage(
        chatId: chatId,
        messageId: messageId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultVoid markMessagesAsRead({
    required String chatId,
    required String userId,
  }) async {
    try {
      await remoteDataSource.markMessagesAsRead(chatId: chatId, userId: userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultVoid deleteChat({required String chatId}) async {
    try {
      await remoteDataSource.deleteChat(chatId: chatId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  ResultStream<List<Chat>> getChatListStream({
    required String userId,
    int limit = 20,
    Chat? lastChat,
  }) {
    try {
      return remoteDataSource
          .getChatListStream(userId: userId, limit: limit, lastChat: lastChat)
          .map((chats) => Right<Failure, List<Chat>>(chats));
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  ResultFuture<ChatUser> getUserDetails(String userId) async {
    try {
      final user = await remoteDataSource.getUserDetails(userId: userId);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  ResultStream<ChatUser> getUserStatusStream(String userId) {
    try {
      return remoteDataSource
          .getUserStatusStream(userId)
          .map((user) => Right<Failure, ChatUser>(user));
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  ResultVoid updateOnlineStatus({
    required String userId,
    required bool isOnline,
  }) async {
    try {
      await remoteDataSource.updateOnlineStatus(
        userId: userId,
        isOnline: isOnline,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
