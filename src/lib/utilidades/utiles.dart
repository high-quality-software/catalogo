// ignore_for_file: prefer_final_fields

import 'dart:convert';
// import 'dart:typed_data';
import 'package:catalog_app/modelos/Base/iaxmodelbase.dart';
import 'package:catalog_app/modelos/fuente_pdf.dart';
import 'package:catalog_app/utilidades/utiles_files.dart';
import 'package:catalog_app/utilidades/utiles_http.dart';
// import 'package:catalog_app/utilidades/valores_generales.dart';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:darq/darq.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:path/path.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:reflectable/reflectable.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart' as w;
import 'reflection.dart';
import 'dart:io';
import 'package:function_tree/function_tree.dart';

// import './Genericos/navigator_key.dart';
// class CsvDetector extends CsvSettingsDetector {

// const CsvDetector();

extension FileExtension on FileSystemEntity {
  String get name {
    return path.split("/").last;
  }

  String get nameWithoutExtension {
    return name.split(".").first;
  }

  String get extension {
    String str = "";
    var s = name.split(".");
    for (int i = 1; i < s.length - 1; i++) {
      if (str.isNotEmpty) {
        str = ".";
      }
      str = s[i];
    }
    return str;
  }
}
//@GlobalQuantifyCapability(r'\.IAxModelBase$', reflectableEntity)
//@GlobalQuantifyCapability(r'\.enum$', reflectableEntity)
//@GlobalQuantifyCapability(r'\.Cliente$', reflectableEntity)
// import 'package:class_to_map/class_to_map.dart';

abstract class Activator {
  static T createInstance<T>() {
    ClassMirror classMirror = reflectableEntity.reflectType(T) as ClassMirror;
    var instance = classMirror.newInstance("", []);
    return instance as T;
  }
}

abstract class Constantes {
  static String strEmptyImageBase64 =
      "R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7";

  static Image? _blankImage;

  static Uint8List getEmptyImageData() {
    return const Base64Codec().decode(strEmptyImageBase64);
  }

  static Image getEmptyImage() {
    if (_blankImage != null) {
      return _blankImage as Image;
    }

    _blankImage = Image.memory(
      getEmptyImageData(),
      height: 1,
    );
    return _blankImage as Image;
  }
}

abstract class Utiles {
  static void cerrarSistema() {
    if (Platform.isIOS) {
      try {
        exit(0);
      } catch (e) {
        SystemNavigator
            .pop(); // for IOS, not true this, you can make comment this :)
      }
    } else if (Platform.isWindows) {
      try {
        exit(0);
      } catch (e) {
        SystemNavigator.pop();
      }
    } else {
      try {
        SystemNavigator.pop(); // sometimes it cant exit app
      } catch (e) {
        exit(0); // so i am giving crash to app ... sad :(
      }
    }
  }

