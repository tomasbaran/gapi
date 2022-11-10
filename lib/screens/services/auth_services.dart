import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gapi/model/my_globals.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart' show FirebaseAuthPlatform;

class AuthServices {
  DatabaseReference ref = FirebaseDatabase.instance.ref('users');

  FirebaseAuth auth = FirebaseAuth.instance;

  Future logout() async {
    await auth.signOut();
  }

  loginWithPhone(String phoneNumber) async {
    print('cp0');
    // Wait for the user to complete the reCAPTCHA & for an SMS code to be sent.
    // ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber('+52 999 175 94 27');
    try {
      ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(
        '+52' + phoneNumber,
        RecaptchaVerifier(
          auth: FirebaseAuthPlatform.instance,
          onSuccess: () => print('reCAPTCHA Completed!'),
          onError: (FirebaseAuthException error) {
            print('firebase error: $error');
            ScaffoldMessenger.of(myGlobals.scaffoldKey.currentContext!).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 5),
                content: Text('Firebase Auth Error: $error.'),
                backgroundColor: kColorRed,
              ),
            );
          },

          onExpired: () => print('reCAPTCHA Expired!'),
          // container: 'recaptcha',
          // size: RecaptchaVerifierSize.compact,
          // theme: RecaptchaVerifierTheme.dark,
        ),
      );

      print('cResult: $confirmationResult');
      UserCredential userCredential = await confirmationResult.confirm('123456');

      Navigator.of(myGlobals.scaffoldKey.currentContext!).pop();
      ScaffoldMessenger.of(myGlobals.scaffoldKey.currentContext!).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text('Ingresaste con éxito! Ahora puedes ir dando reseñas.'),
          backgroundColor: kColorGreen,
        ),
      );
    } catch (e) {
      print('my caught e: $e');
      ScaffoldMessenger.of(myGlobals.scaffoldKey.currentContext!).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text('Caught error (phone number: $phoneNumber): $e.'),
          backgroundColor: kColorRed,
        ),
      );
    }
  }
}
