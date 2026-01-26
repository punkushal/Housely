import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';
import 'package:housely/features/chat/domain/entity/message.dart';
import 'package:housely/features/chat/domain/usecases/create_or_get_chat.dart';
import 'package:housely/features/chat/domain/usecases/get_messages_use_case.dart';
import 'package:housely/features/chat/domain/usecases/get_user_status.dart';
import 'package:housely/features/chat/domain/usecases/send_message_use_case.dart';
import 'package:housely/features/chat/domain/usecases/update_user_status.dart';
import 'package:housely/features/chat/domain/usecases/delete_message.dart'
    as delete_message;
import 'package:housely/features/chat/domain/usecases/mark_message_as_read.dart';

part 'chat_session_event.dart';
part 'chat_session_state.dart';

class ChatSessionBloc extends Bloc<ChatSessionEvent, ChatSessionState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesStreamUseCase getMessagesUseCase;
  final delete_message.DeleteMessage deleteMessageUseCase;
  final MarkMessageAsRead markMessagesAsRead;
  final UpdateOnlineStatusUseCase updateOnlineStatus;
  final GetUserStatusStreamUseCase getUserStatus;
  final CreateOrGetChatUseCase createOrGetChat;

  StreamSubscription? _userStatusSubscription;
  StreamSubscription? _messagesSubscription;
  String? currentChatId;
  List<Message> _lastEmittedMessages = [];

  ChatSessionBloc({
    required this.sendMessageUseCase,
    required this.getMessagesUseCase,
    required this.deleteMessageUseCase,
    required this.markMessagesAsRead,
    required this.updateOnlineStatus,
    required this.getUserStatus,
    required this.createOrGetChat,
  }) : super(ChatSessionInitial()) {
    on<InitializeChat>(_onInitializeChat);
    on<SendMessage>(_onSendMessage);
    on<DeleteMessage>(_onDeleteMessage);
    on<LoadMoreMessages>(_onLoadMoreMessages);
    on<UserStatusUpdated>(_onUserStatusUpdated);
    on<MarkMessageAsReadEvent>(_onMarkMessagesAsRead);
    on<MessagesUpdated>(_onMessagesUpdated);
  }

  @override
  Future<void> close() {
    _userStatusSubscription?.cancel();
    _messagesSubscription?.cancel();
    return super.close();
  }

  /// Load more messages with pagination
  Future<void> _onLoadMoreMessages(
    LoadMoreMessages event,
    Emitter<ChatSessionState> emit,
  ) async {
    if (state is! ChatSessionLoaded) {
      emit(ChatSessionLoading());
    }

    final currentState = state as ChatSessionLoaded;

    // Don't load if no more messages or already loading
    if (!currentState.hasMoreMessages || currentState.isLoadingMore) return;

    // Set loading more state
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      // Get the oldest message for pagination
      final oldestMessage = currentState.messages.isNotEmpty
          ? currentState.messages.last
          : null;

      // Load more messages
      final result = await getMessagesUseCase(
        GetMessagesParams(
          chatId: currentState.chatId,
          limit: TextConstants.messagePageSize,
          lastMessage: oldestMessage,
        ),
      ).first;

      result.fold(
        (failure) {
          emit(
            currentState.copyWith(
              isLoadingMore: false,
              errorMessage: failure.message,
            ),
          );
        },
        (newMessages) {
          // Combine existing and new messages
          final allMessages = [...currentState.messages, ...newMessages];

          emit(
            currentState.copyWith(
              messages: allMessages,
              hasMoreMessages:
                  newMessages.length >= TextConstants.messagePageSize,
              isLoadingMore: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        currentState.copyWith(isLoadingMore: false, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onInitializeChat(
    InitializeChat event,
    Emitter<ChatSessionState> emit,
  ) async {
    // Emit loaded state with empty messages immediately (not loading)
    // This allows "Start a conversation" to show while fetching
    emit(ChatSessionLoaded(chatId: '', messages: [], isInitializing: true));

    // Create or get chat
    final result = await createOrGetChat(
      CreateOrGetChatParams(
        currentUser: event.currentUser,
        otherUser: event.otherUser,
      ),
    );

    await result.fold(
      (failure) async => emit(ChatSessionFailure(failure.message)),
      (chat) async {
        // Store the chat ID for later use
        currentChatId = chat.chatId;

        // Initial Setup (Mark read + online)
        await markMessagesAsRead(
          MarkParams(chatId: chat.chatId, userId: event.currentUser.uid),
        );

        // Update current user status to online
        await updateOnlineStatus(
          UpdateStatusParams(userId: event.currentUser.uid, isOnline: true),
        );

        // Listen to User status
        _userStatusSubscription?.cancel();

        await _setupUserStatusStream(event.otherUser.uid, emit);

        // Load initial messages and set up stream
        await _loadAndSubscribeToMessages(chat.chatId);
      },
    );
  }

  /// Load initial messages and set up persistent stream subscription
  Future<void> _loadAndSubscribeToMessages(String chatId) async {
    try {
      // Get first batch of messages to populate initial state
      final initialResult = await getMessagesUseCase(
        GetMessagesParams(chatId: chatId, limit: TextConstants.messagePageSize),
      ).first;

      await initialResult.fold(
        (failure) async {
          add(MessagesUpdated(messages: []));
        },
        (messages) async {
          // Emit initial messages
          add(MessagesUpdated(messages: messages));

          // Now set up the persistent stream subscription for real-time updates
          _setupMessagesStreamSubscription(chatId);
        },
      );
    } catch (e) {
      add(MessagesUpdated(messages: []));
    }
  }

  /// Set up persistent messages stream subscription for real-time updates
  Future<void> _setupMessagesStreamSubscription(String chatId) async {
    await _messagesSubscription?.cancel();

    _messagesSubscription =
        getMessagesUseCase(
          GetMessagesParams(
            chatId: chatId,
            limit: TextConstants.messagePageSize,
          ),
        ).listen((result) {
          result.fold(
            (failure) {
              // Handle error silently - keep existing messages
            },
            (messages) {
              // Dispatch an event to update messages from stream
              add(MessagesUpdated(messages: messages));
            },
          );
        });
  }

  /// Handle messages updates from stream
  Future<void> _onMessagesUpdated(
    MessagesUpdated event,
    Emitter<ChatSessionState> emit,
  ) async {
    // Prevent duplicate emissions by checking if messages list changed
    if (_lastEmittedMessages.length == event.messages.length &&
        _lastEmittedMessages.every(
          (msg) => event.messages.any((m) => m.messageId == msg.messageId),
        )) {
      // Same messages, skip duplicate emission
      return;
    }

    _lastEmittedMessages = event.messages;

    if (state is ChatSessionLoaded) {
      final currentState = state as ChatSessionLoaded;
      emit(
        currentState.copyWith(
          messages: event.messages,
          hasMoreMessages:
              event.messages.length >= TextConstants.messagePageSize,
          isInitializing: false,
        ),
      );
    } else {
      // First load
      emit(
        ChatSessionLoaded(
          messages: event.messages,
          chatId: currentChatId ?? '',
          hasMoreMessages:
              event.messages.length >= TextConstants.messagePageSize,
          isInitializing: false,
        ),
      );
    }
  }

  /// Set up real-time user status updates
  Future<void> _setupUserStatusStream(
    String otherUserId,
    Emitter<ChatSessionState> emit,
  ) async {
    await _userStatusSubscription?.cancel();

    _userStatusSubscription = getUserStatus(GetStatusParams(otherUserId))
        .listen((result) {
          result.fold(
            (_) {}, // Ignore errors for status updates
            (user) {
              add(
                UserStatusUpdated(
                  isOnline: user.isOnline,
                  lastSeen: user.lastSeen,
                ),
              );
            },
          );
        });
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatSessionState> emit,
  ) async {
    if (state is! ChatSessionLoaded) return;

    final currentState = state as ChatSessionLoaded;

    emit(currentState.copyWith(isSendingMessage: true));

    final result = await sendMessageUseCase(
      SendMessageParams(
        chatId: event.chatId,
        senderId: event.senderId,
        replyToMessageId: event.replyToMessageId,
        message: event.message,
      ),
    );

    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            isSendingMessage: false,
            errorMessage: failure.message,
          ),
        );
      },
      (sentMessage) {
        // Optimistic update: add the message to the list immediately (at the beginning since descending order)
        final updatedMessages = [sentMessage, ...currentState.messages];
        _lastEmittedMessages = updatedMessages;

        emit(
          currentState.copyWith(
            messages: updatedMessages,
            isSendingMessage: false,
          ),
        );

        // The stream will update automatically with the new message from Firestore
        // The deduplication logic will prevent duplicate rendering
      },
    );
  }

  Future<void> _onUserStatusUpdated(
    UserStatusUpdated event,
    Emitter<ChatSessionState> emit,
  ) async {
    if (state is ChatSessionLoaded) {
      final currentState = state as ChatSessionLoaded;
      emit(
        currentState.copyWith(
          isOtherUserOnline: event.isOnline,
          otherUserLastSeen: event.lastSeen,
        ),
      );
    }
  }

  /// Delete a message
  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<ChatSessionState> emit,
  ) async {
    if (state is! ChatSessionLoaded) return;

    final currentState = state as ChatSessionLoaded;

    // Set deleting state
    emit(currentState.copyWith(isDeletingMessage: true));

    // Delete message
    final result = await deleteMessageUseCase(
      delete_message.DeleteMessageParams(
        chatId: currentState.chatId,
        messageId: event.messageId,
      ),
    );

    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            isDeletingMessage: false,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        // Remove message from local list immediately for better UX
        // The stream will update automatically from Firestore
        final updatedMessages = currentState.messages
            .where((msg) => msg.messageId != event.messageId)
            .toList();

        emit(
          currentState.copyWith(
            messages: updatedMessages,
            isDeletingMessage: false,
          ),
        );
      },
    );
  }

  /// Mark messages as read
  Future<void> _onMarkMessagesAsRead(
    MarkMessageAsReadEvent event,
    Emitter<ChatSessionState> emit,
  ) async {
    await markMessagesAsRead(
      MarkParams(chatId: event.chatId, userId: event.currentUser),
    );
  }
}
