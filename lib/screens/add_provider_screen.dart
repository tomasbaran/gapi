import 'package:flutter/material.dart';
import 'package:gapi/constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';

class AddProviderScreen extends StatefulWidget {
  AddProviderScreen({Key? key}) : super(key: key);

  @override
  State<AddProviderScreen> createState() => _AddProviderScreenState();
}

class _AddProviderScreenState extends State<AddProviderScreen> {
  String? _dropdownValue;

  String category = 'unknown';
  String providerName = 'unknown';
  String providerPhone = 'unknown';
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
                DropdownButton(
                  value: _dropdownValue,
                  items: List.generate(
                    categories.length,
                    (index) => DropdownMenuItem(
                      value: categories[index],
                      child: Text(categories[index]),
                    ),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _dropdownValue = newValue;
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
                    hintText: '999 123 45 67',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  enabled: false,
                  onChanged: ((value) => providerLocation = value),
                  decoration: InputDecoration(
                    label: Text('Mérida'),
                    border: OutlineInputBorder(),
                    hintText: 'Mérida',
                  ),
                ),
              ],
            ),
          ),
          BottomBlackButton(
            title: 'Hecho',
            onTap: () {
              print('category: $category');
              print('providersName: $providerName');
              print('providersPhone: $providerPhone');
              print('providersLocation: $providerLocation');

              return;
            },
          ),
        ],
      ),
    );
  }
}
