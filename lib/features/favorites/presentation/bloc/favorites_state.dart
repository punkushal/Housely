part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

final class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

// --- Success: list loaded ---
class FavoritesLoaded extends FavoritesState {
  final List<Favorite> favorites;
  const FavoritesLoaded(this.favorites);
  @override
  List<Object> get props => [favorites];
}

// --- Success: single add/remove completed, carry updated list ---
class FavoriteAdded extends FavoritesState {
  final List<Favorite> favorites;
  const FavoriteAdded(this.favorites);
  @override
  List<Object> get props => [favorites];
}

class FavoriteRemoved extends FavoritesState {
  final List<Favorite> favorites;
  const FavoriteRemoved(this.favorites);
  @override
  List<Object> get props => [favorites];
}

// --- Check result (for a single item, e.g. a heart icon on detail page) ---
class FavoriteChecked extends FavoritesState {
  final bool isFavorite;
  const FavoriteChecked(this.isFavorite);
  @override
  List<Object> get props => [isFavorite];
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
  @override
  List<Object> get props => [message];
}
