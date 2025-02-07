import 'package:catalog_app/modelos/catalogo/item_catalogo.dart';

abstract class GrupoCatalogoBase {
  String nombreGrupo = "";
}

class GrupoItemsCatalogo implements GrupoCatalogoBase {
  List<ItemCatalogo> items = <ItemCatalogo>[];

  @override
  late String nombreGrupo;
}

class GrupoCatalogo implements GrupoCatalogoBase {
  List<GrupoItemsCatalogo> grupos = <GrupoItemsCatalogo>[];
  //List<GrupoItemsCatalogo> items = <GrupoItemsCatalogo>[];

  @override
  late String nombreGrupo;
}

class GranGrupoCatalogo implements GrupoCatalogoBase {
  List<GrupoCatalogo> grupos = <GrupoCatalogo>[];
  List<GrupoItemsCatalogo> items = <GrupoItemsCatalogo>[];

  @override
  late String nombreGrupo;
}

// class GranGrupoCatalogo implements GrupoCatalogoBase {
//   List<GruposCatalogo> grupos = <GruposCatalogo>[];
//   List<GrupoItemsCatalogo> gruposItems = <GrupoItemsCatalogo>[];

//   @override
//   late String nombreGrupo;
// }
