import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:catalog_app/modelos/articulo.dart';
import 'package:catalog_app/modelos/bonificacion.dart';
import 'package:catalog_app/modelos/cliente.dart';
import 'package:catalog_app/modelos/configuracion_catalogo.dart';
// import 'package:catalog_app/modelos/configuracion_fuentes.dart';
import 'package:catalog_app/modelos/imagen.dart';
import 'package:catalog_app/providers/configuracion_provider.dart';
import 'package:catalog_app/providers/loading_provider.dart';
import 'package:catalog_app/utilidades/generador_catalogos.dart';
import 'package:catalog_app/utilidades/generador_pdf.dart';
import 'package:catalog_app/utilidades/importador.dart';
import 'package:catalog_app/utilidades/messagebox.dart';
// import 'package:catalog_app/utilidades/valores_generales.dart';
import 'package:darq/darq.dart';
// import 'package:catalog_app/utilidades/messagebox.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:isolates/isolate_runner.dart';
import 'package:provider/provider.dart';

import '../modelos/catalogo/catalogo.dart';

import '../modelos/iva.dart';
import '../providers/menu_provider.dart';
import '../main.reflectable.dart';
import '../utilidades/utiles_http.dart';

//final _formKey = GlobalKey<FormState>();
class DatosImportados {
  List<Articulo> lstArticulos;
  List<Cliente> lstClientes;
  List<Imagen> lstImagenes;
  List<Bonificacion> lstBonificaciones;
  List<FileSystemEntity> lstFuentes;
  List<Iva> lstAlicuotasIva;
  ConfiguracionCatalogoInterno cfgCat;
  String? error;
  DatosImportados(
      {required this.lstArticulos,
      required this.lstClientes,
      required this.lstImagenes,
      required this.lstBonificaciones,
      required this.lstAlicuotasIva,
      required this.cfgCat,
      required this.lstFuentes,
      this.error});
}

class ResultadoGeneracion {
  bool ok;
  List<ResultadoPdf>? resultadosPdf;
  String? message;
  ResultadoGeneracion({required this.ok, this.message, this.resultadosPdf});
}

class WizardGeneracionPdfPage extends StatefulWidget {
  const WizardGeneracionPdfPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WizardGeneracionPdfPageState createState() =>
      _WizardGeneracionPdfPageState();
}

