import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/theme/app_theme.dart';
import 'package:housely/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize firebase app
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Housely',
      theme: AppTheme.light(context),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Text(
                  'Heading Large',
                  style: AppTextStyle.headingRegular(context),
                ),
                Text('Body Regualar', style: AppTextStyle.bodyRegular(context)),
                Text(
                  'label semi bold',
                  style: AppTextStyle.labelSemiBold(context),
                ),
                TextField(decoration: InputDecoration(hintText: 'UserName')),
                Checkbox(value: false, onChanged: (value) {}),
                ElevatedButton(onPressed: () {}, child: Text("Button")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
