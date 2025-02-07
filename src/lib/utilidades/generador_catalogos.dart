import 'dart:async';
import 'package:catalog_app/modelos/iva.dart';
import 'package:catalog_app/utilidades/utiles.dart';
import 'package:intl/intl.dart';

import 'package:catalog_app/modelos/catalogo/catalogo.dart';
import 'package:catalog_app/modelos/catalogo/grupo_item_catalogo.dart';
import 'package:catalog_app/modelos/catalogo/item_catalogo.dart';
import 'package:catalog_app/modelos/configuracion_catalogo.dart';
// import 'package:catalog_app/utilidades/utiles.dart';
import 'package:darq/darq.dart';
// import 'package:flutter/foundation.dart';
import '../modelos/articulo.dart';
import '../modelos/bonificacion.dart';
import '../modelos/cliente.dart';
import '../modelos/imagen.dart';

class GeneradorCatalogos {
  static int _agregarArticulos(
      List<Articulo> arts,
      List<DescuentoItem> articulosConBonif,
      List<Imagen> imagenes,
      int lista,
      GrupoItemsCatalogo grpArts,
      ConfiguracionCatalogoInterno cfgCatalogo,
      List<Iva> alicuotasIva) {
    if (arts.isNotEmpty) {
      for (var a in arts) {
        var img = imagenes.firstWhereOrDefault(
            (value) => value.nombre == a.codigo,
            defaultValue: null);

        var item = ItemCatalogo();
        item.codigoArticulo = a.codigo;
        item.descripcionArticulo = a.descripcion;
        item.esNuevo = true;
        item.esPromo = false;
        var desc = articulosConBonif.firstWhereOrDefault(
            (value) =>
                value.codArticulo.trim().toLowerCase() ==
                a.codigo.trim().toLowerCase(),
            defaultValue: null);

        double precioLista = a.getPrecio(lista);
        String calculo = cfgCatalogo.calculoPrecio;
        String calculoBonif = cfgCatalogo.calculoPrecioBonificado;
        var alicuotaIva = alicuotasIva.firstWhereOrDefault(
            (value) => value.codigo == a.codigoIva,
            defaultValue: null);

        var result = calculo.calcularPrecio(
            precioLista: precioLista,
            alicuotaIva: alicuotaIva != null ? alicuotaIva.valor : 0,
            bonificacionImporte: desc != null ? desc.valor : 0,
            bonificacionPorcentaje: desc != null ? desc.valor : 0,
            impuestoInterno: a.impuestoInt,
            unidadesPack: a.pack);

        if (result.error.isNotEmpty) {
          throw "Error al calcular el precio del artículo (${a.codigo})\r\nCálculo: ${result.calculo}";
        } else {
          item.precio = result.valor;
        }

        //.getValueFromProperty<Articulo>("lista" + lista.toString());

        if (desc != null) {
          item.esPromo = true;
          result = calculoBonif.calcularPrecio(
              precioLista: precioLista,
              alicuotaIva: alicuotaIva != null ? alicuotaIva.valor : 0,
              bonificacionImporte: desc.valor == 0 ? 1 : desc.valor,
              bonificacionPorcentaje: desc.valor == 0 ? 1 : desc.valor,
              impuestoInterno: a.impuestoInt,
              unidadesPack: a.pack);

          if (result.error.isNotEmpty) {
            throw "Error al calcular la bonificación del artículo (${a.codigo})r\nCálculo: ${result.calculo}";
          } else {
            item.precioPromocional = result.valor;
          }
          // switch (desc.tipoDescuento) {
          //   case eTipoDescuento.importe:
          //     item.precioPromocional = item.precio - desc.valor;
          //     break;
          //   case eTipoDescuento.porcentaje:
          //     item.precioPromocional =
          //         item.precio - ((item.precio / 100.0) * desc.valor);
          //     break;
          //   default:
          //     item.precioPromocional = item.precio;
          // }
        }

        if (img != null) {
          item.imagen = img.imagen;
          item.imagenData = img.imagenData;
        }

        // item.muestraCodigoArticulo = true;
        // item.muestraDescripcionArticulo = true;
        // item.muestraPrecio = true;
        if (item.precio > 0 && img != null) {
          grpArts.items.add(item);
        }
      }
    }
    return grpArts.items.length;
  }

