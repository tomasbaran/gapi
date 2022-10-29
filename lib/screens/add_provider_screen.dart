import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddProviderScreen extends StatelessWidget {
  const AddProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añade nuevo trabajador'),
      ),
      body: Column(children: [
        Text('Campo trabajador'),
      ]),
    );
  }
}
