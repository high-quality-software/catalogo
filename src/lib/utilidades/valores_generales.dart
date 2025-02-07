import 'dart:io';

abstract class ValoresGenerales {
  static String get nameFolderFuentes => "Fuentes";
  static String get pathFolderFuentes =>
      defaultFolderData + Platform.pathSeparator + nameFolderFuentes;
  static String get defaultFolderData => Directory.current.path;
}
