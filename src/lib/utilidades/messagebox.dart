import 'package:flutter/material.dart';
import 'genericos/navigator_key.dart';
// ignore: camel_case_types
enum eMessageBoxButton { aceptar, cancelar, si, no, reintentar }

// ignore: camel_case_types
enum eMessageBoxType { info, error, question }

class MessageBox {
  static List<Widget> _getBotones(
      BuildContext context, List<eMessageBoxButton> botones) {
    List<Widget> buttons = <Widget>[];

    if (botones.isNotEmpty) {
      for (var btn in botones) {
        String nombre = btn.name.toString();
        switch (btn) {
          case eMessageBoxButton.si:
            nombre = "Sí";
            break;
          default:
            nombre = nombre.substring(0, 1).toUpperCase() + nombre.substring(1);
        }
        buttons.add(MaterialButton(
          child: Text(nombre),
          onPressed: () {
            Navigator.of(context).pop(btn);
          },
        ));
      }
    }

    if (buttons.isEmpty) {
      buttons.add(MaterialButton(
        child: const Text("Aceptar"),
        onPressed: () {
          Navigator.of(context).pop(eMessageBoxButton.aceptar);
        },
      ));
    }
    return buttons;
  }

  static Icon _getIcon(eMessageBoxType tipo) {
    switch (tipo) {
      case eMessageBoxType.error:
        return const Icon(
          Icons.error,
          color: Colors.red,
        );
      case eMessageBoxType.question:
        return const Icon(
          Icons.question_mark,
          color: Colors.green,
        );
      default:
        return const Icon(
          Icons.info,
          color: Colors.blue,
        );
    }
  }

  static Future<T?> mostrarWidget<T>(
      {
        // required BuildContext context,
      required String titulo,
      required Icon icon,
      required Widget widget}) async {
    var ret = showDialog<T>(
      context: navigatorKey.currentContext as BuildContext,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Column(
              children: [
                Row(
                  children: [
                    icon,
                    Expanded(child: Center(child: Text(titulo))),
                  ],
                ),
                const Divider(
                  indent: 5,
                  endIndent: 5,
                )
              ],
            ),
            content: widget);
      },
    );
    return ret;
  }

  static Future<eMessageBoxButton?> mostrar(
      {
        //required BuildContext context,
      required String titulo,
      required String mensaje,
      required List<eMessageBoxButton> botones,
      required eMessageBoxType tipo}) async {
    var ret = showDialog<eMessageBoxButton>(
      context: navigatorKey.currentContext as BuildContext,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Column(
              children: [
                Row(
                  children: [
                    _getIcon(tipo),
                    Expanded(child: Center(child: Text(titulo))),
                  ],
                ),
                const Divider(
                  indent: 5,
                  endIndent: 5,
                )
              ],
            ),
            content: Text(mensaje),
            actions: _getBotones(context, botones));
      },
    );
    return ret;
  }
}
