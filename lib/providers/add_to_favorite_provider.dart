import 'package:flutter/material.dart';

class AddToFavoriteProvider extends ChangeNotifier {
  bool _addToFav = false;

  bool get addToFav => _addToFav;

  void initializeAddToFav() {
    _addToFav = false;
    notifyListeners();
  }

  void changeAddToFav() {
    _addToFav = !_addToFav;
    notifyListeners();
  }
}
