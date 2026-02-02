import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FavoritesBloc>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text("Favorite")),
            body: BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                if (state is FavoritesLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
