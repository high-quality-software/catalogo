import 'dart:io';

import 'package:pdf/widgets.dart' as pw;

class FuentePdf {
  final String nombre;
  final pw.Font fuente;
  final FileSystemEntity file;
  FuentePdf({required this.nombre, required this.fuente, required this.file});
}
