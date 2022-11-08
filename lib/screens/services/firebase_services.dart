import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:gapi/model/worker.dart';
import 'package:gapi/theme/constants.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl/intl.dart';

class FirebaseServices {
  writeWorkerToWorkerOnFirebase(
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

  writeReviewToWorkerOnFirebase({
    String? workerId,
    double? rating1,
    double? rating2,
    String? comment,
  }) {
    if (workerId != null && rating1 != null && rating2 != null) {
      writeOverallRatings(workerId, rating1, rating2);
      writeRating(workerId, rating1, '1');
      writeRating(workerId, rating2, '2');
    }
    if (workerId != null && comment != null) {
      writeCommentToWorkerOnFirebase(comment, workerId);
    }
  }

  writeCommentToWorkerOnFirebase(String comment, String workerId) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd-hh-mm').format(now);

    DatabaseReference ref = FirebaseDatabase.instance.ref("workers").child(workerId).child('comment');
    ref.update({formattedDate: comment});
  }

  writeReviewToReviewOnFirebase({
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

  List<Worker> sortByRanking(DataSnapshot snapshot) {
    List<Worker> unorderedWorkers = [];
    Worker newWorker;

    for (var worker in snapshot.children) {
      print("- snapshot worker: ${worker.child('name').value}: ${worker.child('rating1/avg_rating').value}");
      newWorker = Worker(
        key: worker.key ?? 'null',
        category: worker.child('category').value ?? 'null',
        name: worker.child('name').value ?? 'null',
        phoneNumber: worker.child('phone').value ?? 'null',
        ranking: worker.child('overall_rating/ranking').value == null ? 0 : int.parse(worker.child('overall_rating/ranking').value.toString()),
        ratingsCount:
            worker.child('overall_rating/ratings_count').value == null ? 0 : int.parse(worker.child('overall_rating/ratings_count').value.toString()),
        avg_rating1: worker.child('rating1/avg_rating').exists ? double.parse(worker.child('rating1/avg_rating').value.toString()) : 0,
        avg_rating2: worker.child('rating2/avg_rating').exists ? double.parse(worker.child('rating2/avg_rating').value.toString()) : 0,
      );
      unorderedWorkers.add(newWorker);
    }

    unorderedWorkers.sort(((a, b) {
      return b.ranking!.compareTo(a.ranking!);
    }));

    return unorderedWorkers;
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

  writeRating(
    String workerId,
    double rating,
    String ratingId,
  ) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("workers").child(workerId).child('rating' + ratingId);

    final ratingSumSnapshot = await ref.get();

    if (ratingSumSnapshot.exists) {
      final dynamic snapshot = await ref.once();

      int readRatingsSum = snapshot.snapshot.value['ratings_sum'];
      int readRatingsCount = snapshot.snapshot.value['ratings_count'];

      print('$readRatingsSum, $readRatingsCount');

      int newRatingsSum = readRatingsSum + rating.toInt();

      double newAvgRating = (newRatingsSum / ++readRatingsCount);

      await ref.update({'ratings_sum': newRatingsSum});
      await ref.update({'ratings_count': readRatingsCount++});
      await ref.update({'avg_rating': newAvgRating});
    } else {
      await ref.update({'ratings_sum': rating});
      await ref.update({'ratings_count': 1});
      await ref.update({'avg_rating': rating});
    }
  }
}
