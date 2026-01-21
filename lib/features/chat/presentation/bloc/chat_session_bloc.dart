import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/chat/domain/entity/chat_room.dart';
import 'package:housely/features/chat/domain/entity/message.dart';
import 'package:housely/features/chat/domain/usecases/get_chat_rooms_use_case.dart';
import 'package:housely/features/chat/domain/usecases/get_messages_use_case.dart';
import 'package:housely/features/chat/domain/usecases/send_message_use_case.dart';

part 'chat_session_event.dart';
part 'chat_session_state.dart';

class ChatSessionBloc extends Bloc<ChatSessionEvent, ChatSessionState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final GetChatRoomsUseCase getChatRoomsUseCase;
  ChatSessionBloc({
    required this.sendMessageUseCase,
    required this.getMessagesUseCase,
    required this.getChatRoomsUseCase,
  }) : super(ChatSessionInitial()) {
    on<SendMessage>(_sendMessage);
    on<LoadIndividualChatRoomMessages>(_loadChatRoomMessages);
    on<LoadChatRooms>(_loadChatRooms);
  }

  Future<void> _sendMessage(
    SendMessage event,
    Emitter<ChatSessionState> emit,
  ) async {
    emit(ChatSessionLoading());

    final result = await sendMessageUseCase(
      SendParams(message: event.message, chatRoom: event.chatRoom),
    );

    result.fold(
      (f) => ChatSessionFailure(f.message),
      (_) => emit(ChatSessionSuccess()),
    );
  }

  Future<void> _loadChatRoomMessages(
    LoadIndividualChatRoomMessages event,
    Emitter<ChatSessionState> emit,
  ) async {
    emit(ChatSessionLoading());

    await emit.forEach(
      getMessagesUseCase(GetMessagesParams(roomId: event.roomId)),
      onData: (data) => ChatSessionChatRoomMessagesLoaded(data),
      onError: (error, stackTrace) => ChatSessionFailure(error.toString()),
    );
  }

  Future<void> _loadChatRooms(
    LoadChatRooms event,
    Emitter<ChatSessionState> emit,
  ) async {
    emit(ChatSessionLoading());

    await emit.forEach(
      getChatRoomsUseCase(),
      onData: (data) => ChatSessionChatRoomsLoaded(data),
      onError: (error, stackTrace) => ChatSessionFailure(error.toString()),
    );
  }
}
