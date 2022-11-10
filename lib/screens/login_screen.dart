import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:gapi/screens/verify_phone_number_screen.dart';
import 'package:gapi/theme/style_constants.dart';
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
        title: Text('Verificación'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Para garantizar verdaderas evaluaciones, es necesario verificarte.',
              style: tsVerificationText,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                keyboardType: TextInputType.phone,
                onChanged: ((value) => phoneNumberInput = value),
                decoration: InputDecoration(
                  label: Text('Tu número de teléfono'),
                  border: OutlineInputBorder(),
                  prefixText: '+52 ',
                  hintText: '999 123 45 67',
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(13),
                  MaskedInputFormatter('### ### ## ##'),
                  // MaskedInputFormater('(###) ###-####'),
                ]),
          ),
          Expanded(
            child: const SizedBox(),
          ),
          BottomButton(
            title: 'Ingresar',
            onTap: () {
              print('before VerifyPhoneNumberScreen init');
              Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyPhoneNumberScreen(phoneNumber: '+52 ' + phoneNumberInput!)));
            },
          ),
        ],
      ),
    );
  }
}
