import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    emit(state.copyWith(imageList: [...state.imageList, ...imageList]));
  }

  void removeImage(int index) {
    final images = state.imageList;
    images.removeAt(index);
    emit(state.copyWith(imageList: images));
  }
}
