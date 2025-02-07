import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  String _activeTitle = "";
  bool _isOpen = false;

  String get activeTitle => _activeTitle;

  bool get isOpen => _isOpen;

  void closeLoading() {
    _isOpen = false;
    _activeTitle = "";

    notifyListeners();
  }

  void openLoading(String title) {
    _isOpen = true;
    _activeTitle = title.isNotEmpty ? title : "";

    notifyListeners();
  }
}
