// import 'dart:io';

import 'package:catalog_app/modelos/configuracion_catalogo.dart';
import 'package:catalog_app/modelos/configuracion_fuentes.dart';
import 'package:catalog_app/pages/home_page.dart';
import 'package:catalog_app/providers/configuracion_provider.dart';
import 'package:catalog_app/providers/loading_provider.dart';
import 'package:catalog_app/providers/menu_provider.dart';
// import 'package:catalog_app/utilidades/messagebox.dart';
import 'package:catalog_app/widgets/simple_loading_widget.dart';
// import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:widget_loading/widget_loading.dart';
import 'main.reflectable.dart';
import 'modelos/catalogo/catalogo.dart';
import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'utilidades/genericos/navigator_key.dart';
// import 'utilidades/utiles.dart';

void main() {
  initializeReflectable();
  _main();
}

void _main() async {
  registrarAdaptadores();

  await Hive.initFlutter();

  await ConfiguracionProvider.inicializarConfiguraciones();
  // var box = await Hive.openBox<ConfiguracionCatalogo>('configuracion_catalogo');

  // var cfg = box.get(ConfiguracionProvider.keyConfiguracionCatalogo);

  // if (cfg == null) {
  //   var nCfg = ConfiguracionCatalogo();
  //   await box.put(ConfiguracionProvider.keyConfiguracionCatalogo, nCfg);
  //   cfg = box.get(ConfiguracionProvider.keyConfiguracionCatalogo);
  // }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<MenuProvider>(
      create: (BuildContext context) => MenuProvider(),
    ),
    ChangeNotifierProvider<ConfiguracionProvider>(
      create: (BuildContext context) => ConfiguracionProvider(),
    ),
    ChangeNotifierProvider<LoadingProvider>(
      create: (BuildContext context) => LoadingProvider(),
    ),
  ], child: const MyApp()));
}

void registrarAdaptadores() {
  Hive.registerAdapter<FuenteGoogle>(FuenteGoogleAdapter());
  Hive.registerAdapter<ConfiguracionFuentes>(ConfiguracionFuentesAdapter());
  Hive.registerAdapter<eGrupo>(eGrupoAdapter());
  Hive.registerAdapter<eTipoDescuento>(eTipoDescuentoAdapter());
  Hive.registerAdapter<eModoHeaderFooterPagina>(
      eModoHeaderFooterPaginaAdapter());
  Hive.registerAdapter<eTipoFondo>(eTipoFondoAdapter());
  Hive.registerAdapter<eModoImagen>(eModoImagenAdapter());
  Hive.registerAdapter<ConfiguracionCatalogo>(ConfiguracionCatalogoAdapter());

  Hive.registerAdapter<Encabezado>(EncabezadoAdapter());
  Hive.registerAdapter<Degrade>(DegradeAdapter());
  Hive.registerAdapter<FontConfig>(FontConfigAdapter());

  Hive.registerAdapter<Fondo>(FondoAdapter());
  Hive.registerAdapter<Pie>(PieAdapter());
  Hive.registerAdapter<ConfiguracionGrupo>(ConfiguracionGrupoAdapter());
  Hive.registerAdapter<GrupoOrden>(GrupoOrdenAdapter());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // ignore: prefer_const_constructors
      home: LoaderOverlay(
          overlayWholeScreen: true,
          useDefaultLoading: false,
          disableBackButton: true,
          // ignore: prefer_const_constructors
          overlayWidget: SimpleLoadingWidget(
            texto: "",
            color: Colors.blueGrey,
            size: 50.0,
          ),
          // Center(
          //   // ignore: prefer_const_constructors
          //   child: SpinKitCubeGrid(
          //     color: Colors.blueGrey,
          //     size: 50.0,
          //   ),
          // ),
          overlayOpacity: 0.8,
          child: const SafeArea(child: HomePage())),
      // home: CircularWidgetLoading(
      //     loading: loadingProvider.isOpen,
      //     //animatedSize: false,
      //     appearingDuration: const Duration(milliseconds: 500),
      //     loadingDuration: const Duration(milliseconds: 1000),
      //     child: const SafeArea(
      //         child: HomePage())), //title: 'Flutter Demo Home Page'),
    );
  }
}
