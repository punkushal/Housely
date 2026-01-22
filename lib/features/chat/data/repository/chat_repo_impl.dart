import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';
import 'package:housely/features/chat/domain/entity/message.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class ChatRepoImpl implements ChatRepository {
  final ChatRemoteDataSource dataSource;

  ChatRepoImpl(this.dataSource);

  @override
  ResultFuture<Chat> createOrGetChat({
    required String currentUserId,
    required String otherUserId,
    required String currentUserName,
    String? currentUserProfileImage,
    required String otherUserName,
    String? otherUserProfileImage,
  }) async {
    try {
      final chat = await dataSource.createOrGetChat(
        currentUserId: currentUserId,
        otherUserId: otherUserId,
        currentUserName: currentUserName,
        currentUserProfileImage: currentUserProfileImage,
        otherUserName: otherUserName,
        otherUserProfileImage: otherUserProfileImage,
      );
      return Right(chat);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultStream<List<Message>> getMessages({
    required String chatId,
    required String currentUserId,
    int? limit,
    Message? lastMessage,
  }) {
    try {
      return dataSource
          .getMessages(
            chatId: chatId,
            currentUserId: currentUserId,
            limit: limit,
            lastMessage: lastMessage as dynamic,
          )
          .map((messages) => Right<Failure, List<Message>>(messages))
          .handleError((error) {
            return Left<Failure, List<Message>>(
              ServerFailure(error.toString()),
            );
          });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  ResultVoid sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      await dataSource.sendMessage(
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
        message: message,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to send message"));
    }
  }

  @override
  ResultStream<List<Chat>> getChatList(String userId) {
    try {
      return dataSource
          .getChatList(userId)
          .map((chats) => Right<Failure, List<Chat>>(chats))
          .handleError((error) {
            return Left<Failure, List<Chat>>(ServerFailure(error.toString()));
          });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }

  @override
  ResultVoid deleteMessage({
    required String chatId,
    required String messageId,
    required String userId,
  }) async {
    try {
      await dataSource.deleteMessage(
        chatId: chatId,
        messageId: messageId,
        userId: userId,
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
      await dataSource.markMessagesAsRead(chatId: chatId, userId: userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultVoid updateUserStatus({
    required String userId,
    required bool isOnline,
  }) async {
    try {
      await dataSource.updateUserStatus(userId: userId, isOnline: isOnline);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultStream<ChatUser> getUserStatus(String userId) {
    try {
      return dataSource
          .getUserStatus(userId)
          .map((user) => Right<Failure, ChatUser>(user))
          .handleError((error) {
            return Left<Failure, ChatUser>(ServerFailure(error.toString()));
          });
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }
}
