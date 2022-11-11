import 'package:gapi/model/review.dart';

class Worker {
  String key;
  Object category;
  Object name;
  Object phoneNumber;
  int? ranking;
  int? ratingsCount;
  int? commentsCount;
  double avg_rating1;
  double? avg_rating2;
  List<ReviewModel> comments;

  Worker({
    required this.key,
    required this.category,
    required this.name,
    required this.phoneNumber,
    this.ranking,
    this.commentsCount,
    this.ratingsCount,
    this.avg_rating1 = 0,
    this.avg_rating2 = 0,
    this.comments = const [],
  });
}
