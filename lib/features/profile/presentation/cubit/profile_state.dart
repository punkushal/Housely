// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, error, success, loaded }

class ProfileState extends Equatable {
  final File? pickedProfileImage;
  final AppUser? appUser;
  final PropertyOwner? owner;
  final ProfileStatus status;
  final Map<String, dynamic>? profileImageUrl;

  // UI states
  final String? errorMessage;
  final String? imageError;

  const ProfileState({
    this.status = .initial,
    this.pickedProfileImage,
    this.appUser,
    this.owner,
    this.errorMessage,
    this.imageError,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
    status,
    appUser,
    pickedProfileImage,
    owner,
    errorMessage,
    imageError,
    profileImageUrl,
  ];

  ProfileState copyWith({
    File? pickedProfileImage,
    AppUser? appUser,
    PropertyOwner? owner,
    String? errorMessage,
    bool? reauthRequired,
    String? imageError,
    Map<String, dynamic>? profileImageUrl,
    ProfileStatus? status,
  }) {
    return ProfileState(
      pickedProfileImage: pickedProfileImage ?? this.pickedProfileImage,
      appUser: appUser ?? this.appUser,
      owner: owner ?? this.owner,
      errorMessage: errorMessage ?? this.errorMessage,
      imageError: imageError ?? this.imageError,
      status: status ?? this.status,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
