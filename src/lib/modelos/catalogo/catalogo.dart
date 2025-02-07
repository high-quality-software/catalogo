// import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:catalog_app/modelos/catalogo/grupo_item_catalogo.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:darq/darq.dart';

@HiveType(typeId: 5)
// ignore: camel_case_types
enum eModoImagen {
  @HiveField(0, defaultValue: true)
  ninguna,
  @HiveField(1)
  logo,
  @HiveField(2)
  todoElAncho
}

// ignore: camel_case_types
class eModoImagenAdapter extends TypeAdapter<eModoImagen> {
  @override
  final typeId = 5;

  @override
  eModoImagen read(BinaryReader reader) {
    var i = reader.readInt32();
    var e = eModoImagen.values.firstWhereOrDefault((value) => value.index == i,
        defaultValue: eModoImagen.ninguna);

    return e as eModoImagen;
  }

  @override
  void write(BinaryWriter writer, eModoImagen obj) {
    writer.writeInt32(obj.index);
  }
}

@HiveType(typeId: 6)
// ignore: camel_case_types
enum eModoHeaderFooterPagina {
  @HiveField(0, defaultValue: true)
  ninguna,
  @HiveField(1)
  primeraPagina,
  @HiveField(2)
  todasLasPaginas
}

// ignore: camel_case_types
class eModoHeaderFooterPaginaAdapter
    extends TypeAdapter<eModoHeaderFooterPagina> {
  @override
  final typeId = 6;

  @override
  eModoHeaderFooterPagina read(BinaryReader reader) {
    var i = reader.readInt32();
    var e = eModoHeaderFooterPagina.values.firstWhereOrDefault(
        (value) => value.index == i,
        defaultValue: eModoHeaderFooterPagina.ninguna);

    return e as eModoHeaderFooterPagina;
  }

  @override
  void write(BinaryWriter writer, eModoHeaderFooterPagina obj) {
    writer.writeInt32(obj.index);
  }
}

@HiveType(typeId: 7)
// ignore: camel_case_types
enum eTipoFondo {
  @HiveField(0, defaultValue: true)
  ninguno,
  @HiveField(1)
  imagen,
  @HiveField(2)
  degrade
}

// ignore: camel_case_types
class eTipoFondoAdapter extends TypeAdapter<eTipoFondo> {
  @override
  final typeId = 7;

  @override
  eTipoFondo read(BinaryReader reader) {
    var i = reader.readInt32();
    var e = eTipoFondo.values.firstWhereOrDefault((value) => value.index == i,
        defaultValue: eTipoFondo.ninguno);

    return e as eTipoFondo;
  }

  @override
  void write(BinaryWriter writer, eTipoFondo obj) {
    writer.writeInt32(obj.index);
  }
}

@HiveType(typeId: 10)
abstract class HeaderFooterBase {
  @HiveField(0)
  eModoHeaderFooterPagina modoHeaderFooter =
      eModoHeaderFooterPagina.todasLasPaginas;

  @HiveField(1)
  String imagenUrl = "";
  @HiveField(2)
  Uint8List imagenData = Uint8List(0);
  @HiveField(3)
  eModoImagen modoImagen = eModoImagen.ninguna;
  @HiveField(4)
  String texto = "";
  @HiveField(5)
  FontConfig fuente = FontConfig(color: Colors.black, size: 12);
}

@HiveType(typeId: 1)
class Encabezado implements HeaderFooterBase {
  @HiveField(0)
  @override
  eModoHeaderFooterPagina modoHeaderFooter =
      eModoHeaderFooterPagina.todasLasPaginas;

  @HiveField(1)
  @override
  String imagenUrl = "";
  @HiveField(2)
  @override
  Uint8List imagenData = Uint8List(0);
  @HiveField(3)
  @override
  eModoImagen modoImagen = eModoImagen.ninguna;
  @HiveField(4)
  @override
  String texto = "";

  @HiveField(5)
  @override
  FontConfig fuente = FontConfig(color: Colors.black, size: 9, negrita: true);
}

@HiveType(typeId: 2)
class Degrade {
  @HiveField(0, defaultValue: Colors.white)
  late Color color1;
  @HiveField(1, defaultValue: Colors.white)
  late Color color2;

  Degrade({this.color1 = Colors.white, this.color2 = Colors.white});
}

@HiveType(typeId: 15)
class FontConfig {
  @HiveField(0, defaultValue: Colors.grey)
  late Color color = Colors.black;
  @HiveField(1)
  late double size = 10;
  @HiveField(2)
  late bool negrita = false;
  @HiveField(3)
  late String fontFamily = "";
  @HiveField(4)
  late FontStyle fontStyle = FontStyle.normal;
  @HiveField(5)
  late String category = "";
  @HiveField(6)
  late String nameFile = "";
  @HiveField(7)
  late String fontName = "";

  FontConfig(
      {this.color = Colors.black,
      this.size = 10.0,
      this.negrita = false,
      this.fontFamily = "",
      this.fontStyle = FontStyle.normal,
      this.category = "",
      this.nameFile = "",
      this.fontName = ""});
}

