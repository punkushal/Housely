part of 'chat_list_bloc.dart';

sealed class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object> get props => [];
}

class LoadChatList extends ChatListEvent {
  final String userId;
  final int limit;
  const LoadChatList({required this.userId, this.limit = 20});

  @override
  List<Object> get props => [userId, limit];
}

class LoadMoreChats extends ChatListEvent {
  final String userId;

  const LoadMoreChats(this.userId);

  @override
  List<Object> get props => [userId];
}

class ChatListUpdated extends ChatListEvent {
  final List<Chat> chats;

  const ChatListUpdated({required this.chats});

  @override
  List<Object> get props => [chats];
}

class RefreshChatList extends ChatListEvent {}

class DeleteChat extends ChatListEvent {
  final String chatId;

  const DeleteChat({required this.chatId});

  @override
  List<Object> get props => [chatId];
}
