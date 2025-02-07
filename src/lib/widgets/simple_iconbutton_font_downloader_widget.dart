import 'dart:io';

import 'package:catalog_app/modelos/configuracion_fuentes.dart';
import 'package:catalog_app/providers/configuracion_provider.dart';
import 'package:catalog_app/providers/loading_provider.dart';
import 'package:catalog_app/utilidades/utiles.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../utilidades/messagebox.dart';

class SimpleIconButtonFontDownloaderWidget extends StatefulWidget {
  SimpleIconButtonFontDownloaderWidget(
      {Key? key,
      required this.folderDownload,
      this.onFontDownloaded,
      this.onFontAllDeleted})
      : super(key: key);
  final String folderDownload;
  final VoidCallback? onFontDownloaded;
  final VoidCallback? onFontAllDeleted;
  final List<String> _googleFonts = [
    //];
    "Abril Fatface",
    "Aclonica",
    "Alegreya Sans",
    "Architects Daughter",
    "Archivo",
    "Archivo Narrow",
    "Bebas Neue",
    "Bitter",
    "Bree Serif",
    "Bungee",
    "Cabin",
    "Cairo",
    "Coda",
    "Comfortaa",
    "Comic Neue",
    "Cousine",
    "Croissant One",
    "Faster One",
    "Forum",
    "Great Vibes",
    "Heebo",
    "Inconsolata",
    "Josefin Slab",
    "Lato",
    "Libre Baskerville",
    "Lobster",
    "Lora",
    "Merriweather",
    "Montserrat",
    "Mukta",
    "Nunito",
    "Offside",
    "Open Sans",
    "Oswald",
    "Overlock",
    "Pacifico",
    "Playfair Display",
    "Poppins",
    "Raleway",
    "Roboto",
    "Roboto Mono",
    "Source Sans Pro",
    "Space Mono",
    "Spicy Rice",
    "Squada One",
    "Sue Ellen Francisco",
    "Trade Winds",
    "Ubuntu",
    "Varela",
    "Vollkorn",
    "Work Sans",
    "Zilla Slab"
  ];
  @override
  State<SimpleIconButtonFontDownloaderWidget> createState() =>
      _SimpleIconButtonFontDownloaderWidgetState();
}

class _SimpleIconButtonFontDownloaderWidgetState
    extends State<SimpleIconButtonFontDownloaderWidget> {
  late ConfiguracionFuentes _configuracionFuentes;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cfgProvider = Provider.of<ConfiguracionProvider>(context);
    var loadingProvider = Provider.of<LoadingProvider>(context);

    _configuracionFuentes = cfgProvider.configuracionFuentes;

    // ignore: sized_box_for_whitespace
    return Container(
      width: 100,
      child: Row(
        children: [
          IconButton(
              tooltip: "Descargar Fuente Google",
              icon: const Icon(Icons.download_for_offline),
              onPressed: () async {
                var currentFont = widget._googleFonts.first;
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: SingleChildScrollView(
                      child: SizedBox(
                        width: double.maxFinite,
                        child: FontPicker(
                            showInDialog: true,
                            initialFontFamily: currentFont,
                            onFontChanged: (font) async {
                              loadingProvider
                                  .openLoading("Descargando fuente...");
                              await Future.delayed(
                                  const Duration(milliseconds: 50));
                              try {
                                var result =
                                    await font.descargarFuenteDesdeGoogle(
                                        widget.folderDownload);
                                await Future.delayed(
                                    const Duration(milliseconds: 50));
                                loadingProvider.closeLoading();
                                await Future.delayed(
                                    const Duration(milliseconds: 200));

                                if (result.ok && result.files != null) {
                                  var fontGoogle = _configuracionFuentes
                                      .fuentesInstaladas
                                      .firstWhereOrDefault(
                                          (element) =>
                                              element.fontFamily ==
                                              font.fontFamily,
                                          defaultValue: null);

                                  if (fontGoogle == null) {
                                    fontGoogle = FuenteGoogle()
                                      ..category = font.category
                                      ..fontFamily = font.fontFamily
                                      ..fontStyle = font.fontStyle
                                      ..fontWeight = font.fontWeight
                                      ..files = result.files!
                                      ..fontFamilyVariants = result.files!
                                          .select((element, index) =>
                                              basenameWithoutExtension(element))
                                          .toList()
                                      ..zipFile = result.zipFile;

                                    _configuracionFuentes.fuentesInstaladas
                                        .add(fontGoogle);
                                    await cfgProvider
                                        .guardarConfiguracionFuentes(
                                            _configuracionFuentes);

                                    if (widget.onFontDownloaded != null) {
                                      widget.onFontDownloaded!.call();
                                    }
                                  }
                                  // ignore: use_build_context_synchronously
                                  await MessageBox.mostrar(
                                      // context: context,
                                      titulo: "Descarga de Fuentes",
                                      mensaje: "La fuente '${font.fontFamily}' fue descargada correctamente.",
                                      botones: <eMessageBoxButton>[
                                        eMessageBoxButton.aceptar
                                      ],
                                      tipo: eMessageBoxType.info);
                                } else {
                                  // ignore: use_build_context_synchronously
                                  await MessageBox.mostrar(
                                      // context: context,
                                      titulo: "Descarga de Fuentes",
                                      mensaje:
                                          "Ocurrió un error al descargar la fuente '${font.fontFamily}'.",
                                      botones: <eMessageBoxButton>[
                                        eMessageBoxButton.aceptar
                                      ],
                                      tipo: eMessageBoxType.error);
                                }
                              } catch (e) {
                                  // ignore: use_build_context_synchronously
                                await MessageBox.mostrar(
                                    // context: context,
                                    titulo: "Descarga de Fuentes",
                                    mensaje:
                                        "Ocurrió un error al descargar la fuente '${font.fontFamily}'.\nDescripcion del error: $e",
                                    botones: <eMessageBoxButton>[
                                      eMessageBoxButton.aceptar
                                    ],
                                    tipo: eMessageBoxType.error);
                              }

                              setState(() {});
                            },
                            googleFonts: widget._googleFonts),
                      ),
                    ));
                  },
                );
              }),
          IconButton(
              tooltip: "Borrar todas las fuentes descargadas",
              onPressed: () async {
                var result = await MessageBox.mostrar(
                    // context: context,
                    titulo: "Borrado de Fuentes",
                    mensaje:
                        "Se encuentra seguro de borrar todas las fuentes instaladas?",
                    botones: <eMessageBoxButton>[
                      eMessageBoxButton.si,
                      eMessageBoxButton.no
                    ],
                    tipo: eMessageBoxType.question);
                if (result == eMessageBoxButton.si) {
                  var fuentes = _configuracionFuentes.fuentesInstaladas;

                  for (var f in fuentes) {
                    var file = File(f.zipFile);
                    if (await file.exists()) {
                      await file.delete();
                    }
                    if (f.files.isNotEmpty) {
                      for (var f1 in f.files) {
                        var file1 = File(f1);
                        if (await file1.exists()) {
                          await file1.delete();
                        }
                      }
                    }
                  }
                  _configuracionFuentes.fuentesInstaladas.clear();
                  cfgProvider
                      .guardarConfiguracionFuentes(_configuracionFuentes);
                  setState(() {
                    _configuracionFuentes = cfgProvider.configuracionFuentes;
                    if (widget.onFontAllDeleted != null) {
                      widget.onFontAllDeleted!.call();
                    }
                  });
                }
              },
              icon: const Icon(Icons.delete_forever))
        ],
      ),
    );
  }
}
