import 'package:flutter/material.dart';
import 'package:gapi/constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

class AddWorkerScreen extends StatefulWidget {
  AddWorkerScreen({Key? key}) : super(key: key);

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  String? categoryName;

  String? workerName;
  String? workerPhone;
  String workerLocation = 'Merida';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añade nuevo trabajador'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  enabled: false,
                  onChanged: ((value) => workerLocation = value),
                  decoration: InputDecoration(
                    label: Text('Mérida'),
                    border: OutlineInputBorder(),
                    hintText: 'Mérida',
                  ),
                ),
                DropdownButton(
                  hint: const Text('categoría'),
                  value: categoryName,
                  items: List.generate(
                    categories.length,
                    (index) => DropdownMenuItem(
                      value: categories[index],
                      child: Text(categories[index]),
                    ),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      categoryName = newValue;
                    });
                  },
                ),
                TextField(
                  onChanged: ((value) => workerName = value),
                  decoration: InputDecoration(
                    label: Text('Nombre del proveedor'),
                    border: OutlineInputBorder(),
                    hintText: 'Juan Bautista',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                    onChanged: ((value) => workerPhone = value),
                    decoration: InputDecoration(
                      label: Text('Teléfono del proveedor'),
                      border: OutlineInputBorder(),
                      prefixText: '+52 ',
                      hintText: '999 123 45 67',
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ]),
                SizedBox(height: 20),
              ],
            ),
          ),
          BottomBlackButton(
            title: 'Hecho',
            onTap: () async {
              if (categoryName == null || workerName == null || workerPhone == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Hay que rellenar todos los campos.'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                print('category: $categoryName');
                print('workerName: $workerName');
                print('workerPhone: $workerPhone');
                print('workerLocation: $workerLocation');

                DatabaseReference ref = FirebaseDatabase.instance.ref("workers");
                DatabaseReference newRef = ref.push();

                await newRef.set({
                  'name': workerName,
                  'phone': workerPhone,
                  'category': categoryName,
                  'location': {'location1': workerLocation},
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('$workerName ha sido añadido.'),
                    backgroundColor: Colors.green,
                  ),
                );
              }

              return;
            },
          ),
        ],
      ),
    );
  }
}
