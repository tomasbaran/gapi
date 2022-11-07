class Worker {
  String key;
  Object category;
  Object name;
  Object phoneNumber;
  int? ranking;
  int? ratingsCount;

  Worker({
    required this.key,
    required this.category,
    required this.name,
    required this.phoneNumber,
    this.ranking,
    this.ratingsCount,
  });
}
