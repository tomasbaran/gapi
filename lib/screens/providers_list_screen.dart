import 'package:flutter/material.dart';

class ProvidersListScreen extends StatelessWidget {
  const ProvidersListScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(children: [
        Container(
            color: Colors.amber,
            height: 70,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              Text('albañil'),
              Text('plomero'),
              Text('albañil'),
              Text('plomero'),
              Text('albañil'),
              Text('plomero 99'),
              Text('albañil 3 '),
              Text('plomero23 23 23'),
            ])),
        SizedBox(
          height: 32,
        ),
        Expanded(
          child: ListView(
            children: [Text('Provider 1')],
          ),
        ),
        Container(
          height: 70,
          width: double.infinity,
          color: Colors.black87,
          child: Center(
            child: Text(
              'Añadir',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ]),
    );
  }
}
