// import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:catalog_app/modelos/Base/iaxmodelbase.dart';
import 'package:catalog_app/modelos/articulo.dart';
import 'package:catalog_app/modelos/imagen.dart';
import 'package:catalog_app/utilidades/utiles.dart';
import 'package:flutter/material.dart';
import 'package:darq/darq.dart';
import 'package:path/path.dart';

// import 'package:csv/csv.dart';
// import 'package:flutter/foundation.dart';

class Importador {
  late Image _blankImage;

  Importador() {
    _blankImage = Constantes.getEmptyImage();
  }

  Future<List<Imagen>> importarImagenes(
      String folder, List<Articulo> articulos) async {
    var dir = Directory(folder);
    if (!await dir.exists()) {
      return <Imagen>[];
    }
    RegExp regExp =
        RegExp(".(gif|jpg|jpeg|tiff|png|webp|bmp)", caseSensitive: false);
    var files = await Utiles.getFiles(dir, regExp, true);
    List<Imagen> lista = <Imagen>[];

    for (var item in files) {
      String nombreArchivo = basenameWithoutExtension(item.path);

      Articulo? articulo = articulos.firstWhereOrDefault((value) =>
          value.codigo.toString().trim().toLowerCase() ==
          nombreArchivo.trim().toLowerCase());

      if (articulo != null) {
        File f = File(item.path);
        Imagen img = Imagen();
        img.nombre = nombreArchivo;
        img.path = item.path;

        if (await f.exists()) {
          var datos = await f.readAsBytes();
          img.imagen = Image.memory(datos);
          img.imagenData = datos;
        } else {
          img.imagen = _blankImage;
          img.imagenData = Constantes.getEmptyImageData();
        }
        lista.add(img);
      }
    }
    return lista;
  }

  Future<List<FileSystemEntity>> importarFuentes(String folder) async {
    // var dir = Directory(folder);
    // if (!await dir.exists()) {
    //   return <FileSystemEntity>[];
    // }
    // RegExp regExp = RegExp(".(ttf)", caseSensitive: false);
    // return Utiles.getFiles(dir, regExp);
    return Utiles.getFilesFontTTF(folder);
  }

  // Future<List<FileSystemEntity>> _fetchFiles(
  //     Directory dir, RegExp regExp) async {
  //   try {
  //     var lst = await dir.list().toList();
  //     return lst
  //         .where((element) => regExp.hasMatch(element.name) == true)
  //         .toList();
  //   } catch (e) {
  //     rethrow;
  //   }

  //   // List<FileSystemEntity> listFiles = [];
  //   // await dir.list().forEach((element) {
  //   //   RegExp regExp =
  //   //       // ignore: unnecessary_string_escapes
  //   //       RegExp("\.(gif|jpg|jpeg|tiff|png|webp|bmp)", caseSensitive: false);
  //   //   // debugPrint('dir contains: $element is image? ${regExp.hasMatch('$element')}');
  //   //   // Only add in List if file in path is supported
  //   //   if (regExp.hasMatch('$element')) {
  //   //     listFiles.add(element);
  //   //   }
  //   // });
  //   // return listFiles;
  // }

  Future<List<T>> importarCsv<T>(String folder) async {
    var instanceOfType = Activator.createInstance<T>();
    if (instanceOfType is IAxModelBase) {
      var tipo = instanceOfType;

      String filePath = folder + Platform.pathSeparator + tipo.getFileName();
      if (File(filePath).existsSync() != true) {
        var dir = p.dirname(filePath);
        var d = Directory(dir);
        var lst = d.listSync();
        var item = lst.firstWhereOrDefault(
            (element) => element.path.toLowerCase() == filePath.toLowerCase(),
            defaultValue: null);
        filePath = item != null ? item.path : "";
      }
      if (await File(filePath).exists()) {
        return await _openFile(filePath);
      } else {
        return List<T>.empty();
      }
    } else {
      return List<T>.empty();
    }
  }

  Future<List<T>> _openFile<T>(filepath) async {
    File f = File(filepath);

    if (!await f.exists()) {
      return <T>[];
    }

    final datos = await f.readAsBytes();

    final rawData = String.fromCharCodes(datos);

    // var fields =
    //     const CsvToListConverter(shouldParseNumbers: false).convert(_rawData);
    List<T> items = <T>[];
    try {
      items = Utiles.convertTo(rawData);
    } catch (e) {
      throw Exception("El formato del archivo ({filepath}) no es válido.\nDescripción del error: $e");
    }

    // if (kDebugMode) {
    //   print(fields);
    // }
    return items;
  }
}
