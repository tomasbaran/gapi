import 'package:flutter/material.dart';
import 'package:gapi/constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

class AddProviderScreen extends StatefulWidget {
  AddProviderScreen({Key? key}) : super(key: key);

  @override
  State<AddProviderScreen> createState() => _AddProviderScreenState();
}

class _AddProviderScreenState extends State<AddProviderScreen> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  String? categoryValue;

  String? providerName;
  String? providerPhone;
  String providerLocation = 'Merida';

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
                  onChanged: ((value) => providerLocation = value),
                  decoration: InputDecoration(
                    label: Text('Mérida'),
                    border: OutlineInputBorder(),
                    hintText: 'Mérida',
                  ),
                ),
                DropdownButton(
                  hint: const Text('categoría'),
                  value: categoryValue,
                  items: List.generate(
                    categories.length,
                    (index) => DropdownMenuItem(
                      value: categories[index],
                      child: Text(categories[index]),
                    ),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      categoryValue = newValue;
                    });
                  },
                ),
                TextField(
                  onChanged: ((value) => providerName = value),
                  decoration: InputDecoration(
                    label: Text('Nombre del proveedor'),
                    border: OutlineInputBorder(),
                    hintText: 'Juan Bautista',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                    onChanged: ((value) => providerPhone = value),
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
              if (categoryValue == null || providerName == null || providerPhone == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Hay que rellenar todos los campos.'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                print('category: $categoryValue');
                print('providersName: $providerName');
                print('providersPhone: $providerPhone');
                print('providersLocation: $providerLocation');

                DatabaseReference ref = FirebaseDatabase.instance.ref("providers");
                DatabaseReference newRef = ref.push();

                await newRef.set({
                  'name': providerName,
                  'phone': providerPhone,
                  'location': {'location1': providerLocation},
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('$providerName ha sido añadido.'),
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
