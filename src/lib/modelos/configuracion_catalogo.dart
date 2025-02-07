// import 'dart:typed_data';

import 'package:catalog_app/modelos/catalogo/catalogo.dart';
import 'package:darq/darq.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ConfiguracionCatalogoInterno {
  String folderImagenes = "";
  String folderCsv = "";
  String folderSalidaPDF = "";
  Encabezado encabezado = Encabezado();
  Pie pie = Pie();
  Fondo fondo = Fondo();
  ConfiguracionGrupo configuracionGrupo = ConfiguracionGrupo();
  bool mostrarDescripcionArticulo = true;
  bool mostrarAvisoOferta = true;
  bool mostrarPrecioEnChart = false;
  String urlLogoOferta = "";
  Uint8List dataLogoOferta = Uint8List(0);
  eTipoDescuento tipoDescuento = eTipoDescuento.ninguno;
  bool mostrarPrecioOriginalTachado = false;
  bool mostrarChartDeArticulos = true;
  FontConfig fuenteDescripcionArticulo =
      FontConfig(color: Colors.black, size: 6, negrita: true);
  FontConfig fuentePrecioArticulo =
      FontConfig(color: Colors.black, size: 8, negrita: false);

  FontConfig fuenteSkuArticulo =
      FontConfig(color: Colors.black, size: 5, negrita: false);
  String folderFuentes = "";
  String calculoPrecio = "";
  String calculoPrecioBonificado = "";
  String simboloMoneda = "\$";
  double anchoWidgetArticulo = 0;
  double altoWidgetArticulo = 0;
  double porcentajeAltoImagenArticulo = 0;
  DateTime? fechaPrimeraEjecucion;
  int estadoDemo = 0;
}

@HiveType(typeId: 0)
class ConfiguracionCatalogo extends HiveObject {
  @HiveField(0)
  String folderImagenes = "";
  @HiveField(1)
  String folderCsv = "";
  @HiveField(2)
  String folderSalidaPDF = "";
  @HiveField(3)
  Encabezado encabezado = Encabezado();
  @HiveField(4)
  Pie pie = Pie();
  @HiveField(5)
  Fondo fondo = Fondo();
  @HiveField(6)
  ConfiguracionGrupo configuracionGrupo = ConfiguracionGrupo();
  @HiveField(7)
  bool mostrarDescripcionArticulo = true;
  @HiveField(8)
  bool mostrarAvisoOferta = true;
  @HiveField(9)
  bool mostrarPrecioEnChart = false;
  @HiveField(10)
  String urlLogoOferta = "";
  @HiveField(11)
  Uint8List dataLogoOferta = Uint8List(0);
  @HiveField(12)
  eTipoDescuento tipoDescuento = eTipoDescuento.ninguno;
  @HiveField(13)
  bool mostrarPrecioOriginalTachado = false;
  @HiveField(14)
  bool mostrarChartDeArticulos = true;

  @HiveField(15)
  FontConfig fuenteDescripcionArticulo =
      FontConfig(color: Colors.black, size: 6, negrita: true);

  @HiveField(16)
  FontConfig fuentePrecioArticulo =
      FontConfig(color: Colors.black, size: 8, negrita: false);

  @HiveField(17)
  FontConfig fuenteSkuArticulo =
      FontConfig(color: Colors.black, size: 5, negrita: false);
  @HiveField(18)
  String folderFuentes = "";
  @HiveField(19)
  String calculoPrecio = "";
  @HiveField(20)
  String calculoPrecioBonificado = "";
  @HiveField(21, defaultValue: "\$")
  String simboloMoneda = "\$";

  @HiveField(22, defaultValue: 0)
  double anchoWidgetArticulo = 0;
  @HiveField(23, defaultValue: 0)
  double altoWidgetArticulo = 0;
  @HiveField(24, defaultValue: 0)
  double porcentajeAltoImagenArticulo = 0;
  @HiveField(25, defaultValue: null)
  DateTime? fechaPrimeraEjecucion;
  @HiveField(26, defaultValue: 0)
  int estadoDemo = 0;

  // int get encabezadoModo => encabezado.modoEncabezado.index;
  // set encabezadoModo(int value) {}
  ConfiguracionCatalogoInterno getConfiguracionInterna() {
    return ConfiguracionCatalogoInterno()
      ..configuracionGrupo = configuracionGrupo
      ..dataLogoOferta = dataLogoOferta
      ..encabezado = encabezado
      ..folderCsv = folderCsv
      ..folderImagenes = folderImagenes
      ..folderSalidaPDF = folderSalidaPDF
      ..fondo = fondo
      ..mostrarAvisoOferta = mostrarAvisoOferta
      ..mostrarChartDeArticulos = mostrarChartDeArticulos
      ..mostrarDescripcionArticulo = mostrarDescripcionArticulo
      ..mostrarPrecioEnChart = mostrarPrecioEnChart
      ..mostrarPrecioOriginalTachado = mostrarPrecioOriginalTachado
      ..pie = pie
      ..tipoDescuento = tipoDescuento
      ..urlLogoOferta = urlLogoOferta
      ..fuenteDescripcionArticulo = fuenteDescripcionArticulo
      ..fuentePrecioArticulo = fuentePrecioArticulo
      ..fuenteSkuArticulo = fuenteSkuArticulo
      ..folderFuentes = folderFuentes
      ..calculoPrecio = calculoPrecio
      ..calculoPrecioBonificado = calculoPrecioBonificado
      ..simboloMoneda = simboloMoneda
      ..anchoWidgetArticulo = anchoWidgetArticulo
      ..altoWidgetArticulo = altoWidgetArticulo
      ..porcentajeAltoImagenArticulo = porcentajeAltoImagenArticulo
      ..fechaPrimeraEjecucion = fechaPrimeraEjecucion
      ..estadoDemo = estadoDemo;
  }
}

