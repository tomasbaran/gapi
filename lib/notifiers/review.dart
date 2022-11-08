import 'package:flutter/material.dart';

class Review extends ChangeNotifier {
  double tmpRating1 = 0;
  double tmpRating2 = 0;

  changeReview1(double newValue) {
    tmpRating1 = newValue;
    notifyListeners();
  }

  changeReview2(double newValue) {
    tmpRating2 = newValue;
    notifyListeners();
  }
}
