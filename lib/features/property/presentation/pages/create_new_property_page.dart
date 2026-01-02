import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CreateNewPropertyPage extends StatefulWidget {
  const CreateNewPropertyPage({super.key});

  @override
  State<CreateNewPropertyPage> createState() => _CreateNewPropertyPageState();
}

class _CreateNewPropertyPageState extends State<CreateNewPropertyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Add new property')));
  }
}
