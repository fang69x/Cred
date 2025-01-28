import 'package:flutter/material.dart';

class ScreenProvider extends ChangeNotifier {
  bool isEMIButtonClicked = false;

  bool getIsEmiClicked() {
    return isEMIButtonClicked;
  }

  void setIsEmiClicked(bool val) {
    isEMIButtonClicked = val;
    notifyListeners();
  }
}