  static Future<List<DescuentoItem>> _articulosConBonificacionGeneral(
      List<Articulo> articulos,
      List<Cliente> clientes,
      List<Bonificacion> bonificaciones,
      int lista) async {
    List<DescuentoItem> lstArts = <DescuentoItem>[];

    var bonifIds = clientes
        .where((element) => element.lista == lista)
        .select((element, index) => element.tablaBonifId)
        .distinct();
/*Recorrro los Artículos*/
    for (var art in articulos) {
      //Obtengo los Ids de Bonificación
      var bonifs = bonificaciones.where((element) =>
          element.codart.trim().toLowerCase() ==
          art.codigo.trim().toLowerCase());

      if (bonifs.isNotEmpty) {
        var ids = bonifs.select((element, index) => element.bonifId).distinct();
        ids = ids.where((element) =>
            // ignore: unrelated_type_equality_checks
            bonifIds.firstWhereOrDefault((value) => value == element.toString(),
                defaultValue: null) !=
            null);

        var idsPercent =
            bonifs.select((element, index) => element.desc).distinct();

        if (ids.isNotEmpty &&
            idsPercent.isNotEmpty &&
            idsPercent.length == 1 &&
            idsPercent.first > 0) {
          // var dif = ids.firstWhereOrDefault(
          //     (value) => !bonifIds
          //         .contains((element2) => element2 == value.toString()),
          //     defaultValue: null);
          bool ok = true;
          for (var i in ids) {
            var obj = bonifIds.firstWhereOrDefault(
                (value) => value == i.toString(),
                defaultValue: null);
            if (obj == null) {
              ok = false;
              break;
            }
          }

          if (ids.length == bonifIds.length && ok) {
            lstArts.add(DescuentoItem(
              codArticulo: art.codigo,
              valor: idsPercent.first,
              // tipoDescuento: eTipoDescuento.porcentaje
            ));
          }
        }
      }
    }

    return lstArts;
  }

  static Iterable<Articulo> _getArticulosDesdeGrupo(
      Iterable<Articulo> articulos, GrupoOrden grupo, String valor) {
    return articulos.where((element) {
      switch (grupo.grupo) {
        case eGrupo.marca:
          return element.marca.trim() == valor.trim();
        case eGrupo.rubro:
          return element.rubro.trim() == valor.trim();
        case eGrupo.linea:
          return element.linea.trim() == valor.trim();
        default:
          return false;
      }
    });
  }

  static Iterable<dynamic> _getAgrupado(
      Iterable<Articulo> articulos, GrupoOrden grupo) {
    return articulos.select((element, index) {
      switch (grupo.grupo) {
        case eGrupo.marca:
          return element.marca.trim();
        case eGrupo.rubro:
          return element.rubro.trim();
        case eGrupo.linea:
          return element.linea.trim();
        default:
          return "";
      }
    }).distinct();
  }

  // Future<void> _generarCatalogoOrdenViejo(
  //     Catalogo cat,
  //     List<Articulo> articulos,
  //     List<Cliente> clientes,
  //     List<Imagen> imagenes,
  //     List<Bonificacion> bonificaciones,
  //     int lista,
  //     List<String> lstArticulosConBonif,
  //     ConfiguracionCatalogoInterno cfgCatalogo) async {
  //   var rubros = articulos.select((element, index) => element.rubro).distinct();

  //   for (var r in rubros) {
  //     var lineas = articulos
  //         .where((element) => element.rubro == r)
  //         .select((element, index) => element.linea)
  //         .distinct();
  //     List<Articulo> arts = <Articulo>[];

