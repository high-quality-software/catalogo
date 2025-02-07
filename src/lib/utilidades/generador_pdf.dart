import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:catalog_app/modelos/catalogo/catalogo.dart';
import 'package:catalog_app/modelos/catalogo/grupo_item_catalogo.dart';
import 'package:catalog_app/modelos/catalogo/item_catalogo.dart';
import 'package:catalog_app/modelos/configuracion_catalogo.dart';
import 'package:catalog_app/modelos/pdf/item_pdf.dart';
import 'package:catalog_app/utilidades/utiles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' as mat;
// import 'package:path/path.dart';
// import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;
import 'package:darq/darq.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

class ResultadoPdf {
  final String _fileName;
  final bool _ok;
  final String _titulo;

  String get fileName => _fileName;
  bool get ok => _ok;
  String get titulo => _titulo;

  ResultadoPdf(this._fileName, this._ok, this._titulo);
}
// class _WidgetCreatorPdf {
//   pw.Widget? _widget;

//   pw.Widget? get widget => _widget;

//   int _level = 0;

//   int addGroup(ItemPdfBase grp) {
//     _level++;

//     return _level;
//   }

//   int closeGroup() {
//     _level--;

//     return _level;
//   }
// }

class GeneradorPdf {
  final pw.Document _pdf =
      pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  // late pw.Font _font;

  late pw.Font _fontDescripcionArticulo;
  late pw.Font _fontPrecioArticulo;
  late pw.Font _fontSkuArticulo;
  late pw.Font _fontEncabezado;
  late pw.Font _fontPie;
  late pw.Font _fontGrupo;

