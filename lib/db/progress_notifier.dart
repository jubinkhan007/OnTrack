import 'package:flutter/material.dart';

class ProgressNotifier extends ChangeNotifier {
  double _progress = 0.0;  // Progress value (0.0 to 1.0)
  int _totalItems = 0;
  int _itemsSaved = 0;

  double get progress => _progress;

  void start(int totalItems) {
    _totalItems = totalItems;
    _itemsSaved = 0;
    _progress = 0.0;
    notifyListeners();
  }

  void updateProgress(int processedItems) {
    _itemsSaved = processedItems;
    _progress = _itemsSaved / _totalItems;
    notifyListeners();
  }

  void complete() {
    _progress = 1.0;
    notifyListeners();
  }
}
