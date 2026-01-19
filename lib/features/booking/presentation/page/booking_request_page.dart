import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BookingRequestPage extends StatelessWidget {
  const BookingRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Request')),
      body: SafeArea(child: Column(children: [])),
    );
  }
}