  //     if (lineas.isNotEmpty &&
  //         (lineas.length > 1 ||
  //             (lineas.length == 1 && lineas.first.isNotEmpty))) {
  //       var grp1 = GruposCatalogo();
  //       grp1.nombreGrupo = r;

  //       for (var l in lineas) {
  //         var grpLine = GrupoItemsCatalogo();
  //         grpLine.nombreGrupo = l;
  //         arts = articulos
  //             .where((element) => element.rubro == r && element.linea == l)
  //             .toList();
  //         if (_agregarArticulos(
  //                 arts, lstArticulosConBonif, imagenes, lista, grpLine) >
  //             0) {
  //           grp1.grupos.add(grpLine);
  //         }
  //       }
  //       if (grp1.grupos.isNotEmpty) {
  //         cat.grupos.add(grp1);
  //       }
  //     } else {
  //       var grp2 = GrupoItemsCatalogo();
  //       grp2.nombreGrupo = r;

  //       arts = articulos.where((element) => element.rubro == r).toList();

  //       _agregarArticulos(arts, lstArticulosConBonif, imagenes, lista, grp2);

  //       if (grp2.items.isNotEmpty) {
  //         cat.grupos.add(grp2);
  //       }
  //     }
  //   }
  // }
  static bool _cargarGrupo3(
      Iterable<GrupoOrden> orden,
      Iterable<Articulo> articulos2,
      List<DescuentoItem> lstArticulosConBonif,
      List<Imagen> imagenes,
      int lista,
      //GranGrupoCatalogo grupo1,
      GrupoCatalogoBase grupo2,
      String agrupado2,
      ConfiguracionCatalogoInterno cfgCatalogo,
      List<Iva> alicuotasIva) {
    var grpOrden3 = orden.skip(2).firstOrDefault();
    bool ok = false;
    Iterable<dynamic> agrupados3 = <dynamic>[];
    if (grpOrden3 != null) {
      agrupados3 = _getAgrupado(articulos2, grpOrden3);
      if (agrupados3
          .where((element) => element.toString().trim().isNotEmpty)
          .isNotEmpty) {
        //Recorro agrupados Grupo 3
        for (var agrupado3 in agrupados3) {
          //Obtengo los artículos del Agrupado 3
          var articulos3 =
              _getArticulosDesdeGrupo(articulos2, grpOrden3, agrupado3);
          //Si tiene items sigo
          if (articulos3.isNotEmpty) {
            var grupo3 = GrupoItemsCatalogo()
              ..nombreGrupo = agrupado3.toString();

            if (_agregarArticulos(articulos3.toList(), lstArticulosConBonif,
                    imagenes, lista, grupo3, cfgCatalogo, alicuotasIva) >
                0) {
              if (grupo2 is GranGrupoCatalogo) {
                grupo2.items.add(grupo3);
              } else if (grupo2 is GrupoCatalogo) {
                grupo2.grupos.add(grupo3);
              }
            }
          }
        }
      } else {
        var grupo3items = GrupoItemsCatalogo()
          ..nombreGrupo = agrupado2.toString();

        if (_agregarArticulos(articulos2.toList(), lstArticulosConBonif,
                imagenes, lista, grupo3items, cfgCatalogo, alicuotasIva) >
            0) {
          if (grupo2 is GranGrupoCatalogo) {
            grupo2.items.add(grupo3items);
          } else if (grupo2 is GrupoCatalogo) {
            grupo2.grupos.add(grupo3items);
          }
        }
      }
      ok = true;
    }
    return ok;
  }

