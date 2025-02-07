import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:catalog_app/utilidades/valores_generales.dart';
// import 'package:catalog_app/utilidades/utiles.dart';

abstract class UtilesFiles {
  static String crearCarpetaLocal(String folder) {
    Directory dir = Directory(
        ValoresGenerales.defaultFolderData + Platform.pathSeparator + folder);

    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir.path;
  }

  static void borrarArchivo(String filename) {
    var f = File(filename);
    if (f.existsSync()) {
      f.deleteSync();
    }
  }
  // static Future<bool> comprimirZip(String filename, String folder) async {

  //       // Encode the archive as a BZip2 compressed Tar file.
  //   final tarData = TarEncoder().encode(archive);
  //   final tarBz2 = BZip2Encoder().encode(tarData);

  //   // Write the compressed tar file to disk.
  //   final fp = File('test.tbz');
  //   fp.writeAsBytesSync(tarBz2);

  //   // Zip a directory to out.zip using the zipDirectory convenience method
  //   var encoder = ZipFileEncoder();
  //   encoder.zipDirectory(Directory('out'), filename: 'out.zip');

  //   // Manually create a zip of a directory and individual files.
  //   encoder.create('out2.zip');
  //   encoder.addDirectory(Directory('out'));
  //   encoder.addFile(File('test.zip'));
  //   encoder.close();

  // }
  static Future<List<String>?> descomprimirZip(
      String filename, String folder) async {
    var f = File(filename);
    if (!await f.exists()) {
      return null;
    }

    //var extension = f.extension;

    var bytes = await f.readAsBytes();

// Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);
    List<String> lst = <String>[];

    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      var fOut = File(folder + Platform.pathSeparator + filename);
      if (file.isFile) {
        final data = file.content as List<int>;

        fOut
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);

        lst.add(fOut.path);
      } else {
        fOut.create(recursive: true);
      }
    }
    return lst;
  }
}