class _WizardGeneracionPdfPageState extends State<WizardGeneracionPdfPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: const FormWidget());
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> with TickerProviderStateMixin {
  int _stepNumber = 1;

  Isolate? isolate;

  final _ctlFolderImagenes = TextEditingController();
  final _ctlFolderCSV = TextEditingController();
  final _ctlFolderPDF = TextEditingController();
  //final _ctlFondoPDF = TextEditingController();
  //final _ctlImagenEncabezado = TextEditingController();
  //final _ctlImagenPie = TextEditingController();
  //late TabController _tabPDFsController;

  // List<Tab> _tabsPDFs = <Tab>[];

  // final Importador _importador = Importador();
  // late List<Articulo> _lstArticulos;
  // late List<Cliente> _lstClientes;
  // late List<Imagen> _lstImagenes;
  // late List<Bonificacion> _lstBonificaciones;
  late DatosImportados _datosImportados;

  late List<ResultadoPdf> _resultadosPDF;
  @override
  void initState() {
    super.initState();
    _resultadosPDF = <ResultadoPdf>[];
    _ctlFolderImagenes.text = "";
    // "/home/jvega/CatalogoPDF/Imagenes";
    _ctlFolderCSV.text = "";
    //"/home/jvega/CatalogoPDF/CSV";
    _ctlFolderPDF.text = "";
    // "/home/jvega/CatalogoPDF/PDF";
    //_ctlFondoPDF.text = "";
    //"/home/jvega/CatalogoPDF/Fondos/fondo3.png";
    //_ctlImagenEncabezado.text = "/home/jvega/CatalogoPDF/logoDiemar.png";
    //_ctlImagenPie.text = "";
    //"/home/jvega/CatalogoPDF/footerDiemar.png";

    //_tabPDFsController = TabController(vsync: this, length: 0);
  }

  // Future<void> _crearPdfs(
  //     List<Catalogo> catalogos,
  //     ConfiguracionCatalogoInterno cfgCat,
  //     LoadingProvider loadingProvider) async {
  //   _resultadosPDF = <ResultadoPdf>[];
  //   Future.wait(List.generate(catalogos.length, (index) {
  //     var catalogo = catalogos[index];
  //     var generadorPdf = GeneradorPdf();
  //     return generadorPdf.generarPDF(_ctlFolderPDF.text, catalogo, cfgCat);
  //   })).then((value) {
  //     _resultadosPDF.addAll(value);
  //     setState(() {
  //       if (_stepNumber == 2) {
  //         _stepNumber = 3;
  //       }
  //     });

  //     Future.delayed(
  //         const Duration(seconds: 1), () => loadingProvider.closeLoading());
  //   }).onError((error, stackTrace) {
  //     Future.delayed(
  //         const Duration(seconds: 1), () => loadingProvider.closeLoading());
  //   });
  // }

  static Future<List<ResultadoPdf>> _crearPdfsStatic(
      List<Catalogo> catalogos,
      ConfiguracionCatalogoInterno cfgCat,
      String folderPDF,
      List<FileSystemEntity> fuentes) {
    // var results = List.generate(catalogos.length, (index) {
    //   var catalogo = catalogos[index];
    //   var generadorPdf = GeneradorPdf();
    //   return generadorPdf.generarPDF(folderPDF, catalogo, cfgCat);
    // });

    var ret = Future.wait(List.generate(catalogos.length, (index) async {
      var catalogo = catalogos[index];
      var generadorPdf = GeneradorPdf();
      var result =
          await generadorPdf.generarPDF(folderPDF, catalogo, cfgCat, fuentes);

      return result;
    })).then((value) {
      var resultadosPDF = <ResultadoPdf>[];
      resultadosPDF.addAll(value);
      return resultadosPDF;
    }).catchError((error, stackTrace) {
      throw error;
    });
    return ret;
  }

  static Future<ResultadoGeneracion> generarCatalogos(
      DatosImportados datos) async {
    var generadorCatalogos = GeneradorCatalogos();

    try {
      var fCatalogos = await generadorCatalogos.generarCatalogos(
          datos.lstArticulos,
          datos.lstClientes,
          datos.lstImagenes,
          datos.lstBonificaciones,
          datos.lstAlicuotasIva,
          datos.cfgCat);

      var result = await _crearPdfsStatic(fCatalogos, datos.cfgCat,
          datos.cfgCat.folderSalidaPDF, datos.lstFuentes);

      return ResultadoGeneracion(ok: true, resultadosPdf: result);
    } catch (e) {
      return ResultadoGeneracion(ok: false, message: e.toString());
    }
  }

  void _generateCatalogs(BuildContext context, LoadingProvider loadingProvider,
      ConfiguracionProvider cfgProvider) async {
    //_formKey.currentState?.save();

    loadingProvider.openLoading("Generando catálogos");
    _resultadosPDF.clear();
    try {
      Future.delayed(
        const Duration(seconds: 1),
        () async {
          DatosImportados datos = _datosImportados;

          final runner = await IsolateRunner.spawn();

          var result = await runner.run(generarCatalogos, datos).whenComplete(
              () => runner.close()); //await compute(generarCatalogos, datos);

          if (result.ok) {
            if (result.resultadosPdf != null) {
              _resultadosPDF.addAll(result.resultadosPdf as List<ResultadoPdf>);
            }

            setState(() {
              if (_stepNumber == 2) {
                _stepNumber = 3;
              }
            });
          }
          await Future.delayed(
              const Duration(seconds: 1), () => loadingProvider.closeLoading());

          if (!result.ok) {
            await MessageBox.mostrar(
                // context: context,
                titulo: "Generación de Catálogo",
                mensaje:
                    "No se generaron archivos de catálogo.\nDescripción del error: ${result.message ?? "Desconocido"}",
                botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
                tipo: eMessageBoxType.error);
          }
        },
      );
    } on Exception catch (e) {
      log(e.toString());
      loadingProvider.closeLoading();

      await MessageBox.mostrar(
          // context: context,
          titulo: "Generación de Catálogo",
          mensaje:
              "Ocurrió un error al generar el catálogo.\nDescripción del error: $e",
          botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
          tipo: eMessageBoxType.error);
    }
  }

  void backPage() {
    setState(() {
      _stepNumber--;
    });
  }

  void _importarCSV(LoadingProvider loadingProvider,
      ConfiguracionProvider cfgProvider, MenuProvider menuProvider) async {
    loadingProvider.openLoading("Importando archivos csv");
    var cfgCat = cfgProvider.configuracionCatalogo;

    try {
      await Future.delayed(const Duration(seconds: 1), () async {
        final runner = await IsolateRunner.spawn();
        var cfg = cfgCat.getConfiguracionInterna();

        var result = await runner
            .run(importarArchivos, cfg)
            .whenComplete(() => runner.close());

        bool hayImagenVinculada = false;

        if (result.lstArticulos.isNotEmpty == true &&
            result.lstImagenes.isNotEmpty == true) {
          for (var i in result.lstImagenes) {
            var a = result.lstArticulos.firstWhereOrDefault(
                (value) =>
                    i.nombre.trim().toLowerCase() ==
                    value.codigo.trim().toLowerCase(),
                defaultValue: null);
            if (a != null) {
              hayImagenVinculada = true;
              break;
            }
          }

          _datosImportados = result;
        }
        await Future.delayed(
            const Duration(seconds: 1), () => loadingProvider.closeLoading());

        if (result.error != null && result.error!.isNotEmpty) {
          await MessageBox.mostrar(
              // context: context,
              titulo: "Importación de archivos",
              mensaje: result.error!,
              botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
              tipo: eMessageBoxType.error);
        } else {
          if (result.lstArticulos.isEmpty == true) {
            await MessageBox.mostrar(
                // context: context,
                titulo: "Importación de archivos",
                mensaje:
                    "No se importaron registros de Artículos, verifique que el archivo 'Articulos.csv' tenga contenido.",
                botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
                tipo: eMessageBoxType.error);
          } else if (result.lstArticulos.firstWhereOrDefault(
                  (value) => value.codigo.isNotEmpty,
                  defaultValue: null) ==
              null) {
            await MessageBox.mostrar(
                // context: context,
                titulo: "Importación de archivos",
                mensaje:
                    "El archivo 'Articulos.csv' no tiene un formato válido.",
                botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
                tipo: eMessageBoxType.error);
          } else if (result.lstArticulos.firstWhereOrDefault(
                  (value) => value.tienePrecio(),
                  defaultValue: null) ==
              null) {
            await MessageBox.mostrar(
                // context: context,
                titulo: "Importación de archivos",
                mensaje:
                    "El archivo 'Articulos.csv' no tiene precios cargados para ningún artículo, por favor verifique los precios de lista.",
                botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
                tipo: eMessageBoxType.error);
          } else if (result.lstClientes.isNotEmpty &&
              result.lstClientes.firstWhereOrDefault(
                      (value) => value.codigo.isNotEmpty,
                      defaultValue: null) ==
                  null) {
            await MessageBox.mostrar(
                // context: context,
                titulo: "Importación de archivos",
                mensaje:
                    "El archivo 'Clientes.csv' no tiene un formato válido.",
                botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
                tipo: eMessageBoxType.error);
            // } else if (result.lstClientes.isEmpty) {
            //   await MessageBox.mostrar(
            //       context: context,
            //       titulo: "Importación de archivos",
            //       mensaje:
            //           "No se importaron registros de Clientes, verifique que el archivo 'Clientes.csv' tenga contenido.",
            //       botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
            //       tipo: eMessageBoxType.error);
          } else if (result.lstAlicuotasIva.isNotEmpty &&
              result.lstAlicuotasIva.firstWhereOrDefault(
                      (value) => value.valor > 0,
                      defaultValue: null) ==
                  null) {
            await MessageBox.mostrar(
                // context: context,
                titulo: "Importación de archivos",
                mensaje: "El archivo 'Iva.csv' no tiene un formato válido.",
                botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
                tipo: eMessageBoxType.error);
          } else if (result.lstBonificaciones.isNotEmpty &&
              result.lstBonificaciones.firstWhereOrDefault(
                      (value) => value.codart.isNotEmpty,
                      defaultValue: null) ==
                  null) {
            await MessageBox.mostrar(
                // context: context,
                titulo: "Importación de archivos",
                mensaje:
                    "El archivo 'Bonificaciones.csv' no tiene un formato válido.",
                botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
                tipo: eMessageBoxType.error);
          } else if (!hayImagenVinculada) {
            await MessageBox.mostrar(
                // context: context,
                titulo: "Importación de archivos",
                mensaje:
                    "No se importaron Imágenes vinculadas a los Artículos, verifique que los nombres de imágenes respeten lo definido en la documentación.",
                botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
                tipo: eMessageBoxType.error);
          } else {
            setState(() {
              _stepNumber = 2;
            });
          }
        }
      });
    } on Exception catch (e) {
      log(e.toString());
      await Future.delayed(
          const Duration(seconds: 1), () => loadingProvider.closeLoading());
      await MessageBox.mostrar(
          // context: context,
          titulo: "Importación de CSV",
          mensaje:
              "Ocurrió un error al importar los archivos CSV.\nDescripción del error: $e",
          botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
          tipo: eMessageBoxType.error);
    }
  }

  static Future<DatosImportados> importarArchivos(
      ConfiguracionCatalogoInterno cfgCat) async {
    initializeReflectable();
    try {
      final Importador importador = Importador();
      try {
        var lstArticulos =
            await importador.importarCsv<Articulo>(cfgCat.folderCsv);

        var lstAlicuotasIva =
            await importador.importarCsv<Iva>(cfgCat.folderCsv);

        var lstClientes =
            await importador.importarCsv<Cliente>(cfgCat.folderCsv);

        var lstBonificaciones =
            await importador.importarCsv<Bonificacion>(cfgCat.folderCsv);

        var lstImagenes = await importador.importarImagenes(
            cfgCat.folderImagenes, lstArticulos);

        var lstFuentes = await importador.importarFuentes(cfgCat.folderFuentes);
        DatosImportados datos = DatosImportados(
            cfgCat: cfgCat,
            lstArticulos: List.from(lstArticulos),
            lstBonificaciones: List.from(lstBonificaciones),
            lstAlicuotasIva: List.from(lstAlicuotasIva),
            lstClientes: List.from(lstClientes),
            lstImagenes: List.from(lstImagenes),
            lstFuentes: List.from(lstFuentes));

        if (datos.lstArticulos.isNotEmpty) {
          for (var element in datos.lstArticulos) {
            Articulo.setearPrecios(element);
          }
        }
        return datos;
      } catch (e) {
        return DatosImportados(
            cfgCat: cfgCat,
            lstArticulos: <Articulo>[],
            lstBonificaciones: <Bonificacion>[],
            lstAlicuotasIva: <Iva>[],
            lstClientes: <Cliente>[],
            lstImagenes: <Imagen>[],
            lstFuentes: <FileSystemEntity>[],
            error: e.toString());
      }
      // var lstFuentes = await importador.importarFuentes(
      //     ValoresGenerales.pathFolderFuentes); //cfgCat.folderFuentes);

    } catch (e) {
      rethrow;
    }
  }

  Column _formImportacionCSVBuilder(BuildContext context,
      MenuProvider menuProvider, ConfiguracionProvider cfgProvider) {
    final loadingProvider = Provider.of<LoadingProvider>(context);
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    //decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                    width: double.infinity,
                    child: const Text(
                      "Importación de CSV",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              const Divider(
                indent: 10,
                endIndent: 10,
              ),
            ],
          ),
        ),
        Flexible(
          flex: 7,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _ctlFolderCSV,
                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: 'Carpeta Origen de CSV'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _ctlFolderImagenes,
                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: 'Carpeta Origen de Imágenes'),
                  ),
                ),
              ]),
        ),
        Flexible(
          flex: 1,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    color: Colors.blue,
                    child: const Text('Cancelar'),
                    onPressed: () => {menuProvider.closeOptionMenu()},
                  ),
                  const Padding(padding: EdgeInsets.only(left: 8)),
                  MaterialButton(
                    color: Colors.blue,
                    child: const Text('Siguiente'),
                    onPressed: () async {
                      bool ok = false;
                      await cfgProvider.cargarConfiguracionGuardada();
                      var cfg = cfgProvider.configuracionCatalogo;
                      Duration? diasRestantes;
                      try {
                        if (cfg.estadoDemo < 2) {
                          DateTime fechaActual = DateTime.now();
                          try {
                            fechaActual = await UtilesHttp.getFechaHoraNTP();
                            // ignore: empty_catches
                          } catch (e) {
                            fechaActual = DateTime.now();
                          }

                          //cfg.fechaPrimeraEjecucion ??= fechaActual;

                          var fechaMaxima = DateUtils.addDaysToDate(
                              cfg.fechaPrimeraEjecucion!, 20);

                          if (cfg.estadoDemo == 0 ||
                              (cfg.fechaPrimeraEjecucion == null)) {
                            cfg.fechaPrimeraEjecucion = fechaActual;
                            diasRestantes = fechaMaxima.difference(fechaActual);

                            cfg.estadoDemo = 1;
                            ok = await cfgProvider.guardarConfiguracion(cfg);
                          } else {
                            diasRestantes = fechaMaxima.difference(fechaActual);

                            if (diasRestantes.inDays > 0) {
                              ok = true;
                            }
                          }
                        } else {
                          ok = true;
                        }
                      } catch (e) {
                        ok = true;
                      }
                      if (ok) {
                        if (cfg.estadoDemo < 2 && diasRestantes != null) {
                          await MessageBox.mostrar(
                              // context: context,
                              titulo: "Demo",
                              mensaje: "Quedan ${diasRestantes.inDays.toStringAsFixed(0)} días de uso.",
                              botones: <eMessageBoxButton>[
                                eMessageBoxButton.aceptar
                              ],
                              tipo: eMessageBoxType.info);
                        }
                        _importarCSV(loadingProvider, cfgProvider,
                            menuProvider);
                      } else {
                        await MessageBox.mostrar(
                            // context: context,
                            titulo: "Demo vencida",
                            mensaje:
                                "La aplicación se encuentra vencida.\r\nPor favor comuniquesé con su proveedor de servicios.",
                            botones: <eMessageBoxButton>[
                              eMessageBoxButton.aceptar
                            ],
                            tipo: eMessageBoxType.info);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Column _formGeneracionPDFBuilder(BuildContext context,
      MenuProvider menuProvider, ConfiguracionProvider cfgProvider) {
    final loadingProvider = Provider.of<LoadingProvider>(context);
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border.all(color: const Color.fromARGB(255, 39, 114, 255))),
                  width: double.infinity,
                  child: const Text(
                    "Exportación de Catálogo a PDF",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const Divider(
                indent: 10,
                endIndent: 10,
              )
            ],
          ),
        ),
        Flexible(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                            "Se importaron ${_datosImportados.lstArticulos.length
                                    .toStringAsFixed(0)} artículos.",
                            textAlign: TextAlign.left),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                            "Se importaron ${_datosImportados.lstClientes.length
                                    .toStringAsFixed(0)} clientes.",
                            textAlign: TextAlign.left),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                            "Se importaron ${_datosImportados.lstBonificaciones.length
                                    .toStringAsFixed(0)} bonificaciones.",
                            textAlign: TextAlign.left),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                            "Se importaron ${_datosImportados.lstAlicuotasIva.length
                                    .toStringAsFixed(0)} alícuotas de I.V.A.",
                            textAlign: TextAlign.left),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                            "Se importaron ${_datosImportados.lstImagenes.length
                                    .toStringAsFixed(0)} imágenes.",
                            textAlign: TextAlign.left),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  indent: 30,
                  endIndent: 30,
                ),
              ],
            )),
        Flexible(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _ctlFolderPDF,
                  readOnly: true,
                  decoration: const InputDecoration(
                      labelText: 'Carpeta destino de PDF'),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    color: Colors.blue,
                    child: const Text('Atrás'),
                    onPressed: () {
                      backPage();
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(left: 8)),
                  MaterialButton(
                    color: Colors.blue,
                    child: const Text('Siguiente'),
                    onPressed: () {
                      if (_ctlFolderPDF.text.length > 3) {
                        _generateCatalogs(
                            context, loadingProvider, cfgProvider);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Column _formVisoresPDFBuilder(
      BuildContext context, MenuProvider menuProvider) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border.all(color: const Color.fromARGB(255, 39, 114, 255))),
                  width: double.infinity,
                  child: const Text(
                    "Archivos Generados de Catálogo PDF",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const Divider(
                indent: 10,
                endIndent: 10,
              )
            ],
          ),
        ),
        Flexible(
          flex: 6,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                child: TextFormField(
                  controller: _ctlFolderPDF,
                  readOnly: true,
                  decoration: const InputDecoration(
                      labelText: 'Carpeta destino de PDF'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: const [
                    Text("Archivos generados",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Divider(
                      indent: 15,
                      endIndent: 15,
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(),
                  height: 195,
                  //width: 300,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(2),
                      itemCount: _resultadosPDF.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          // textColor: _resultadosPDF[index].ok
                          //     ? Color.fromARGB(255, 136, 255, 0)
                          //     : Colors.red,
                          trailing: _resultadosPDF[index].ok
                              ? const Icon(Icons.check)
                              : const Icon(Icons.error),
                          title: Text(_resultadosPDF[index].fileName,
                              textAlign: TextAlign.center),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    color: Colors.blue,
                    child: const Text('Atrás'),
                    onPressed: () {
                      backPage();
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(left: 8)),
                  MaterialButton(
                    color: Colors.blue,
                    child: const Text('Finalizar'),
                    onPressed: () {
                      menuProvider.closeOptionMenu();
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final configProvider = Provider.of<ConfiguracionProvider>(context);

    _ctlFolderCSV.text = configProvider.configuracionCatalogo.folderCsv;
    _ctlFolderImagenes.text =
        configProvider.configuracionCatalogo.folderImagenes;
    _ctlFolderPDF.text = configProvider.configuracionCatalogo.folderSalidaPDF;

    switch (_stepNumber) {
      case 1:
        return Form(
          //key: _formKey,
          child:
              _formImportacionCSVBuilder(context, menuProvider, configProvider),
        );
      //break;

      case 2:
        return Form(
          //key: _formKey,
          child:
              _formGeneracionPDFBuilder(context, menuProvider, configProvider),
        );
      //break;
      case 3:
        return Form(
          //key: _formKey,
          child: _formVisoresPDFBuilder(context, menuProvider),
        );
      default:
        return const Form(
          //key: _formKey,
          child: Text("No configurado"),
        );
    }
  }

  @override
  void dispose() {
    // ctl_address.dispose();
    // ctl_age.dispose();
    // ctl_city.dispose();
    //_tabPDFsController.dispose();
    _ctlFolderCSV.dispose();
    _ctlFolderPDF.dispose();
    _ctlFolderImagenes.dispose();
    //_ctlFondoPDF.dispose();
    //_ctlImagenEncabezado.dispose();
    //_ctlImagenPie.dispose();
    super.dispose();
  }
}
