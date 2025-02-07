// import 'dart:io';

import 'package:catalog_app/pages/wizard_generacion_pdf_page.dart';
import 'package:catalog_app/providers/configuracion_provider.dart';
import 'package:catalog_app/widgets/simple_menu_principal.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../providers/loading_provider.dart';
import '../providers/menu_provider.dart';
import '../utilidades/messagebox.dart';
// import '../utilidades/utiles.dart';
import '../widgets/simple_loading_widget.dart';
import 'configuracion_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context);
    var mq = MediaQuery.of(context);

    var size = mq.size;
    bool overflowSize = false;
    double wMin = 1130;
    double hMin = 580;

    if (size.width < wMin || size.height < hMin) {
      overflowSize = true;
    }

    if (loadingProvider.isOpen) {
      context.loaderOverlay.show(
        widget: SimpleLoadingWidget(
          texto: loadingProvider.activeTitle,
          color: Colors.blueGrey,
          size: 50.0,
        ),
      );
    } else {
      context.loaderOverlay.hide();
    }

    final menuProvider = Provider.of<MenuProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: _getTitulo(menuProvider.activeOptionMenu),
        centerTitle: true,
        toolbarHeight: 30,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          color: Colors.white,
          child: overflowSize
              ? Center(
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Se requiere que amplie el tamaño de la ventana",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Tamaño mínimo: ${wMin.toStringAsFixed(1)} x ${hMin.toStringAsFixed(1)}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Tamaño actual: ${size.width.toStringAsFixed(1)} x ${size.height.toStringAsFixed(1)}"),
                        ),
                      ],
                    ),
                  ),
                )
              : _getOption(context),
        ),
      ),
    );
  }

  Text _getTitulo(optionMenu) {
    switch (optionMenu) {
      case 1:
        return const Text("Configuraciones");
      case 2:
        return const Text("Generación de Catálogo en PDF");
      default:
        return const Text('Catálogo PDF');
    }
  }

  Widget _getOption(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final cfgProvider = Provider.of<ConfiguracionProvider>(context);

    List<Choice> opcionesMenu = <Choice>[
      Choice(
          title: "Configuraciones",
          icon: Icons.settings,
          color: const Color.fromARGB(255, 71, 71, 71),
          highlightColor: const Color.fromARGB(255, 24, 24, 24),
          onPressed: () => menuProvider.openOptionMenu(1)),
      Choice(
          title: "Generar Catálogo",
          icon: Icons.view_list,
          color: const Color.fromARGB(255, 0, 104, 189),
          highlightColor: const Color.fromARGB(255, 0, 97, 177),
          onPressed: () async {
            var cfgCat = cfgProvider.configuracionCatalogo;
            String message = "";
            if (cfgCat.folderCsv.isEmpty) {
              message = "La carpeta 'Origen CSV' no está configurada.\n";
            }
            if (cfgCat.folderImagenes.isEmpty) {
              message =
                  "La carpeta 'Origen de Imágenes' no está configurada.\n";
            }
            if (cfgCat.folderSalidaPDF.isEmpty) {
              message = "La carpeta 'Destino PDF' no está configurada.\n";
            }

            if (message.isNotEmpty) {
              MessageBox.mostrar(
                  // context: context,
                  titulo: "Configuración",
                  mensaje: message,
                  botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
                  tipo: eMessageBoxType.error);
              menuProvider.closeOptionMenu();
            } else {
              menuProvider.openOptionMenu(2);
            }
          }),
      Choice(
          title: "Cerrar Sistema",
          icon: Icons.exit_to_app,
          color: const Color.fromARGB(255, 179, 42, 0),
          highlightColor: const Color.fromARGB(255, 228, 65, 0),
          onPressed: () async {
            var ret = await MessageBox.mostrar(
                // context: context,
                titulo: "Catálogos PDF",
                mensaje: "Se encuentra seguro de cerrar el Sistema?.",
                botones: <eMessageBoxButton>[
                  eMessageBoxButton.si,
                  eMessageBoxButton.no,
                ],
                tipo: eMessageBoxType.question);
            if (ret == eMessageBoxButton.si) {
              menuProvider.cerrarSistema();
            }
          })
    ];

    switch (menuProvider.activeOptionMenu) {
      case 1:
        return const ConfiguracionPage();
      case 2:
        return const WizardGeneracionPdfPage();
      default:
        return Center(
            // ignore: sized_box_for_whitespace
            child: Container(
          height: 380,
          width: 350,
          child: SimpleMenuPrincipal(
            choices: opcionesMenu,
            textStyle: const TextStyle(fontSize: 18, color: Colors.white70),
            maxPerRow: 2,
            iconSize: 64,
          ),
        ));
    }
  }
}