class ConfiguracionCatalogoAdapter extends TypeAdapter<ConfiguracionCatalogo> {
  @override
  final typeId = 0;

  @override
  ConfiguracionCatalogo read(BinaryReader reader) {
    var cfg = ConfiguracionCatalogo()
      ..folderImagenes = reader.readString()
      ..folderCsv = reader.readString()
      ..folderSalidaPDF = reader.readString()
      ..encabezado = reader.read()
      ..pie = reader.read()
      ..fondo = reader.read();

    try {
      cfg.configuracionGrupo = reader.read();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      cfg.mostrarAvisoOferta = reader.readBool();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      cfg.mostrarDescripcionArticulo = reader.readBool();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      cfg.mostrarPrecioEnChart = reader.readBool();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      cfg.urlLogoOferta = reader.readString();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      cfg.dataLogoOferta = reader.readByteList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      cfg.tipoDescuento = reader.read();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      cfg.mostrarPrecioOriginalTachado = reader.readBool();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      cfg.mostrarChartDeArticulos = reader.readBool();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      cfg.fuenteDescripcionArticulo = reader.read();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      cfg.fuentePrecioArticulo = reader.read();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      cfg.fuenteSkuArticulo = reader.read();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      cfg.folderFuentes = reader.readString();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      cfg.calculoPrecio = reader.readString();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      cfg.calculoPrecioBonificado = reader.readString();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      cfg.simboloMoneda = reader.readString();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      cfg.anchoWidgetArticulo = reader.readDouble();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      cfg.altoWidgetArticulo = reader.readDouble();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      cfg.porcentajeAltoImagenArticulo = reader.readDouble();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      var strDT = reader.readString();
      cfg.fechaPrimeraEjecucion = DateTime.tryParse(strDT);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      cfg.estadoDemo = reader.readInt();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return cfg;
  }

  @override
  void write(BinaryWriter writer, ConfiguracionCatalogo obj) {
    writer.writeString(obj.folderImagenes);
    writer.writeString(obj.folderCsv);
    writer.writeString(obj.folderSalidaPDF);
    writer.write(obj.encabezado);
    writer.write(obj.pie);
    writer.write(obj.fondo);
    writer.write(obj.configuracionGrupo);
    writer.writeBool(obj.mostrarAvisoOferta);
    writer.writeBool(obj.mostrarDescripcionArticulo);
    writer.writeBool(obj.mostrarPrecioEnChart);
    writer.writeString(obj.urlLogoOferta);
    writer.writeByteList(obj.dataLogoOferta);
    writer.write(obj.tipoDescuento);
    writer.writeBool(obj.mostrarPrecioOriginalTachado);
    writer.writeBool(obj.mostrarChartDeArticulos);
    writer.write(obj.fuenteDescripcionArticulo);
    writer.write(obj.fuentePrecioArticulo);
    writer.write(obj.fuenteSkuArticulo);
    writer.writeString(obj.folderFuentes);
    writer.writeString(obj.calculoPrecio);
    writer.writeString(obj.calculoPrecioBonificado);
    writer.writeString(obj.simboloMoneda);
    writer.writeDouble(obj.anchoWidgetArticulo);
    writer.writeDouble(obj.altoWidgetArticulo);
    writer.writeDouble(obj.porcentajeAltoImagenArticulo);
    writer.writeString(DateFormat("yyyyMMdd")
        .format(obj.fechaPrimeraEjecucion ?? DateTime.parse("19700101"))
        .toString());
    writer.writeInt(obj.estadoDemo);
  }
}

@HiveType(typeId: 11)
class ConfiguracionGrupo extends HiveObject {
  @HiveField(0)
  List<GrupoOrden> orden = <GrupoOrden>[];
  @HiveField(1)
  bool mostrarCabeceraGrupo = true;
  @HiveField(2)
  bool noAgrupar = false;
  @HiveField(3)
  bool ordenarLosArticulosPorNombre = false;
  @HiveField(4)
  FontConfig fuente = FontConfig(size: 10, negrita: false, color: Colors.black);
}

@HiveType(typeId: 12)
class GrupoOrden extends HiveObject {
  @HiveField(0)
  int orden = 0;
  @HiveField(1)
  String nombre = "";
  @HiveField(2)
  bool activo = true;
  @HiveField(3, defaultValue: eGrupo.marca)
  eGrupo get grupo {
    var sGrupo = nombre
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');
    //if (sGrupo != g.grupo.name) {
    try {
      return eGrupo.values.firstWhereOrDefault((value) => value.name == sGrupo,
          defaultValue: eGrupo.marca) as eGrupo;
    } catch (e) {
      if (kDebugMode) {
        print("Error en GrupoOrdenAdapter: $e");
      }
    }
    return eGrupo.marca;
  }
}

class ConfiguracionGrupoAdapter extends TypeAdapter<ConfiguracionGrupo> {
  @override
  final typeId = 11;

