import '../utilidades/reflection.dart';
import 'Base/iaxmodelbase.dart';

@reflectableEntity
class Iva implements IAxModelBase {
  @override
  String getFileName() => "iva.csv";

  int codigo = 0;
  double valor = 0;
}
