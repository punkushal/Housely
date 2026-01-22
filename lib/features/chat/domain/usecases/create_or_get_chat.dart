import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/chat/domain/entity/chat.dart';
import 'package:housely/features/chat/domain/repositories/chat_repo.dart';

class CreateOrGetChat implements UseCase<Chat, CreateOrGetChatParams> {
  final ChatRepository repository;

  CreateOrGetChat(this.repository);

  @override
  ResultFuture<Chat> call(CreateOrGetChatParams params) async {
    return await repository.createOrGetChat(
      currentUserId: params.currentUserId,
      otherUserId: params.otherUserId,
      currentUserName: params.currentUserName,
      currentUserProfileImage: params.currentUserProfileImage,
      otherUserName: params.otherUserName,
      otherUserProfileImage: params.otherUserProfileImage,
    );
  }
}

class CreateOrGetChatParams extends Equatable {
  final String currentUserId;
  final String otherUserId;
  final String currentUserName;
  final String? currentUserProfileImage;
  final String otherUserName;
  final String? otherUserProfileImage;

  const CreateOrGetChatParams({
    required this.currentUserId,
    required this.otherUserId,
    required this.currentUserName,
    this.currentUserProfileImage,
    required this.otherUserName,
    this.otherUserProfileImage,
  });

  @override
  List<Object?> get props => [
    currentUserId,
    otherUserId,
    currentUserName,
    currentUserProfileImage,
    otherUserName,
    otherUserProfileImage,
  ];
}