  static Future<Color?> colorPickerDialog(
      BuildContext context, Color dialogPickerColor) async {
    // ignore: no_leading_underscores_for_local_identifiers
    Color _currentColor = dialogPickerColor;

    var ok = await ColorPicker(
      color: dialogPickerColor,
      onColorChanged: (Color color) => _currentColor = color,
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      //customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
    if (ok) {
      return _currentColor;
    } else {
      return null;
    }
  }

  static Future<Directory?> seleccionarCarpeta(
      String title, Directory? selectedDirectory) async {
    Directory? directory = selectedDirectory;
    directory ??= Directory.current;

    var result = await FilePicker.platform.getDirectoryPath(
        dialogTitle: title,
        initialDirectory: selectedDirectory!.path,
        lockParentWindow: true);

    Directory? newDirectory;
    if (result != null) {
      newDirectory = Directory(result);
    }

    return newDirectory;
  }

  static Future<List<pw.Font>> obtenerFuentesTTF(String folder) async {
    var lst = await getFilesFontTTF(folder);

    return lst.getFonts();
  }

  // ignore: non_constant_identifier_names
  static Future<List<FuentePdf>> obtenerFuentesTTF_paraPDF(
      String folder) async {
    var lst = await getFilesFontTTF(folder);

    return lst.getFontsPdf();
  }

  static Future<List<FileSystemEntity>> getFilesFontTTF(String folder) async {
    var dir = Directory(folder);
    if (!await dir.exists()) {
      return <FileSystemEntity>[];
    }
    RegExp regExp = RegExp(".(ttf)", caseSensitive: false);
    return getFiles(dir, regExp, true);
  }

  static Future<List<FileSystemEntity>> getFiles(
      Directory dir, RegExp regExp, bool requiereSubdir) async {
    try {
      var lst = await dir.list().toList();
      if (requiereSubdir) {
        List<FileSystemEntity> files = <FileSystemEntity>[];

        for (var item in lst) {
          var s = await item.stat();
          if (s.type == FileSystemEntityType.file &&
              regExp.hasMatch(item.name) == true) {
            files.add(item);
          } else if (s.type == FileSystemEntityType.directory) {
            var d1 = Directory(item.path);
            if (await d1.exists()) {
              var tmp = await getFiles(dir, regExp, requiereSubdir);
              if (tmp.isNotEmpty) {
                files.addAll(tmp);
              }
            }
          }
        }
        return files;
      } else {
        return lst
            .where((element) => regExp.hasMatch(element.name) == true)
            .toList();
      }
    } catch (e) {
      rethrow;
    }
  }

  static List<T> convertTo<T>(String csv) {
    List<T> lst = <T>[];
    if (csv.isNotEmpty) {
      // bool allowInvalid = true;
      //var detector = CsvSettingsDetector().detectFromString(csv);
      var converter = CsvToMapConverter(
          // allowInvalid: allowInvalid,
          // csvSettingsDetector: detector,
          // fieldDelimiter: settings.fieldDelimiter ?? defaultFieldDelimiter,
          // textDelimiter: settings.textDelimiter ?? defaultTextDelimiter,
          // textEndDelimiter: settings.textEndDelimiter,
          // eol: settings.eol ?? defaultEol
          );

      var salida = converter.convert(csv
          // ,
          // settings.fieldDelimiter ?? defaultFieldDelimiter,
          // settings.textDelimiter ?? defaultTextDelimiter,
          // settings.textEndDelimiter ?? defaultTextDelimiter,
          // allowInvalid,
          // detector
          );

      for (var element in salida) {
        var t = element.toClass<T>();

        lst.add(t);
      }
    }

    return lst;
  }
}

class DownloadFontGoogleResult {
  List<String>? _files;
  List<String>? get files => _files;
  bool _ok;
  bool get ok => _ok;
  String _zipFile;
  String get zipFile => _zipFile;

