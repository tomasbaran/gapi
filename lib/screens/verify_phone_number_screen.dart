import 'dart:developer';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/pin_input_field_widget.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';

  final String phoneNumber;

  const VerifyPhoneNumberScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() => _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  late final ScrollController scrollController;

  @override
  void initState() {
    print('verifyPhoneNumberScreen init; phoneNu: ${widget.phoneNumber}');
    scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
  }

  // scroll to bottom of screen, when pin input field is in focus.
  Future<void> _scrollToBottomOnKeyboardOpen() async {
    while (!isKeyboardVisible) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await Future.delayed(const Duration(milliseconds: 250));

    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber: widget.phoneNumber,
        signOutOnSuccessfulVerification: false,
        linkWithExistingUser: false,
        autoRetrievalTimeOutDuration: const Duration(seconds: 30),
        otpExpirationDuration: const Duration(seconds: 30),
        onCodeSent: () {
          log(VerifyPhoneNumberScreen.id + ' OTP sent!');
        },
        onLoginSuccess: (userCredential, autoVerified) async {
          log(
            VerifyPhoneNumberScreen.id,
            // msg: autoVerified
            //     ? 'OTP was fetched automatically!'
            //     : 'OTP was verified manually!',
          );
          print('Phone number verified successfully!');

          // showSnackBar('Phone number verified successfully!');

          log(
            VerifyPhoneNumberScreen.id,
            // msg: 'Login Success UID: ${userCredential.user?.uid}',
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 5),
              content: Text(
                '¡Felicidades!\n\nYa puedes añadir reseñas.',
                style: tsSnackBarTitle,
              ),
              backgroundColor: kColorGreen,
            ),
          );
          // Navigator.pushNamedAndRemoveUntil(
          //   context,
          //   HomeScreen.id,
          //   (route) => false,
          // );
        },
        onLoginFailed: (authException, stackTrace) {
          log(
            VerifyPhoneNumberScreen.id,
            // msg: authException.message,
            error: authException,
            stackTrace: stackTrace,
          );

          switch (authException.code) {
            case 'invalid-phone-number':
              // invalid phone number
              // return showSnackBar('Invalid phone number!');
              print('Invalid phone number!');
              Navigator.of(context).pop();
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text(
                    'Error!\n\nNúmero de teléfono inválido.',
                    style: tsSnackBarTitle,
                  ),
                  backgroundColor: kColorRed,
                ),
              );
              return;
            case 'invalid-verification-code':
              // invalid otp entered
              // return showSnackBar('The entered OTP is invalid!');
              Navigator.of(context).pop();
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text(
                    'Error!\n\Código de verificación inválido.',
                    style: tsSnackBarTitle,
                  ),
                  backgroundColor: kColorRed,
                ),
              );
              return print('The entered OTP is invalid!');
            // handle other error codes
            default:
              Navigator.of(context).pop();
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text(
                    'Error!\n\nAlgo fue mal.',
                    style: tsSnackBarTitle,
                  ),
                  backgroundColor: kColorRed,
                ),
              );
              return print('Something went wrong! ${authException.code}');
          }
        },
        onError: (error, stackTrace) {
          log(
            VerifyPhoneNumberScreen.id,
            error: error,
            stackTrace: stackTrace,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 5),
              content: Text(
                'Error #1!\n\nAlgo fue mal.',
                style: tsSnackBarTitle,
              ),
              backgroundColor: kColorRed,
            ),
          );

          return print('Ann error occurred!');
        },
        builder: (context, controller) {
          return Scaffold(
            appBar: AppBar(
              leadingWidth: 0,
              leading: const SizedBox.shrink(),
              title: const Text('Verificacar Número de Teléfono'),
              actions: [
                if (controller.codeSent)
                  TextButton(
                    onPressed: controller.isOtpExpired
                        ? () async {
                            log(VerifyPhoneNumberScreen.id + 'Reenviar código.');
                            await controller.sendOTP();
                          }
                        : null,
                    child: Text(
                      controller.isOtpExpired ? 'Reenviar' : '${controller.otpExpirationTimeLeft.inSeconds}s',
                      style: const TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                const SizedBox(width: 5),
              ],
            ),
            body: controller.isSendingCode
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 50),
                      Center(
                        child: Text(
                          'Enviando código.',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    controller: scrollController,
                    children: [
                      Text(
                        "Hemos enviado un mensaje con el código de verificación a ${widget.phoneNumber}.",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 15),
                      const Text(
                        'Ingresa el código',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      PinInputField(
                        length: 6,
                        onFocusChange: (hasFocus) async {
                          if (hasFocus) await _scrollToBottomOnKeyboardOpen();
                        },
                        onSubmit: (enteredOtp) async {
                          final verified = await controller.verifyOtp(enteredOtp);
                          if (verified) {
                            // number verify success
                            // will call onLoginSuccess handler
                          } else {
                            // phone verification failed
                            // will call onLoginFailed or onError callbacks with the error
                          }
                        },
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
