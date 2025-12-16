import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:housely/app/app.dart';
import 'package:housely/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize firebase app
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
