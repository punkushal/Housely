import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';
import 'package:housely/features/property/domain/usecases/create_owner_profile.dart';
import 'package:housely/features/property/domain/usecases/get_owner_profile.dart';
import 'package:housely/features/property/domain/usecases/upload_cover_image.dart';

part 'owner_state.dart';

class OwnerCubit extends Cubit<OwnerState> {
  final CreateOwnerProfile createOwnerProfile;
  final GetOwnerProfile getOwnerProfile;
  final UploadCoverImage uploadCoverImage;
  OwnerCubit({
    required this.createOwnerProfile,
    required this.uploadCoverImage,
    required this.getOwnerProfile,
  }) : super(OwnerInitial());

  // upload profile image
  Future<Map<String, String>?> _uploadImage({
    File? image,
    required String folderType,
  }) async {
    emit(OwnerLoading());
    if (image == null) return null;
    final param = UploadImageParam(image: image, folderType: folderType);
    final result = await uploadCoverImage(param);

    final uploaded = result.fold(
      (failure) {
        emit(OwnerError(failure.message));
        return null;
      },
      (imageUrl) {
        emit(OwnerProfileUploaded());
        return imageUrl;
      },
    );
    return uploaded;
  }

  // create owner profile
  Future<void> createProfile(PropertyOwner owner, File? profile) async {
    emit(OwnerLoading());

    final coverUrl = await _uploadImage(image: profile, folderType: "profile");

    final param = OwnerParam(owner: owner.copyWith(profileImage: coverUrl));

    final result = await createOwnerProfile(param);

    result.fold(
      (f) => emit(OwnerError(f.message)),
      (_) => emit(OwnerLoaded(owner: owner)),
    );
  }

  // fetch owner profile
  Future<void> fetchProfile() async {
    emit(OwnerLoading());

    final result = await getOwnerProfile();

    result.fold(
      (f) => emit(OwnerError(f.message)),
      (owner) => emit(OwnerLoaded(owner: owner)),
    );
  }
}
