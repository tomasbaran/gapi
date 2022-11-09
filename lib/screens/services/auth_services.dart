import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gapi/model/my_globals.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';

class AuthServices {
  DatabaseReference ref = FirebaseDatabase.instance.ref('users');

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> loginWithPhone() async {
    // Wait for the user to complete the reCAPTCHA & for an SMS code to be sent.
    ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber('+52 999 175 94 28');
    UserCredential userCredential = await confirmationResult.confirm('123456');
    String output = 'cp0';

    await FirebaseAuth.instance.signInWithPhoneNumber(
      '+529991759427',
      RecaptchaVerifier(
        auth: FirebaseAuthWeb.instance,
        onSuccess: () => print('reCAPTCHA Completed!'),
        onError: (FirebaseAuthException error) => print(error),
        onExpired: () => print('reCAPTCHA Expired!'),
        container: 'recaptcha',
        size: RecaptchaVerifierSize.compact,
        theme: RecaptchaVerifierTheme.dark,
      ),
    );

    //  .verifyPhoneNumber(
    //   phoneNumber: '+529991759427',
    //   verificationCompleted: (PhoneAuthCredential credential) {
    //     print('completed $credential');
    //     output = 'completed $credential';
    //     ScaffoldMessenger.of(myGlobals.scaffoldKey.currentContext!).showSnackBar(
    //       SnackBar(
    //         duration: Duration(seconds: 5),
    //         content: Text('completed $credential.'),
    //         backgroundColor: kColorRed,
    //       ),
    //     );
    //   },
    //   verificationFailed: (FirebaseAuthException e) {
    //     print('failed $e');
    //     output = 'failed $e';
    //     ScaffoldMessenger.of(myGlobals.scaffoldKey.currentContext!).showSnackBar(
    //       SnackBar(
    //         duration: Duration(seconds: 5),
    //         content: Text('failed $e'),
    //         backgroundColor: kColorRed,
    //       ),
    //     );
    //   },
    //   codeSent: (String verificationId, int? resendToken) {
    //     print('sent');
    //     output = 'sent';
    //     ScaffoldMessenger.of(myGlobals.scaffoldKey.currentContext!).showSnackBar(
    //       const SnackBar(
    //         duration: Duration(seconds: 5),
    //         content: Text('sent.'),
    //         backgroundColor: kColorRed,
    //       ),
    //     );
    //   },
    //   codeAutoRetrievalTimeout: (String verificationId) {
    //     print('timeOut');
    //     output = 'timeOUt';
    //     ScaffoldMessenger.of(myGlobals.scaffoldKey.currentContext!).showSnackBar(
    //       const SnackBar(
    //         duration: Duration(seconds: 5),
    //         content: Text('timeOut.'),
    //         backgroundColor: kColorRed,
    //       ),
    //     );
    //   },
    // );
    return output;
  }
}
