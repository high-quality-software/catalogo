import 'dart:io';

// import 'package:catalog_app/providers/loading_provider.dart';
// import 'package:catalog_app/utilidades/messagebox.dart';
import 'package:catalog_app/modelos/configuracion_fuentes.dart';
import 'package:catalog_app/widgets/simple_calculo_matematico_widget.dart';
import 'package:catalog_app/widgets/simple_font_size_and_color_widget.dart';
import 'package:catalog_app/widgets/simple_iconbutton_font_downloader_widget.dart';
import 'package:catalog_app/widgets/simple_tab_view.dart';
// import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
// import 'package:flutter_font_picker/flutter_font_picker.dart';
// import 'package:group_radio_button/group_radio_button.dart';
// import 'package:provider/provider.dart';

import '../../../modelos/configuracion_catalogo.dart';
import '../../../utilidades/utiles.dart';
import '../../simple_image_widget.dart';

class ConfigCatalogoGral extends StatefulWidget {
  const ConfigCatalogoGral({Key? key, required this.configuracionCatalogo})
      : super(key: key);
  final ConfiguracionCatalogo configuracionCatalogo;

  @override
  State<ConfigCatalogoGral> createState() => _ConfigCatalogoGralState();
}

class _ConfigCatalogoGralState extends State<ConfigCatalogoGral> {
  final _ctlFolderImagenes = TextEditingController();

  final _ctlFolderCSV = TextEditingController();

  final _ctlFolderPDF = TextEditingController();

