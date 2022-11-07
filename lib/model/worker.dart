class Worker {
  String key;
  Object category;
  Object name;
  Object phoneNumber;
  int? ranking;
  int? ratingsCount;
  double avg_rating1;
  double? avg_rating2;

  Worker({
    required this.key,
    required this.category,
    required this.name,
    required this.phoneNumber,
    this.ranking,
    this.ratingsCount,
    this.avg_rating1 = 0,
    this.avg_rating2 = 0,
  });
}
