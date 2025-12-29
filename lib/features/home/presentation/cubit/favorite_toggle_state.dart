part of 'favorite_toggle_cubit.dart';

final class FavoriteToggleState extends Equatable {
  final bool isSelected;
  const FavoriteToggleState({this.isSelected = false});

  FavoriteToggleState copyWith({bool? isSelected}) =>
      FavoriteToggleState(isSelected: isSelected ?? this.isSelected);

  @override
  List<Object> get props => [isSelected];
}
