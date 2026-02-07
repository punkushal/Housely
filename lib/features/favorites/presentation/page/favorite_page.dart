import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:housely/features/home/presentation/widgets/property_list.dart';

@RoutePage()
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<FavoritesBloc>().add(LoadFavoritesRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(title: Text("Favorite")),
          body: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              return switch (state) {
                FavoritesLoading() => Center(
                  child: CircularProgressIndicator(),
                ),

                FavoriteAdded(favorites: final list) ||
                FavoriteRemoved(favorites: final list) ||
                FavoritesLoaded(favorites: final list) => RefreshIndicator(
                  onRefresh: () async {
                    context.read<FavoritesBloc>().add(LoadFavoritesRequested());
                    // Wait a bit for the state to update
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: list.isEmpty
                      ? _buildEmptyListMessage()
                      : PropertyList(
                          propertyList: list
                              .map((fav) => fav.property)
                              .toList(),
                          showAll: true,
                        ),
                ),

                FavoritesError(message: final msg) => _buildErrorMessage(msg),

                _ => Center(child: Text("No favorites added yet")),
              };
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorMessage(String msg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.red),
        const SizedBox(height: 16),
        const Text(
          'Failed to load favorites',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            context.read<FavoritesBloc>().add(LoadFavoritesRequested());
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _buildEmptyListMessage() {
    return Center(
      child: Text(
        "No favorites added yet",
        style: AppTextStyle.bodySemiBold(
          context,
          color: AppColors.textHint,
          fontSize: 16,
        ),
      ),
    );
  }
}
