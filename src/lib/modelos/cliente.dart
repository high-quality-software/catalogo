import '../utilidades/reflection.dart';
import 'Base/iaxmodelbase.dart';

@reflectableEntity
class Cliente implements IAxModelBase {
  @override
  String getFileName() => "Clientes.csv";

  /// <summary>
  /// 15 caracteres
  /// </summary>
  String codigo = "";

  /// <summary>
  /// 255 caracteres
  /// </summary>
  // ignore: non_constant_identifier_names
  String razon_social = "";

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String direccion = "";

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String zona = "";

  /// <summary>
  /// 15 caracteres
  /// </summary>
  String vendedor = "";

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String telefono = "";

  /// <summary>
  /// 4 digitos
  /// </summary>
  int lista = 0;

  /// <summary>
  /// Entero
  /// </summary>
  int orden = 0;

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String ramo = "";

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String localidad = "";
  bool cobraIB = false;

  int condIva = 1; //(eCondicionIVA.ConsumidorFinal.index + 1);

  // eCondicionIVA get getCondicionIva => eCondicionIVA.values[condIva - 1];

  /// <summary>
  /// 15 caracteres
  /// </summary>
  String tablaBonifId = "";
  double topeVenta = 0;
  double margen = 0;

  /// <summary>
  /// 15 caracteres
  /// </summary>
  String percepid = "";

  /// <summary>
  /// XX-XXXXXXXX-X 13 caracteres
  /// </summary>
  String cuit = "";

  int tipoDoc = 0; //eTipoDocumento.None.index;

  // eTipoDocumento get getTipoDocumento {
  //   switch (tipoDoc) {
  //     case 80:
  //       return eTipoDocumento.CUIT;
  //     case 96:
  //       return eTipoDocumento.DNI;
  //     default:
  //       return eTipoDocumento.None;
  //   }
  // }

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String email = "";

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String password = "";

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String condicionDePago = "";

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String coordenadas = "";
  bool habilitacion = false;
  bool esFoco = false;
  String segmentacion = "C"; //eCategoriaCliente.C.index;

  // eCategoriaCliente get getSegmentacion {
  //   eCategoriaCliente idx = eCategoriaCliente.values
  //       .firstWhere((element) => element.name == segmentacion);

  //   return idx; //eCategoriaCliente.values[segmentacion];
  // }

  /// <summary>
  /// 10 caracteres
  /// </summary>
  String codigoPostal = "";

  /// <summary>
  /// 50 caracteres
  /// </summary>
  String pais = "";

  /// <summary>
  /// 50 caracteres
  /// </summary>
  String provincia = "";

  /// <summary>
  /// 50 caracteres
  /// </summary>
  String ciudad = "";

  /// <summary>
  /// 255 caracteres
  /// </summary>
  String listasaseleccionar = "";
  bool ivaTasaCero = false;
}
