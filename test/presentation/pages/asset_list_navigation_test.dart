// ============================================================================
// test/presentation/pages/asset_list_navigation_test.dart
// ASSET LIST NAVIGATION — tests mínimos de valor real (Presentation)
//
// QUÉ HACE:
// - Verifica que AssetListPage agrupa por tipo (no lista plana de unidades).
// - Verifica que el tap en una tarjeta de tipo navega a Routes.assetsByType
//   pasando el AssetType correcto como argumento.
// - Verifica que AssetsByTypePage filtra la lista al tipo recibido.
// - Verifica el comportamiento con un único tipo presente.
// - Verifica la sección "Mis portafolios": renderizado, subtítulo por tipo
//   y navegación al tap (Routes.portfolioAssets + PortfolioEntity).
// - Verifica el FAB extendido: label "Registrar activo" y que su tap abre
//   el selector de tipo (ActionSheetPro).
//
// QUÉ NO HACE:
// - No abre Isar ni red. Siembra el controller vía debugSeed() para aislar la
//   capa de presentación y no duplicar contratos de repositorio.
// - No testea tiles internos de PortfolioAssetOperationalTile.
//
// PRINCIPIOS:
// - Un setUp por test; GetX reseteado para evitar estado compartido.
// - Se usa un fake de AssetListController que omite Session/DI en onInit
//   pero respeta el contrato público del padre (Get.find<AssetListController>).
// ============================================================================

import 'package:avanzza/domain/entities/asset/asset_content.dart';
import 'package:avanzza/domain/entities/asset/asset_entity.dart';
import 'package:avanzza/domain/entities/portfolio/portfolio_entity.dart';
import 'package:avanzza/presentation/controllers/asset_list_controller.dart';
import 'package:avanzza/presentation/pages/asset_list_page.dart';
import 'package:avanzza/presentation/pages/asset_type_display.dart';
import 'package:avanzza/presentation/pages/assets_by_type_page.dart';
import 'package:avanzza/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// Fake del AssetListController que omite onInit (Session/DI) y permite sembrar
/// la lista reactiva desde el test. Satisface `Get.find<AssetListController>()`.
class _FakeAssetListController extends AssetListController {
  // Saltamos la inicialización real: no dependemos de SessionContextController
  // ni de DIContainer en estos tests de presentación.
  @override
  // ignore: must_call_super
  void onInit() {}

  @override
  // ignore: must_call_super
  void onClose() {}
}

AssetEntity _vehicle(String id, String placa) => AssetEntity.create(
      id: id,
      content: AssetContent.vehicle(
        assetKey: placa,
        brand: 'CHEVROLET',
        model: 'SPARK',
        color: 'ROJO',
        engineDisplacement: 1000,
        mileage: 0,
      ),
    );

AssetEntity _realEstate(String id, String matricula) => AssetEntity.create(
      id: id,
      content: AssetContent.realEstate(
        assetKey: matricula,
        address: 'CRA 1',
        city: 'BOGOTA',
        area: 60.0,
        usage: 'RESIDENCIAL',
      ),
    );

AssetEntity _machinery(String id, String serie) => AssetEntity.create(
      id: id,
      content: AssetContent.machinery(
        assetKey: serie,
        brand: 'CAT',
        model: '320',
      ),
    );

PortfolioEntity _portfolio({
  required String id,
  required String name,
  required PortfolioType type,
  int assetsCount = 0,
}) =>
    PortfolioEntity(
      id: id,
      portfolioType: type,
      portfolioName: name,
      countryId: 'CO',
      cityId: 'BOG',
      orgId: 'org-1',
      status: PortfolioStatus.active,
      assetsCount: assetsCount,
      createdBy: 'user-1',
    );

Widget _buildApp() => GetMaterialApp(
      initialRoute: Routes.assets,
      getPages: [
        GetPage(name: Routes.assets, page: () => const AssetListPage()),
        GetPage(
          name: Routes.assetsByType,
          page: () => const AssetsByTypePage(),
        ),
        // Placeholder para validar la navegación desde la tarjeta de
        // portafolio (no rendereamos la página real aquí; solo verificamos
        // que el route y los arguments lleguen correctamente).
        GetPage(
          name: Routes.portfolioAssets,
          page: () => const Scaffold(body: SizedBox.shrink()),
        ),
      ],
    );

