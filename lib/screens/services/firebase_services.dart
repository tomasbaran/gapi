import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:gapi/model/my_globals.dart';
import 'package:gapi/model/review.dart';
import 'package:gapi/model/worker.dart';
import 'package:gapi/notifiers/review.dart';
import 'package:gapi/theme/constants.dart';
import 'package:gapi/theme/style_constants.dart';
import 'package:gapi/widgets/bottom_black_button.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  Future writeReviewToWorkerOnFirebase({
    String? workerId,
    double? rating1,
    double? rating2,
    String? comment,
  }) async {
    DatabaseReference reviewIdRef = await checkIfAmmendedReviewAndGetReviewRef(workerId!);
    print('ammended reviewIdString: ${reviewIdRef}; ammendedReview: $ammendedReview');
    double? newRating1;
    double? newRating2;
    if (ammendedReview != null) {
      print('ammendedReview:');
      if (ammendedReview!) {
        ReviewModel oldReview = await readReviewByUserOnFirebase(workerId: workerId);
        newRating1 = rating1!;
        rating1 = newRating1 - oldReview.rating1!.toDouble();
        // print('updatedRating1: $updatedRating1 = rating1:$rating1 - oldReview.rating1: ${oldReview.rating1}');
        print('updatedRating1: $rating1');
        newRating2 = rating2!;
        rating2 = newRating2 - oldReview.rating2!.toDouble();
        print('updatedRating2: $rating2');
        // print('updatedRating1: $updatedRating2 = rating2:$rating2 - oldReview.rating2: ${oldReview.rating2}');
      }
    }

    if (workerId != null && rating1 != null && rating2 != null) {
      await writeOverallRatings(workerId, rating1, rating2);
      writeRating(workerId, rating1, '1');
      writeRating(workerId, rating2, '2');
      print('commentario: $comment');
      if (comment != null) {
        if (comment != '') {
          if (ammendedReview!) {
            rating1 = newRating1!;
            rating2 = newRating2!;
          }
          double avgRating = (rating1 + rating2) / 2;
          writeCommentToWorkerOnFirebase(
            comment,
            workerId,
            avgRating,
          );
        }
      }
    }
    // else {

    // else if (workerId != null && comment != null && rating1 != null && rating2 != null) {
    //   double avgRating = (rating1 + rating2) / 2;
    //   writeCommentToWorkerOnFirebase(
    //     comment,
    //     workerId,
    //     avgRating,
    //   );
    // }
    // }
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

  Future<ReviewModel> readReviewByUserOnFirebase({required String workerId}) async {
    String uid = auth.currentUser!.uid;

    DataSnapshot workerSnapshot = await usersRef.child(uid).child('reviews').child(workerId).get();

    String reviewId = workerSnapshot.value.toString();

    DataSnapshot reviewSnapshot = await reviewsRef.child(reviewId).get();

    print('workerId: $workerId; reviewSnapshot: ${reviewSnapshot.ref.path}');
    print('$reviewSnapshot ${reviewSnapshot.exists}');

    if (reviewSnapshot.exists) {
      String comment = '';

      String rating1 = reviewSnapshot.children.firstWhere((element) => element.key == 'rating1').value.toString();

      String rating2 = reviewSnapshot.children.firstWhere((element) => element.key == 'rating2').value.toString();
      Map readReview = reviewSnapshot.value as Map<String, dynamic>;
      print('readReview: ${readReview.containsKey('comment')}');
      print('cp0 a: ${reviewSnapshot.value}');
      print('cp0 b: ${reviewSnapshot.children.contains('comment')}');

      //.children.kcontains("comment")}');
      print('cp1: ${reviewSnapshot.children.first.key}');
      if (readReview.containsKey('comment')) {
        comment = readReview.entries.firstWhere((element) => element.key == 'comment').value;
        print('1A: contains comment: $comment');

        comment = reviewSnapshot.children.firstWhere((element) => element.key == 'comment').value.toString();
        print('1B: contains comment: $comment');
      }

      print('---------------------------');
      print('rating1: $rating1');
      print('rating2: $rating2');
      print('comment: $comment');

      return ReviewModel(
        rating1: int.parse(rating1),
        rating2: int.parse(rating2),
        commentText: comment,
      );
    } else {
      print('???????????????? UGH ??????????????????');
      return ReviewModel();
    }
  }

  writeReviewToUserOnFirebase({required workerId, required reviewId}) async {
    print('newReviewToUser: $reviewId');
    DatabaseReference newReviewRef = usersRef.child(auth.currentUser!.uid).child('reviews');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd-HH-mm').format(now);
    print('cp10');

    try {
      // DatabaseReference newUserReviewRew = newReviewRef.push();
      await newReviewRef.update({workerId: reviewId});
    } catch (e) {
      print('error #99: $e');
    }
  }

  bool? ammendedReview;

  Future<DatabaseReference> checkIfAmmendedReviewAndGetReviewRef(String workerId) async {
    String uid = auth.currentUser!.uid;
    DataSnapshot reviewIdSnapshot = await usersRef.child(uid).child('reviews').child(workerId).get();
    String reviewId = reviewIdSnapshot.value.toString();
    print('ammendedReview: $reviewId');
    DatabaseReference newReviewRef;
    if (reviewId == 'null') {
      ammendedReview = false;
      return reviewsRef.push().ref;
    } else {
      ammendedReview = true;
      return reviewsRef.child(reviewId).ref;
    }
  }

  writeReviewToReviewsOnFirebase({
    required String workerId,
    required double rating1,
    required double rating2,
    String? comment,
  }) async {
    DatabaseReference newReviewRef = await checkIfAmmendedReviewAndGetReviewRef(workerId);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    if (comment == null)
      await newReviewRef.set({
        'uid': auth.currentUser!.uid,
        'rating1': rating1,
        'rating2': rating2,
        'worker_id': workerId,
        'date': formattedDate,
      });
    else
      await newReviewRef.set({
        'uid': auth.currentUser!.uid,
        'rating1': rating1,
        'rating2': rating2,
        'worker_id': workerId,
        'comment': comment,
        'date': formattedDate,
      });

    await writeReviewToUserOnFirebase(workerId: workerId, reviewId: newReviewRef.key);
  }

  List<Worker> sortByRanking(DataSnapshot snapshot) {
    List<Worker> unorderedWorkers = [];
    Worker newWorker;

    for (var worker in snapshot.children) {
      print("- snapshot worker: ${worker.child('name').value}: ${worker.child('rating1/avg_rating').value}");
      List<ReviewModel> commentsList = [];
      if (worker.child('comments').exists) {
        print('LLength: ${worker.child('comments').children.length}');

        for (var readComment in worker.child('comments').children) {
          print('comment.value: ${readComment.child('path')}');
          commentsList.add(
            ReviewModel(
              commentText: readComment.child('comment').value.toString(),
              date: DateTime.parse(readComment.key.toString()),
              avgRating: double.parse(readComment.child('avg_rating').value.toString()),
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
    if (newRating < 4 && !ammendedReview!) {
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

      int newRanking = calcRanking(updatedRatingsSum, ammendedReview! ? readRatingsCount : ++readRatingsCount);

      await overallRatingRef.update({'ratings_sum': updatedRatingsSum});
      await overallRatingRef.update({'ratings_count': ammendedReview! ? readRatingsCount : readRatingsCount++});
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

      double newAvgRating = (newRatingsSum / (ammendedReview! ? readRatingsCount : ++readRatingsCount));

      await ratingRef.update({'ratings_sum': newRatingsSum});
      await ratingRef.update({'ratings_count': ammendedReview! ? readRatingsCount : readRatingsCount++});
      await ratingRef.update({'avg_rating': newAvgRating});
    } else {
      await ratingRef.update({'ratings_sum': rating});
      await ratingRef.update({'ratings_count': 1});
      await ratingRef.update({'avg_rating': rating});
    }
  }
}
