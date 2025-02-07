import 'package:flutter/widgets.dart';
//import 'package:catalog_app/utilidades/utiles.dart';

//@reflectableEntity
abstract class IAxModelBase {
  @required
  String getFileName();
}

class Precio {
  double valor = 0;
  int lista = 0;
}
