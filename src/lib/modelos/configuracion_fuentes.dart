// import 'dart:typed_data';

import 'package:darq/darq.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 21)
class ConfiguracionFuentes {
  @HiveField(0)
  List<FuenteGoogle> fuentesInstaladas = <FuenteGoogle>[];

  static bool get fuentesActivo => true;
}

class ConfiguracionFuentesAdapter extends TypeAdapter<ConfiguracionFuentes> {
  @override
  final typeId = 21;

  @override
  ConfiguracionFuentes read(BinaryReader reader) {
    var cfg = ConfiguracionFuentes();
    cfg.fuentesInstaladas = <FuenteGoogle>[];
    try {
      cfg.fuentesInstaladas = reader
          .readList()
          .select((element, index) => element as FuenteGoogle)
          .toList();
      // ignore: empty_catches
    } catch (e) {}

    return cfg;
  }

  @override
  void write(BinaryWriter writer, ConfiguracionFuentes obj) {
    writer.writeList(obj.fuentesInstaladas);
  }
}

@HiveType(typeId: 20)
class FuenteGoogle {
  @HiveField(0)
  String fontFamily = "";
  @HiveField(1)
  String category = "";
  @HiveField(2)
  FontStyle fontStyle = FontStyle.normal;
  @HiveField(3)
  FontWeight fontWeight = FontWeight.normal;
  @HiveField(4)
  List<String> files = <String>[];
  @HiveField(5)
  List<String> fontFamilyVariants = <String>[];
  @HiveField(6)
  String zipFile = "";
}

class FuenteGoogleAdapter extends TypeAdapter<FuenteGoogle> {
  @override
  final typeId = 20;

  @override
  FuenteGoogle read(BinaryReader reader) {
    var cfg = FuenteGoogle()
      ..fontFamily = reader.readString()
      ..category = reader.readString();

    var fs = reader.readInt32();
    var fw = reader.readInt32();

    cfg.fontStyle = FontStyle.values.firstWhereOrDefault(
        (value) => value.index == fs,
        defaultValue: FontStyle.normal)!;

    cfg.fontWeight = FontWeight.values.firstWhereOrDefault(
        (value) => value.index == fw,
        defaultValue: FontWeight.normal)!;

    try {
      cfg.files = reader.readStringList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      cfg.fontFamilyVariants = reader.readStringList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      cfg.zipFile = reader.readString();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return cfg;
  }

  @override
  void write(BinaryWriter writer, FuenteGoogle obj) {
    writer.writeString(obj.fontFamily);
    writer.writeString(obj.category);
    writer.writeInt32(obj.fontStyle.index);
    writer.writeInt32(obj.fontWeight.index);
    writer.writeStringList(obj.files);
    writer.writeStringList(obj.fontFamilyVariants);
    writer.writeString(obj.zipFile);
  }
}
