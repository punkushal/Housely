part of 'chat_session_bloc.dart';

sealed class ChatSessionEvent extends Equatable {
  const ChatSessionEvent();

  @override
  List<Object?> get props => [];
}

final class InitializeChat extends ChatSessionEvent {
  final ChatUser currentUser;
  final ChatUser otherUser;

  const InitializeChat({required this.currentUser, required this.otherUser});

  @override
  List<Object?> get props => [currentUser, otherUser];
}

final class SendMessage extends ChatSessionEvent {
  final String message;
  final String chatId;
  final String senderId;
  final String? replyToMessageId;

  const SendMessage({
    this.replyToMessageId,
    required this.message,
    required this.chatId,
    required this.senderId,
  });

  @override
  List<Object?> get props => [message, replyToMessageId];
}

final class DeleteMessage extends ChatSessionEvent {
  final String messageId;

  const DeleteMessage({required this.messageId});

  @override
  List<Object> get props => [messageId];
}

final class LoadMessages extends ChatSessionEvent {
  final String chatId;
  final String currentUserId;
  const LoadMessages({required this.chatId, required this.currentUserId});

  @override
  List<Object> get props => [chatId, currentUserId];
}

final class LoadMoreMessages extends ChatSessionEvent {}

class UserStatusUpdated extends ChatSessionEvent {
  final bool isOnline;
  final DateTime? lastSeen;

  const UserStatusUpdated({required this.isOnline, this.lastSeen});

  @override
  List<Object?> get props => [isOnline, lastSeen];
}

final class MarkMessageAsReadEvent extends ChatSessionEvent {
  final String chatId;
  final String currentUser;

  const MarkMessageAsReadEvent({
    required this.chatId,
    required this.currentUser,
  });

  @override
  List<Object?> get props => [chatId, currentUser];
}

final class MessagesUpdated extends ChatSessionEvent {
  final List<Message> messages;

  const MessagesUpdated({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class RetryMessageEvent extends ChatSessionEvent {
  final Message message;

  const RetryMessageEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
