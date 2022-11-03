import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:gapi/theme/constants.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class FirebaseServices {
  addWorker(
    String? workerName,
    String workerPhone,
    String? categoryName,
    String workerLocation,
  ) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("workers");
    DatabaseReference newRef = ref.push();

    await newRef.set({
      'name': workerName,
      'phone': workerPhone,
      'category': categoryName,
      'location': {'location1': workerLocation},
    });
  }
}
