import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class SimpleLoadingWidget extends StatelessWidget {
  SimpleLoadingWidget(
      {Key? key,
      required this.texto,
      this.color = Colors.blueGrey,
      this.size = 50.0,
      this.widget})
      : super(key: key);
  final String texto;
  Color color;
  double size;
  late Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Center(
      // ignore: prefer_const_constructors
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitCubeGrid(
            color: color,
            size: size,
          ),
          SizedBox(
            height: 40,
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'Horizon',
              ),
              child: AnimatedTextKit(repeatForever: true, animatedTexts: [
                texto.isNotEmpty
                    ? RotateAnimatedText(texto)
                    : RotateAnimatedText("Procesando..."),
                RotateAnimatedText('Por favor aguarde'),
              ]),
            ),
          ),
          widget != null ? widget as Widget : Container()
        ],
      ),
    );
  }
}
