import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';
import 'package:housely/features/chat/domain/usecases/get_chat_list.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetChatListUseCase getChatList;
  ChatListBloc(this.getChatList) : super(ChatListInitial()) {
    on<LoadChatList>(_onLoadChatList);
    on<LoadMoreChats>(_onLoadMoreChats);
  }

  Future<void> _onLoadChatList(
    LoadChatList event,
    Emitter<ChatListState> emit,
  ) async {
    if (state is ChatListInitial) {
      emit(ChatListLoading());
    }

    await emit.forEach<Either<Failure, List<Chat>>>(
      getChatList(GetChatListParams(userId: event.userId, limit: event.limit)),
      onData: (result) {
        return result.fold((f) => ChatListError(f.message), (chatList) {
          final hasReachedMax = chatList.length < event.limit;
          return ChatListLoaded(
            chats: chatList,
            hasReachedMax: hasReachedMax,
            currentLimit: event.limit,
          );
        });
      },
      onError: (error, stackTrace) => ChatListError(error.toString()),
    );
  }

  void _onLoadMoreChats(
    LoadMoreChats event,
    Emitter<ChatListState> emit,
  ) async {
    if (state is ChatListLoaded) {
      final currentState = state as ChatListLoaded;
      if (currentState.hasReachedMax || currentState.isLoadingMore) return;

      emit(currentState.copyWith(isLoadingMore: true));

      // Increase the limit in state
      final newLimit =
          TextConstants.chatListPageSize + currentState.currentLimit;

      await emit.forEach<Either<Failure, List<Chat>>>(
        getChatList(GetChatListParams(userId: event.userId, limit: newLimit)),
        onData: (result) {
          return result.fold((f) => ChatListError(f.message), (chatList) {
            final hasReachedMax = chatList.length < newLimit;
            return ChatListLoaded(
              chats: chatList,
              hasReachedMax: hasReachedMax,
              currentLimit: newLimit,
              isLoadingMore: false,
            );
          });
        },
        onError: (error, stackTrace) => ChatListError(error.toString()),
      );
    }
  }
}
