import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class GetUserStatus
    implements UseCaseStreamWithParam<ChatUser, GetStatusParams> {
  final ChatRepository chatRepository;

  GetUserStatus(this.chatRepository);
  @override
  ResultStream<ChatUser> call(params) {
    return chatRepository.getUserStatus(params.userId);
  }
}

class GetStatusParams extends Equatable {
  final String userId;

  const GetStatusParams(this.userId);

  @override
  List<Object?> get props => [userId];
}
