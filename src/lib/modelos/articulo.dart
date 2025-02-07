import 'package:catalog_app/utilidades/utiles.dart';
import 'package:darq/darq.dart';
import '../utilidades/reflection.dart';
import 'Base/iaxmodelbase.dart';
//import 'package:catalog_app/utilidades/utiles.dart';

@reflectableEntity
class Articulo implements IAxModelBase {
  @override
  String getFileName() => "Articulos.csv";

  String codigo = "";

  String descripcion = "";

  double lista1 = 0;
  double lista2 = 0;
  double lista3 = 0;
  double lista4 = 0;
  double lista5 = 0;
  double lista6 = 0;
  double lista7 = 0;
  double lista8 = 0;
  double lista9 = 0;
  double lista10 = 0;
  double lista11 = 0;
  double lista12 = 0;
  double lista13 = 0;
  double lista14 = 0;
  double lista15 = 0;
  double lista16 = 0;
  double lista17 = 0;
  double lista18 = 0;
  double lista19 = 0;
  double lista20 = 0;
  double lista21 = 0;
  double lista22 = 0;
  double lista23 = 0;
  double lista24 = 0;
  double lista25 = 0;
  double lista26 = 0;
  double lista27 = 0;
  double lista28 = 0;
  double lista29 = 0;
  double lista30 = 0;
  double lista31 = 0;
  double lista32 = 0;
  double lista33 = 0;
  double lista34 = 0;
  double lista35 = 0;
  double lista36 = 0;
  double lista37 = 0;
  double lista38 = 0;
  double lista39 = 0;
  double lista40 = 0;
  double lista41 = 0;
  double lista42 = 0;
  double lista43 = 0;
  double lista44 = 0;
  double lista45 = 0;
  double lista46 = 0;
  double lista47 = 0;
  double lista48 = 0;
  double lista49 = 0;
  double lista50 = 0;
  double lista51 = 0;
  double lista52 = 0;
  double lista53 = 0;
  double lista54 = 0;
  double lista55 = 0;
  double lista56 = 0;
  double lista57 = 0;
  double lista58 = 0;
  double lista59 = 0;
  double lista60 = 0;
  double lista61 = 0;
  double lista62 = 0;
  double lista63 = 0;
  double lista64 = 0;
  double lista65 = 0;
  double lista66 = 0;
  double lista67 = 0;
  double lista68 = 0;
  double lista69 = 0;
  double lista70 = 0;
  double lista71 = 0;
  double lista72 = 0;
  double lista73 = 0;
  double lista74 = 0;
  double lista75 = 0;
  double lista76 = 0;
  double lista77 = 0;
  double lista78 = 0;
  double lista79 = 0;
  double lista80 = 0;
  double lista81 = 0;
  double lista82 = 0;
  double lista83 = 0;
  double lista84 = 0;
  double lista85 = 0;
  double lista86 = 0;
  double lista87 = 0;
  double lista88 = 0;
  double lista89 = 0;
  double lista90 = 0;
  double lista91 = 0;
  double lista92 = 0;
  double lista93 = 0;
  double lista94 = 0;
  double lista95 = 0;
  double lista96 = 0;
  double lista97 = 0;
  double lista98 = 0;
  double lista99 = 0;
  double lista100 = 0;

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String linea = "";

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String rubro = "";

  double capacidad = 0;
  double pack = 1;
  int unidadesmin = 0;

  double impuestoInt = 0;
  double topeDesc = 0;
  double costo = 0;

  /// <summary>
  /// 15 caracteres
  /// </summary>
  int codigoIva = 0;

  /// <summary>
  /// 13 caracteres
  /// </summary>
  String codbarra = "";

  /// <summary>
  /// 14 caracteres
  /// </summary>
  String codbarraPack = "";

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String marca = "";

  double peso = 0;

  String proveedor = "";
  bool ivaTasaCero = false;

  String categorias = "";

  // ignore: prefer_final_fields
  List<Precio> _precios = <Precio>[];

  static void setearPrecios(Articulo a) {
    for (int i = 1; i <= 100; i++) {
      var p = Precio()
        ..lista = i
        ..valor = a.getValueFromProperty<Articulo>("lista$i");

      a._precios.add(p);
    }
  }

  bool tienePrecio() {
    var p = _precios.firstWhereOrDefault((value) => value.valor > 0);
    if (p != null) {
      return true;
    }
    return false;
  }

  Iterable<int> getListasPrecios() {
    return _precios
        .where((element) => element.valor > 0)
        .select((element, index) => element.lista);
  }
  // bool tienePrecioLista(int lista) {
  //   var p = _precios.firstWhereOrDefault(
  //       (value) => value.valor > 0 && value.lista == lista);
  //   if (p != null) {
  //     return true;
  //   }
  //   return false;
  // }

  double getPrecio(int lista) {
    var p = _precios.firstWhereOrDefault((value) => value.lista == lista);
    if (p != null) {
      return p.valor;
    }
    return 0;
  }
}
