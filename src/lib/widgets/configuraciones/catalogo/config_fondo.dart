import 'package:catalog_app/modelos/catalogo/catalogo.dart';
import 'package:catalog_app/utilidades/utiles.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:group_radio_button/group_radio_button.dart';

import '../../simple_image_widget.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class ConfigFondo extends StatefulWidget {
  const ConfigFondo({Key? key, required this.fondo}) : super(key: key);

  final Fondo fondo;

  @override
  State<ConfigFondo> createState() => _ConfigFondoState();
}

class _ConfigFondoState extends State<ConfigFondo> {
  final double ancho = 200;

  final double alto = 300;

  Widget _getWImagen() {
    if (widget.fondo.tipoFondo != eTipoFondo.imagen) {
      return Container(
        width: 0,
      );
    }

    return SimpleImageWidget(
      titulo: "Imagen",
      width: ancho,
      height: alto,
      initialImageUrl: widget.fondo.imagenUrl,
      onImageChanged: (url, data) {
        setState(() {
          widget.fondo.imagenUrl = url;
          widget.fondo.imagenData = data;
        });
      },
    );
  }

  Widget _getWidget() {
    switch (widget.fondo.tipoFondo) {
      case eTipoFondo.degrade:
        return _getWDegrade();
      case eTipoFondo.imagen:
        return _getWImagen();
      default:
        return const SizedBox(
          width: 0,
        );
    }
  }

  Widget _getWDegrade() {
    if (widget.fondo.tipoFondo != eTipoFondo.degrade) {
      return const SizedBox(
        width: 0,
      );
    }

    return Card(
      elevation: 5,
      // ignore: sized_box_for_whitespace
      child: Container(
          height: alto,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text("Color desde:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0) //
                                      ),
                            ),
                            child: ColorIndicator(
                              width: 50,
                              height: 50,
                              borderRadius: 4,
                              color: widget.fondo.fondoDegrade.color1,
                              onSelectFocus: false,
                              onSelect: () async {
                                var colorSelected =
                                    await Utiles.colorPickerDialog(context,
                                        widget.fondo.fondoDegrade.color1);
                                if (colorSelected != null) {
                                  setState(() {
                                    widget.fondo.fondoDegrade.color1 =
                                        colorSelected;
                                  });
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text("Color hasta:"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0) //
                                      ),
                            ),
                            child: ColorIndicator(
                              width: 50,
                              height: 50,
                              borderRadius: 4,
                              color: widget.fondo.fondoDegrade.color2,
                              onSelectFocus: false,
                              onSelect: () async {
                                var colorSelected =
                                    await Utiles.colorPickerDialog(context,
                                        widget.fondo.fondoDegrade.color2);
                                if (colorSelected != null) {
                                  setState(() {
                                    widget.fondo.fondoDegrade.color2 =
                                        colorSelected;
                                  });
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                indent: 5,
                endIndent: 5,
              ),
              Center(
                child: Container(
                  height: 150,
                  width: 450,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      gradient: LinearGradient(colors: [
                        widget.fondo.fondoDegrade.color1,
                        widget.fondo.fondoDegrade.color2
                      ], tileMode: TileMode.clamp)
                      // borderRadius: const BorderRadius.all(Radius.circular(4.0) //
                      //     ),
                      ),
                ),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
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
                  const Text("Tipo de fondo"),
                  const Divider(
                    indent: 5,
                    endIndent: 5,
                  ),
                  RadioGroup<eTipoFondo>.builder(
                    groupValue: widget.fondo.tipoFondo,
                    onChanged: (value) => setState(() {
                      widget.fondo.tipoFondo = value!;
                    }),
                    items: eTipoFondo.values,
                    itemBuilder: (item) {
                      String value = "";
                      switch (item) {
                        case eTipoFondo.imagen:
                          value = "Imagen";
                          break;
                        case eTipoFondo.degrade:
                          value = "Degrade";
                          break;
                        default:
                          value = "Vacío";
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
          child: _getWidget(),
        ),
      ],
    );
  }
}
