import 'package:catalog_app/modelos/articulo.dart';
import 'package:catalog_app/modelos/bonificacion.dart';
import 'package:catalog_app/modelos/cliente.dart';
import 'package:reflectable/reflectable.dart';

@GlobalQuantifyMetaCapability(Cliente, reflectableEntity)
@GlobalQuantifyMetaCapability(Bonificacion, reflectableEntity)
@GlobalQuantifyMetaCapability(Articulo, reflectableEntity)
class ReflectableEntity extends Reflectable {
  const ReflectableEntity()
      : super(
          declarationsCapability,
          invokingCapability,
          subtypeQuantifyCapability,
          typeAnnotationDeepQuantifyCapability,
          typeCapability,
          reflectedTypeCapability,
          typeRelationsCapability,
        );
}

const reflectableEntity = ReflectableEntity();
