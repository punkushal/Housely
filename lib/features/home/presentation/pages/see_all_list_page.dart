import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/home/presentation/cubit/favorite_toggle_cubit.dart';
import 'package:housely/features/home/presentation/widgets/property_list.dart';

@RoutePage()
class SeeAllListPage extends StatelessWidget {
  const SeeAllListPage({super.key, required this.appBarTitle});
  final String appBarTitle;
  // later i also accept the list parameter to display data
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteToggleCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text(appBarTitle)),
        // body: SafeArea(child: PropertyList()),
      ),
    );
  }
}
