import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:housely/features/home/presentation/widgets/property_list.dart';

@RoutePage()
class MyPropertyListPage extends StatefulWidget {
  const MyPropertyListPage({super.key});

  @override
  State<MyPropertyListPage> createState() => _MyPropertyListPageState();
}

class _MyPropertyListPageState extends State<MyPropertyListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My properties")),
      body: PropertyList(),
    );
  }
}
