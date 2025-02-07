import 'dart:io';
import 'dart:typed_data';

import 'package:catalog_app/utilidades/utiles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../utilidades/messagebox.dart';
//import 'package:transparent_image/transparent_image.dart';

typedef OnImageChangedCallback = void Function(String url, Uint8List data);

// ignore: must_be_immutable
class SimpleImageWidget extends StatefulWidget {
  SimpleImageWidget(
      {Key? key,
      required this.titulo,
      this.onImageChanged,
      this.width,
      this.height,
      this.initialImageUrl})
      : super(key: key);

  OnImageChangedCallback? onImageChanged;
  final double? width;
  final double? height;
  final String? initialImageUrl;
  final String titulo;

  @override
  State<SimpleImageWidget> createState() => _SimpleImageWidgetState();
}

class _SimpleImageWidgetState extends State<SimpleImageWidget> {
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.initialImageUrl ?? "";
  }

  Future<PlatformFile?> _pickFile(
      String titulo, String? initialDirectory) async {
    var result = await FilePicker.platform.pickFiles(
        dialogTitle: titulo,
        type: FileType.image,
        allowMultiple: false,
        initialDirectory: initialDirectory);
    if (result != null && result.isSinglePick == true && result.count > 0) {
      return result.files[0];
    }
    return null;
  }

  Widget _showImage() {
    if (imageUrl.isNotEmpty == true) {
      var f = File(imageUrl);
      if (f.existsSync()) {
        return Image(
            image: FileImage(f),
            colorBlendMode: BlendMode.saturation); //Image.file(f);
      }
    }
    return Image.memory(Constantes.getEmptyImageData());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Column(children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Center(
                  child: Text(widget.titulo),
                ),
                const Divider(
                  indent: 5,
                  endIndent: 5,
                ),
              ],
            ),
          ),
          Expanded(
              flex: 6,
              // height: widget.height == null
              //     ? widget.height
              //     : (widget.height! * 0.80),
              child: _showImage()),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: MaterialButton(
                      child: Row(
                        children: const [
                          Icon(Icons.image_search),
                          Text("Buscar")
                        ],
                      ),
                      onPressed: () async {
                        String? initialDirectory;
                        if (imageUrl.isNotEmpty) {
                          File f = File(imageUrl);

                          if (await f.parent.exists()) {
                            initialDirectory = f.parent.path;
                          }
                        }
                        var result = await _pickFile(
                            "Por favor seleccione una imagen.",
                            initialDirectory);
                        if (result != null) {
                          setState(() {
                            imageUrl = result.path!;
                          });
                          var f = File(imageUrl);
                          var data = await f.readAsBytes();

                          widget.onImageChanged!(imageUrl, data);
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: MaterialButton(
                      child: Row(
                        children: const [Icon(Icons.clear), Text("Quitar")],
                      ),
                      onPressed: () async {
                        var ret = await MessageBox.mostrar(
                            // context: context,
                            titulo: widget.titulo,
                            mensaje:
                                "Se encuentra seguro de quitar la imagen?.",
                            botones: <eMessageBoxButton>[
                              eMessageBoxButton.si,
                              eMessageBoxButton.no,
                            ],
                            tipo: eMessageBoxType.question);
                        if (ret == eMessageBoxButton.si) {
                          setState(() {
                            imageUrl = "";
                          });
                          widget.onImageChanged!(imageUrl, Uint8List(0));
                        }
                      }),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
