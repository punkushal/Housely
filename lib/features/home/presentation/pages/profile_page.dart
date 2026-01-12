import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:housely/app/app_router.gr.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            context.router.push(MyPropertyListRoute());
          },
          child: Text('property list'),
        ),
      ),
    );
  }
}
