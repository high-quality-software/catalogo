import 'package:catalog_app/modelos/catalogo/catalogo.dart';
import 'package:catalog_app/modelos/configuracion_fuentes.dart';
import 'package:catalog_app/modelos/fuente_pdf.dart';
import 'package:catalog_app/providers/configuracion_provider.dart';
// import 'package:catalog_app/providers/loading_provider.dart';
import 'package:catalog_app/utilidades/messagebox.dart';
import 'package:darq/darq.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_font_picker/flutter_font_picker.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:list_picker/list_picker.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import '../providers/loading_provider.dart';
import '../utilidades/utiles.dart';
import 'simple_iconbutton_font_downloader_widget.dart';

// ignore: camel_case_types
enum eModoSimpleFontSizeAndColor { vertical, horizontal }

// ignore: must_be_immutable
class SimpleFontSizeAndColorWidget extends StatefulWidget {
  SimpleFontSizeAndColorWidget(
      {Key? key,
      required this.config,
      required this.folderFonts,
      this.modo = eModoSimpleFontSizeAndColor.horizontal})
      : super(key: key);

  late FontConfig? config;
  late String folderFonts;

  late eModoSimpleFontSizeAndColor modo =
      eModoSimpleFontSizeAndColor.horizontal;

  @override
  State<SimpleFontSizeAndColorWidget> createState() =>
      _SimpleFontSizeAndColorWidgetState();
}

