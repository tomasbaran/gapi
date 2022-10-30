import 'package:flutter/material.dart';
import 'package:gapi/screens/providers_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  runApp(const MyApp());
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gapi',
      theme: ThemeData(
        primaryColor: const Color(0xFF076AA2),
        appBarTheme: AppBarTheme(
          color: const Color(0xFF076AA2),
        ),
      ),
      home: ProvidersListScreen(title: 'Gapi'),
    );
  }
}
