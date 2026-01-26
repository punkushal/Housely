part of 'chat_session_bloc.dart';

sealed class ChatSessionState extends Equatable {
  const ChatSessionState();

  @override
  List<Object?> get props => [];
}

final class ChatSessionInitial extends ChatSessionState {}

final class ChatSessionLoading extends ChatSessionState {}

final class ChatSessionLoaded extends ChatSessionState {
  final String chatId;
  final List<Message> messages;
  final bool isOtherUserOnline;
  final DateTime? otherUserLastSeen;

  // Pagination
  final bool hasMoreMessages;
  final bool isLoadingMore;

  // To handle delete message loading state
  final bool isDeletingMessage;
  final bool isSendingMessage;
  final String? errorMessage;
  final bool isInitializing; // Track if still initializing chat

  const ChatSessionLoaded({
    required this.chatId,
    required this.messages,
    this.isOtherUserOnline = false,
    this.otherUserLastSeen,
    this.isDeletingMessage = false,
    this.errorMessage,
    this.hasMoreMessages = false,
    this.isLoadingMore = false,
    this.isSendingMessage = false,
    this.isInitializing = false,
  });

  ChatSessionLoaded copyWith({
    List<Message>? messages,
    bool? isOtherUserOnline,
    DateTime? otherUserLastSeen,
    bool? isDeletingMessage,
    String? errorMessage,
    bool? hasMoreMessages,
    bool? isLoadingMore,
    bool? isSendingMessage,
    bool? isInitializing,
  }) {
    return ChatSessionLoaded(
      chatId: chatId,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      messages: messages ?? this.messages,
      isOtherUserOnline: isOtherUserOnline ?? this.isOtherUserOnline,
      otherUserLastSeen: otherUserLastSeen ?? this.otherUserLastSeen,
      isDeletingMessage: isDeletingMessage ?? this.isDeletingMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      isInitializing: isInitializing ?? this.isInitializing,
    );
  }

  @override
  List<Object?> get props => [
    chatId,
    messages,
    isOtherUserOnline,
    otherUserLastSeen,
    isDeletingMessage,
    errorMessage,
    hasMoreMessages,
    isLoadingMore,
    isSendingMessage,
    isInitializing,
  ];
}

final class ChatSessionSuccess extends ChatSessionState {}

final class ChatSessionFailure extends ChatSessionState {
  final String message;

  const ChatSessionFailure(this.message);

  @override
  List<Object> get props => [message];
}