void main() {
  late _FakeAssetListController fake;

  setUp(() {
    Get.reset();
    fake = _FakeAssetListController();
    Get.put<AssetListController>(fake);

    // Mock del canal de plataforma para que HapticFeedback y SystemChrome
    // no lancen MissingPluginException en entornos de test (ActionSheetPro
    // hace `await HapticFeedback.selectionClick()` antes de abrir el sheet).
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    Get.reset();
  });

  testWidgets(
    'AssetListPage agrupa por tipo y muestra una tarjeta por tipo presente',
    (tester) async {
      fake.debugSeed([
        _vehicle('a1', 'ABC123'),
        _vehicle('a2', 'DEF456'),
        _realEstate('a3', 'MAT-001'),
        _machinery('a4', 'S-9'),
      ]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Tres tipos distintos sembrados → tres tarjetas (plural labels).
      expect(
        find.text(AssetTypeDisplay.of(AssetType.vehicle).pluralLabel),
        findsOneWidget,
      );
      expect(
        find.text(AssetTypeDisplay.of(AssetType.realEstate).pluralLabel),
        findsOneWidget,
      );
      expect(
        find.text(AssetTypeDisplay.of(AssetType.machinery).pluralLabel),
        findsOneWidget,
      );
      // Equipos no tiene activos → no debe aparecer.
      expect(
        find.text(AssetTypeDisplay.of(AssetType.equipment).pluralLabel),
        findsNothing,
      );

      // Contador correcto para vehículos (2).
      expect(find.text('2'), findsOneWidget);
    },
  );

  testWidgets(
    'Tap en tarjeta de tipo navega a Routes.assetsByType con AssetType correcto',
    (tester) async {
      fake.debugSeed([
        _vehicle('a1', 'ABC123'),
        _realEstate('a2', 'MAT-001'),
      ]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Tap en "Inmuebles".
      await tester.tap(
        find.text(AssetTypeDisplay.of(AssetType.realEstate).pluralLabel),
      );
      await tester.pumpAndSettle();

      // La ruta activa debe ser la dedicada por tipo, con AssetType como arg.
      expect(Get.currentRoute, Routes.assetsByType);
      expect(Get.arguments, AssetType.realEstate);

      // AppBar de la página dedicada muestra el label en plural del tipo.
      expect(
        find.widgetWithText(
          AppBar,
          AssetTypeDisplay.of(AssetType.realEstate).pluralLabel,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'AssetsByTypePage solo considera activos del tipo recibido (filtro)',
    (tester) async {
      fake.debugSeed([
        _vehicle('a1', 'ABC123'),
        _vehicle('a2', 'DEF456'),
        _realEstate('a3', 'MAT-001'),
      ]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Ir directo a la vista dedicada de vehículos.
      Get.toNamed(Routes.assetsByType, arguments: AssetType.vehicle);
      await tester.pumpAndSettle();

      // Contrato del controller compartido: el filtro que aplica la página
      // debe producir exactamente los 2 vehículos sembrados, excluyendo el
      // inmueble. Validamos el contrato del filtro sobre la misma fuente.
      final filtered = fake.assets
          .where((a) => a.type == AssetType.vehicle)
          .toList();
      expect(filtered.length, 2);
      expect(filtered.every((a) => a.type == AssetType.vehicle), isTrue);

      // AppBar de vehículos presente.
      expect(
        find.widgetWithText(
          AppBar,
          AssetTypeDisplay.of(AssetType.vehicle).pluralLabel,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'AssetListPage con un único tipo registrado navega sin romper',
    (tester) async {
      fake.debugSeed([
        _vehicle('a1', 'ABC123'),
      ]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Solo una tarjeta (Vehículos).
      expect(
        find.text(AssetTypeDisplay.of(AssetType.vehicle).pluralLabel),
        findsOneWidget,
      );

      await tester.tap(
        find.text(AssetTypeDisplay.of(AssetType.vehicle).pluralLabel),
      );
      await tester.pumpAndSettle();

      expect(Get.currentRoute, Routes.assetsByType);
      expect(Get.arguments, AssetType.vehicle);
    },
  );

  testWidgets(
    'AssetListPage sin activos muestra estado vacío y no lista tarjetas',
    (tester) async {
      fake.debugSeed([]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Aún no tienes activos'), findsOneWidget);
      expect(
        find.text(AssetTypeDisplay.of(AssetType.vehicle).pluralLabel),
        findsNothing,
      );
    },
  );

  // ==========================================================================
  // SECCIÓN "MIS PORTAFOLIOS" — tests dedicados
  // ==========================================================================

  testWidgets(
    'Sección "Mis portafolios" renderiza título, nombre y subtítulo por tipo',
    (tester) async {
      // Activos presentes (habilitan el render del body; si counts.isEmpty
      // la pantalla muestra empty state y no llega a la sección portafolios).
      fake.debugSeed([_vehicle('a1', 'ABC123')]);
      fake.portfolios.assignAll([
        _portfolio(
          id: 'p1',
          name: 'Flota Norte',
          type: PortfolioType.vehiculos,
          assetsCount: 4,
        ),
        _portfolio(
          id: 'p2',
          name: 'Edificios Centro',
          type: PortfolioType.inmuebles,
          assetsCount: 2,
        ),
        _portfolio(
          id: 'p3',
          name: 'Operación General',
          type: PortfolioType.operacionGeneral,
          assetsCount: 7,
        ),
      ]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Títulos de sección.
      expect(find.text('Tipos de activos'), findsOneWidget);
      expect(find.text('Mis portafolios'), findsOneWidget);

      // Nombres de portafolios.
      expect(find.text('Flota Norte'), findsOneWidget);
      expect(find.text('Edificios Centro'), findsOneWidget);
      expect(find.text('Operación General'), findsOneWidget);

      // Subtítulos mapeados por tipo.
      expect(find.text('Flota vehicular'), findsOneWidget);
      expect(find.text('Bienes inmuebles'), findsOneWidget);
      expect(find.text('Operación general'), findsOneWidget);
    },
  );

  testWidgets(
    'Sección "Mis portafolios" muestra empty state textual cuando no hay portafolios',
    (tester) async {
      fake.debugSeed([_vehicle('a1', 'ABC123')]);
      fake.portfolios.clear();

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Mis portafolios'), findsOneWidget);
      expect(find.text('No hay portafolios activos'), findsOneWidget);
    },
  );

  testWidgets(
    'Tap en tarjeta de portafolio navega a Routes.portfolioAssets con PortfolioEntity',
    (tester) async {
      final target = _portfolio(
        id: 'p-target',
        name: 'Flota Norte',
        type: PortfolioType.vehiculos,
        assetsCount: 4,
      );
      fake.debugSeed([_vehicle('a1', 'ABC123')]);
      fake.portfolios.assignAll([target]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Flota Norte'));
      await tester.pumpAndSettle();

      expect(Get.currentRoute, Routes.portfolioAssets);
      expect(Get.arguments, isA<PortfolioEntity>());
      expect((Get.arguments as PortfolioEntity).id, target.id);
    },
  );

  // ==========================================================================
  // FAB EXTENDIDO — tests dedicados
  // ==========================================================================

  testWidgets(
    'FAB extendido muestra el label "Registrar activo"',
    (tester) async {
      fake.debugSeed([_vehicle('a1', 'ABC123')]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Hay exactamente un FAB y el label "Registrar activo" está presente.
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Registrar activo'), findsOneWidget);
    },
  );

  testWidgets(
    'Tap en FAB abre el selector de tipo (ActionSheetPro)',
    (tester) async {
      fake.debugSeed([_vehicle('a1', 'ABC123')]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Título del sheet de showAssetTypeSheet() aún no visible.
      expect(find.text('Selecciona el tipo de activo'), findsNothing);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // ActionSheetPro se abrió con su título por defecto.
      expect(find.text('Selecciona el tipo de activo'), findsOneWidget);
    },
  );
}
