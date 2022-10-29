import 'package:flutter/cupertino.dart';
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
        SizedBox(
          height: 32,
        ),
        Container(
            // color: Colors.amber,
            height: 40,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              SizedBox(width: 24),
              Text('albañil'),
              SizedBox(width: 12),
              Text('plomero'),
              SizedBox(width: 12),
              Text('albañil'),
              SizedBox(width: 12),
              Text('plomero'),
              SizedBox(width: 12),
              Text('albañil'),
              SizedBox(width: 12),
              Text('plomero 99'),
              SizedBox(width: 12),
              Text('albañil 3 '),
              Text('plomero23 23 23'),
            ])),
        SizedBox(
          height: 12,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: [
                Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Luis Jimenez'),
                            Text('calificaciones: 6'),
                            Text('reseñas: 1'),
                          ],
                        ),
                        Container(
                          color: Colors.green,
                          child: Text('79%'),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            height: 70,
            width: double.infinity,
            color: Colors.black87,
            child: const Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Añadir',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => Scaffold(
              appBar: AppBar(
                title: Text('Añade nuevo trabajador'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownList(),
                      TextField(
                        decoration: InputDecoration(
                          label: Text('Nombre del proveedor'),
                          border: OutlineInputBorder(),
                          hintText: 'Juan Bautista',
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          label: Text('Teléfono del proveedor'),
                          border: OutlineInputBorder(),
                          hintText: '999 123 45 67',
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          label: Text('Disponible en'),
                          border: OutlineInputBorder(),
                          hintText: 'Mérida',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class DropdownList extends StatefulWidget {
  const DropdownList({
    Key? key,
  }) : super(key: key);

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String dropdownValue = 'plomero';
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: [
        DropdownMenuItem(
          value: 'plomero',
          child: Text('plomero'),
        ),
        DropdownMenuItem(
          value: 'electricista',
          child: Text('electricista'),
        ),
      ],
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
    );
  }
}
