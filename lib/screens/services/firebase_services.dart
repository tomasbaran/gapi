import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:gapi/theme/constants.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl/intl.dart';

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

  addReview({
    required String workerId,
    required double rating1,
    required double rating2,
    String? comment,
  }) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("reviews");
    DatabaseReference newRef = ref.push();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    if (comment == null)
      await newRef.set({
        'rating1': rating1,
        'rating2': rating2,
        'worker_id': workerId,
        'date': formattedDate,
      });
    else
      await newRef.set({
        'rating1': rating1,
        'rating2': rating2,
        'worker_id': workerId,
        'comment': comment,
        'date': formattedDate,
      });
  }

  accumulateReviewToWorker(
    String workerId,
    double rating1,
    double rating2,
  ) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("workers").child(workerId).child('overall_rating');

    double newRatingsSum = rating1 + rating2;

    final ratingSumSnapshot = await ref.child('ratings_sum').get();
    if (ratingSumSnapshot.exists) {
      final dynamic snapshot = await ref.once();

      int readRatingsSum = snapshot.snapshot.value['ratings_sum'];
      int readRatingsCount = snapshot.snapshot.value['ratings_count'];
      int readRanking = snapshot.snapshot.value['ranking'];
      print('$readRatingsSum, $readRatingsCount, $readRanking');

      newRatingsSum += readRatingsSum;
      int newRating = ((newRatingsSum / ++readRatingsCount) * 10).toInt();

      await ref.update({'ratings_sum': newRatingsSum});
      await ref.update({'ratings_count': readRatingsCount++});
      await ref.update({'ranking': newRating});
    } else {
      double ranking = newRatingsSum / 1 * 10;

      await ref.update({'ratings_sum': newRatingsSum});
      await ref.update({'ratings_count': 1});
      await ref.update({'ranking': ranking});
    }
  }
}
