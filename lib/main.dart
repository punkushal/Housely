import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:housely/app/app.dart';
import 'package:housely/env/env.dart';
import 'package:housely/firebase_options.dart';
import 'package:housely/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize firebase app
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GoogleSignIn.instance.initialize(
    serverClientId: Env.googleServerClientId,
  );

  // Initialize dependencies
  await initializeDependencies();
  runApp(MyApp());
}