  pw.Widget _getWidgetArticulo(
      ItemCatalogo item, ConfiguracionCatalogoInterno cfgCat) {
    var imgProducto = pw.MemoryImage(item.imagenData as Uint8List);
    pw.MemoryImage? imgOferta;
    if (cfgCat.dataLogoOferta.isNotEmpty) {
      imgOferta = pw.MemoryImage(cfgCat.dataLogoOferta);
    } else {
      var f = File(cfgCat.urlLogoOferta);
      if (f.existsSync()) {
        cfgCat.dataLogoOferta = f.readAsBytesSync();
        imgOferta = pw.MemoryImage(cfgCat.dataLogoOferta);
      }
    }

    double alto =
        cfgCat.altoWidgetArticulo < 130 ? 130 : cfgCat.altoWidgetArticulo;
    double ancho =
        cfgCat.anchoWidgetArticulo < 130 ? 130 : cfgCat.anchoWidgetArticulo;
    double coefImagen = (cfgCat.porcentajeAltoImagenArticulo < 30 || cfgCat.porcentajeAltoImagenArticulo > 70 ? 70 : 65) /100;
    double coefImagenOferta = 0.25;

    pw.BoxDecoration? decorador;
    if (cfgCat.mostrarChartDeArticulos) {
      decorador = pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(10),
        boxShadow: const [
          pw.BoxShadow(
              color: PdfColors.indigo,
              blurRadius: 10,
              spreadRadius: 10,
              offset: PdfPoint(2, 2)),
        ],
      );
    }
    String simboloMoneda = "";
    if (cfgCat.simboloMoneda.isNotEmpty) {
      simboloMoneda = cfgCat.simboloMoneda;
    }
    return pw.Padding(
        padding: const pw.EdgeInsets.all(5),
        child: pw.Container(
            height: alto,
            width: ancho,
            decoration: decorador,
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Stack(alignment: pw.Alignment.topCenter, children: [
                    pw.Center(
                      child: pw.SizedBox(
                          height: alto * coefImagen,
                          width: ancho * coefImagen,
                          child: pw.Image(imgProducto,
                              height: (imgProducto.width ?? 0) >
                                      (imgProducto.height ?? 0)
                                  ? null
                                  : alto * coefImagen,
                              width: (imgProducto.width ?? 0) >
                                      (imgProducto.height ?? 0)
                                  ? ancho * coefImagen
                                  : null,
                              dpi: 300,
                              fit: (imgProducto.width ?? 0) >
                                      (imgProducto.height ?? 0)
                                  ? pw.BoxFit.fitWidth
                                  : pw.BoxFit.fitHeight,
                              alignment: pw.Alignment.center)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10, top: 10),
                      child: pw.Container(
                          width: ancho,
                          child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                cfgCat.mostrarAvisoOferta &&
                                        item.esPromo &&
                                        imgOferta != null
                                    ? pw.Image(imgOferta,
                                        height: alto * coefImagenOferta,
                                        width: ancho * coefImagenOferta,
                                        fit: pw.BoxFit.fitWidth,
                                        alignment: pw.Alignment.center)
                                    : pw.Container()
                              ])),
                    )
                    // pw.Center(
                    //     child: pw.Text("SKU: " + item.codigoArticulo))
                  ]),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Center(
                                child: cfgCat.mostrarDescripcionArticulo
                                    ? pw.Text(item.descripcionArticulo,
                                        softWrap: true,
                                        style: pw.TextStyle(
                                            font: _fontDescripcionArticulo,
                                            // fontStyle: cfgCat
                                            //             .fuenteDescripcionArticulo
                                            //             .fontStyle ==
                                            //         mat.FontStyle.italic
                                            //     ? pw.FontStyle.italic
                                            //     : pw.FontStyle.normal,
                                            color: PdfColor.fromInt(cfgCat
                                                .fuenteDescripcionArticulo
                                                .color
                                                .value),
                                            fontSize: cfgCat
                                                .fuenteDescripcionArticulo.size,
                                            fontWeight: cfgCat
                                                    .fuenteDescripcionArticulo
                                                    .negrita
                                                ? pw.FontWeight.bold
                                                : pw.FontWeight.normal))
                                    : pw.Container())),
                        pw.Center(
                            child: cfgCat.mostrarPrecioEnChart
                                ? (pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                        pw.Text("Precio: ",
                                            softWrap: true,
                                            style: pw.TextStyle(
                                                font: _fontPrecioArticulo,
                                                color: PdfColor.fromInt(cfgCat
                                                    .fuentePrecioArticulo
                                                    .color
                                                    .value),
                                                fontWeight: cfgCat
                                                        .fuentePrecioArticulo
                                                        .negrita
                                                    ? pw.FontWeight.bold
                                                    : pw.FontWeight.normal,
                                                fontSize: cfgCat
                                                    .fuentePrecioArticulo
                                                    .size)),
                                        item.esPromo
                                            ? (pw.Row(children: [
                                                cfgCat
                                                        .mostrarPrecioOriginalTachado
                                                    ? pw.Text(
                                                        " $simboloMoneda ${item.precio
                                                                .toStringAsFixed(
                                                                    2)}",
                                                        softWrap: true,
                                                        style: pw.TextStyle(
                                                          font:
                                                              _fontPrecioArticulo,
                                                          color: PdfColor
                                                              .fromInt(cfgCat
                                                                  .fuentePrecioArticulo
                                                                  .color
                                                                  .value),
                                                          fontWeight: cfgCat
                                                                  .fuentePrecioArticulo
                                                                  .negrita
                                                              ? pw.FontWeight
                                                                  .bold
                                                              : pw.FontWeight
                                                                  .normal,
                                                          fontSize: cfgCat
                                                                  .fuentePrecioArticulo
                                                                  .size -
                                                              1.0,
                                                          decoration: pw
                                                              .TextDecoration
                                                              .lineThrough,
                                                          decorationColor:
                                                              PdfColors.black,
                                                        ))
                                                    : pw.Container(height: 0),
                                                pw.Padding(
                                                    padding:
                                                        const pw.EdgeInsets.only(
                                                            left: 3),
                                                    child: pw.Text(
                                                        " $simboloMoneda ${item.precioPromocional
                                                                .toStringAsFixed(
                                                                    2)}",
                                                        softWrap: true,
                                                        style: pw.TextStyle(
                                                            font:
                                                                _fontPrecioArticulo,
                                                            color: PdfColor.fromInt(
                                                                cfgCat
                                                                    .fuentePrecioArticulo
                                                                    .color
                                                                    .value),
                                                            fontWeight: cfgCat.fuentePrecioArticulo.negrita
                                                                ? pw.FontWeight.bold
                                                                : pw.FontWeight.normal,
                                                            fontSize: cfgCat.fuentePrecioArticulo.size)))
                                              ]))
                                            : pw.Text(
                                                " $simboloMoneda ${item.precio
                                                        .toStringAsFixed(2)}",
                                                softWrap: true,
                                                style: pw.TextStyle(
                                                    font: _fontPrecioArticulo,
                                                    color: PdfColor
                                                        .fromInt(cfgCat
                                                            .fuentePrecioArticulo
                                                            .color
                                                            .value),
                                                    fontWeight: cfgCat
                                                            .fuentePrecioArticulo
                                                            .negrita
                                                        ? pw.FontWeight.bold
                                                        : pw.FontWeight.normal,
                                                    fontSize: cfgCat
                                                        .fuentePrecioArticulo
                                                        .size))
                                      ]))
                                : pw.Container(height: 0)),
                        pw.Center(
                            child: pw.Text("SKU: ${item.codigoArticulo}",
                                softWrap: true,
                                style: pw.TextStyle(
                                    font: _fontSkuArticulo,
                                    color: PdfColor.fromInt(
                                        cfgCat.fuenteSkuArticulo.color.value),
                                    fontWeight: cfgCat.fuenteSkuArticulo.negrita
                                        ? pw.FontWeight.bold
                                        : pw.FontWeight.normal,
                                    fontSize: cfgCat.fuenteSkuArticulo.size
                                    //fontSize: cfgCat.mostrarPrecioEnChart ? 5 : 6,
                                    )))
                      ]),
                ])));
  }

  pw.Widget _getTituloHeader(
      Catalogo catalogo, ConfiguracionCatalogoInterno cfgCat) {
    if (catalogo.encabezado.modoImagen != eModoImagen.todoElAncho &&
        catalogo.encabezado.texto.isNotEmpty) {
      return pw.Text(catalogo.encabezado.texto,
          style: pw.TextStyle(
              font: _fontEncabezado,
              color: PdfColor.fromInt(cfgCat.encabezado.fuente.color.value),
              fontWeight: cfgCat.encabezado.fuente.negrita
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
              fontSize: cfgCat.encabezado.fuente.size));
    } else {
      return pw.Container();
    }
  }

  pw.Widget _getTituloFooter(
      Catalogo catalogo, ConfiguracionCatalogoInterno cfgCat) {
    if (catalogo.pie.modoImagen != eModoImagen.todoElAncho &&
        catalogo.pie.texto.isNotEmpty) {
      return pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(5, 3, 5, 8),
          child: pw.Container(
              child: pw.Column(children: [
            pw.Divider(indent: 16, endIndent: 16, color: PdfColors.grey100),
            pw.Text(catalogo.pie.texto,
                softWrap: true,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                    font: _fontPie,
                    color:
                        PdfColor.fromInt(cfgCat.encabezado.fuente.color.value),
                    fontWeight: cfgCat.encabezado.fuente.negrita
                        ? pw.FontWeight.bold
                        : pw.FontWeight.normal,
                    fontSize: cfgCat.encabezado.fuente.size)),
          ])));
    } else {
      return pw.Container();
    }
  }

  pw.Widget _footer(pw.Context context, Catalogo catalogo,
      bool primeraPaginaCreada, ConfiguracionCatalogoInterno cfgCat) {
    if (catalogo.pie.modoHeaderFooter == eModoHeaderFooterPagina.ninguna) {
      return pw.Container(height: 0, width: 0);
    } else if (catalogo.pie.modoHeaderFooter ==
            eModoHeaderFooterPagina.primeraPagina &&
        context.pageNumber > 1 &&
        primeraPaginaCreada) {
      return pw.Container(height: 0, width: 0);
    }

    if (catalogo.pie.modoImagen == eModoImagen.logo) {
      return pw.Container(
          height: 30,
          child: pw.Row(children: [
            pw.Image(pw.MemoryImage(catalogo.pie.imagenData)),
            _getTituloFooter(catalogo, cfgCat)
          ]));
    } else if (catalogo.pie.modoImagen == eModoImagen.todoElAncho) {
      return pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Divider(borderStyle: pw.BorderStyle.solid),
            pw.Stack(children: [
              pw.Image(pw.MemoryImage(catalogo.pie.imagenData)),
              _getTituloFooter(catalogo, cfgCat)
            ])
          ]);
    } else {
      return _getTituloFooter(catalogo, cfgCat);
    }
  }

  pw.Widget _header(pw.Context context, Catalogo catalogo,
      bool primeraPaginaCreada, ConfiguracionCatalogoInterno cfgCat) {
    if (catalogo.encabezado.modoHeaderFooter ==
        eModoHeaderFooterPagina.ninguna) {
      return pw.Container(height: 0, width: 0);
    } else if (catalogo.encabezado.modoHeaderFooter ==
            eModoHeaderFooterPagina.primeraPagina &&
        context.pageNumber > 1 &&
        primeraPaginaCreada) {
      return pw.Container(height: 0, width: 0);
    }

    if (catalogo.encabezado.modoImagen == eModoImagen.logo) {
      return pw.Container(
          height: 45,
          child: pw.Row(children: [
            pw.Image(pw.MemoryImage(catalogo.encabezado.imagenData)),
            _getTituloHeader(catalogo, cfgCat)
          ]));
    } else if (catalogo.encabezado.modoImagen == eModoImagen.todoElAncho) {
      return pw.Column(children: [
        //pw.Divider(borderStyle: pw.BorderStyle.solid),
        pw.Stack(alignment: pw.Alignment.center,
            //fit: pw.StackFit.expand,
            children: [
              pw.Image(pw.MemoryImage(catalogo.encabezado.imagenData)),
              _getTituloHeader(catalogo, cfgCat)
            ])
      ]);
    } else {
      return _getTituloHeader(catalogo, cfgCat);
    }
  }

  pw.Gradient _getDegrade(Degrade degrade) {
    return pw.LinearGradient(colors: [
      PdfColor.fromInt(degrade.color1.value),
      PdfColor.fromInt(degrade.color2.value)
    ]);
  }

  pw.Widget _getPDFBackground(pw.Context context, Catalogo catalogo) {
    if (catalogo.fondo.tipoFondo == eTipoFondo.imagen) {
      return pw.Container(
        decoration: pw.BoxDecoration(
          border: const pw.Border(
              bottom: pw.BorderSide(width: 0.2, style: pw.BorderStyle.solid),
              left: pw.BorderSide(width: 0.2, style: pw.BorderStyle.solid),
              right: pw.BorderSide(width: 0.2, style: pw.BorderStyle.solid),
              top: pw.BorderSide(width: 0.2, style: pw.BorderStyle.solid)),
          image: pw.DecorationImage(
            image: pw.MemoryImage(catalogo.fondo.imagenData),
            fit: pw.BoxFit.fill,
          ),
        ),
        child: pw.Container(),
      );
    }
    if (catalogo.fondo.tipoFondo == eTipoFondo.degrade) {
      return pw.Container(
        decoration: pw.BoxDecoration(
            border: const pw.Border(
                bottom: pw.BorderSide(width: 0.2, style: pw.BorderStyle.solid),
                left: pw.BorderSide(width: 0.2, style: pw.BorderStyle.solid),
                right: pw.BorderSide(width: 0.2, style: pw.BorderStyle.solid),
                top: pw.BorderSide(width: 0.2, style: pw.BorderStyle.solid)),
            gradient: _getDegrade(catalogo.fondo.fondoDegrade)),
        child: pw.Container(),
      );
    } else {
      return pw.Container(
        decoration: const pw.BoxDecoration(
          borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)),
          border: pw.Border(
              bottom: pw.BorderSide(width: 0.5, style: pw.BorderStyle.solid),
              left: pw.BorderSide(width: 0.5, style: pw.BorderStyle.solid),
              right: pw.BorderSide(width: 0.5, style: pw.BorderStyle.solid),
              top: pw.BorderSide(width: 0.5, style: pw.BorderStyle.solid)),
        ),
        child: pw.Container(),
      );
    }
  }

  pw.PageTheme _getPageTheme(Catalogo catalogo) {
    return pw.PageTheme(
        buildBackground: (context) => _getPDFBackground(context, catalogo),
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.natural,
        textDirection: pw.TextDirection.ltr,
        margin: (catalogo.fondo.tipoFondo != eTipoFondo.ninguno
            ? const pw.EdgeInsets.all(0.1)
            : const pw.EdgeInsets.all(5)),
        clip: false);
  }

  Future<List<List<ItemPdfBase>>> _separarListadoItems(
      List<ItemPdfBase> items, int limiteItems) async {
    List<List<ItemPdfBase>> lista = <List<ItemPdfBase>>[];
    List<GrupoPdf> parentGroups = <GrupoPdf>[];
    int count = 0;

    if (items.isNotEmpty) {
      lista.add(<ItemPdfBase>[]);
    }
    //List<ItemPdfBase> current = <ItemPdfBase>[];
    //bool recrearGrupos = false;
    for (var item in items) {
      var current = lista[lista.length - 1];
      // count++;
      current.add(item);
      if (item is GrupoPdf) {
        parentGroups.add(item);
      } else if (item is ItemPdf) {
        count++;
        if (count == limiteItems) {
          var rev = parentGroups.reversed;
          for (var g in rev) {
            var f = items.firstWhereOrDefault(
                (value) =>
                    value.id == g.id &&
                    value.idParent == g.idParent &&
                    value is FinGrupoPdf,
                defaultValue: null);
            if (f != null) {
              current.add(f);
            }
          }
        }
      } else if (item is FinGrupoPdf) {
        var value = parentGroups.firstWhereOrDefault(
            (value) => value.id == item.id && value.idParent == item.idParent);

        parentGroups.remove(value);
      }
      if (count == limiteItems) {
        count = parentGroups.length;
        lista.add(<ItemPdfBase>[]);
        //lista.add(current);
        //current = <ItemPdfBase>[];
        //current.addAll(parentGroups);
      }
    }
    return lista;
  }

  double _getEspacioDivisorFromLevelGroup(int level) {
    double espacioBase = 12;
    switch (level) {
      case 0:
        return espacioBase;
      case 1:
        return espacioBase + 6;
      case 2:
        return espacioBase + 12;
      case 3:
        return espacioBase + 18;
      case 4:
        return espacioBase + 24;
      default:
        return espacioBase + 32;
    }
  }

  pw.Widget _getHeaderGrupoPdf(
      GrupoPdf grp, ConfiguracionCatalogoInterno cfgCat) {
    List<pw.Widget> lista = <pw.Widget>[];
    double espacioDivisor = _getEspacioDivisorFromLevelGroup(grp.nivelGrupo);
    // double coef = grp.id + 1;
    // if (coef > 1) {
    //   espacioDivisor = espacioDivisor * coef;
    // }

    PdfColor color = PdfColors.grey100;

    pw.Divider divisor = pw.Divider(
        indent: espacioDivisor,
        endIndent: espacioDivisor,
        color: color,
        thickness: 1);

    lista.add(pw.Padding(padding: const pw.EdgeInsets.only(top: 10.0)));
    lista.add(divisor);

    if (grp.nombre.isNotEmpty) {
      // pw.Divider divisor2 = pw.Divider(
      //     indent: espacioDivisor, endIndent: espacioDivisor, color: color);
      lista.clear();
      lista.add(pw.Padding(padding: const pw.EdgeInsets.only(top: 10.0)));
      lista.add(divisor);
      lista.add(pw.Padding(padding: const pw.EdgeInsets.only(top: 2.0)));
      lista.add(pw.Text(grp.nombre,
          style: pw.TextStyle(
              font: _fontGrupo,
              color: PdfColor.fromInt(
                  cfgCat.configuracionGrupo.fuente.color.value),
              fontWeight: cfgCat.configuracionGrupo.fuente.negrita
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
              fontSize: cfgCat.configuracionGrupo.fuente.size
              // fontWeight: espacioDivisor > 16
              //     ? pw.FontWeight.normal
              //     : pw.FontWeight.bold,
              // fontSize: espacioDivisor > 18 ? 9 : 10
              )));
      lista.add(pw.Padding(padding: const pw.EdgeInsets.only(top: 2.0)));

      //lista.add(divisor2);
    }

    return pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: lista);
  }

    List<pw.Widget> _getWidgetsFromListItems(List<ItemPdfBase> items,
      Catalogo catalogo, ConfiguracionCatalogoInterno cfgCat) {
    List<pw.Widget> lista = <pw.Widget>[];

    // List<pw.Widget> itemsPdf = <pw.Widget>[];
// pw.Wrap(
//         alignment: pw.WrapAlignment.spaceEvenly,
//         crossAxisAlignment: pw.WrapCrossAlignment.center,
//         children: List<pw.Widget>.generate(grupo.items.length, (int index) {
//           var item = grupo.items[index];
//           return _getWidgetArticulo(item);
//         }));
    // List<dynamic> lst = <dynamic>[];

    if (items.isNotEmpty) {
      for (var itemPdf in items) {
        if (itemPdf is GrupoPdf) {
          if (itemPdf.nombre.trim().isNotEmpty &&
              cfgCat.configuracionGrupo.mostrarCabeceraGrupo &&
              !cfgCat.configuracionGrupo.noAgrupar) {
            var g = _getHeaderGrupoPdf(itemPdf, cfgCat);

            lista.add(g);

            //lista.add(w);
          }
        } else if (itemPdf is ItemPdf) {
          var w = _getWidgetArticulo(itemPdf.item, cfgCat);
        
          lista.add(w);
        
        } 
        // else if (itemPdf is FinGrupoPdf) {
        //   if (lst.isNotEmpty) {
        //     var g = lst.last as List<pw.Widget>;
        //     lst.removeLast();
        //     if (g.isNotEmpty) {
        //       // pw.Wrap wrap =
        //       //     pw.Wrap(alignment: pw.WrapAlignment.spaceEvenly, children: g);
        //       pw.Wrap wrap = pw.Wrap(
        //           alignment: pw.WrapAlignment.spaceBetween,
        //           crossAxisAlignment: pw.WrapCrossAlignment.start,
        //           children: g);

        //       if (lst.isEmpty) {
        //         lista.add(pw.Container(child:wrap ) );
        //       } else {
        //         var gParent = lst.last as List<pw.Widget>;
        //         gParent.add(wrap);
        //       }
        //     }
        //   }
        // }
      }
    }
    return lista;
  }

