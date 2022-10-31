import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:gapi/constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AddWorkerScreen extends StatefulWidget {
  AddWorkerScreen({Key? key, required this.categoryIndex}) : super(key: key);
  int categoryIndex;

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  String? categoryName;

  String? workerName;
  String workerPhone = '';
  String workerLocation = 'Merida';

  @override
  void initState() {
    super.initState();
    categoryName = categories[widget.categoryIndex];
  }

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
                  // hint: Text(categories[widget.categoryIndex]),
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
                    keyboardType: TextInputType.phone,
                    onChanged: ((value) => workerPhone = value),
                    decoration: InputDecoration(
                      label: Text('Teléfono del proveedor'),
                      border: OutlineInputBorder(),
                      prefixText: '+52 ',
                      hintText: '999 123 45 67',
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(13),
                      MaskedInputFormatter('### ### ## ##'),
                      // MaskedInputFormater('(###) ###-####'),
                    ]),
                SizedBox(height: 20),
              ],
            ),
          ),
          BottomButton(
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

                // format phoneNumber to delete all spacebars
                workerPhone = workerPhone.replaceAll(' ', '');

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
