import 'package:catalog_app/modelos/configuracion_catalogo.dart';
import 'package:catalog_app/pages/configuracion_catalogo_page.dart';
import 'package:catalog_app/providers/configuracion_provider.dart';
import 'package:catalog_app/utilidades/messagebox.dart';
import 'package:catalog_app/utilidades/utiles.dart';
import 'package:catalog_app/widgets/simple_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/menu_provider.dart';

class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({Key? key}) : super(key: key);

  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  final _ctlDesbloqueo = TextEditingController();

  Widget _getConfiguracionCatalogo(ConfiguracionCatalogo cfgCatalogo) {
    return ConfiguracionCatalogoPage(configuracionCatalogo: cfgCatalogo);
  }

  @override
  void dispose() {
    _ctlDesbloqueo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final cfgProvider = Provider.of<ConfiguracionProvider>(context);
    var cfgCatalogo = cfgProvider.configuracionCatalogo;

    return Flex(
      direction: Axis.vertical,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Expanded(
          //fit: FlexFit.tight,
          flex: 18,
          child: SimpleTabView(
            contentHeight: 475,
            itemCount: 1,
            tabBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const Tab(
                    text: "Catálogo",
                  );
                default:
                  return Tab();
              }
            },
            pageBuilder: (context, index) {
              switch (index) {
                case 0:
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(0),
                    child: _getConfiguracionCatalogo(cfgCatalogo),
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Visibility(
                  visible: cfgCatalogo.estadoDemo != 2,
                  child: Tooltip(
                    message: "Registrar clave de producto.",
                    child: IconButton(
                      icon: const Icon(Icons.lock_open),
                      onPressed: () async {
                        _ctlDesbloqueo.text = "";
                        var w = SizedBox(
                          height: 200,
                          width: 360,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: TextField(
                                  controller: _ctlDesbloqueo,
                                  decoration: const InputDecoration(
                                    labelText: "Ingrese la clave de desbloqueo",
                                    //hintText: "Ingrese la clave de desbloqueo",
                                    // icon: Icon(Icons.format_size)
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 160,
                                        height: 40,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              Navigator.of(context)
                                                  .pop(_ctlDesbloqueo.text);
                                            },
                                            child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: const [
                                                  Icon(Icons
                                                      .check_circle_outline),
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child:
                                                          Text("Desbloquear"),
                                                    ),
                                                  )
                                                ])),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 160,
                                        height: 40,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop("");
                                            },
                                            child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: const [
                                                  Icon(Icons.cancel_outlined),
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text("Cancelar"),
                                                    ),
                                                  )
                                                ])),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                        var ret = await MessageBox.mostrarWidget<String>(
                            // context: context,
                            titulo: "Desbloqueo de aplicación",
                            icon: const Icon(Icons.lock_open),
                            widget: w);

                        if (ret != null &&
                            ret.toLowerCase() ==
                                Constantes.strEmptyImageBase64.toLowerCase()) {
                          await cfgProvider.cargarConfiguracionGuardada();
                          cfgCatalogo = cfgProvider.configuracionCatalogo;
                          cfgCatalogo.estadoDemo = 2;
                          await cfgProvider.guardarConfiguracion(cfgCatalogo);

                          await MessageBox.mostrar(
                              // context: context,
                              titulo: "Desbloqueo de aplicación",
                              mensaje:
                                  "La aplicación se desbloqueó correctamente!!",
                              botones: <eMessageBoxButton>[
                                eMessageBoxButton.aceptar
                              ],
                              tipo: eMessageBoxType.info);
                          setState(() {});
                        } else {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        child: Row(
                          children: const [
                            Icon(Icons.save),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Guardar"),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          if (await cfgProvider
                              .guardarConfiguracion(cfgCatalogo)) {
                            await MessageBox.mostrar(
                                // context: context,
                                titulo: "Configuración",
                                mensaje:
                                    "La configuración fue guardada con éxito!!",
                                botones: <eMessageBoxButton>[
                                  eMessageBoxButton.aceptar
                                ],
                                tipo: eMessageBoxType.info);

                            menuProvider.closeOptionMenu();
                          } else {
                            await MessageBox.mostrar(
                                // context: context,
                                titulo: "Configuración",
                                mensaje:
                                    "Ocurrió un error al guardar la información",
                                botones: <eMessageBoxButton>[
                                  eMessageBoxButton.aceptar
                                ],
                                tipo: eMessageBoxType.error);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        child: Row(
                          children: const [
                            Icon(Icons.cancel),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Cerrar"),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          var ret = await MessageBox.mostrar(
                              // context: context,
                              titulo: "Configuración",
                              mensaje:
                                  "Se encuentra seguro de cancelar los cambios?.",
                              botones: <eMessageBoxButton>[
                                eMessageBoxButton.si,
                                eMessageBoxButton.no,
                              ],
                              tipo: eMessageBoxType.question);
                          if (ret == eMessageBoxButton.si) {
                            menuProvider.closeOptionMenu();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
