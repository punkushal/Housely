import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_limits.dart';

part 'property_form_state.dart';

class PropertyFormCubit extends Cubit<PropertyFormState> {
  PropertyFormCubit() : super(PropertyFormState());

  void changePropertyType(String value) {
    emit(state.copyWith(propertyType: value));
  }

  void changePropertyStatus(String value) {
    emit(state.copyWith(propertyStatus: value));
  }

  void setSingleImage(File image) {
    emit(state.copyWith(image: image));
  }

  void setMultipleImages(List<File> imageList) {
    final currentCount = state.imageList.length;
    final availableSlots = maxPropertyImagesLimit - currentCount;

    if (availableSlots <= 0) {
      return emit(
        state.copyWith(
          imageError: "You can only upload max $maxPropertyImagesLimit images",
        ),
      );
    }
    final imagesToAdd = imageList.take(availableSlots).toList();
    emit(
      state.copyWith(
        imageList: [...state.imageList, ...imagesToAdd],
        imageError: null,
      ),
    );
  }

  void removeImage(int index) {
    final images = state.imageList;
    images.removeAt(index);
    emit(state.copyWith(imageList: images));
  }
}