class _SimpleFontSizeAndColorWidgetState
    extends State<SimpleFontSizeAndColorWidget> {
  late List<FuentePdf> _fuentes;
  final List<String> _myGoogleFonts = [];

  final _ctlFuente = TextEditingController();
  @override
  void initState() {
    super.initState();

    _ctlFuente.text = widget.config!.fontFamily;
    _obtenerFuentes();
  }

  Future<void> _obtenerFuentes() async {
    _fuentes = await Utiles.obtenerFuentesTTF_paraPDF(widget.folderFonts);

    _myGoogleFonts.clear();

    for (var f in _fuentes) {
      _myGoogleFonts.add(f.nombre);
    }

    if (_myGoogleFonts.firstWhereOrDefault(
            (element) =>
                element.toLowerCase() ==
                widget.config!.fontFamily.toLowerCase(),
            defaultValue: null) !=
        null) {
      var f = _fuentes.first;

      widget.config!.fontFamily = f.nombre;
      widget.config!.fontName = f.fuente.fontName;
    }

    _ctlFuente.text = widget.config!.fontFamily;
  }

  @override
  void dispose() {
    _ctlFuente.dispose();
    super.dispose();
  }

  Widget _getFontSelector(BuildContext context, FontConfig fuente) {
    var loadingProvider = Provider.of<LoadingProvider>(context);
    var cfgProvider = Provider.of<ConfiguracionProvider>(context);
    var cfgFuentes = cfgProvider.configuracionFuentes;

    TextStyle style = TextStyle(
      // fontFamily: fontFamily,
      // fontStyle: estilo, // widget.config!.fontStyle,
      fontWeight: widget.config!.negrita ? FontWeight.bold : FontWeight.normal,
    );

    if (fuente.fontName.isNotEmpty) {
      try {
        var f = cfgFuentes.fuentesInstaladas.firstWhereOrDefault((value) =>
            value.fontFamilyVariants.firstWhereOrDefault(
                (subvalue) => subvalue == fuente.fontFamily,
                defaultValue: null) !=
            null);

        if (f != null) {
          style = GoogleFonts.getFont(f.fontFamily,
              fontStyle: f.fontStyle,
              fontWeight:
                  widget.config!.negrita ? FontWeight.bold : FontWeight.normal,
              fontSize: 14);
        }
        // ignore: empty_catches
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    return TextField(
      controller: _ctlFuente,
      readOnly: true,
      style: style,
      decoration: InputDecoration(
          labelText: 'Fuente',
          hintText: "Fuente",
          prefixIcon: IconButton(
              tooltip: "Seleccionar Fuente Google",
              icon: const Icon(Icons.font_download),
              onPressed: () async {
                if (_myGoogleFonts.isEmpty) {
                  await MessageBox.mostrar(
                      // context: context,
                      titulo: "Fuentes",
                      mensaje:
                          "No se encontraron fuentes configuradas.\nPor favor verifique la carpeta de fuentes que esté correctamente configurada y que hayan fuentes .ttf",
                      botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
                      tipo: eMessageBoxType.error);
                } else if (_myGoogleFonts.isNotEmpty) {
                  String? fuente = await showDialog(
                    context: context,
                    builder: (context) => Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        title: const Text('Selección de Fuentes'),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(18),
                          ),
                        ),
                        //backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      body: ListPickerDialog(
                        label: "Font",
                        items: _myGoogleFonts,
                      ),
                    ),
                  );

                  if (fuente != null) {
                    setState(() {
                      var fuentePdf = _fuentes.firstWhereOrDefault(
                          (value) => value.nombre == fuente,
                          defaultValue: null);

                      if (fuentePdf != null) {
                        _ctlFuente.text = fuente; //.fontFamily;
                        widget.config!.fontFamily = fuente;
                        widget.config!.fontName = fuentePdf.fuente.fontName;
                        widget.config!.nameFile = fuentePdf.file.path;
                      }
                    });
                  }
                }
              }),
          suffixIcon: widget.folderFonts.isEmpty
              ? null
              : SimpleIconButtonFontDownloaderWidget(
                  folderDownload: widget.folderFonts,
                  onFontAllDeleted: () async {
                    setState(() {
                      widget.config!.fontFamily = "";
                      widget.config!.fontName = "";
                      widget.config!.fontStyle = FontStyle.normal;
                      widget.config!.nameFile = "";
                      _ctlFuente.text = "";
                    });
                    loadingProvider.openLoading("Cargando fuentes...");
                    await Future.delayed(const Duration(milliseconds: 100));
                    await _obtenerFuentes();
                    await Future.delayed(const Duration(milliseconds: 100));
                    loadingProvider.closeLoading();
                  },
                  onFontDownloaded: () async {
                    loadingProvider.openLoading("Cargando fuentes...");
                    await Future.delayed(const Duration(milliseconds: 100));
                    await _obtenerFuentes();
                    await Future.delayed(const Duration(milliseconds: 100));
                    loadingProvider.closeLoading();
                  },
                )
          // suffixIcon: _ctlFuente.text.isEmpty
          //     ? null
          //     : IconButton(
          //         icon: const Icon(Icons.clear),
          //         onPressed: () => setState(() {
          //           _ctlFuente.text = "";
          //           widget.config!.fontFamily = "";
          //         }),
          //       )
          ),
    );
  }

  Widget _getWidgetSegunModo(BuildContext context) {
    if (widget.modo == eModoSimpleFontSizeAndColor.horizontal) {
      return Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.max,
        children: [
          _getFontSelector(context, widget.config!),
          Row(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(child: Text("Color: ")),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 25, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0) //
                                    ),
                          ),
                          child: ColorIndicator(
                            width: 20,
                            height: 20,
                            borderRadius: 4,
                            color: widget.config == null
                                ? Colors.black
                                : widget.config!.color,
                            onSelectFocus: false,
                            onSelect: () async {
                              var colorSelected =
                                  await Utiles.colorPickerDialog(
                                      context, widget.config!.color);
                              if (colorSelected != null) {
                                setState(() {
                                  // ignore: prefer_conditional_assignment

                                  widget.config!.color = colorSelected;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Switch(
                        value: widget.config!.negrita,
                        onChanged: (value) {
                          setState(() {
                            widget.config!.negrita = value;
                          });
                        }),
                    const Text("Negrita")
                  ]),
                ],
              ),
              Expanded(
                child: SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SpinBox(
                      max: 24.0,
                      min: 4.0,
                      value: widget.config!.size, //5.0,
                      //widget.config == null ? 12.0 : widget.config!.size,
                      decimals: 2,
                      step: 0.1,
                      onChanged: (value) {
                        setState(() {
                          widget.config!.size = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Ingrese el tamaño de la fuente",
                        hintText: "Ingrese el tamaño de la fuente",
                        // icon: Icon(Icons.format_size)
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: SizedBox(
                //width: 250,
                child: _getFontSelector(context, widget.config!)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(child: Text("Color: ")),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(4.0) //
                        ),
                  ),
                  child: ColorIndicator(
                    width: 30,
                    height: 30,
                    borderRadius: 4,
                    color: widget.config == null
                        ? Colors.black
                        : widget.config!.color,
                    onSelectFocus: false,
                    onSelect: () async {
                      var colorSelected = await Utiles.colorPickerDialog(
                          context, widget.config!.color);
                      if (colorSelected != null) {
                        setState(() {
                          // ignore: prefer_conditional_assignment

                          widget.config!.color = colorSelected;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          // ignore: avoid_unnecessary_containers
          Container(
            //width: 200,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SpinBox(
                max: 30.0,
                value: widget.config!.size, //5.0,
                //widget.config == null ? 12.0 : widget.config!.size,
                decimals: 2,
                step: 0.1,
                decoration: const InputDecoration(
                  labelText: "Ingrese el tamaño de la fuente",
                  hintText: "Ingrese el tamaño de la fuente",
                  // icon: Icon(Icons.format_size)
                ),
              ),
            ),
          ),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Switch(
                value: widget.config!.negrita,
                onChanged: (value) {
                  setState(() {
                    widget.config!.negrita = value;
                  });
                }),
            const Text("Negrita")
          ]),
        ],
      );
      // return Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     Container(
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: SizedBox(
      //             width: 250, child: _getFontSelector(context, widget.config!)),
      //       ),
      //     ),
      //     Container(
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         mainAxisSize: MainAxisSize.max,
      //         children: [
      //           const SizedBox(child: Text("Color: ")),
      //           Padding(
      //             padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
      //             child: Container(
      //               decoration: BoxDecoration(
      //                 border: Border.all(),
      //                 borderRadius:
      //                     const BorderRadius.all(Radius.circular(4.0) //
      //                         ),
      //               ),
      //               child: ColorIndicator(
      //                 width: 50,
      //                 height: 50,
      //                 borderRadius: 4,
      //                 color: widget.config == null
      //                     ? Colors.black
      //                     : widget.config!.color,
      //                 onSelectFocus: false,
      //                 onSelect: () async {
      //                   var colorSelected = await Utiles.colorPickerDialog(
      //                       context, widget.config!.color);
      //                   if (colorSelected != null) {
      //                     setState(() {
      //                       // ignore: prefer_conditional_assignment

      //                       widget.config!.color = colorSelected;
      //                     });
      //                   }
      //                 },
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Container(
      //       width: 200,
      //       child: Padding(
      //         padding: const EdgeInsets.all(16.0),
      //         child: SpinBox(
      //           max: 30.0,
      //           value: widget.config!.size, //5.0,
      //           //widget.config == null ? 12.0 : widget.config!.size,
      //           decimals: 2,
      //           step: 0.1,
      //           decoration: const InputDecoration(
      //             labelText: "Ingrese el tamaño de la fuente",
      //             hintText: "Ingrese el tamaño de la fuente",
      //             // icon: Icon(Icons.format_size)
      //           ),
      //         ),
      //       ),
      //     ),
      //     Row(mainAxisSize: MainAxisSize.min, children: [
      //       Switch(
      //           value: widget.config!.negrita,
      //           onChanged: (value) {
      //             setState(() {
      //               widget.config!.negrita = value;
      //             });
      //           }),
      //       const Text("Negrita")
      //     ]),
      //   ],
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.config ??= FontConfig();

    return AbsorbPointer(
      absorbing: !ConfiguracionFuentes.fuentesActivo,
      child: Opacity(
        opacity: ConfiguracionFuentes.fuentesActivo ? 1.0 : 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(2.0),
                child: _getWidgetSegunModo(context)),
          ],
        ),
      ),
    );
  }
}
