import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/message.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class GetMessagesUseCase
    implements UseCaseStreamWithParam<List<Message>, GetMessagesParams> {
  final ChatRepository chatRepository;

  GetMessagesUseCase(this.chatRepository);
  @override
  ResultStream<List<Message>> call(param) {
    return chatRepository.getMessages(roomId: param.roomId);
  }
}

class GetMessagesParams extends Equatable {
  final String roomId;

  const GetMessagesParams({required this.roomId});

  @override
  List<Object> get props => [roomId];
}
