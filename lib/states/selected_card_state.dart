import 'package:flutter/material.dart';

class SelectedCardState with ChangeNotifier {
  int _selectedCard;
  SelectedCardState() {
    _selectedCard = 0;
  }

  int get selCard => _selectedCard;

  void chooseCard(int position) {
    _selectedCard = position;
    notifyListeners();
  }
}
