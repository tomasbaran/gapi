import 'package:flutter/material.dart';
import 'package:gapi/screens/workers_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // options: FirebaseOptions(apiKey: apiKey, appId: appId, messagingSenderId: messagingSenderId, projectId: projectId)
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tedi',
      theme: ThemeData(
        primaryColor: const Color(0xFF076AA2),
        appBarTheme: AppBarTheme(
          color: const Color(0xFF076AA2),
        ),
      ),
      home: WorkersListScreen(title: 'Tedi'),
    );
  }
}
