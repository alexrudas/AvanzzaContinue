import 'package:avanzza/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/startup/bootstrap.dart';
import 'core/theme/app_theme.dart';
import 'presentation/controllers/app_theme_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(AppThemeController(), permanent: true);
    final light = buildLightTheme();
    final dark = buildDarkTheme();

    return Obx(() {
      return GetMaterialApp(
        title: 'Avanzza 2.0',
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.home,
        getPages: Routes.pages,
        theme: light,
        darkTheme: dark,
        themeMode: themeController.themeMode.value,
      );
    });
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Bootstrap.init();
  // await seedMain(); // datos demos para las bds
  runApp(const App());
}
