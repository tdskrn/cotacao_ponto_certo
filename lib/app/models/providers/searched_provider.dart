import 'package:flutter/material.dart';

class Search with ChangeNotifier {
  String _searchedValue = "";

  String get searchedValue => _searchedValue;

  void attValue(String newValue) {
    _searchedValue = newValue;
    notifyListeners();
  }
}