@HiveType(typeId: 3)
class Fondo {
  @HiveField(0)
  String imagenUrl = "";
  @HiveField(1)
  Uint8List imagenData = Uint8List(0);
  @HiveField(2)
  eTipoFondo tipoFondo = eTipoFondo.ninguno;
  @HiveField(3)
  Degrade fondoDegrade = Degrade();
}

@HiveType(typeId: 4)
class Pie implements HeaderFooterBase {
  @HiveField(0)
  @override
  eModoHeaderFooterPagina modoHeaderFooter =
      eModoHeaderFooterPagina.todasLasPaginas;

  @HiveField(1)
  @override
  String imagenUrl = "";
  @HiveField(2)
  @override
  Uint8List imagenData = Uint8List(0);
  @HiveField(3)
  @override
  eModoImagen modoImagen = eModoImagen.ninguna;
  @HiveField(4)
  @override
  String texto = "";
  @HiveField(5)
  @override
  FontConfig fuente = FontConfig(color: Colors.black, size: 12);
}

class Catalogo {
  late Fondo fondo;

  String fileName = "";
  late Encabezado encabezado;
  late Pie pie;
  List<GrupoCatalogoBase> grupos = <GrupoCatalogoBase>[];
}

class PieAdapter extends TypeAdapter<Pie> {
  @override
  final typeId = 4;

  @override
  Pie read(BinaryReader reader) {
    return Pie()
      ..modoHeaderFooter = reader.read()
      ..imagenUrl = reader.readString()
      ..imagenData = reader.read()
      ..modoImagen = reader.read()
      ..texto = reader.readString()
      ..fuente = reader.read();
  }

  @override
  void write(BinaryWriter writer, Pie obj) {
    writer.write(obj.modoHeaderFooter);
    writer.writeString(obj.imagenUrl);
    writer.write(obj.imagenData);
    writer.write(obj.modoImagen);
    writer.writeString(obj.texto);
    writer.write(obj.fuente);
  }
}

class FondoAdapter extends TypeAdapter<Fondo> {
  @override
  final typeId = 3;

  @override
  Fondo read(BinaryReader reader) {
    return Fondo()
      ..imagenUrl = reader.readString()
      ..imagenData = reader.read()
      ..tipoFondo = reader.read()
      ..fondoDegrade = reader.read();
  }

  @override
  void write(BinaryWriter writer, Fondo obj) {
    writer.writeString(obj.imagenUrl);
    writer.write(obj.imagenData);
    writer.write(obj.tipoFondo);
    writer.write(obj.fondoDegrade);
  }
}

class FontConfigAdapter extends TypeAdapter<FontConfig> {
  @override
  final typeId = 15;

  @override
  FontConfig read(BinaryReader reader) {
    var i1 = reader.readInt32();
    var i2 = reader.readDouble();
    var negrita = reader.readBool();
    var fuente = reader.readString();
    var iFStyle = reader.readInt32();
    FontStyle? f = FontStyle.values.firstWhereOrDefault(
        (e) => e.index == iFStyle,
        defaultValue: FontStyle.normal);
    var category = reader.readString();
    var nameFile = reader.readString();
    var fontName = reader.readString();

    return FontConfig(
        color: Color(i1),
        size: i2,
        negrita: negrita,
        fontFamily: fuente,
        fontStyle: f ?? FontStyle.normal,
        category: category,
        nameFile: nameFile,
        fontName: fontName);
  }

  @override
  void write(BinaryWriter writer, FontConfig obj) {
    writer.writeInt32(obj.color.value);
    writer.writeDouble(obj.size);
    writer.writeBool(obj.negrita);
    writer.writeString(obj.fontFamily);
    writer.writeInt32(obj.fontStyle.index);
    writer.writeString(obj.category);
    writer.writeString(obj.nameFile);
    writer.writeString(obj.fontName);
  }
}

class DegradeAdapter extends TypeAdapter<Degrade> {
  @override
  final typeId = 2;

  @override
  Degrade read(BinaryReader reader) {
    var i1 = reader.readInt32();
    var i2 = reader.readInt32();

    return Degrade(color1: Color(i1), color2: Color(i2));
  }

  @override
  void write(BinaryWriter writer, Degrade obj) {
    writer.writeInt32(obj.color1.value);
    writer.writeInt32(obj.color2.value);
  }
}

class EncabezadoAdapter extends TypeAdapter<Encabezado> {
  @override
  final typeId = 1;

  @override
  Encabezado read(BinaryReader reader) {
    return Encabezado()
      ..modoHeaderFooter = reader.read()
      ..imagenUrl = reader.readString()
      ..imagenData = reader.read()
      ..modoImagen = reader.read()
      ..texto = reader.readString()
      ..fuente = reader.read();
  }

  @override
  void write(BinaryWriter writer, Encabezado obj) {
    writer.write(obj.modoHeaderFooter);
    writer.writeString(obj.imagenUrl);
    writer.write(obj.imagenData);
    writer.write(obj.modoImagen);
    writer.writeString(obj.texto);
    writer.write(obj.fuente);
  }
}