  static bool _cargarGrupo2(
      Iterable<GrupoOrden> orden,
      Iterable<Articulo> articulos1,
      List<DescuentoItem> lstArticulosConBonif,
      List<Imagen> imagenes,
      int lista,
      GranGrupoCatalogo grupo1,
      Catalogo catalogo,
      String agrupado1,
      ConfiguracionCatalogoInterno cfgCatalogo,
      List<Iva> alicuotasIva) {
    bool ok = false;
    var grpOrden2 = orden.skip(1).firstOrDefault();
    //.firstWhereOrDefault((value) => value.orden == 2);
    Iterable<dynamic> agrupados2 = <dynamic>[];
    if (grpOrden2 != null) {
      agrupados2 = _getAgrupado(articulos1, grpOrden2);
      if (agrupados2
          .where((element) => element.toString().trim().isNotEmpty)
          .isNotEmpty) {
        //Recorro agrupados Grupo 2
        for (var agrupado2 in agrupados2) {
          //Obtengo los artículos del Agrupado 2
          var articulos2 =
              _getArticulosDesdeGrupo(articulos1, grpOrden2, agrupado2);
          //Si tiene items sigo
          if (articulos2.isNotEmpty) {
            var grupo2 = GrupoCatalogo()..nombreGrupo = agrupado2.toString();

            if (_cargarGrupo3(orden, articulos2, lstArticulosConBonif, imagenes,
                lista, grupo2, agrupado2, cfgCatalogo, alicuotasIva)) {
              if (grupo2.grupos.isNotEmpty) {
                grupo1.grupos.add(grupo2);
              }
            } else {
              //No tiene Grupo 3 así que cargo todos los artículos del Grupo 2
              var grupo2items = GrupoItemsCatalogo()
                ..nombreGrupo = agrupado2.toString();

              if (_agregarArticulos(articulos2.toList(), lstArticulosConBonif,
                      imagenes, lista, grupo2items, cfgCatalogo, alicuotasIva) >
                  0) {
                grupo1.items.add(grupo2items);
              }
            }
          }
        }
      } else {
        //es agrupado vacío, seguir con el grupo 3
        if (!_cargarGrupo3(orden, articulos1, lstArticulosConBonif, imagenes,
            lista, grupo1, agrupado1, cfgCatalogo, alicuotasIva)) {
          //No tiene Grupo 3 así que cargo todos los artículos del Grupo 1
          var grupo1items = GrupoItemsCatalogo()
            ..nombreGrupo = agrupado1.toString();

          if (_agregarArticulos(articulos1.toList(), lstArticulosConBonif,
                  imagenes, lista, grupo1items, cfgCatalogo, alicuotasIva) >
              0) {
            catalogo.grupos.add(grupo1items);
          }
        }
      }

      if (grupo1.grupos.isNotEmpty || grupo1.items.isNotEmpty) {
        catalogo.grupos.add(grupo1);
      }
      ok = true;
    }
    return ok;
  }

