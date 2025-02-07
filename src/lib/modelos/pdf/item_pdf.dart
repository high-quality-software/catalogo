import '../catalogo/item_catalogo.dart';

abstract class ItemPdfBase {
  int id = 0;
  int idParent = 0;
  String nombre = "";
}

class GrupoPdf implements ItemPdfBase {
  @override
  int id;

  int nivelGrupo = -1;

  @override
  int idParent;

  @override
  String nombre;

  int countItems = 0;

  GrupoPdf({required this.id, required this.idParent, required this.nombre})
      : super();
}

class FinGrupoPdf implements ItemPdfBase {
  @override
  int id;

  @override
  int idParent;

  @override
  String nombre;

  FinGrupoPdf({required this.id, required this.idParent, required this.nombre})
      : super();
}

class ItemPdf implements ItemPdfBase {
  @override
  int id;

  @override
  int idParent;

  @override
  String nombre;

  ItemCatalogo item;

  ItemPdf(
      {required this.id,
      required this.idParent,
      required this.nombre,
      required this.item})
      : super();
}
