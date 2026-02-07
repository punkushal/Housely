import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_toggle_state.dart';

class FavoriteToggleCubit extends Cubit<FavoriteToggleState> {
  FavoriteToggleCubit() : super(FavoriteToggleState());

  void toggleFavorite() {
    emit(state.copyWith(isSelected: !state.isSelected));
  }
}
