import 'package:catalog_app/modelos/catalogo/catalogo.dart';
import 'package:catalog_app/modelos/configuracion_catalogo.dart';
import 'package:catalog_app/widgets/simple_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

import '../../simple_font_size_and_color_widget.dart';

// ignore: must_be_immutable
class ConfigHeaderFooter extends StatefulWidget {
  ConfigHeaderFooter(
      {Key? key,
      required this.headerFooter,
      required this.configuracionCatalogo})
      : super(key: key);
  HeaderFooterBase headerFooter;
  final ConfiguracionCatalogo configuracionCatalogo;
  @override
  State<ConfigHeaderFooter> createState() => _ConfigHeaderFooterState();
}

class _ConfigHeaderFooterState extends State<ConfigHeaderFooter> {
  final _ctlTitulo = TextEditingController();

  Widget _showSettings(eModoHeaderFooterPagina modo) {
    switch (modo) {
      case eModoHeaderFooterPagina.ninguna:
        return const SizedBox(
          width: 0,
        );
      default:
        return _showConfigHeader();
    }
  }

  Widget _getWTexto(HeaderFooterBase headerFooter) {
    if (headerFooter.modoImagen == eModoImagen.todoElAncho) {
      return const SizedBox(
        width: 0,
      );
    }

    return Card(
      elevation: 5,
      // ignore: sized_box_for_whitespace
      child: Container(
        //width: ancho,
        height: alto,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: const [
                  Center(
                    child: Text("Texto"),
                  ),
                  Divider(
                    indent: 5,
                    endIndent: 5,
                  ),
                ],
              ),
            ),
            TextField(
              enableInteractiveSelection: true,
              enabled: headerFooter.modoImagen != eModoImagen.todoElAncho,
              controller: _ctlTitulo,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              // contextMenuBuilder: (context, editable) {
              //           return AdaptiveTextSelectionToolbar(
              //               anchors: editable.contextMenuAnchors, 
              //               children: editable
              //           );
              //       },
              // toolbarOptions: const ToolbarOptions(
                  // copy: true, selectAll: true, cut: true, paste: true),
              // onSubmitted: (value) {
              //   setState(() {
              //     headerFooter.texto = value;
              //   });
              // },
              // onEditingComplete: () {
              //   setState(() {
              //     headerFooter.texto = _ctlTitulo.text;
              //   });
              // },
              autofocus: true,
              showCursor: true,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                //var sel = _ctlTitulo.selection;
                //setState(() {
                headerFooter.texto = value;
                //});
                // _ctlTitulo.selection = TextSelection(
                //     baseOffset: sel.baseOffset, extentOffset: sel.extentOffset);
              },
              // decoration: const InputDecoration(
              //     labelText: 'Texto',
              //     alignLabelWithHint: true,
              //     floatingLabelAlignment: FloatingLabelAlignment.start),
            ),
          ],
        ),
      ),
    );
  }

  final double ancho = 200;
  final double alto = 300;
  Widget _getWidgetFuente(HeaderFooterBase headerFooter) {
    if (headerFooter.modoImagen == eModoImagen.todoElAncho) {
      return Container(
        width: 0,
      );
    }

    return Card(
      elevation: 5,
      child: SizedBox(
        height: alto,
        child: Column(
          children: [
            Column(
              children: const [
                Center(
                  child: Text("Fuente"),
                ),
                Divider(
                  indent: 5,
                  endIndent: 5,
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                //width: ancho * 3,
                child: SimpleFontSizeAndColorWidget(
                  folderFonts: widget.configuracionCatalogo.folderFuentes,
                  modo: eModoSimpleFontSizeAndColor.vertical,
                  config: widget.headerFooter.fuente,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getWImagen(HeaderFooterBase headerFooter) {
    if (headerFooter.modoImagen == eModoImagen.ninguna) {
      return Container(
        width: 0,
      );
    }

    return SimpleImageWidget(
      titulo: "Imagen",
      width: ancho,
      height: alto,
      initialImageUrl: headerFooter.imagenUrl,
      onImageChanged: (url, data) {
        setState(() {
          headerFooter.imagenUrl = url;
          headerFooter.imagenData = data;
        });
      },
    );
  }

  Widget _showConfigHeader() {
    var encabezado = widget.headerFooter;

    _ctlTitulo.text = encabezado.texto;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,

      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          fit: FlexFit.loose,
          flex: 2,
          child: Card(
            elevation: 5,
            // ignore: sized_box_for_whitespace
            child: Container(
              height: alto,
              width: 160,
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Modo de imagen"),
                  const Divider(
                    indent: 5,
                    endIndent: 5,
                  ),
                  RadioGroup<eModoImagen>.builder(
                    groupValue: widget.headerFooter.modoImagen,
                    onChanged: (value) => setState(() {
                      widget.headerFooter.modoImagen = value!;
                    }),
                    items: eModoImagen.values,
                    itemBuilder: (item) {
                      String value = "";
                      switch (item) {
                        case eModoImagen.logo:
                          value = "Logotipo";
                          break;
                        case eModoImagen.todoElAncho:
                          value = "Completo";
                          break;
                        default:
                          value = "Sin imagen";
                      }
                      return RadioButtonBuilder(
                        value,
                        textPosition: RadioButtonTextPosition.right,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          //fit: FlexFit.tight,
          flex: 8,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  flex: encabezado.modoImagen == eModoImagen.todoElAncho
                      ? 10
                      : (encabezado.modoImagen == eModoImagen.logo ? 3 : 0),
                  child: _getWImagen(encabezado)),
              Flexible(
                  fit: FlexFit.tight,
                  flex: encabezado.modoImagen == eModoImagen.todoElAncho
                      ? 0
                      : 3, //(encabezado.modoImagen == eModoImagen.logo ? 2 : 4),
                  child: _getWidgetFuente(encabezado)),
              Flexible(
                  fit: FlexFit.tight,
                  //flex: 6,
                  flex: encabezado.modoImagen == eModoImagen.todoElAncho
                      ? 0
                      : (encabezado.modoImagen == eModoImagen.ninguna ? 5 : 4),
                  child: _getWTexto(encabezado))
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // const Text("Modo de encabezado"),
        // const Divider(
        //   indent: 50,
        //   endIndent: 50,
        // ),
        RadioGroup<eModoHeaderFooterPagina>.builder(
          groupValue: widget.headerFooter.modoHeaderFooter,
          horizontalAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
          // direction: Axis.vertical,
          onChanged: (value) => setState(() {
            widget.headerFooter.modoHeaderFooter = value!;
          }),
          items: eModoHeaderFooterPagina.values,
          itemBuilder: (item) {
            String value = "";
            switch (item) {
              case eModoHeaderFooterPagina.primeraPagina:
                value = "Sólo en la primera página";
                break;
              case eModoHeaderFooterPagina.todasLasPaginas:
                value = "En todas las páginas";
                break;
              default:
                value = "Ninguna página";
            }
            return RadioButtonBuilder(
              value,
              textPosition: RadioButtonTextPosition.right,
            );
          },
        ),
        const Divider(
          indent: 16,
          endIndent: 16,
        ),
        _showSettings(widget.headerFooter.modoHeaderFooter),
      ],
    );
  }

  @override
  void dispose() {
    _ctlTitulo.dispose();
    super.dispose();
  }
}