  DownloadFontGoogleResult(this._files, this._ok, this._zipFile);
}

abstract class ConstantesPrecio {
  static String get precioLista => "@precioLista";
  static String get unidadesPack => "@unidadesPack";
  static String get alicuotaIva => "@alicuotaIva";
  static String get impuestoInterno => "@impuestoInterno";
  static String get bonificacionImporte => "@bonificacionImporte";
  static String get bonificacionPorcentaje => "@bonificacionPorcentaje";
}

class ResultadoCalculoMatematico {
  double _valor;
  double get valor => _valor;
  String _calculoSinInterpretar;
  String get calculoSinInterpretar => _calculoSinInterpretar;
  String _calculo;
  String get calculo => _calculo;
  String _error;
  String get error => _error;
  ResultadoCalculoMatematico(
      this._valor, this._calculo, this._calculoSinInterpretar, this._error);
}

extension StringExtension on String {
  ResultadoCalculoMatematico calcularPrecio(
      {required double precioLista,
      double unidadesPack = 1,
      double alicuotaIva = 21.0,
      double impuestoInterno = 0.0,
      double bonificacionImporte = 0.0,
      double bonificacionPorcentaje = 0.0}) {
    if (unidadesPack == 0) {
      unidadesPack = 1;
    }

    var calculoStringSalida =
        // ignore: unnecessary_this
        this
            .replaceAll(ConstantesPrecio.precioLista, precioLista.toString())
            .replaceAll(ConstantesPrecio.alicuotaIva, alicuotaIva.toString())
            .replaceAll(ConstantesPrecio.bonificacionImporte,
                bonificacionImporte.toString())
            .replaceAll(ConstantesPrecio.bonificacionPorcentaje,
                bonificacionPorcentaje.toString())
            .replaceAll(
                ConstantesPrecio.impuestoInterno, impuestoInterno.toString())
            .replaceAll(ConstantesPrecio.unidadesPack, unidadesPack.toString());
    try {
      double valor = precioLista;
      String error = "";
      if (calculoStringSalida.isNotEmpty) {
        var result = calculoStringSalida.interpret();
        if (result.isNaN) {
          error = "El resultado no es un número válido.";
        }
        if (result.isInfinite) {
          error = "El resultado es un número infinito.";
        }
        if (result.isNegative) {
          error = "El resultado es un número negativo.";
        }
        try {
          valor = result.toDouble();
        } catch (e1) {
          error =
              "Error al convertir el resultado a un número.\n$e1";
        }
      }
      return ResultadoCalculoMatematico(
          valor, calculoStringSalida, this, error);
    } catch (e) {
      return ResultadoCalculoMatematico(double.nan, calculoStringSalida, this,
          "Cálculo matemático no válido.\n$e");
    }
  }
}

extension FontPickerExtension on PickerFont {
  Future<DownloadFontGoogleResult> descargarFuenteDesdeGoogle(
      String folder) async {
    String url = "https://fonts.google.com/download?family=$fontFamily";
    String folderLocal = folder;
    //UtilesFiles.crearCarpetaLocal(ValoresGenerales.nameFolderFuentes);
    List<String>? lst = <String>[];
    String filename = "$fontFamily.zip";
    if (folderLocal.isNotEmpty) {
      var fTmp = File(folderLocal + Platform.pathSeparator + filename);
      if (await fTmp.exists()) {
        lst = await UtilesFiles.descomprimirZip(fTmp.path, folderLocal);
      } else {
        var result = await UtilesHttp.downloadFile(
            url: url, filename: filename, folder: folderLocal);

        if (result != null && await result.exists()) {
          lst = await UtilesFiles.descomprimirZip(result.path, folderLocal);

          //UtilesFiles.borrarArchivo(result.path);
        }
      }
    }
    return DownloadFontGoogleResult(lst, (lst != null && lst.isNotEmpty),
        folderLocal + Platform.pathSeparator + filename);
  }
}

extension Fuente on FileSystemEntity {
  pw.Font getPdfFont(String name, pw.Font defaultFont) {
    var font = defaultFont;
    try {
      if (name.isNotEmpty) {
        var f = File(path);
        if (f.existsSync()) {
          var data = f.readAsBytesSync();
          if (data.isNotEmpty) {
            var bData = ByteData.view(data.buffer);
            var font2 = pw.Font.ttf(bData);
            font = font2;
          }
        }
      }
    } catch (e) {
      font = defaultFont;
    }

    return font;
  }
}

extension Fuentes on List<FileSystemEntity> {
  Future<List<FuentePdf>> getFontsPdf() async {
    List<FuentePdf> fonts = <FuentePdf>[];

    for (var element in this) {
      try {
        var f = File(element.path);
        if (f.existsSync()) {
          var data = f.readAsBytesSync();
          if (data.isNotEmpty) {
            var bData = ByteData.view(data.buffer);
            var font2 = pw.Font.ttf(bData);
            var nombre = basenameWithoutExtension(element.path);
            fonts.add(FuentePdf(nombre: nombre, fuente: font2, file: element));
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    return fonts;
  }

  // ignore: non_constant_identifier_names
  Future<List<pw.Font>> getFonts() async {
    List<pw.Font> fonts = <pw.Font>[];

    for (var element in this) {
      try {
        var f = File(element.path);
        if (f.existsSync()) {
          var data = f.readAsBytesSync();
          if (data.isNotEmpty) {
            var bData = ByteData.view(data.buffer);
            var font2 = pw.Font.ttf(bData);
            fonts.add(font2);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    return fonts;
  }

  pw.Font getFont(String name, pw.Font defaultFont) {
    var font = defaultFont;
    try {
      if (name.isNotEmpty) {
        var fEnt = firstWhereOrDefault((value) {
          String nombreArchivo = basenameWithoutExtension(value.path);
          if (nombreArchivo.toLowerCase() == name.toLowerCase()) {
            return true;
          } else {
            return false;
          }
        }, defaultValue: null);

        if (fEnt != null) {
          var f = File(fEnt.path);
          if (f.existsSync()) {
            var data = f.readAsBytesSync();
            if (data.isNotEmpty) {
              var bData = ByteData.view(data.buffer);
              var font2 = pw.Font.ttf(bData);
              font = font2;
            }
          }
        }
      }
    } catch (e) {
      font = defaultFont;
    }

    return font;
  }
}

extension IAxModel on IAxModelBase {
  dynamic getValueFromProperty<T>(String propertyName) {
    ClassMirror classMirror = reflectableEntity.reflectType(T) as ClassMirror;
    InstanceMirror instanceMirror = reflectableEntity.reflect(this);

    var key2 = "";
    for (var l in classMirror.declarations.entries) {
      if (l.key.toLowerCase() == propertyName.toLowerCase()) {
        key2 = l.key;
        break;
      }
    }

    var dec = classMirror.declarations[key2];
    if (dec != null) {
      var varM = dec as VariableMirror;
      return instanceMirror.invokeGetter(varM.simpleName);
    }
    return null;
  }
}

extension MapToClass on Map<String, dynamic> {
  T toClass<T>() {
    ClassMirror classMirror = reflectableEntity.reflectType(T) as ClassMirror;
    var instance = classMirror.newInstance("", []);
    InstanceMirror instanceMirror = reflectableEntity.reflect(instance);
    // ignore: unnecessary_this
    this.forEach((key, value) {
      var value2 = value as Object;
      var key2 = "";
      for (var l in classMirror.declarations.entries) {
        if (l.key.toLowerCase() == key.toLowerCase()) {
          key2 = l.key;
          break;
        }
      }

      var dec = classMirror.declarations[key2];
      if (dec != null) {
        var varM = dec as VariableMirror;
        var tipo = varM.dynamicReflectedType;
        switch (tipo) {
          case double:
            {
              double? d = double.tryParse(value as String);
              d ??= 0;
              // ignore: unnecessary_cast
              value2 = d as double;
              break;
            }
          case int:
            {
              int? i = int.tryParse(value as String);
              i ??= 0;
              // ignore: unnecessary_cast
              value2 = i as int;
              break;
            }
          case DateTime:
            {
              DateTime? dt = DateTime.tryParse(value as String);
              dt ??= DateTime(1900);
              // ignore: unnecessary_cast
              value2 = dt as DateTime;
              //DateTime.parse(value as String);
              break;
            }
          case bool:
            {
              bool b = false;
              String str = value as String;
              str = str.trim().toLowerCase();
              if (str == "1" ||
                  str == "true" ||
                  str == "s" ||
                  str == "si" ||
                  str == "sí") {
                b = true;
              }

              value2 = b;
              break;
            }
          case String:
            {
              value2 = value as String;
              break;
            }
          default:
            {
              if (kDebugMode) {
                print("Key: $key, Tipo de Dato: $tipo");
              }
              break;
            }
        }
        instanceMirror.invokeSetter(varM.simpleName, value2);
      } else {
        if (kDebugMode) {
          print("$key es Nulo");
        }
      }
    });

    return instance as T;
  }
}

class CsvToMapConverter {
  // late CsvToListConverter _converter;
  // CsvToMapConverter(
  //     {String fieldDelimiter = defaultFieldDelimiter,
  //     String textDelimiter = defaultTextDelimiter,
  //     String? textEndDelimiter,
  //     String eol = defaultEol,
  //     CsvSettingsDetector? csvSettingsDetector,
  //     bool? shouldParseNumbers,
  //     bool? allowInvalid}) {
  //   _converter = CsvToListConverter(
  //       fieldDelimiter: fieldDelimiter,
  //       textDelimiter: textDelimiter,
  //       textEndDelimiter: textEndDelimiter,
  //       eol: eol,
  //       csvSettingsDetector: csvSettingsDetector,
  //       shouldParseNumbers: shouldParseNumbers,
  //       allowInvalid: allowInvalid);
  // }
  List<Map<String, dynamic>> convert(String csv) {
    // ignore: prefer_const_constructors
    var detector = FirstOccurrenceSettingsDetector(
        fieldDelimiters: <String>[",", ";"],
        textDelimiters: <String>["\"", " ", "'", ""],
        textEndDelimiters: <String>["\"", " ", "'", ""],
        eols: <String>["\r\n", "\n"]);

    var settings = detector.detectFromString(csv);
    String? defaultDelimited = "\"";

    // ignore: prefer_const_constructors
    List<List<dynamic>> list = CsvToListConverter()
        . //_converter.
        convert(csv,
            csvSettingsDetector: detector,
            fieldDelimiter: settings.fieldDelimiter ?? defaultFieldDelimiter,
            textDelimiter: settings.textDelimiter == null ||
                    settings.textDelimiter!.isEmpty == true
                ? defaultDelimited
                : settings.textDelimiter,
            // textEndDelimiter: settings.textEndDelimiter == null ||
            //         settings.textEndDelimiter!.isEmpty
            //     ? defaultDelimited
            //     : settings.textEndDelimiter,
            eol: settings.eol ?? defaultEol,
            allowInvalid: false);
    List legend = list[0];
    List<Map<String, dynamic>> maps = [];
    list.sublist(1).forEach((List l) {
      Map<String, dynamic> map = {};
      for (int i = 0; i < legend.length; i++) {
        if (l.length > i) {
          map.putIfAbsent('${legend[i]}', () => l[i]);
        }
      }
      maps.add(map);
    });
    return maps;
  }
}
