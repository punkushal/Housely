import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar());
  }
}
