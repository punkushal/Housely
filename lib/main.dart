import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:housely/app/app.dart';
import 'package:housely/firebase_options.dart';
import 'package:housely/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize firebase app
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GoogleSignIn.instance.initialize(
    serverClientId:
        '299731885134-1c0bcthjhbl8p9n7tqa3cu0a51979a3o.apps.googleusercontent.com',
  );

  // Initialize dependencies
  await initializeDependencies();
  runApp(const MyApp());
}
