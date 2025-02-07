import 'package:catalog_app/modelos/configuracion_catalogo.dart';
import 'package:darq/darq.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../utilidades/messagebox.dart';
import '../../simple_font_size_and_color_widget.dart';

// ignore: must_be_immutable
class ConfigGrupos extends StatefulWidget {
  ConfigGrupos(
      {Key? key,
      required this.configuracionGrupo,
      required this.configuracionCatalogo})
      : super(key: key);

  ConfiguracionGrupo configuracionGrupo;
  ConfiguracionCatalogo configuracionCatalogo;

  @override
  State<ConfigGrupos> createState() => _ConfigGruposState();
}

class _ConfigGruposState extends State<ConfigGrupos> {
  final double ancho = 200;

  final double alto = 300;

  @override
  void initState() {
    super.initState();

    _generarListadoOrdenTemp();
  }

  void _generarListadoOrdenTemp() {
    try {
      if (widget.configuracionGrupo.orden.firstWhereOrDefault(
              (element) => element.grupo == eGrupo.marca,
              defaultValue: null) ==
          null) {
        widget.configuracionGrupo.orden.add(GrupoOrden()
          ..orden = 1
          ..nombre = "Marca"
          ..activo = true);
      }
      if (widget.configuracionGrupo.orden.firstWhereOrDefault(
              (element) => element.grupo == eGrupo.rubro,
              defaultValue: null) ==
          null) {
        widget.configuracionGrupo.orden.add(GrupoOrden()
          ..orden = 2
          ..nombre = "Rubro"
          ..activo = true);
      }
      if (widget.configuracionGrupo.orden.firstWhereOrDefault(
              (element) => element.grupo == eGrupo.linea,
              defaultValue: null) ==
          null) {
        widget.configuracionGrupo.orden.add(GrupoOrden()
          ..orden = 3
          ..nombre = "Línea"
          ..activo = true);
      }
    } catch (e) {
      MessageBox.mostrar(
          // context: context,
          titulo: "Generación de Catálogo",
          mensaje:
              "Error al generar el listado temporal de Orden.\nDescripción del error: $e",
          botones: <eMessageBoxButton>[eMessageBoxButton.aceptar],
          tipo: eMessageBoxType.error);
    }
  }

  void _reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = widget.configuracionGrupo.orden.removeAt(oldindex);
      widget.configuracionGrupo.orden.insert(newindex, items);
      for (int i = 0; i < widget.configuracionGrupo.orden.length; i++) {
        widget.configuracionGrupo.orden[i].orden = i + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      //width: ancho,
      height: alto,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: alto,
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(children: [
                      Switch(
                          value: widget.configuracionGrupo.mostrarCabeceraGrupo,
                          //tristate: false,
                          onChanged: (value) {
                            setState(() {
                              widget.configuracionGrupo.mostrarCabeceraGrupo =
                                  value;
                            });
                          }),
                      const Text("Mostrar cabecera de Grupo?"),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(children: [
                      Switch(
                          value: widget.configuracionGrupo.noAgrupar,
                          //tristate: false,
                          onChanged: (value) {
                            setState(() {
                              widget.configuracionGrupo.noAgrupar = value;
                            });
                          }),
                      const Text("No agrupar los artículos"),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(children: [
                      Switch(
                          value: widget
                              .configuracionGrupo.ordenarLosArticulosPorNombre,
                          //tristate: false,
                          onChanged: (value) {
                            setState(() {
                              widget.configuracionGrupo
                                  .ordenarLosArticulosPorNombre = value;
                            });
                          }),
                      const Text("Ordenar los Artículos por Nombre (A-Z)"),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: alto,
            padding: const EdgeInsets.all(8.0),
            width: 350,
            child: Card(
              elevation: 5,
              child: SimpleFontSizeAndColorWidget(
                folderFonts: widget.configuracionCatalogo.folderFuentes,
                modo: eModoSimpleFontSizeAndColor.vertical,
                config: widget.configuracionGrupo.fuente,
              ),
            ),
          ),
          Container(
            height: alto,
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: Center(
                  child: AbsorbPointer(
                absorbing: widget.configuracionGrupo.noAgrupar ||
                    widget.configuracionGrupo.ordenarLosArticulosPorNombre,
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  height: alto - 20,
                  width: 400,
                  child: ReorderableListView(
                    //dragStartBehavior: DragStartBehavior.start,
                    // ignore: sort_child_properties_last
                    children: <Widget>[
                      for (final items in widget.configuracionGrupo.orden)
                        Card(
                          color: (widget.configuracionGrupo.noAgrupar ||
                                  widget.configuracionGrupo
                                      .ordenarLosArticulosPorNombre)
                              ? Colors.grey.shade400
                              : const Color.fromARGB(255, 0, 129, 194),
                          key: ValueKey(items),
                          elevation: 2,
                          child: SwitchListTile(
                            tileColor: Colors.transparent,
                            subtitle: Text(
                              items.activo ? "Activo" : "Inactivo",
                              textAlign: TextAlign.center,
                            ),
                            value: items.activo,
                            activeColor: (widget.configuracionGrupo.noAgrupar ||
                                    widget.configuracionGrupo
                                        .ordenarLosArticulosPorNombre)
                                ? Colors.grey.shade400
                                : const Color.fromARGB(255, 0, 201, 43),
                            inactiveThumbColor: Colors.grey.shade400,
                            onChanged: (value) {
                              setState(() {
                                items.activo = value;
                              });
                            },
                            title: Text(
                              items.nombre,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                            // leading:
                            // const Icon(
                            //   Icons.work,
                            //   color: Colors.black,
                            // ),
                          ),
                        ),
                    ],
                    onReorder: _reorderData,
                  ),
                ),
              )),
            ),
          )
        ],
      ),
    );
  }
}