//   List<pw.Widget> _getWidgetsFromListItems(List<ItemPdfBase> items,
//       Catalogo catalogo, ConfiguracionCatalogoInterno cfgCat) {
//     List<pw.Widget> lista = <pw.Widget>[];

//     // List<pw.Widget> itemsPdf = <pw.Widget>[];
// // pw.Wrap(
// //         alignment: pw.WrapAlignment.spaceEvenly,
// //         crossAxisAlignment: pw.WrapCrossAlignment.center,
// //         children: List<pw.Widget>.generate(grupo.items.length, (int index) {
// //           var item = grupo.items[index];
// //           return _getWidgetArticulo(item);
// //         }));
//     List<dynamic> lst = <dynamic>[];

//     if (items.isNotEmpty) {
//       for (var itemPdf in items) {
//         if (itemPdf is GrupoPdf) {
//           if (itemPdf.nombre.trim().isNotEmpty &&
//               cfgCat.configuracionGrupo.mostrarCabeceraGrupo &&
//               !cfgCat.configuracionGrupo.noAgrupar) {
//             var g = _getHeaderGrupoPdf(itemPdf, cfgCat);

//             lst.add(<pw.Widget>[g]);

//             //lista.add(w);
//           }
//         } else if (itemPdf is ItemPdf) {
//           var w = _getWidgetArticulo(itemPdf.item, cfgCat);
//           //lista.add(_getWidgetArticulo(itemPdf.item));
//           if (lst.isNotEmpty) {
//             var g = lst.last as List<pw.Widget>;

