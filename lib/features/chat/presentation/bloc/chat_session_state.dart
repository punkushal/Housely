part of 'chat_session_bloc.dart';

sealed class ChatSessionState extends Equatable {
  const ChatSessionState();

  @override
  List<Object> get props => [];
}

final class ChatSessionInitial extends ChatSessionState {}

final class ChatSessionLoading extends ChatSessionState {}

final class ChatSessionChatRoomMessagesLoaded extends ChatSessionState {
  final List<Message> messages;

  const ChatSessionChatRoomMessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

final class ChatSessionChatRoomsLoaded extends ChatSessionState {
  final List<ChatRoom> chatrooms;

  const ChatSessionChatRoomsLoaded(this.chatrooms);

  @override
  List<Object> get props => [chatrooms];
}

final class ChatSessionSuccess extends ChatSessionState {}

final class ChatSessionFailure extends ChatSessionState {
  final String message;

  const ChatSessionFailure(this.message);

  @override
  List<Object> get props => [message];
}
