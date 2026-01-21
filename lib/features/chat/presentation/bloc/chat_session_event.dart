part of 'chat_session_bloc.dart';

sealed class ChatSessionEvent extends Equatable {
  const ChatSessionEvent();

  @override
  List<Object> get props => [];
}

final class SendMessage extends ChatSessionEvent {
  final ChatRoom chatRoom;
  final Message message;

  const SendMessage({required this.chatRoom, required this.message});

  @override
  List<Object> get props => [chatRoom, message];
}

final class LoadIndividualChatRoomMessages extends ChatSessionEvent {
  final String roomId;

  const LoadIndividualChatRoomMessages(this.roomId);

  @override
  List<Object> get props => [roomId];
}

final class LoadChatRooms extends ChatSessionEvent {}