  static Future<void> _generarCatalogoSegunOrden(
      Catalogo cat,
      List<Articulo> articulos,
      List<Cliente> clientes,
      List<Imagen> imagenes,
      List<Bonificacion> bonificaciones,
      int lista,
      List<DescuentoItem> lstArticulosConBonif,
      ConfiguracionCatalogoInterno cfgCatalogo,
      List<Iva> alicuotasIva) async {
    var orden = cfgCatalogo.configuracionGrupo.orden
        .where((element) => element.activo == true)
        .orderBy((element) => element.orden);

    if (orden.isNotEmpty &&
        !cfgCatalogo.configuracionGrupo.ordenarLosArticulosPorNombre) {
      var grpOrden1 = orden.firstOrDefault();

      //firstWhereOrDefault((value) => value.orden == 1);
      Iterable<dynamic> agrupados1 = <dynamic>[];

      if (grpOrden1 != null) {
        agrupados1 = _getAgrupado(articulos, grpOrden1);
        if (agrupados1
            .where((element) => element.toString().trim().isNotEmpty)
            .isNotEmpty) {
          //Recorro agrupados Grupo 1
          for (var agrupado1 in agrupados1) {
            //Obtengo los artículos del Agrupado 1
            var articulos1 =
                _getArticulosDesdeGrupo(articulos, grpOrden1, agrupado1);

            //Si tiene items sigo
            if (articulos1.isNotEmpty) {
              var grupo1 = GranGrupoCatalogo()
                ..nombreGrupo = agrupado1.toString();

              if (!_cargarGrupo2(
                  orden,
                  articulos1,
                  lstArticulosConBonif,
                  imagenes,
                  lista,
                  grupo1,
                  cat,
                  agrupado1,
                  cfgCatalogo,
                  alicuotasIva)) {
                // if (grupo1.grupos.isNotEmpty) {
                //   cat.grupos.add(grupo1);
                // }

                // } else {
                //No tiene Grupo 2 así que cargo todos los artículos del Grupo 1
                var grupo1items = GrupoItemsCatalogo()
                  ..nombreGrupo = agrupado1.toString();

                if (_agregarArticulos(
                        articulos1.toList(),
                        lstArticulosConBonif,
                        imagenes,
                        lista,
                        grupo1items,
                        cfgCatalogo,
                        alicuotasIva) >
                    0) {
                  cat.grupos.add(grupo1items);
                }
              }
            }
          }
        } else {
          //es agrupado vacío, seguir con el grupo 2
          var grupo1 = GranGrupoCatalogo()..nombreGrupo = "";
          if (!_cargarGrupo2(orden, articulos, lstArticulosConBonif, imagenes,
              lista, grupo1, cat, "", cfgCatalogo, alicuotasIva)) {
            var grupo1items = GrupoItemsCatalogo()..nombreGrupo = "";

            if (_agregarArticulos(articulos.toList(), lstArticulosConBonif,
                    imagenes, lista, grupo1items, cfgCatalogo, alicuotasIva) >
                0) {
              cat.grupos.add(grupo1items);
            }
          }
        }
      } else {
        //No hay agrupados
        var grupo1items = GrupoItemsCatalogo();
        grupo1items.nombreGrupo = "";
        if (_agregarArticulos(articulos.toList(), lstArticulosConBonif,
                imagenes, lista, grupo1items, cfgCatalogo, alicuotasIva) >
            0) {
          cat.grupos.add(grupo1items);
        }
      }
    } else {
      //No hay agrupados
      var grupo1items = GrupoItemsCatalogo();
      grupo1items.nombreGrupo = "";

      List<Articulo> articulos2 = <Articulo>[];
      if (cfgCatalogo.configuracionGrupo.ordenarLosArticulosPorNombre) {
        articulos2 = articulos
            .orderBy((element) => element.descripcion.trim().toLowerCase())
            .toList();
      } else {
        articulos2 = articulos;
      }
      if (_agregarArticulos(articulos2, lstArticulosConBonif, imagenes, lista,
              grupo1items, cfgCatalogo, alicuotasIva) >
          0) {
        cat.grupos.add(grupo1items);
      }
    }
  }

  static Future<Catalogo> _crearCatalogoAsync(
      List<Articulo> articulos,
      List<Cliente> clientes,
      List<Imagen> imagenes,
      List<Bonificacion> bonificaciones,
      ConfiguracionCatalogoInterno cfgCatalogo,
      int lista,
      List<DescuentoItem> lstArticulosConBonif,
      List<Iva> alicuotasIva) {
    Catalogo cat = Catalogo();
    DateTime dt = DateTime.now();
    String formattedDate = DateFormat("yyyyMMdd_HHmmss").format(dt);

    cat.fileName = "${formattedDate}_lista$lista.pdf";
    cat.pie = cfgCatalogo.pie; //Pie();

    cat.encabezado = cfgCatalogo.encabezado; //Encabezado();

    cat.fondo = cfgCatalogo.fondo; //Fondo();

    return Future(() async {
      await _generarCatalogoSegunOrden(
          cat,
          articulos,
          clientes,
          imagenes,
          bonificaciones,
          lista,
          lstArticulosConBonif,
          cfgCatalogo,
          alicuotasIva);
      return cat;
    });
  }

