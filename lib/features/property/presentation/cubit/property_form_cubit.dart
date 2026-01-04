import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_limits.dart';
import 'package:housely/core/utils/file_utils.dart';

part 'property_form_state.dart';

class PropertyFormCubit extends Cubit<PropertyFormState> {
  PropertyFormCubit() : super(PropertyFormState());

  void changePropertyType(String value) {
    emit(state.copyWith(propertyType: value));
  }

  void changePropertyStatus(String value) {
    emit(state.copyWith(propertyStatus: value));
  }

  void setAddress(String address) {
    emit(state.copyWith(address: address));
  }

  void setSingleImage(File image) {
    final imageSize = FileUtils.getFileSizeInMB(image);
    if (imageSize <= 10) {
      return emit(state.copyWith(image: image, imageError: null));
    } else {
      return emit(
        state.copyWith(imageError: "Cover image must be under 10 MB"),
      );
    }
  }

  void setMultipleImages(List<File> newImages) {
    final currentImages = List<File>.from(state.imageList);

    double currentSize = FileUtils.getTotalSizeInMB(currentImages);

    final allowedImages = <File>[];

    for (var image in newImages) {
      final imageSize = FileUtils.getFileSizeInMB(image);
      if (currentSize + imageSize <= maxPropertyImagesSizeInMB) {
        allowedImages.add(image);
        currentSize += imageSize;
      } else {
        break;
      }
    }

    if (allowedImages.isEmpty) {
      return emit(
        state.copyWith(
          imageError: "Image files exceed $maxPropertyImagesSizeInMB MB",
        ),
      );
    }

    emit(
      state.copyWith(
        imageList: [...state.imageList, ...allowedImages],
        imageError: null,
      ),
    );
  }

  void removeImage(int index) {
    final updatedImages = List<File>.from(state.imageList)..removeAt(index);
    emit(state.copyWith(imageList: updatedImages, imageError: null));
  }

  void updateFacilities(List<String> facilities) {
    emit(state.copyWith(facilities: facilities));
  }
}
