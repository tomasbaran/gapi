import 'package:flutter/material.dart';
import 'package:gapi/screens/services/auth_services.dart';
import 'package:gapi/screens/verify_phone_number_screen.dart';
import 'package:gapi/widgets/bottom_black_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? phoneNumberInput;
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesión'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 16),
          Text('Para garantizar verdaderas evaluaciones, es necesario verificarte.'),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => phoneNumberInput = value,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '999 123 45 67',
                labelText: 'Número de teléfono',
              ),
            ),
          ),
          BottomButton(
            title: 'Ingresar',
            onTap: () {
              print('before VerifyPhoneNumberScreen init');
              Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyPhoneNumberScreen(phoneNumber: '+52' + phoneNumberInput!)));
            },
          ),
        ],
      ),
    );
  }
}
