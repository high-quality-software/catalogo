import 'package:catalog_app/modelos/configuracion_catalogo.dart';
import 'package:catalog_app/modelos/configuracion_fuentes.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfiguracionProvider extends ChangeNotifier {
  //static String simpletradedb = 'simpletrade.db';
  static int keyConfiguracionCatalogo = 1;
  static int keyConfiguracionFuentes = 1;
  static String boxnameConfiguracionCatalogo = "configuracion_catalogo.db";
  static String boxnameConfiguracionFuentes = "configuracion_fuentes.db";

  static ConfiguracionFuentes _configuracionFuentes = ConfiguracionFuentes();
  static late Box<ConfiguracionFuentes> _boxConfiguracionFuentes;
  static ConfiguracionCatalogo _configuracionCatalogo = ConfiguracionCatalogo();
  static late Box<ConfiguracionCatalogo> _boxConfiguracionCatalogo;

  ConfiguracionCatalogo get configuracionCatalogo => _configuracionCatalogo;
  ConfiguracionFuentes get configuracionFuentes => _configuracionFuentes;

  // ConfiguracionProvider() {
  //   _cargarConfiguraciones();
  // }

  static Future inicializarConfiguraciones() async {
    //await Hive.openBox(simpletradedb);
    try {
      var box = await Hive.openBox<ConfiguracionCatalogo>(
          boxnameConfiguracionCatalogo);

      _boxConfiguracionCatalogo = box;
    } catch (e) {
      if (await Hive.boxExists(boxnameConfiguracionCatalogo)) {
        await Hive.deleteBoxFromDisk(boxnameConfiguracionCatalogo);

        var box = await Hive.openBox<ConfiguracionCatalogo>(
            boxnameConfiguracionCatalogo);

        _boxConfiguracionCatalogo = box;
      }
    }
    await _cargarConfiguracionGuardada();

    await _initConfiguracionFuentes();
  }

  static Future<void> _cargarConfiguracionGuardada() async {
    var cfg = _boxConfiguracionCatalogo.get(keyConfiguracionCatalogo);

    if (cfg == null) {
      var nCfg = ConfiguracionCatalogo();
      await _boxConfiguracionCatalogo.put(keyConfiguracionCatalogo, nCfg);
      cfg = _boxConfiguracionCatalogo.get(keyConfiguracionCatalogo);
    }

    if (cfg != null) {
      _configuracionCatalogo = cfg;
    } else {
      _configuracionCatalogo = ConfiguracionCatalogo();
    }
  }

  static Future<void> _initConfiguracionFuentes() async {
    try {
      var box =
          await Hive.openBox<ConfiguracionFuentes>(boxnameConfiguracionFuentes);

      _boxConfiguracionFuentes = box;
    } catch (e) {
      if (await Hive.boxExists(boxnameConfiguracionFuentes)) {
        await Hive.deleteBoxFromDisk(boxnameConfiguracionFuentes);

        var box = await Hive.openBox<ConfiguracionFuentes>(
            boxnameConfiguracionFuentes);

        _boxConfiguracionFuentes = box;
      }
    }

    var cfg = _boxConfiguracionFuentes.get(keyConfiguracionFuentes);

    if (cfg == null) {
      var nCfg = ConfiguracionFuentes();
      await _boxConfiguracionFuentes.put(keyConfiguracionFuentes, nCfg);
      cfg = _boxConfiguracionFuentes.get(keyConfiguracionFuentes);
    }

    if (cfg != null) {
      _configuracionFuentes = cfg;
    } else {
      _configuracionFuentes = ConfiguracionFuentes();
    }
  }

  // Future _cargarConfiguraciones() async {
  //   _boxConfiguracionCatalogo =
  //       await Hive.openBox<ConfiguracionCatalogo>('configuracion_catalogo');

  //   var cfg = _boxConfiguracionCatalogo.get(keyConfiguracionCatalogo);

  //   if (cfg == null) {
  //     var nCfg = ConfiguracionCatalogo();
  //     await _boxConfiguracionCatalogo.put(1, nCfg);
  //     cfg = _boxConfiguracionCatalogo.get(1);
  //   }

  //   if (cfg != null) {
  //     _configuracionCatalogo = cfg;
  //   } else {
  //     _configuracionCatalogo = ConfiguracionCatalogo();
  //   }
  //   notifyListeners();
  // }
  Future<void> cargarConfiguracionGuardada() async {
    await _cargarConfiguracionGuardada();
  }

  Future<bool> guardarConfiguracion(ConfiguracionCatalogo cfg) async {
    await _boxConfiguracionCatalogo.put(keyConfiguracionCatalogo, cfg);
    try {
      _configuracionCatalogo = cfg;
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  Future<bool> guardarConfiguracionFuentes(ConfiguracionFuentes cfg) async {
    await _boxConfiguracionFuentes.put(keyConfiguracionFuentes, cfg);
    try {
      _configuracionFuentes = cfg;
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }
  // @override
  // void dispose() {
  //   _boxConfiguracionCatalogo.close().whenComplete(() => super.dispose());
  // }
}
