// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import '../utilidades/utiles.dart';

class MenuProvider extends ChangeNotifier {
  int _optionMenu = 0;

  int get activeOptionMenu => _optionMenu;

  void closeOptionMenu() {
    _optionMenu = 0;

    notifyListeners();
  }

  void openOptionMenu(int option) {
    _optionMenu = option;

    notifyListeners();
  }

  void cerrarSistema() {
    Utiles.cerrarSistema();
  }
}
