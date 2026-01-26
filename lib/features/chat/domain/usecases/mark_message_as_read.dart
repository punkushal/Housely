import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class MarkMessageAsRead implements UseCase<void, MarkParams> {
  final ChatRepository chatRepository;

  MarkMessageAsRead(this.chatRepository);
  @override
  ResultFuture<void> call(params) async {
    return await chatRepository.markMessagesAsRead(
      chatId: params.chatId,
      userId: params.userId,
    );
  }
}

class MarkParams extends Equatable {
  final String chatId;
  final String userId;

  const MarkParams({required this.chatId, required this.userId});

  @override
  List<Object?> get props => [chatId, userId];
}
