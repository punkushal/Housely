part of 'chat_list_bloc.dart';

sealed class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object> get props => [];
}

final class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<Chat> chats;
  final bool hasReachedMax;
  final int currentLimit;

  // Loading states
  final bool isLoadingMore;
  final bool isDeletingChat;

  const ChatListLoaded({
    required this.chats,
    required this.hasReachedMax,
    required this.currentLimit,
    this.isDeletingChat = false,
    this.isLoadingMore = false,
  });

  ChatListLoaded copyWith({
    List<Chat>? chats,
    bool? hasReachedMax,
    String? userId,
    int? currentLimit,
    bool? isLoadingMore,
    bool? isDeletingChat,
    String? errorMessage,
  }) {
    return ChatListLoaded(
      chats: chats ?? this.chats,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentLimit: currentLimit ?? this.currentLimit,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isDeletingChat: isDeletingChat ?? this.isDeletingChat,
    );
  }

  @override
  List<Object> get props => [
    chats,
    hasReachedMax,
    isDeletingChat,
    isLoadingMore,
    currentLimit,
  ];
}

class ChatListError extends ChatListState {
  final String message;

  const ChatListError(this.message);

  @override
  List<Object> get props => [message];
}
