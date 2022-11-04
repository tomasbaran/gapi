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

  double calcRelevancy(double ranking, int ratingsCount) {
    // 100 (1 review): 10
    // 100 (2): 20
    // 100 (9): 90
    // 100 (10): 100
    if (ratingsCount < 10) {
      ranking = ranking / 10 * ratingsCount;
    }
    return ranking;
  }

  double calcRating(double readRating, double newRating) {
    double output;
    // penalty for an extremely bad rating of value 1
    if (newRating < 4) {
      output = readRating + newRating - 3;
    } else {
      output = readRating + newRating;
    }

    return output;
  }

  int calcRanking(double ratingsSum, int ratingsCount) {
    double avgRating = ratingsSum / ratingsCount;

    // example
    // 10	-> 100  4
    // 8	-> 50	  2
    // 6	-> 0		0
    // 4	-> -50	-2
    // 2	-> -100	-4
    avgRating = (avgRating - 6) * 25;

    avgRating = calcRelevancy(avgRating, ratingsCount);

    if (avgRating < -100) {
      avgRating = -100;
    }

    return avgRating.toInt();
  }

  writeOverallRatings(
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

      double updatedRatingsSum = calcRating(readRatingsSum.toDouble(), newRatingsSum);

      int newRanking = calcRanking(updatedRatingsSum, ++readRatingsCount);

      await ref.update({'ratings_sum': updatedRatingsSum});
      await ref.update({'ratings_count': readRatingsCount++});
      await ref.update({'ranking': newRanking});
    } else {
      double updatedRatingsSum = calcRating(0, newRatingsSum);
      int ranking = calcRanking(newRatingsSum, 1);

      await ref.update({'ratings_sum': updatedRatingsSum});
      await ref.update({'ratings_count': 1});
      await ref.update({'ranking': ranking});
    }
  }

  writeRating1(
    String workerId,
    double rating1,
  ) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("workers").child(workerId).child('rating1');

    double newRatingsSum = rating1;

    final ratingSumSnapshot = await ref.child('ratings_sum').get();
    if (ratingSumSnapshot.exists) {
      final dynamic snapshot = await ref.once();

      int readRatingsSum = snapshot.snapshot.value['ratings_sum'];
      int readRatingsCount = snapshot.snapshot.value['ratings_count'];
      int readRanking = snapshot.snapshot.value['ranking'];
      print('$readRatingsSum, $readRatingsCount, $readRanking');

      int newRating = ((newRatingsSum / ++readRatingsCount) * 10).toInt();

      await ref.update({'ratings_sum': newRatingsSum});
      await ref.update({'ratings_count': readRatingsCount++});
      await ref.update({'ranking': newRating});
    } else {
      double ranking = newRatingsSum / 1;

      await ref.update({'ratings_sum': newRatingsSum});
      await ref.update({'ratings_count': 1});
      await ref.update({'ranking': ranking});
    }
  }

  assignAllRatingsToWorkers(
    String workerId,
    double rating1,
    double rating2,
  ) {
    writeOverallRatings(workerId, rating1, rating2);
  }
}
