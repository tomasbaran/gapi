import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:gapi/model/comment.dart';
import 'package:gapi/model/worker.dart';
import 'package:gapi/theme/constants.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl/intl.dart';

class FirebaseServices {
  DatabaseReference workersRef = FirebaseDatabase.instance.ref("workers");
  DatabaseReference reviewsRef = FirebaseDatabase.instance.ref("reviews");
  DatabaseReference usersRef = FirebaseDatabase.instance.ref("users");

  FirebaseAuth auth = FirebaseAuth.instance;

  Future logout() async {
    await auth.signOut();
  }

  writeWorkerToWorkerOnFirebase(
    String? workerName,
    String workerPhone,
    String? categoryName,
    String workerLocation,
  ) async {
    DatabaseReference newWorkerRef = workersRef.push();
    await newWorkerRef.set({
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
    if (workerId != null && comment != null && rating1 != null && rating2 != null) {
      double avgRating = (rating1 + rating2) / 2;
      writeCommentToWorkerOnFirebase(
        comment,
        workerId,
        avgRating,
      );
    }
  }

  writeCommentToWorkerOnFirebase(String comment, String workerId, double avgRating) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    DatabaseReference commentsRef = FirebaseDatabase.instance.ref("workers").child(workerId).child('comments');
    commentsRef.update({
      formattedDate: {
        'comment': comment,
        'avg_rating': avgRating,
      }
    });
  }

  writeReviewToUserOnFirebase({required reviewId}) async {
    DatabaseReference newReviewRef = usersRef.child(auth.currentUser!.uid).child('reviews');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd-hh-mm').format(now);
    print('cp10');
    try {
      await newReviewRef.set({formattedDate: reviewId});
    } catch (e) {
      print('error #99: $e');
    }
  }

  writeReviewToReviewOnFirebase({
    required String workerId,
    required double rating1,
    required double rating2,
    String? comment,
  }) async {
    DatabaseReference newReviewRef = reviewsRef.push();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    if (comment == null)
      await newReviewRef.set({
        'rating1': rating1,
        'rating2': rating2,
        'worker_id': workerId,
        'date': formattedDate,
      });
    else
      await newReviewRef.set({
        'rating1': rating1,
        'rating2': rating2,
        'worker_id': workerId,
        'comment': comment,
        'date': formattedDate,
      });

    await writeReviewToUserOnFirebase(reviewId: newReviewRef.key);
  }

  List<Worker> sortByRanking(DataSnapshot snapshot) {
    List<Worker> unorderedWorkers = [];
    Worker newWorker;

    for (var worker in snapshot.children) {
      print("- snapshot worker: ${worker.child('name').value}: ${worker.child('rating1/avg_rating').value}");
      List<CommentModel> commentsList = [];
      if (worker.child('comments').exists) {
        print('LLength: ${worker.child('comments').children.length}');

        for (var readComment in worker.child('comments').children) {
          print('comment.value: ${readComment.child('path')}');
          commentsList.add(
            CommentModel(
              body: readComment.child('comment').value.toString(),
              date: DateTime.parse(readComment.key.toString()),
              rating: double.parse(readComment.child('avg_rating').value.toString()),
            ),
          );
        }
      }
      newWorker = Worker(
        key: worker.key ?? 'null',
        category: worker.child('category').value ?? 'null',
        name: worker.child('name').value ?? 'null',
        phoneNumber: worker.child('phone').value ?? 'null',
        ranking: worker.child('overall_rating/ranking').value == null ? 0 : int.parse(worker.child('overall_rating/ranking').value.toString()),
        ratingsCount:
            worker.child('overall_rating/ratings_count').value == null ? 0 : int.parse(worker.child('overall_rating/ratings_count').value.toString()),
        commentsCount: worker.child('comments').children.length,
        avg_rating1: worker.child('rating1/avg_rating').exists ? double.parse(worker.child('rating1/avg_rating').value.toString()) : 0,
        avg_rating2: worker.child('rating2/avg_rating').exists ? double.parse(worker.child('rating2/avg_rating').value.toString()) : 0,
        comments: commentsList,
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
    DatabaseReference overallRatingRef = FirebaseDatabase.instance.ref("workers").child(workerId).child('overall_rating');

    double newRatingsSum = rating1 + rating2;

    final ratingSumSnapshot = await overallRatingRef.child('ratings_sum').get();
    if (ratingSumSnapshot.exists) {
      final dynamic snapshot = await overallRatingRef.once();

      int readRatingsSum = snapshot.snapshot.value['ratings_sum'];
      int readRatingsCount = snapshot.snapshot.value['ratings_count'];
      int readRanking = snapshot.snapshot.value['ranking'];
      print('$readRatingsSum, $readRatingsCount, $readRanking');

      double updatedRatingsSum = calcRating(readRatingsSum.toDouble(), newRatingsSum);

      int newRanking = calcRanking(updatedRatingsSum, ++readRatingsCount);

      await overallRatingRef.update({'ratings_sum': updatedRatingsSum});
      await overallRatingRef.update({'ratings_count': readRatingsCount++});
      await overallRatingRef.update({'ranking': newRanking});
    } else {
      double updatedRatingsSum = calcRating(0, newRatingsSum);
      int ranking = calcRanking(newRatingsSum, 1);

      await overallRatingRef.update({'ratings_sum': updatedRatingsSum});
      await overallRatingRef.update({'ratings_count': 1});
      await overallRatingRef.update({'ranking': ranking});
    }
  }

  writeRating(
    String workerId,
    double rating,
    String ratingId,
  ) async {
    DatabaseReference ratingRef = FirebaseDatabase.instance.ref("workers").child(workerId).child('rating' + ratingId);

    final ratingSumSnapshot = await ratingRef.get();

    if (ratingSumSnapshot.exists) {
      final dynamic snapshot = await ratingRef.once();

      int readRatingsSum = snapshot.snapshot.value['ratings_sum'];
      int readRatingsCount = snapshot.snapshot.value['ratings_count'];

      print('$readRatingsSum, $readRatingsCount');

      int newRatingsSum = readRatingsSum + rating.toInt();

      double newAvgRating = (newRatingsSum / ++readRatingsCount);

      await ratingRef.update({'ratings_sum': newRatingsSum});
      await ratingRef.update({'ratings_count': readRatingsCount++});
      await ratingRef.update({'avg_rating': newAvgRating});
    } else {
      await ratingRef.update({'ratings_sum': rating});
      await ratingRef.update({'ratings_count': 1});
      await ratingRef.update({'avg_rating': rating});
    }
  }
}
