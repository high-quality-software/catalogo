import '../utilidades/reflection.dart';
import 'Base/iaxmodelbase.dart';

@reflectableEntity
class Bonificacion implements IAxModelBase {
  @override
  String getFileName() => "bonificaciones.csv";

  int bonifId = 0;
  String codart = "";
  double cantsuperior = 0;
  double desc = 0;
  int sincargo = 0;
}