  @override
  ConfiguracionGrupo read(BinaryReader reader) {
    var cfg = ConfiguracionGrupo();

    cfg.orden = <GrupoOrden>[];
    try {
      var lst = reader.readList();
      if (lst.isNotEmpty) {
        for (var i in lst) {
          var item = i as GrupoOrden;
          cfg.orden.add(item);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error en ConfiguracionGrupo:$e");
      }
    }
    cfg.mostrarCabeceraGrupo = reader.readBool();

    cfg.noAgrupar = reader.readBool();

    try {
      cfg.ordenarLosArticulosPorNombre = reader.readBool();
    } catch (e) {
      if (kDebugMode) {
        print("Error en ConfiguracionGrupo:$e");
      }
    }

    try {
      cfg.fuente = reader.read();
    } catch (e) {
      if (kDebugMode) {
        print("Error en ConfiguracionGrupo:$e");
      }
    }
    return cfg;
  }

  @override
  void write(BinaryWriter writer, ConfiguracionGrupo obj) {
    writer.writeList(obj.orden);
    writer.writeBool(obj.mostrarCabeceraGrupo);
    writer.writeBool(obj.noAgrupar);
    writer.writeBool(obj.ordenarLosArticulosPorNombre);
    writer.write(obj.fuente);
  }
}

class GrupoOrdenAdapter extends TypeAdapter<GrupoOrden> {
  @override
  final typeId = 12;

  @override
  GrupoOrden read(BinaryReader reader) {
    var g = GrupoOrden()
      ..orden = reader.readInt32()
      ..nombre = reader.readString()
      ..activo = reader.readBool();

    // try {
    //   var grp = reader.read();
    //   g.grupo = grp;
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("Error en GrupoOrden: " + e.toString());
    //   }
    // }

    // var sGrupo = g.nombre
    //     .toLowerCase()
    //     .replaceAll('á', 'a')
    //     .replaceAll('é', 'e')
    //     .replaceAll('í', 'i')
    //     .replaceAll('ó', 'o')
    //     .replaceAll('ú', 'u');
    // //if (sGrupo != g.grupo.name) {
    // try {
    //   g.grupo = eGrupo.values.firstWhereOrDefault(
    //       (value) => value.name == sGrupo,
    //       defaultValue: eGrupo.marca) as eGrupo;
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("Error en GrupoOrdenAdapter: " + e.toString());
    //   }
    // }
    //}
    return g;
  }

  @override
  void write(BinaryWriter writer, GrupoOrden obj) {
    writer.writeInt32(obj.orden);
    writer.writeString(obj.nombre);
    writer.writeBool(obj.activo);
    //writer.write(obj.grupo);
  }
}

@HiveType(typeId: 13)
// ignore: camel_case_types
enum eGrupo {
  @HiveField(0, defaultValue: true)
  marca,
  @HiveField(1)
  rubro,
  @HiveField(2)
  linea
}

// ignore: camel_case_types
class eGrupoAdapter extends TypeAdapter<eGrupo> {
  @override
  final typeId = 13;

  @override
  eGrupo read(BinaryReader reader) {
    var i = reader.readInt32();
    var e = eGrupo.values.firstWhereOrDefault((value) => value.index == i,
        defaultValue: eGrupo.marca);

    return e as eGrupo;
  }

  @override
  void write(BinaryWriter writer, eGrupo obj) {
    writer.writeInt32(obj.index);
  }
}

@HiveType(typeId: 14)
// ignore: camel_case_types
enum eTipoDescuento {
  @HiveField(0, defaultValue: true)
  ninguno,
  @HiveField(1)
  importe,
  @HiveField(2)
  porcentaje
}

// ignore: camel_case_types
class eTipoDescuentoAdapter extends TypeAdapter<eTipoDescuento> {
  @override
  final typeId = 14;

  @override
  eTipoDescuento read(BinaryReader reader) {
    var i = reader.readInt32();
    var e = eTipoDescuento.values.firstWhereOrDefault(
        (value) => value.index == i,
        defaultValue: eTipoDescuento.porcentaje);

    return e as eTipoDescuento;
  }

  @override
  void write(BinaryWriter writer, eTipoDescuento obj) {
    writer.writeInt32(obj.index);
  }
}
