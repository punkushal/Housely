import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SeeAllListPage extends StatelessWidget {
  const SeeAllListPage({super.key, required this.appBarTitle});
  final String appBarTitle;
  // later i also accept the list parameter to display data
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(appBarTitle)));
  }
}
