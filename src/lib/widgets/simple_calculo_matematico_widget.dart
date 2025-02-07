import 'package:catalog_app/utilidades/utiles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SimpleCalculoMatematicoWidget extends StatefulWidget {
  SimpleCalculoMatematicoWidget(
      {Key? key,
      required this.calculo,
      required this.titulo,
      this.onChanged,
      this.mostrarAyudaDebajo = false})
      : super(key: key);

  String calculo;
  String titulo;
  bool mostrarAyudaDebajo = false;
  Function(String)? onChanged;
  @override
  State<SimpleCalculoMatematicoWidget> createState() =>
      _SimpleCalculoMatematicoWidgetState();
}

class _SimpleCalculoMatematicoWidgetState
    extends State<SimpleCalculoMatematicoWidget> {
  final _ctlCalculo = TextEditingController();
  bool _errorCalculo = false;
  ResultadoCalculoMatematico? _resultadoCalculoMatematico;

  final double _precioLista = 1000.0,
      _alicuotaIva = 21.0,
      _bonificacionImporte = 100,
      _bonificacionPorcentaje = 10,
      _impuestoInterno = 50;

  final double _unidadesPack = 6;

  @override
  void initState() {
    super.initState();
    _errorCalculo = false;
    _ctlCalculo.text = "";
    _ctlCalculo.text = widget.calculo;
    _resultadoCalculoMatematico = _realizarPruebaCalculo(widget.calculo);
    if (_resultadoCalculoMatematico != null) {
      if (_resultadoCalculoMatematico!.error.isEmpty) {
        setState(() {
          _errorCalculo = false;
        });
      } else {
        setState(() {
          _errorCalculo = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _ctlCalculo.dispose();
    super.dispose();
  }

  ResultadoCalculoMatematico _realizarPruebaCalculo(String calculo) {
    try {
      return calculo.calcularPrecio(
          precioLista: _precioLista,
          alicuotaIva: _alicuotaIva,
          bonificacionImporte: _bonificacionImporte,
          bonificacionPorcentaje: _bonificacionPorcentaje,
          unidadesPack: _unidadesPack,
          impuestoInterno: _impuestoInterno);
    } catch (e) {
      return ResultadoCalculoMatematico(
          double.nan, "", widget.calculo, e.toString());
    }
  }

  bool _expandedAyuda = false;

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
      fontWeight: FontWeight.bold,
    );

    // ignore: avoid_unnecessary_containers
    return Container(
      child: Flex(
        direction: Axis.vertical,
        children: [
          TextField(
            minLines: widget.mostrarAyudaDebajo ? 1 : 3,
            maxLines: widget.mostrarAyudaDebajo ? 1 : 6,
            controller: _ctlCalculo,
            readOnly: false,
            style: style,
            onChanged: (value) {
              _resultadoCalculoMatematico = _realizarPruebaCalculo(value);
              if (_resultadoCalculoMatematico != null) {
                if (_resultadoCalculoMatematico!.error.isEmpty) {
                  setState(() {
                    _errorCalculo = false;
                    widget.calculo = value;
                    if (widget.onChanged != null) {
                      widget.onChanged!.call(value);
                    }
                  });
                } else {
                  setState(() {
                    _errorCalculo = true;
                  });
                }
              }
            },
            decoration: InputDecoration(
              labelText: widget.titulo,
              //hintText: widget.titulo,
              suffixIcon: IconButton(
                  tooltip: "Resultado de cálculo matemático.",
                  icon: _errorCalculo
                      ? Icon(
                          Icons.error,
                          color: Colors.red.shade900,
                        )
                      : Icon(
                          Icons.check,
                          color: Colors.green.shade700,
                        ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: SingleChildScrollView(
                          child: SizedBox(
                              width: double.maxFinite,
                              child: Column(
                                children: [
                                  const Text(
                                    "Resultado de cálculo matemático.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const Divider(
                                    height: 4,
                                    endIndent: 5,
                                    indent: 5,
                                  ),
                                  const Padding(padding: EdgeInsets.all(16)),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      // ignore: sized_box_for_whitespace
                                      child: Container(
                                          width: 400,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Valores utilizados para la simulación",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Divider(
                                                endIndent: 40,
                                                indent: 40,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("${ConstantesPrecio
                                                          .precioLista}: $_precioLista"),
                                                  Text("${ConstantesPrecio
                                                          .unidadesPack}: $_unidadesPack"),
                                                  Text("${ConstantesPrecio
                                                          .alicuotaIva}: $_alicuotaIva"),
                                                  Text("${ConstantesPrecio
                                                          .impuestoInterno}: $_impuestoInterno"),
                                                  Text("${ConstantesPrecio
                                                          .bonificacionImporte}: $_bonificacionImporte"),
                                                  Text("${ConstantesPrecio
                                                          .bonificacionPorcentaje}: $_bonificacionPorcentaje"),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    // ignore: avoid_unnecessary_containers
                                    child: Container(
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Cálculo simulado",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Divider(
                                            endIndent: 40,
                                            indent: 40,
                                          ),
                                          _resultadoCalculoMatematico != null
                                              ? Text(
                                                  _resultadoCalculoMatematico!
                                                      .calculoSinInterpretar)
                                              : const Text(
                                                  "No hay datos ingresados"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    // ignore: avoid_unnecessary_containers
                                    child: Container(
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Cálculo",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Divider(
                                            endIndent: 40,
                                            indent: 40,
                                          ),
                                          _resultadoCalculoMatematico != null &&
                                                  _resultadoCalculoMatematico!
                                                          .valor.isNaN ==
                                                      false
                                              ? Text("${_resultadoCalculoMatematico!
                                                      .calculo} = ${_resultadoCalculoMatematico!
                                                      .valor}")
                                              : const Text(
                                                  "No hay datos ingresados"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ignore: sized_box_for_whitespace
                                  Container(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.close),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            8, 0, 8, 0),
                                                    child: Text("Cerrar"),
                                                  )
                                                ],
                                              )),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ));
                      },
                    );
                  }),
              prefixIcon: IconButton(
                  tooltip: "Ayuda de cálculo matemático.",
                  icon: const Icon(Icons.help_outline),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            // ignore: sized_box_for_whitespace
                            content: Container(
                          height: 450,
                          child: Flex(
                            direction: Axis.vertical,
                            children: [
                              const Text(
                                "Ayuda de cálculo matemático.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const Divider(
                                height: 4,
                                endIndent: 5,
                                indent: 5,
                              ),
                              const Padding(padding: EdgeInsets.all(16)),
                              SizedBox(
                                height: 340,
                                child: SingleChildScrollView(
                                  primary: true,
                                  // ignore: avoid_unnecessary_containers
                                  child: Container(
                                      //width: 400,
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Variables",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Divider(
                                        endIndent: 40,
                                        indent: 40,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("${ConstantesPrecio.precioLista}: Precio de lista para el catálogo que se está generando."),
                                          Text("${ConstantesPrecio.unidadesPack}: Pack de unidades informado en 'Articulos.csv' (pack)."),
                                          Text("${ConstantesPrecio.alicuotaIva}: Alícuota de IVA informada en 'Articulos.csv' e 'Iva.csv' (codigoIva)."),
                                          Text("${ConstantesPrecio
                                                  .impuestoInterno}: Impuesto interno informado en 'Articulos.csv' (impuestoInt)."),
                                          Text("${ConstantesPrecio
                                                  .bonificacionImporte}: Importe bonificación informado en 'Bonificaciones.csv'."),
                                          Text("${ConstantesPrecio
                                                  .bonificacionPorcentaje}: Porcentaje bonificación informado en 'Bonificaciones.csv'."),
                                        ],
                                      ),
                                      const Divider(
                                        endIndent: 40,
                                        indent: 40,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        // ignore: avoid_unnecessary_containers
                                        child: Container(
                                          child: Column(
                                            children: const [
                                              Text(
                                                "Operadores matemáticos y agrupadores",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Divider(
                                                endIndent: 40,
                                                indent: 40,
                                              ),
                                              Text(" + : suma."),
                                              Text(" - : resta."),
                                              Text(" * : multiplicación."),
                                              Text(" / : división."),
                                              Text(" ( : apertura de grupo."),
                                              Text(" ) : cierre de grupo."),
                                              Text(" . : separador decimal."),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                // ignore: sized_box_for_whitespace
                                child: Container(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Row(
                                            children: const  [
                                              Icon(Icons.close),
                                              Text("Cerrar")
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ));
                      },
                    );
                  }),
            ),
          ),
          _errorCalculo && _resultadoCalculoMatematico != null
              ? Text(
                  _resultadoCalculoMatematico!.error,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                )
              : Container(),

          widget.mostrarAyudaDebajo
              ? ExpansionPanelList(
                  animationDuration: const Duration(milliseconds: 500),
                  children: [
                    ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return const SizedBox(
                          height: 30,
                          child: ListTile(
                            title: Text('Ayuda de cálculo matemático'),
                            style: ListTileStyle.list,
                          ),
                        );
                      },
                      isExpanded: _expandedAyuda,
                      canTapOnHeader: true,
                      body: SizedBox(
                        height: 120,
                        child: SingleChildScrollView(
                          primary: true,
                          // ignore: avoid_unnecessary_containers
                          child: Container(
                              //width: 400,
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Variables",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Divider(
                                endIndent: 40,
                                indent: 40,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${ConstantesPrecio.precioLista}: Precio de lista para el catálogo que se está generando."),
                                  Text("${ConstantesPrecio.unidadesPack}: Pack de unidades informado en 'Articulos.csv' (pack)."),
                                  Text("${ConstantesPrecio.alicuotaIva}: Alícuota de IVA informada en 'Articulos.csv' e 'Iva.csv' (codigoIva)."),
                                  Text("${ConstantesPrecio.impuestoInterno}: Impuesto interno informado en 'Articulos.csv' (impuestoInt)."),
                                  Text("${ConstantesPrecio.bonificacionImporte}: Importe bonificación informado en 'Bonificaciones.csv'."),
                                  Text("${ConstantesPrecio.bonificacionPorcentaje}: Porcentaje bonificación informado en 'Bonificaciones.csv'."),
                                ],
                              ),
                              const Divider(
                                endIndent: 40,
                                indent: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                // ignore: avoid_unnecessary_containers
                                child: Container(
                                  child: Column(
                                    children: const [
                                      Text(
                                        "Operadores matemáticos y agrupadores",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Divider(
                                        endIndent: 40,
                                        indent: 40,
                                      ),
                                      Text(" + : suma."),
                                      Text(" - : resta."),
                                      Text(" * : multiplicación."),
                                      Text(" / : división."),
                                      Text(" ( : apertura de grupo."),
                                      Text(" ) : cierre de grupo."),
                                      Text(" . : separador decimal."),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                  ],
                  dividerColor: Colors.grey,
                  expansionCallback: (panelIndex, isExpanded) {
                    _expandedAyuda = !_expandedAyuda;
                    setState(() {});
                  },
                )
              : Container(
                  height: 0,
                ),

          // SingleChildScrollView(
          //   child: SizedBox(
          //       width: double.maxFinite,
          //       child: Column(
          //         children: [
          //           // const Text(
          //           //   "Ayuda de cálculo matemático.",
          //           //   style:
          //           //       TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          //           // ),
          //           // const Divider(
          //           //   height: 4,
          //           //   endIndent: 5,
          //           //   indent: 5,
          //           // ),
          //           //const Padding(padding: EdgeInsets.all(16)),

          //           // Padding(
          //           //   padding: const EdgeInsets.all(8.0),
          //           //   child: Container(
          //           //     child: Column(
          //           //       children: const [
          //           //         Text(
          //           //           "Operadores matemáticos y agrupadores",
          //           //           style: TextStyle(fontWeight: FontWeight.bold),
          //           //         ),
          //           //         Divider(
          //           //           endIndent: 40,
          //           //           indent: 40,
          //           //         ),
          //           //         Text(" + : suma."),
          //           //         Text(" - : resta."),
          //           //         Text(" * : multiplicación."),
          //           //         Text(" / : división."),
          //           //         Text(" ( : apertura de grupo."),
          //           //         Text(" ) : cierre de grupo."),
          //           //         Text(" . : separador decimal."),
          //           //       ],
          //           //     ),
          //           //   ),
          //           // ),
          //         ],
          //       )),
          // )
        ],
      ),
    );
  }
}
