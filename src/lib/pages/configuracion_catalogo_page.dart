import 'package:catalog_app/modelos/configuracion_catalogo.dart';
import 'package:catalog_app/widgets/configuraciones/catalogo/config_catalogo_gral.dart';
import 'package:catalog_app/widgets/configuraciones/catalogo/config_fondo.dart';
import 'package:catalog_app/widgets/configuraciones/catalogo/config_grupos.dart';
import 'package:catalog_app/widgets/configuraciones/catalogo/config_header_footer.dart';
import 'package:catalog_app/widgets/simple_tab_view.dart';
import 'package:flutter/material.dart';

class ConfiguracionCatalogoPage extends StatefulWidget {
  const ConfiguracionCatalogoPage(
      {Key? key, required this.configuracionCatalogo})
      : super(key: key);
  final ConfiguracionCatalogo configuracionCatalogo;

  @override
  State<ConfiguracionCatalogoPage> createState() =>
      _ConfiguracionCatalogoPageState();
}

class _ConfiguracionCatalogoPageState extends State<ConfiguracionCatalogoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleTabView(
      contentHeight: 450,
      itemCount: 5,
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const Tab(
              text: "General",
            );
          case 1:
            return const Tab(
              text: "Encabezado",
            );
          case 2:
            return const Tab(
              text: "Fondo de catálogo",
            );
          case 3:
            return const Tab(
              text: "Pie",
            );
          case 4:
            return const Tab(
              text: "Agrupación",
            );
          default:
            return Tab();
        }
      },
      pageBuilder: (context, index) {
        switch (index) {
          case 0:
            return ConfigCatalogoGral(
                configuracionCatalogo:
                    widget.configuracionCatalogo); //_getConfiguracionGeneral();
          case 1:
            return ConfigHeaderFooter(
                configuracionCatalogo: widget.configuracionCatalogo,
                headerFooter: widget.configuracionCatalogo.encabezado);
          case 2:
            return ConfigFondo(fondo: widget.configuracionCatalogo.fondo);
          case 3:
            return ConfigHeaderFooter(
                configuracionCatalogo: widget.configuracionCatalogo,
                headerFooter: widget.configuracionCatalogo.pie);
          case 4:
            return ConfigGrupos(
                configuracionCatalogo: widget.configuracionCatalogo,
                configuracionGrupo:
                    widget.configuracionCatalogo.configuracionGrupo);
          default:
            return Container();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