  final _ctlFolderFuentes = TextEditingController();
  final _ctlSimboloMoneda = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctlFolderCSV.text = widget.configuracionCatalogo.folderCsv;
    _ctlFolderImagenes.text = widget.configuracionCatalogo.folderImagenes;
    _ctlFolderPDF.text = widget.configuracionCatalogo.folderSalidaPDF;
    _ctlFolderFuentes.text = widget.configuracionCatalogo.folderFuentes;
    _ctlSimboloMoneda.text = widget.configuracionCatalogo.simboloMoneda;
  }

  @override
  Widget build(BuildContext context) {
    double ancho = 200;
    double alto = 180;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SimpleTabView(
                contentHeight: 400,
                itemCount: 5,
                tabBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return const Tab(
                        text: "Artículo",
                      );
                    case 1:
                      return const Tab(
                        text: "Precio",
                      );
                    case 2:
                      return const Tab(
                        text: "SKU",
                      );
                    case 3:
                      return const Tab(text: "Carpetas");
                    case 4:
                      return const Tab(text: "Ofertas");

                    default:
                      return Tab();
                  }
                },
                pageBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return _getTabArticulos(
                          ancho, alto); //_getConfiguracionGeneral();
                    case 1:
                      return _getTabPrecios(ancho, alto);
                    case 2:
                      return _getTabSKU(ancho);
                    case 3:
                      return _getTabCarpetas(context);
                    case 4:
                      return _getTabOfertas(alto, ancho);
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTabSKU(double ancho) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: ancho * 2,
          //height: 210,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                    child: Center(child: Text("Texto del SKU de Artículo")),
                  ),
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                  ),
                  SizedBox(
                    width: ancho * 3,
                    child: SimpleFontSizeAndColorWidget(
                      folderFonts: widget.configuracionCatalogo.folderFuentes,
                      config: widget.configuracionCatalogo.fuenteSkuArticulo,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _getTabArticulos(double ancho, double alto) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: ancho * 1.5,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Switch(
                    value: widget.configuracionCatalogo.mostrarChartDeArticulos,
                    onChanged: (value) {
                      setState(() {
                        widget.configuracionCatalogo.mostrarChartDeArticulos =
                            value;
                      });
                    }),
                const Text("Mostrar Chart de Artículos")
              ]),
        ),
        SizedBox(
          width: ancho * 1.5,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Switch(
                    value:
                        widget.configuracionCatalogo.mostrarDescripcionArticulo,
                    onChanged: (value) {
                      setState(() {
                        widget.configuracionCatalogo
                            .mostrarDescripcionArticulo = value;
                      });
                    }),
                const Text("Mostrar descripción de artículos")
              ]),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: ancho * 1.5,
              height: alto * 1.55,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 10, 8, 8),
                        child: Center(
                            child: Text("Texto de la Descripción de Artículo")),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                      ),
                      SizedBox(
                        width: ancho * 3,
                        height: alto,
                        child: SimpleFontSizeAndColorWidget(
                          folderFonts:
                              widget.configuracionCatalogo.folderFuentes,
                          config: widget
                              .configuracionCatalogo.fuenteDescripcionArticulo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: ancho * 1.5,
              height: alto * 1.55,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  elevation: 10,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 10, 8, 8),
                        child: Center(
                            child: Text("Tamaño del Widget de Artículo")),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                        //height: 4,
                      ),
                      SizedBox(
                          width: ancho * 2,
                          height: alto * 1.15,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: SpinBox(
                                  textStyle: const TextStyle(fontSize: 14),
                                  //spacing: 1,
                                  max: 9999.0,
                                  min: 130.0,
                                  value: widget.configuracionCatalogo
                                              .altoWidgetArticulo <
                                          130
                                      ? 130
                                      : widget.configuracionCatalogo
                                          .altoWidgetArticulo, //5.0,
                                  //widget.config == null ? 12.0 : widget.config!.size,
                                  decimals: 2,
                                  step: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.configuracionCatalogo
                                          .altoWidgetArticulo = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Ingrese el Alto",
                                    hintText: "Ingrese el Alto",
                                    // icon: Icon(Icons.format_size)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: SpinBox(
                                  textStyle: const TextStyle(fontSize: 14),
                                  max: 9999.0,
                                  min: 130.0,
                                  value: widget.configuracionCatalogo
                                              .anchoWidgetArticulo <
                                          130
                                      ? 130
                                      : widget.configuracionCatalogo
                                          .anchoWidgetArticulo, //5.0,
                                  //widget.config == null ? 12.0 : widget.config!.size,
                                  decimals: 2,
                                  step: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.configuracionCatalogo
                                          .anchoWidgetArticulo = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Ingrese el Ancho",
                                    hintText: "Ingrese el Ancho",
                                    // icon: Icon(Icons.format_size)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: SpinBox(
                                  textStyle: const TextStyle(fontSize: 14),
                                  max: 70.0,
                                  min: 30.0,
                                  value: widget.configuracionCatalogo
                                              .porcentajeAltoImagenArticulo <
                                          70
                                      ? 70
                                      : widget.configuracionCatalogo
                                          .porcentajeAltoImagenArticulo, //5.0,
                                  //widget.config == null ? 12.0 : widget.config!.size,
                                  decimals: 2,
                                  step: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.configuracionCatalogo
                                          .porcentajeAltoImagenArticulo = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText:
                                        "Porcentaje del Alto de la Imagen",
                                    hintText:
                                        "Porcentaje del Alto de la Imagen",
                                    // icon: Icon(Icons.format_size)
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
        // Card(
        //   child: Row(
        //     children: [
        //       SimpleFontSizeAndColor(
        //           config:
        //               widget.configuracionCatalogo.fuenteDescripcionArticulo)
        //     ],
        //   ),
        // )
      ],
    );
  }

  Widget _getTabPrecios(double ancho, double alto) {
    double alto2 = alto * 1.9;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 250,
                height: 50,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Switch(
                      value: widget.configuracionCatalogo.mostrarPrecioEnChart,
                      onChanged: (value) {
                        setState(() {
                          widget.configuracionCatalogo.mostrarPrecioEnChart =
                              value;
                        });
                      }),
                  const Text("Mostrar precio")
                ]),
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: TextField(
                    controller: _ctlSimboloMoneda,
                    onChanged: (value) {
                      setState(() {
                        widget.configuracionCatalogo.simboloMoneda = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Símbolo de moneda',
                      suffixIcon: _ctlSimboloMoneda.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.configuracionCatalogo.simboloMoneda =
                                      "";
                                  _ctlSimboloMoneda.text = "";
                                });
                              },
                              icon: const Icon(Icons.clear)),
                    )),
              ),
            ],
          ),
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: ancho * 3,
              height: alto2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 10,
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    //height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                          child: Center(
                              child: Text(
                                  "Precio de catálogo (debe excluir en el cálculo la bonificación.)")),
                        ),
                        const Divider(
                          indent: 15,
                          endIndent: 15,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Flex(
                              direction: Axis.vertical,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SimpleCalculoMatematicoWidget(
                                  calculo: widget
                                      .configuracionCatalogo.calculoPrecio,
                                  titulo:
                                      "Cálculo de Precio a mostrar en catálogo.",
                                  onChanged: (value) {
                                    setState(() {
                                      widget.configuracionCatalogo
                                          .calculoPrecio = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: ancho * 2,
              height: alto2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 10,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                        child:
                            Center(child: Text("Texto del Precio de Artículo")),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                      ),
                      SizedBox(
                        width: ancho * 3,
                        child: SimpleFontSizeAndColorWidget(
                          folderFonts:
                              widget.configuracionCatalogo.folderFuentes,
                          config:
                              widget.configuracionCatalogo.fuentePrecioArticulo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _getTabCarpetas(BuildContext context) {
    // var loadingProvider = Provider.of<LoadingProvider>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AbsorbPointer(
            absorbing: !ConfiguracionFuentes.fuentesActivo,
            child: Opacity(
              opacity: ConfiguracionFuentes.fuentesActivo ? 1.0 : 0.5,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  controller: _ctlFolderFuentes,
                  readOnly: true,
                  //style: TextStyle(fontFamily:  ),
                  decoration: InputDecoration(
                      labelText: 'Carpeta de Fuentes',
                      prefixIcon: IconButton(
                          icon: const Icon(Icons.search_rounded),
                          onPressed: () async {
                            Directory? selectedDirectory =
                                Directory(_ctlFolderFuentes.text);
                            if (!(await selectedDirectory.exists())) {
                              selectedDirectory = Directory.current;
                            }

                            var dir = await Utiles.seleccionarCarpeta(
                                "Carpeta de Fuentes",
                                // context,
                                selectedDirectory);

                            if (dir != null && await dir.exists()) {
                              setState(() {
                                widget.configuracionCatalogo.folderFuentes =
                                    dir.path;
                                _ctlFolderFuentes.text = dir.path;
                              });
                            }
                          }),
                      suffixIcon: _ctlFolderFuentes.text.isEmpty
                          ? null
                          : SimpleIconButtonFontDownloaderWidget(
                              folderDownload: _ctlFolderFuentes.text)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _ctlFolderCSV,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Carpeta Origen de CSV',
                  prefixIcon: IconButton(
                      icon: const Icon(Icons.search_rounded),
                      onPressed: () async {
                        Directory? selectedDirectory =
                            Directory(_ctlFolderCSV.text);
                        if (!(await selectedDirectory.exists())) {
                          selectedDirectory = Directory.current;
                        }

                        var dir = await Utiles.seleccionarCarpeta(
                            "Origen de achivos CSV",
                            // context,
                            selectedDirectory);

                        if (dir != null && await dir.exists()) {
                          setState(() {
                            widget.configuracionCatalogo.folderCsv = dir.path;
                            _ctlFolderCSV.text = dir.path;
                          });
                        }
                      }),
                  suffixIcon: _ctlFolderCSV.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                            _ctlFolderCSV.text = "";
                            widget.configuracionCatalogo.folderCsv = "";
                          }),
                        )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _ctlFolderImagenes,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Carpeta Origen de Imágenes',
                  prefixIcon: IconButton(
                      icon: const Icon(Icons.search_rounded),
                      onPressed: () async {
                        Directory? selectedDirectory =
                            Directory(_ctlFolderImagenes.text);
                        if (!(await selectedDirectory.exists())) {
                          selectedDirectory = Directory.current;
                        }

                        var dir = await Utiles.seleccionarCarpeta(
                            "Origen de Imágenes",  selectedDirectory);

                        if (dir != null && await dir.exists()) {
                          setState(() {
                            widget.configuracionCatalogo.folderImagenes =
                                dir.path;
                            _ctlFolderImagenes.text = dir.path;
                          });
                        }
                      }),
                  suffixIcon: _ctlFolderImagenes.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                            _ctlFolderImagenes.text = "";
                            widget.configuracionCatalogo.folderImagenes = "";
                          }),
                        )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: _ctlFolderPDF,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Carpeta destino de Catálogo PDF',
                  prefixIcon: IconButton(
                      icon: const Icon(Icons.search_rounded),
                      onPressed: () async {
                        Directory? selectedDirectory =
                            Directory(_ctlFolderPDF.text);

                        if (!(await selectedDirectory.exists())) {
                          selectedDirectory = Directory.current;
                        }

                        var dir = await Utiles.seleccionarCarpeta(
                            "Destino de Catálogo PDF",
                            // context,
                            selectedDirectory);

                        if (dir != null && await dir.exists()) {
                          setState(() {
                            widget.configuracionCatalogo.folderSalidaPDF =
                                dir.path;
                            _ctlFolderPDF.text = dir.path;
                          });
                        }
                      }),
                  suffixIcon: _ctlFolderPDF.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                            _ctlFolderPDF.text = "";
                            widget.configuracionCatalogo.folderSalidaPDF = "";
                          }),
                        )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTabOfertas(double alto, double ancho) {
    double alto2 = alto * 1.6;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Switch(
              value: widget.configuracionCatalogo.mostrarAvisoOferta,
              onChanged: (value) {
                setState(() {
                  widget.configuracionCatalogo.mostrarAvisoOferta = value;
                });
              }),
          const Text("Mostrar aviso de oferta")
        ]),
        Expanded(
            child: Row(
          children: [
            widget.configuracionCatalogo.mostrarAvisoOferta
                ? Card(
                    elevation: 10,
                    child: SizedBox(
                      width: ancho * 3,
                      height: alto2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Precio bonificado"),
                          const Divider(
                            indent: 5,
                            endIndent: 5,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Flex(
                                direction: Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SimpleCalculoMatematicoWidget(
                                    calculo: widget.configuracionCatalogo
                                        .calculoPrecioBonificado,
                                    titulo: "Cálculo de Precio bonificado.",
                                    onChanged: (value) {
                                      setState(() {
                                        widget.configuracionCatalogo
                                            .calculoPrecioBonificado = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    width: ancho,
                    height: alto2,
                  ),
            widget.configuracionCatalogo.mostrarAvisoOferta
                ? Card(
                    elevation: 5,
                    // ignore: sized_box_for_whitespace
                    child: Container(
                      height: alto2,
                      width: 300,
                      child: Column(
                        //mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // const Text("Tipo de Descuento"),
                          // const Divider(
                          //   indent: 5,
                          //   endIndent: 5,
                          // ),
                          // RadioGroup<eTipoDescuento>.builder(
                          //   groupValue:
                          //       widget.configuracionCatalogo.tipoDescuento,
                          //   onChanged: (value) => setState(() {
                          //     widget.configuracionCatalogo.tipoDescuento =
                          //         value!;
                          //   }),
                          //   items: eTipoDescuento.values,
                          //   itemBuilder: (item) {
                          //     String value = "";
                          //     switch (item) {
                          //       case eTipoDescuento.importe:
                          //         value = "Por Importe";
                          //         break;
                          //       case eTipoDescuento.porcentaje:
                          //         value = "Por Porcentaje";
                          //         break;
                          //       default:
                          //         value = "No aplicar los descuentos";
                          //     }
                          //     return RadioButtonBuilder(
                          //       value,
                          //       textPosition: RadioButtonTextPosition.right,
                          //     );
                          //   },
                          // ),
                          // const Divider(
                          //   height: 2,
                          //   indent: 5,
                          //   endIndent: 5,
                          // ),
                          Row(children: [
                            Switch(
                                value: widget.configuracionCatalogo
                                    .mostrarPrecioOriginalTachado,
                                onChanged: (value) {
                                  setState(() {
                                    widget.configuracionCatalogo
                                        .mostrarPrecioOriginalTachado = value;
                                  });
                                }),
                            const Text("Mostrar precio original tachado?")
                          ]),
                        ],
                      ),
                    ),
                  )
                :
                // ignore: sized_box_for_whitespace
                Container(
                    height: alto2,
                    width: ancho,
                  ),
            Expanded(
              child: widget.configuracionCatalogo.mostrarAvisoOferta
                  ? SimpleImageWidget(
                      titulo: "Imagen de Oferta",
                      width: ancho,
                      height: alto2,
                      initialImageUrl:
                          widget.configuracionCatalogo.urlLogoOferta,
                      onImageChanged: (url, data) {
                        setState(() {
                          widget.configuracionCatalogo.urlLogoOferta = url;
                          widget.configuracionCatalogo.dataLogoOferta = data;
                        });
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(4.0),
                      // ignore: sized_box_for_whitespace
                      child: Container(
                        width: ancho,
                        height: alto2,
                      ),
                    ),
            ),
          ],
        )),
      ],
    );
  }

  @override
  void dispose() {
    _ctlFolderCSV.dispose();
    _ctlFolderPDF.dispose();
    _ctlFolderImagenes.dispose();
    _ctlFolderFuentes.dispose();
    _ctlSimboloMoneda.dispose();
    super.dispose();
  }
}
