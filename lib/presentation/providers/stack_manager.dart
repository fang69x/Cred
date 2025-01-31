// stack_manager.dart
import 'package:flutter/material.dart';

class StackManager extends ChangeNotifier {
  int? _expandedIndex;

  int? get expandedIndex => _expandedIndex;

  void toggleExpanded(int index) {
    if (_expandedIndex == index) {
      _expandedIndex = null; // Collapse if already expanded
    } else {
      _expandedIndex = index; // Expand new index
    }
    notifyListeners();
  }
}
