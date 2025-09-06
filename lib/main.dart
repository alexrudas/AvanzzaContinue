import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes.dart';
import 'core/startup/bootstrap.dart';
import 'seed.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Avanzza 2.0',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.pages,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Bootstrap.init();
  // await seedMain(); // datos demos para las bds
  runApp(const App());
}