//             g.add(w);
//           } else {
//             lista.add(w);
//           }
//         } else if (itemPdf is FinGrupoPdf) {
//           if (lst.isNotEmpty) {
//             var g = lst.last as List<pw.Widget>;
//             lst.removeLast();
//             if (g.isNotEmpty) {
//               // pw.Wrap wrap =
//               //     pw.Wrap(alignment: pw.WrapAlignment.spaceEvenly, children: g);
//               pw.Wrap wrap = pw.Wrap(
//                   alignment: pw.WrapAlignment.spaceBetween,
//                   crossAxisAlignment: pw.WrapCrossAlignment.start,
//                   children: g);

//               if (lst.isEmpty) {
//                 lista.add(pw.Container(child:wrap ) );
//               } else {
//                 var gParent = lst.last as List<pw.Widget>;
//                 gParent.add(pw.Container(child:wrap ));
//               }
//             }
//           }
//         }
//       }
//     }
//     return lista;
//   }

  Future<void> _prepararFuentes(ConfiguracionCatalogoInterno cfgCat,
      List<FileSystemEntity> fuentes) async {
    _fontDescripcionArticulo = fuentes.getFont(
        cfgCat.fuenteDescripcionArticulo.fontFamily, pw.Font.times());
    _fontEncabezado =
        fuentes.getFont(cfgCat.encabezado.fuente.fontFamily, pw.Font.times());
    _fontPie = fuentes.getFont(cfgCat.pie.fuente.fontFamily, pw.Font.times());
    _fontPrecioArticulo = fuentes.getFont(
        cfgCat.fuentePrecioArticulo.fontFamily, pw.Font.times());
    _fontSkuArticulo =
        fuentes.getFont(cfgCat.fuenteSkuArticulo.fontFamily, pw.Font.times());
    _fontGrupo = fuentes.getFont(
        cfgCat.configuracionGrupo.fuente.fontFamily, pw.Font.times());
  }

  Future<void> _armarEstructuraPdf(
      List<ItemPdfBase> items,
      Catalogo catalogo,
      ConfiguracionCatalogoInterno cfgCat,
      List<FileSystemEntity> fuentes) async {
    var pageTheme = _getPageTheme(catalogo);
    // final font =
    //     GoogleFonts.getFont(cfgCat.fuenteDescripcionArticulo.fontFamily)
    //         .toString();
    await _prepararFuentes(cfgCat, fuentes);

    //final ttf = pw.Font.ttf();

    // _fontDescripcionArticulo = await FontLoader(cfgCat.fuenteDescripcionArticulo.fontFamily);
    //GoogleFonts.getFont(cfgCat.fuenteDescripcionArticulo.fontFamily, )
    bool primeraPaginaCreada = false;
    int cantItems =
        items.where((element) => (element is ItemPdf) == true).length;

    // if (cantItems > 50) {
    //   cantItems = 50;
    // }

    var listado = await _separarListadoItems(items, cantItems);

    for (var grupo in listado) {
      List<pw.Widget> widgets = <pw.Widget>[];

      widgets = _getWidgetsFromListItems(grupo, catalogo, cfgCat);
      if (widgets.isNotEmpty) {
        var mPages = pw.MultiPage(
          maxPages: 100,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          pageTheme: pageTheme,
          header: (pw.Context context) =>
              _header(context, catalogo, primeraPaginaCreada, cfgCat),
          footer: (pw.Context context) =>
              _footer(context, catalogo, primeraPaginaCreada, cfgCat),
          build: (pw.Context context) => <pw.Widget>[
            pw.Wrap(
              alignment: pw.WrapAlignment.center,
              crossAxisAlignment: pw.WrapCrossAlignment.start,
              runAlignment: pw.WrapAlignment.start,
              //direction: pw.Axis.horizontal,
              //verticalDirection: ,
              //crossAxisAlignment: pw.WrapCrossAlignment.start,
              children:
                  widgets, //_getChildrenFromGrupoCatalago(context, grpCat),
            ),
          ],
        );
        primeraPaginaCreada = true;
        _pdf.addPage(mPages);
      }

      //widgets.clear();
    }
  }

  Future<List<ItemPdfBase>> _crearItemsParaPDF(Catalogo catalogo) async {
    List<ItemPdfBase> items = <ItemPdfBase>[];

    for (var g0 = 0; g0 < catalogo.grupos.length; g0++) {
      var grupoN0 = catalogo.grupos[g0];

      if (grupoN0 is GranGrupoCatalogo) {
        var gItems0 =
            GrupoPdf(id: g0, idParent: -1, nombre: grupoN0.nombreGrupo.trim());

        if (gItems0.nombre.isNotEmpty) {
          gItems0.nivelGrupo = 0;
        }

        if (grupoN0.grupos.isNotEmpty || grupoN0.items.isNotEmpty) {
          items.add(gItems0);
        }
        if (grupoN0.grupos.isNotEmpty) {
          for (var g1 = 0; g1 < grupoN0.grupos.length; g1++) {
            var grupoN1 = grupoN0.grupos[g1];
            if (grupoN1.grupos.isNotEmpty &&
                grupoN1.grupos.firstWhereOrDefault(
                        (element) => element.items.isNotEmpty,
                        defaultValue: null) !=
                    null) {
              var gItems1 =
                  GrupoPdf(id: g1, idParent: g0, nombre: grupoN1.nombreGrupo);

              if (gItems1.nombre.isNotEmpty) {
                gItems1.nivelGrupo = gItems0.nivelGrupo + 1;
              }

              items.add(gItems1);
              gItems0.countItems++;

              for (var g2 = 0; g2 < grupoN1.grupos.length; g2++) {
                var grupoN2 = grupoN1.grupos[g2];
                if (grupoN2.items.isNotEmpty) {
                  var gItems2 = GrupoPdf(
                      id: g2, idParent: g1, nombre: grupoN2.nombreGrupo);

                  if (gItems2.nombre.isNotEmpty) {
                    gItems2.nivelGrupo = gItems1.nivelGrupo + 1;
                  }

                  items.add(gItems2);
                  gItems0.countItems++;
                  gItems1.countItems++;
                  for (var g3 = 0; g3 < grupoN2.items.length; g3++) {
                    var item = grupoN2.items[g3];
                    items.add(ItemPdf(
                        id: g3,
                        idParent: g2,
                        nombre: item.codigoArticulo,
                        item: item));
                    gItems0.countItems++;
                    gItems1.countItems++;
                    gItems2.countItems++;
                  }
                  items.add(FinGrupoPdf(
                      id: g2, idParent: g1, nombre: grupoN2.nombreGrupo));
                }
              }

              items.add(FinGrupoPdf(
                  id: g1, idParent: g0, nombre: grupoN1.nombreGrupo));
            }
          }
        }

        if (grupoN0.items.isNotEmpty) {
          for (var g1 = 0; g1 < grupoN0.items.length; g1++) {
            var grupoN1 = grupoN0.items[g1];
            if (grupoN1.items.isNotEmpty) {
              var gItems1 =
                  GrupoPdf(id: g1, idParent: g0, nombre: grupoN1.nombreGrupo);

              if (gItems1.nombre.isNotEmpty) {
                gItems1.nivelGrupo = gItems0.nivelGrupo + 1;
              }
              items.add(gItems1);
              gItems0.countItems++;

              for (var g2 = 0; g2 < grupoN1.items.length; g2++) {
                var item = grupoN1.items[g2];
                items.add(ItemPdf(
                    id: g2,
                    idParent: g1,
                    nombre: item.codigoArticulo,
                    item: item));
                gItems0.countItems++;
                gItems1.countItems++;
              }

              items.add(FinGrupoPdf(
                  id: g1, idParent: g0, nombre: grupoN1.nombreGrupo));
            }
          }
        }

        if (grupoN0.grupos.isNotEmpty || grupoN0.items.isNotEmpty) {
          items.add(
              FinGrupoPdf(id: g0, idParent: -1, nombre: grupoN0.nombreGrupo));
        }
      } else if (grupoN0 is GrupoCatalogo) {
        var gItems0 =
            GrupoPdf(id: g0, idParent: -1, nombre: grupoN0.nombreGrupo);

        if (grupoN0.grupos.isNotEmpty) {
          items.add(gItems0);
        }
        if (grupoN0.grupos.isNotEmpty) {
          for (var g1 = 0; g1 < grupoN0.grupos.length; g1++) {
            var grupoN1 = grupoN0.grupos[g1];
            if (grupoN1.items.isNotEmpty) {
              var gItems1 =
                  GrupoPdf(id: g1, idParent: g0, nombre: grupoN1.nombreGrupo);

              if (gItems1.nombre.isNotEmpty) {
                gItems1.nivelGrupo = gItems0.nivelGrupo + 1;
              }
              items.add(gItems1);
              gItems0.countItems++;

              for (var g2 = 0; g2 < grupoN1.items.length; g2++) {
                var item = grupoN1.items[g2];
                items.add(ItemPdf(
                    id: g2,
                    idParent: g1,
                    nombre: item.codigoArticulo,
                    item: item));
                gItems0.countItems++;
                gItems1.countItems++;
              }

              items.add(FinGrupoPdf(
                  id: g1, idParent: g0, nombre: grupoN1.nombreGrupo));
            }
          }
        }

        if (grupoN0.grupos.isNotEmpty) {
          items.add(
              FinGrupoPdf(id: g0, idParent: -1, nombre: grupoN0.nombreGrupo));
        }
      } else if (grupoN0 is GrupoItemsCatalogo) {
        var gItems0 =
            GrupoPdf(id: g0, idParent: -1, nombre: grupoN0.nombreGrupo);

        if (gItems0.nombre.isNotEmpty) {
          gItems0.nivelGrupo = 0;
        }

        if (grupoN0.items.isNotEmpty) {
          items.add(gItems0);
        }
        if (grupoN0.items.isNotEmpty) {
          for (var g1 = 0; g1 < grupoN0.items.length; g1++) {
            var item = grupoN0.items[g1];
            items.add(ItemPdf(
                id: g1, idParent: g0, nombre: item.codigoArticulo, item: item));
            gItems0.countItems++;
          }
        }

        if (grupoN0.items.isNotEmpty) {
          items.add(
              FinGrupoPdf(id: g0, idParent: -1, nombre: grupoN0.nombreGrupo));
        }
      }
    }
    return items;
  }

  Future<ResultadoPdf> generarPDF(
      String folder,
      Catalogo catalogo,
      ConfiguracionCatalogoInterno cfgCat,
      List<FileSystemEntity> fuentes) async {
    //_crearPDF(catalogo);
    bool result = false;
    String pathS = "";
    var listado = await _crearItemsParaPDF(catalogo);
    if (listado.isNotEmpty) {
      await _armarEstructuraPdf(listado, catalogo, cfgCat, fuentes);

      pathS = folder + p.separator + catalogo.fileName;

      result = await _guardarPdf(pathS);
    } else {
      pathS = "${catalogo.fileName}: Sin artículos con imágenes para generar";
      result = false;
    }
    ResultadoPdf res = ResultadoPdf(pathS, result, catalogo.fileName);

    return res;
  }

  Future<bool> _guardarPdf(String path) async {
    try {
      File file = File(path);
      var result = await _pdf.save();
      file.writeAsBytesSync(result);
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
