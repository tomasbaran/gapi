import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:gapi/notifiers/review.dart';
import 'package:gapi/screens/workers_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gapi/theme/style_constants.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // options: FirebaseOptions(apiKey: apiKey, appId: appId, messagingSenderId: messagingSenderId, projectId: projectId)
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FirebasePhoneAuthProvider(
      child: MaterialApp(
        title: 'Tedi',
        theme: ThemeData(
          primaryColor: kColorDarkGrey,
          appBarTheme: AppBarTheme(
            color: kColorDarkGrey,
          ),
        ),
        home: ChangeNotifierProvider(
          create: (_) => Review(),
          child: WorkersListScreen(title: 'Tedi.app'),
        ),
      ),
    );
  }
}
