import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    Key? key,
    this.input,
  }) : super(key: key);
  final String? input;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesión'),
      ),
      body: Column(children: [
        Text('Para garantizar verdaderas evaluaciones, es necesario verificarte.'),
        const SizedBox(height: 16),
        Text(input ?? 'no input'),
      ]),
    );
  }
}
