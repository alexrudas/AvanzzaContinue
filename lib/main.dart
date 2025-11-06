import 'package:avanzza/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
// NUEVO: intl y localizaciones
import 'package:intl/intl.dart';

import 'core/startup/bootstrap.dart';
import 'presentation/controllers/app_theme_controller.dart';
import 'presentation/themes/presets/light_theme.dart';
import 'presentation/themes/presets/dark_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(AppThemeController(), permanent: true);
    // Use new theme system (UI PRO 2025) with all extensions
    final light = lightTheme;
    final dark = darkTheme;

    return Obx(() {
      return GetMaterialApp(
        title: 'Avanzza 2.0',
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.home,
        getPages: Routes.pages,
        theme: light,
        darkTheme: dark,
        themeMode: themeController.themeMode.value,

        // NUEVO: soporte de localización (Material/Cupertino/Widgets)
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es', 'CO')],
        locale: const Locale('es', 'CO'),
      );
    });
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NUEVO: inicializa datos de locale para intl y fija por defecto
  await initializeDateFormatting('es_CO');
  Intl.defaultLocale = 'es_CO';

  await Bootstrap.init();
  // await seedMain(); // datos demos para las bds
  runApp(const App());
}
