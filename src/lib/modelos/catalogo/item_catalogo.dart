import 'dart:typed_data';

// import 'package:catalog_app/modelos/configuracion_catalogo.dart';
import 'package:flutter/material.dart';

class ItemCatalogo {
  String codigoArticulo = "";
  //bool muestraCodigoArticulo = true;
  double precio = 0;
  double precioPromocional = 0;
  //bool muestraPrecio = true;
  Image? imagen;
  Uint8List? imagenData;
  String descripcionArticulo = "";
  //bool muestraDescripcionArticulo = true;
  bool esPromo = false;
  bool esNuevo = false;
}

class DescuentoItem {
  final String codArticulo;
  final double valor;
  // final eTipoDescuento tipoDescuento;

  DescuentoItem({
    required this.codArticulo,
    required this.valor,
    // required this.tipoDescuento
  }) : super();
}
