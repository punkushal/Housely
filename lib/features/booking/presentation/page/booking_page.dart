import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:housely/features/property/domain/entities/property.dart';

@RoutePage()
class BookingPage extends StatelessWidget {
  const BookingPage({super.key, required this.property});
  final Property property;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Booking')));
  }
}