  static Future<Catalogo> _crearCatalogo(
      List<Articulo> articulos,
      List<Cliente> clientes,
      List<Imagen> imagenes,
      List<Bonificacion> bonificaciones,
      List<Iva> alicuotasIva,
      ConfiguracionCatalogoInterno cfgCatalogo,
      int lista) async {
    var lstArticulosConBonif = <DescuentoItem>[];
    if (cfgCatalogo.mostrarAvisoOferta) {
      // lstArticulosConBonif = await _articulosConBonificacionGeneral(
      //     articulos, clientes, bonificaciones, lista);
      return Future(() async {
        lstArticulosConBonif = await _articulosConBonificacionGeneral(
            articulos, clientes, bonificaciones, lista);
        return _crearCatalogoAsync(
            articulos,
            clientes,
            imagenes,
            bonificaciones,
            cfgCatalogo,
            lista,
            lstArticulosConBonif,
            alicuotasIva);
      });
    } else {
      return _crearCatalogoAsync(articulos, clientes, imagenes, bonificaciones,
          cfgCatalogo, lista, lstArticulosConBonif, alicuotasIva);
    }
  }

  // static Future<List<Catalogo>> _generarCatalogosStatic(
  //     List<Articulo> articulos,
  //     List<Cliente> clientes,
  //     List<Imagen> imagenes,
  //     List<Bonificacion> bonificaciones,
  //     ConfiguracionCatalogoInterno cfgCatalogo) async {
  //   return Future(() async {
  //     var listas = clientes
  //         .where((element) => element.lista >= 0)
  //         .select((element, index) => element.lista)
  //         .distinct();

  //     var waits = listas.select((element, index) async {
  //       return _crearCatalogo(articulos, clientes, imagenes, bonificaciones,
  //           cfgCatalogo, element);
  //     }).toList();

  //     return Future.wait(waits);
  //   });
  // }

  // List<Catalogo> generarCatalogosSync(
  //     List<Articulo> articulos,
  //     List<Cliente> clientes,
  //     List<Imagen> imagenes,
  //     List<Bonificacion> bonificaciones,
  //     ConfiguracionCatalogoInterno cfgCatalogo) {
  //   var listas = clientes
  //       .where((element) => element.lista >= 0)
  //       .select((element, index) => element.lista)
  //       .distinct();

  //   var waits = listas.select((element, index) {
  //     return _crearCatalogo(
  //         articulos, clientes, imagenes, bonificaciones, cfgCatalogo, element);
  //   }).toList();

  //   var result = Future.wait(waits);

  //   var stream = result.asStream();
  //   List<Catalogo> ret = <Catalogo>[];
  //   stream.map((event) => ret = event);
  //   return ret;
  // }

  Future<List<Catalogo>> generarCatalogos(
      List<Articulo> articulos,
      List<Cliente> clientes,
      List<Imagen> imagenes,
      List<Bonificacion> bonificaciones,
      List<Iva> alicuotasIva,
      ConfiguracionCatalogoInterno cfgCatalogo) async {
    return Future(() async {
      List<int> listas;

      if (clientes.isNotEmpty) {
        listas = clientes
            .where((element) => element.lista >= 0)
            .select((element, index) => element.lista)
            .distinct()
            .toList();
      } else {
        var lst = articulos
            .where((element) => element.tienePrecio())
            .select((element, index) => element.getListasPrecios());
        listas = <int>[];

        for (var element in lst) {
          for (var e in element) {
            if (listas.firstWhereOrDefault((value) => value == e,
                    defaultValue: null) ==
                null) {
              listas.add(e);
            }
          }
        }
      }

      var waits = listas.select((element, index) async {
        return _crearCatalogo(articulos, clientes, imagenes, bonificaciones,
            alicuotasIva, cfgCatalogo, element);
      }).toList();

      return Future.wait(waits);
    });
  }
}
