import 'package:flutter/material.dart';

class IndicatorProvider extends ChangeNotifier {
  int _current = 0;

  int get current => _current;

  void initializeIndicator() {
    _current = 0;
    notifyListeners();
  }

  void updateIndicator(int newIndex) {
    _current = newIndex;
    notifyListeners();
  }
}
