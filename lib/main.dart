import 'package:flutter/material.dart';
import 'package:gapi/screens/providers_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gapi',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const ProvidersListScreen(title: 'Gapi: Yucatán'),
    );
  }
}
