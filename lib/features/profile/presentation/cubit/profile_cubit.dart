import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/utils/file_utils.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/profile/domain/usecases/delete_profile_image_use_case.dart';
import 'package:housely/features/profile/domain/usecases/update_user_profile_use_case.dart';
import 'package:housely/features/profile/domain/usecases/upload_profile_image_use_case.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final UploadProfileImageUseCase uploadCoverImage;
  final DeleteProfileImageUseCase deleteImageFile;

  ProfileCubit({
    required this.updateUserProfileUseCase,
    required this.uploadCoverImage,
    required this.deleteImageFile,
  }) : super(ProfileState());

  void setProfileUrl(AppUser user) {
    emit(state.copyWith(profileImageUrl: user.photoUrl, appUser: user));
  }

  void setProfileImage(File image) {
    final imageSize = FileUtils.getFileSizeInMB(image);
    if (imageSize <= 10) {
      return emit(state.copyWith(pickedProfileImage: image));
    } else {
      return emit(
        state.copyWith(imageError: "Profile image must be under 10 MB"),
      );
    }
  }

  // upload profile image
  Future<Map<String, String>?> _uploadImage({
    required File image,
    required String folderType,
    required String email,
  }) async {
    emit(state.copyWith(status: .loading));
    final param = UploadProfileParams(
      image: image,
      folderType: folderType,
      email: email,
    );
    final result = await uploadCoverImage(param);

    return result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: failure.message, status: .error));
        return null;
      },
      (imageUrl) {
        return imageUrl;
      },
    );
  }

  Future<void> _deleteImageFile({required String fileId}) async {
    final result = await deleteImageFile(DeleteProfileImageParam(fileId));

    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message, status: .error)),
      (_) {
        emit(state.copyWith(status: .imageDeleted));
      },
    );
  }

  Future<void> updateUserProfile({
    required AppUser appUser,
    PropertyOwner? owner,
  }) async {
    emit(state.copyWith(status: .loading));

    AppUser updatedUser = appUser;
    // Upload profile image if user picked one
    if (state.pickedProfileImage != null) {
      if (state.profileImageUrl != null) {
        await _deleteImageFile(fileId: state.profileImageUrl!['id']);
      }
      final uploaded = await _uploadImage(
        image: state.pickedProfileImage!,
        folderType: "Profile",
        email: appUser.email,
      );
      if (uploaded != null) {
        updatedUser = updatedUser.copyWith(photoUrl: uploaded);
      } else {
        return emit(
          state.copyWith(
            errorMessage: "Failed to upload your profile image",
            status: .error,
          ),
        );
      }
    }

    final params = UpdateUserProfileParams(appUser: updatedUser, owner: owner);
    final result = await updateUserProfileUseCase(params);

    result.fold(
      (failure) {
        // requires recent login -> ask for reauthentication
        if (failure.message == 'requires-recent-login') {
          emit(
            state.copyWith(
              status: .error,
              reauthRequired: true,
              errorMessage: failure.message,
              appUser: updatedUser,
              owner: owner,
            ),
          );
        } else {
          emit(state.copyWith(status: .error, errorMessage: failure.message));
        }
      },
      (_) {
        emit(
          state.copyWith(
            status: .success,
            appUser: updatedUser,
            pickedProfileImage: null,
            owner: owner,
          ),
        );
      },
    );
  }

  void reset() {
    emit(
      state.copyWith(
        status: .initial,
        errorMessage: null,
        appUser: null,
        owner: null,
        imageError: null,
        pickedProfileImage: null,
        profileImageUrl: null,
      ),
    );
  }
}
