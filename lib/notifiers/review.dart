import 'package:flutter/material.dart';

class Review extends ChangeNotifier {
  double review1 = 0;
  double review2 = 0;

  changeReview1(double newValue) {
    review1 = newValue;
    notifyListeners();
  }

  changeReview2(double newValue) {
    review2 = newValue;
    notifyListeners();
  }
}
