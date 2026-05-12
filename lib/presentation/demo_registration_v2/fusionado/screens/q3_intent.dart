// ============================================================================
// FUSIONADO — Q3: INTENT AGRUPADO EN 5 BLOQUES (con expansion inline)
//
// Sustituye "¿Cuál es tu perfil?" por una pregunta de ACCIÓN agrupando las
// opciones en 5 bloques temáticos (cada bloque = SectionCard con header +
// items separados por línea, patrón inspirado en "Mis pacientes" de la ref).
//
// BLOQUES:
//   1. Propietarios o administradores (4 items)
//      → Gestionar vehículo / inmueble / maquinaria / equipo
//      → Cada uno expande con relación: Propietario | Administrador
//   2. Arrendatarios (1 item)
//      → Tomar en arriendo
//      → Expande con 4 mercados: vehículo / inmueble / maq. / eq.
//   3. Proveedores — "Negocio con local o inventario propio" (2 items)
//      → Vender productos       → expande con 4 mercados (providerOfferType=productos)
//      → Ofrecer servicios      → expande con 4 mercados (providerOfferType=servicios)
//   4. Asesores comerciales — "Vendedor independiente o vinculado a una empresa" (1 item)
//      → Vender productos       → expande con 4 mercados (asesorMarket)
//      Nota: card y expansión IDÉNTICAS al "Vender productos" del Bloque 3.
//      La distinción se transmite vía el subtitle del header del bloque
//      (negocio con inventario vs persona-vendedor).
//   5. Profesionales especializados (3 items)
//      → Gestión inmobiliaria   → role=broker, brokerMarket=inmueble
//      → Gestión de vehículos   → role=broker, brokerMarket=vehiculo
//      → Servicios jurídicos    → role=legal, expande con civil|penal|ambas
//
//   BROKER (DemoRoleCode.broker) = INTERMEDIACIÓN DE ACTIVOS — no es
//   proveedor (no tiene inventario propio fijo) ni asegurador. Cubre 2
//   dominios HOY (inmobiliario + vehículos); maquinaria + equipos en
//   backlog (validar mercado primero).
//
//   NOTA: Asegurador/Broker REMOVIDO (modelo Invisible Broker para seguros).
//   `DemoRoleCode.insurer` + `DemoInsurerSpecialty` quedan VIVOS en código
//   pero la card es inalcanzable hasta Fase 0 con corredor real.
//   Ver decisión estratégica 2026-05 en el Bloque 5 build.
//
// Q3 captura productos vs servicios DIRECTAMENTE (antes era una pantalla extra
// post-Q4). Esto evita el "step intermedio" del antiguo q5_provider_market.
//
// Discriminador interno de expansion: String key ('renter', 'provider_productos',
// 'provider_servicios', 'asesor', 'insurer', 'legal'). Necesario porque dos
// cards comparten role=provider y la card de asesor (Bloque 4) replica el
// modelo visual del Bloque 3 mapeando a role=asesor + asesorMarket.
//
// El RUNT consult sigue en Q5 (post-commit Tu negocio) para evitar abuso.
// ============================================================================

import 'package:flutter/material.dart';

import '../../demo_state.dart';
import '../../widgets/demo_step_scaffold.dart';

class Q3Intent extends StatefulWidget {
  final DemoRegistrationState state;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const Q3Intent({
    super.key,
    required this.state,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<Q3Intent> createState() => _Q3IntentState();
}

class _Q3IntentState extends State<Q3Intent> {
  /// Card de activo expandida actualmente (Bloque 1).
  DemoAssetType? _expandedAsset;

  /// Card de servicio expandida actualmente (Bloques 2/3/4/5).
  /// String key porque varias cards mapean a roles compuestos:
  ///   - Bloque 3: 2 cards con role=provider (provider_productos / servicios)
  ///   - Bloque 5: 2 cards con role=broker (broker_inmobiliario / vehiculos)
  /// Valores: 'renter' | 'provider_productos' | 'provider_servicios' |
  ///          'asesor' | 'broker_inmobiliario' | 'broker_vehiculos' | 'legal'
  ///
  /// `'insurer'` queda DORMIDO (no alcanzable desde UI) — reservado para
  /// reactivación de la card Asegurador/Broker tras Fase 0 de seguros.
  String? _expandedService;

  /// Relación con el activo (para asset cards de Bloque 1).
  DemoRoleCode? _selectedRelation;

  /// Opción seleccionada dentro de un service card. String value que el
  /// callback de cada service card mapea a su enum específico.
  String? _selectedServiceOption;

  /// GlobalKeys por item para identificación. Las claves coinciden con
  /// `DemoAssetType.name` para asset items y con los strings de
  /// `_expandedService` para service items.
  final Map<String, GlobalKey> _itemKeys = {
    'vehiculo': GlobalKey(),
    'inmueble': GlobalKey(),
    'maquinaria': GlobalKey(),
    'equipo': GlobalKey(),
    'renter': GlobalKey(),
    'provider_productos': GlobalKey(),
    'provider_servicios': GlobalKey(),
    'asesor': GlobalKey(),
    // Broker: 2 cards en Bloque 5 (gestión inmobiliaria + vehículos).
    'broker_inmobiliario': GlobalKey(),
    'broker_vehiculos': GlobalKey(),
    'legal': GlobalKey(),
  };

  /// GlobalKeys por bloque (SectionCard). Se usan como target del auto-scroll
  /// para que el TÍTULO DEL BLOQUE quede visible al expandir un item.
  /// Si scrolleamos al item directamente, el header del bloque queda fuera
  /// del viewport y el usuario pierde contexto.
  final Map<int, GlobalKey> _sectionKeys = {
    1: GlobalKey(), // Propietarios o administradores
    2: GlobalKey(), // Arrendatarios
    3: GlobalKey(), // Proveedores
    4: GlobalKey(), // Asesores comerciales
    5: GlobalKey(), // Profesionales especializados
  };

  /// Mapea la key de un item al número de bloque que lo contiene.
  int _blockOf(String itemKey) {
    switch (itemKey) {
      case 'vehiculo':
      case 'inmueble':
      case 'maquinaria':
      case 'equipo':
        return 1;
      case 'renter':
        return 2;
      case 'provider_productos':
      case 'provider_servicios':
        return 3;
      case 'asesor':
        return 4;
      case 'broker_inmobiliario':
      case 'broker_vehiculos':
      case 'legal':
        return 5;
      default:
        return 1;
    }
  }

  /// Scrollea el viewport para que el TÍTULO DEL BLOQUE que contiene al
  /// item activo quede visible cerca del top del área visible. El usuario
  /// mantiene el contexto de "estás dentro de este bloque" y ve toda la
  /// expansión debajo. Solo se invoca al EXPANDIR (no al colapsar).
  ///
  /// alignment: 0.1 → el bloque queda a ~10% del top del viewport (pequeño
  /// respiro arriba). 0.0 lo pegaría al borde y podría quedar cortado por
  /// el AppBar/safe area en algunos dispositivos.
  void _scrollToItem(String itemKey) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final block = _blockOf(itemKey);
      final ctx = _sectionKeys[block]?.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    });
  }

  // ── Asset cards (Bloque 1) ───────────────────────────────────────────────

  void _toggleAsset(DemoAssetType type) {
    final wasExpanded = _expandedAsset == type;
    setState(() {
      if (wasExpanded) {
        _expandedAsset = null;
        _selectedRelation = null;
      } else {
        _expandedAsset = type;
        _expandedService = null;
        _selectedServiceOption = null;
        _selectedRelation = null;
      }
    });
    if (!wasExpanded) _scrollToItem(type.name);
  }

  void _selectRelation(DemoRoleCode role) {
    setState(() => _selectedRelation = role);
  }

  void _onContinueAsset() {
    final asset = _expandedAsset;
    final role = _selectedRelation;
    if (asset == null || role == null) return;

    widget.state.update(() {
      widget.state.assetType = asset;
      widget.state.role = role;
    });
    widget.onContinue();
  }

  // ── Service cards (Bloques 2/3/4) ────────────────────────────────────────

  void _toggleService(String key) {
    final wasExpanded = _expandedService == key;
    setState(() {
      if (wasExpanded) {
        _expandedService = null;
        _selectedServiceOption = null;
      } else {
        _expandedService = key;
        _expandedAsset = null;
        _selectedRelation = null;
        _selectedServiceOption = null;
      }
    });
    if (!wasExpanded) _scrollToItem(key);
  }

  void _selectServiceOption(String value) {
    setState(() => _selectedServiceOption = value);
  }

  void _onContinueService() {
    final key = _expandedService;
    final option = _selectedServiceOption;
    if (key == null || option == null) return;

    widget.state.update(() {
      // Service roles NO registran activo propio — assetType queda null
      // para que el routing los mande directo a Q6 (workspace) tras Q4.
      widget.state.assetType = null;

      switch (key) {
        case 'renter':
          widget.state.role = DemoRoleCode.renter;
          final market = _stringToAssetType(option);
          widget.state.renterMarket = market;
          // Sub-rol derivado del mercado para customizar workspace.
          // Maquinaria → operador (no cliente) refleja la realidad: la
          // maquinaria se OPERA, no se consume. Equipo sí es uso/cliente.
          widget.state.renterSubrole = switch (market) {
            DemoAssetType.vehiculo => DemoRenterSubrole.conductor,
            DemoAssetType.inmueble => DemoRenterSubrole.inquilino,
            // Maquinaria + Equipo → cliente. El que arrienda es cliente,
            // independiente de si lo opera él mismo o un tercero.
            _ => DemoRenterSubrole.cliente,
          };
          break;
        case 'provider_productos':
          widget.state.role = DemoRoleCode.provider;
          widget.state.providerOfferType = DemoProviderOfferType.productos;
          widget.state.providerMarket = _stringToAssetType(option);
          break;
        case 'provider_servicios':
          widget.state.role = DemoRoleCode.provider;
          widget.state.providerOfferType = DemoProviderOfferType.servicios;
          widget.state.providerMarket = _stringToAssetType(option);
          break;
        case 'asesor':
          widget.state.role = DemoRoleCode.asesor;
          widget.state.asesorMarket = _stringToAssetType(option);
          break;
        case 'broker_inmobiliario':
          // Broker = intermediación de activos inmobiliarios.
          // role=broker, brokerMarket=inmueble. NO usa insurer (semántica
          // limpia: insurer es solo para seguros cuando se reactive).
          widget.state.role = DemoRoleCode.broker;
          widget.state.brokerMarket = DemoAssetType.inmueble;
          break;
        case 'broker_vehiculos':
          // Broker = comercialización de vehículos.
          widget.state.role = DemoRoleCode.broker;
          widget.state.brokerMarket = DemoAssetType.vehiculo;
          break;
        case 'insurer':
          // DORMIDO: card removida del UI (Invisible Broker para seguros).
          // Switch case se mantiene para reactivación trivial post Fase 0.
          widget.state.role = DemoRoleCode.insurer;
          widget.state.insurerSpecialty = switch (option) {
            'seguros' => DemoInsurerSpecialty.seguros,
            'inmobiliario' => DemoInsurerSpecialty.inmobiliario,
            _ => null,
          };
          break;
        case 'legal':
          widget.state.role = DemoRoleCode.legal;
          widget.state.legalSpecialty = switch (option) {
            'civil' => DemoLegalSpecialty.civil,
            'penal' => DemoLegalSpecialty.penal,
            'ambas' => DemoLegalSpecialty.ambas,
            _ => null,
          };
          break;
      }
    });
    widget.onContinue();
  }

  /// Helper: mapea string value de _ServiceOption al enum DemoAssetType.
  static DemoAssetType? _stringToAssetType(String v) => switch (v) {
        'vehiculo' => DemoAssetType.vehiculo,
        'inmueble' => DemoAssetType.inmueble,
        'maquinaria' => DemoAssetType.maquinaria,
        'equipo' => DemoAssetType.equipo,
        _ => null,
      };

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // ── Active flags por bloque ──────────────────────────────────────────────
    // Determina si algún item dentro del bloque está expandido. Se pasa al
    // SectionCard para que pinte su header en cs.primary + texto cs.onPrimary
    // cuando el bloque tiene foco.
    final block1Active = _expandedAsset != null;
    final block2Active = _expandedService == 'renter';
    final block3Active = _expandedService == 'provider_productos' ||
        _expandedService == 'provider_servicios';
    final block4Active = _expandedService == 'asesor';
    final block5Active = _expandedService == 'broker_inmobiliario' ||
        _expandedService == 'broker_vehiculos' ||
        _expandedService == 'legal';

    // Mercados para Bloque 3 (Proveedores) y Bloque 4 (Asesores).
    // Subtítulos descriptivos del activo (qué es).
    const marketOptions = <_ServiceOption>[
      _ServiceOption(
        value: 'vehiculo',
        icon: Icons.directions_car_rounded,
        title: 'Vehículos',
        subtitle: 'Carros, motos, camiones',
      ),
      _ServiceOption(
        value: 'inmueble',
        icon: Icons.home_work_rounded,
        title: 'Inmuebles',
        subtitle: 'Casas, apartamentos, locales',
      ),
      _ServiceOption(
        value: 'maquinaria',
        icon: Icons.precision_manufacturing_rounded,
        title: 'Maquinaria',
        subtitle: 'Construcción, industrial, agrícola',
      ),
      _ServiceOption(
        value: 'equipo',
        icon: Icons.handyman_rounded,
        title: 'Equipos',
        subtitle: 'Audiovisual, herramientas, electrónico',
      ),
    ];

    // Mercados para Bloque 2 (Arrendatarios).
    // Subtítulos describen el SUB-ROL del usuario (qué será al elegir),
    // alineado con la derivación de `renterSubrole` en `_onContinueService`.
    // Vehículo→conductor, Inmueble→inquilino, Maq./Equipo→cliente.
    const renterMarketOptions = <_ServiceOption>[
      _ServiceOption(
        value: 'vehiculo',
        icon: Icons.directions_car_rounded,
        title: 'Vehículos',
        subtitle: 'Como conductor o arrendatario',
      ),
      _ServiceOption(
        value: 'inmueble',
        icon: Icons.home_work_rounded,
        title: 'Inmuebles',
        subtitle: 'Como inquilino',
      ),
      _ServiceOption(
        value: 'maquinaria',
        icon: Icons.precision_manufacturing_rounded,
        title: 'Maquinaria',
        subtitle: 'Como operador o arrendatario',
      ),
      _ServiceOption(
        value: 'equipo',
        icon: Icons.handyman_rounded,
        title: 'Equipos',
        subtitle: 'Como cliente o arrendatario',
      ),
    ];

    return DemoStepScaffold(
      currentStep: 2,
      // Fusionado: 4 pasos visibles (Q1, Q2, Q3, Q4). Q5 fue eliminado;
      // Q6 (workspace mock) no usa DemoStepScaffold.
      totalSteps: 4,
      title: '¿Qué quieres hacer?',
      onBack: widget.onBack,
      primaryAction: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Elige una opción para empezar.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // ════ BLOQUE 1: Propietarios o administradores ════════════════════
          _SectionCard(
            key: _sectionKeys[1],
            active: block1Active,
            expansionStates: [
              _expandedAsset == DemoAssetType.vehiculo,
              _expandedAsset == DemoAssetType.inmueble,
              _expandedAsset == DemoAssetType.maquinaria,
              _expandedAsset == DemoAssetType.equipo,
            ],
            title: 'Propietarios o administradores',
            subtitle: 'Registra y controla activos propoios o de terceros',
            children: [
              _AssetItem(
                key: _itemKeys['vehiculo'],
                type: DemoAssetType.vehiculo,
                icon: Icons.directions_car_rounded,
                label: 'Gestionar vehículo',
                tagline: 'Carro, moto, miccrobús, camión, otros.',
                expanded: _expandedAsset == DemoAssetType.vehiculo,
                selectedRelation: _selectedRelation,
                onTap: () => _toggleAsset(DemoAssetType.vehiculo),
                onRelationSelected: _selectRelation,
                onContinue: _onContinueAsset,
              ),
              _AssetItem(
                key: _itemKeys['inmueble'],
                type: DemoAssetType.inmueble,
                icon: Icons.home_work_rounded,
                label: 'Gestionar inmueble',
                tagline: 'Casa, apartamento, local',
                expanded: _expandedAsset == DemoAssetType.inmueble,
                selectedRelation: _selectedRelation,
                onTap: () => _toggleAsset(DemoAssetType.inmueble),
                onRelationSelected: _selectRelation,
                onContinue: _onContinueAsset,
              ),
              _AssetItem(
                key: _itemKeys['maquinaria'],
                type: DemoAssetType.maquinaria,
                icon: Icons.precision_manufacturing_rounded,
                label: 'Gestionar maquinaria',
                tagline: 'Construcción, industrial, agrícola',
                expanded: _expandedAsset == DemoAssetType.maquinaria,
                selectedRelation: _selectedRelation,
                onTap: () => _toggleAsset(DemoAssetType.maquinaria),
                onRelationSelected: _selectRelation,
                onContinue: _onContinueAsset,
              ),
              _AssetItem(
                key: _itemKeys['equipo'],
                type: DemoAssetType.equipo,
                icon: Icons.handyman_rounded,
                label: 'Gestionar equipo',
                tagline: 'Audiovisual, herramientas, electrónico',
                expanded: _expandedAsset == DemoAssetType.equipo,
                selectedRelation: _selectedRelation,
                onTap: () => _toggleAsset(DemoAssetType.equipo),
                onRelationSelected: _selectRelation,
                onContinue: _onContinueAsset,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ════ BLOQUE 2: Arrendatarios ═════════════════════════════════════
          _SectionCard(
            key: _sectionKeys[2],
            active: block2Active,
            expansionStates: [_expandedService == 'renter'],
            title: 'Arrendatarios',
            subtitle: 'Uso o busco activos en arriendo',
            children: [
              _ServiceItem(
                key: _itemKeys['renter'],
                label: 'Tomar o gestionar un arriendo',
                tagline: 'Vehículo, inmueble, maquinaria o equipo',
                icon: Icons.key_rounded,
                expanded: _expandedService == 'renter',
                selectedValue: _selectedServiceOption,
                expansionPrompt:
                    '¿Qué tipo de activo usas o buscas en arriendo?',
                // Subtítulos describen el SUB-ROL del renter (no el activo)
                // — preview de lo que será su workspace al confirmar.
                options: renterMarketOptions,
                onTap: () => _toggleService('renter'),
                onOptionSelected: _selectServiceOption,
                onContinue: _onContinueService,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ════ BLOQUE 3: Proveedores ═══════════════════════════════════════
          // 2 cards: productos, servicios. Distinguidas por providerOfferType
          // (capturado upfront en Q3, no en workspace).
          // Subtitle del header diferencia conceptualmente de Bloque 4
          // (Asesores comerciales): proveedor = negocio con inventario propio.
          _SectionCard(
            key: _sectionKeys[3],
            active: block3Active,
            expansionStates: [
              _expandedService == 'provider_productos',
              _expandedService == 'provider_servicios',
            ],
            title: 'Proveedores',
            subtitle: 'Impulsa las ventas de tu negocio/empresa',
            children: [
              _ServiceItem(
                key: _itemKeys['provider_productos'],
                label: 'Vender productos',
                tagline: 'Repuestos, insumos, materiales de construcción y más',
                icon: Icons.inventory_2_rounded,
                expanded: _expandedService == 'provider_productos',
                selectedValue: _selectedServiceOption,
                expansionPrompt: '¿A qué mercado atiendes?',
                options: marketOptions,
                onTap: () => _toggleService('provider_productos'),
                onOptionSelected: _selectServiceOption,
                onContinue: _onContinueService,
              ),
              _ServiceItem(
                key: _itemKeys['provider_servicios'],
                label: 'Ofrecer servicios',
                tagline:
                    'Mantenimientos, transporte, asistencia, diagnóstico, carwash y más',
                icon: Icons.miscellaneous_services_rounded,
                expanded: _expandedService == 'provider_servicios',
                selectedValue: _selectedServiceOption,
                expansionPrompt: '¿A qué mercado atiendes?',
                options: marketOptions,
                onTap: () => _toggleService('provider_servicios'),
                onOptionSelected: _selectServiceOption,
                onContinue: _onContinueService,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ════ BLOQUE 4: Asesores comerciales ══════════════════════════════
          // Card y expansión IDÉNTICAS al "Vender productos" del Bloque 3.
          // La diferenciación es el subtitle del header: persona-vendedor
          // (con o sin vínculo laboral) vs negocio con inventario.
          // Mapeo de estado: role=asesor + asesorMarket (no providerOfferType).
          _SectionCard(
            key: _sectionKeys[4],
            active: block4Active,
            expansionStates: [_expandedService == 'asesor'],
            title: 'Asesores comerciales',
            subtitle: 'Independiente o vinculado a una empresa',
            children: [
              _ServiceItem(
                key: _itemKeys['asesor'],
                label: 'Vender o  recomendar productos',
                tagline: 'Repuestos, insumos, materiales de construcción y más',
                icon: Icons.inventory_2_rounded,
                expanded: _expandedService == 'asesor',
                selectedValue: _selectedServiceOption,
                expansionPrompt: '¿A qué mercado atiendes?',
                options: marketOptions,
                onTap: () => _toggleService('asesor'),
                onOptionSelected: _selectServiceOption,
                onContinue: _onContinueService,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ════ BLOQUE 5: Profesionales especializados ══════════════════════
          //
          // DECISIÓN ESTRATÉGICA 2026-05 (asimetría de mercados):
          //
          // BROKER (DemoRoleCode.broker) = INTERMEDIACIÓN DE ACTIVOS.
          //   No es proveedor (no tiene inventario propio fijo) ni asegurador.
          //   Es el gestor/corredor/comercializador que conecta partes en
          //   transacciones de activos. Cubre 2 dominios HOY:
          //     - inmobiliario (gestor/corredor inmobiliario)
          //     - vehiculos    (gestor/comercializador de vehículos)
          //   Maquinaria + equipos están en backlog (validar mercado primero).
          //
          // SEGUROS (DemoRoleCode.insurer) — modelo "Invisible Broker":
          //   El usuario NO ve "Corredor de seguros" en UI. Cuando un seguro
          //   está por vencer, Avanzza muestra la pantalla de gestión y atrás
          //   coordina con corredor/aseguradora aliados (sin exponer canal).
          //   Razón: oferta concentrada (~15 aseguradoras), 1-2 corredores
          //   integrados cubren >95% del mercado. NO requiere self-onboarding.
          //
          //   Card "Asegurador / Broker" REMOVIDA hasta cerrar Fase 0:
          //   - Validar acuerdo comercial con corredor real
          //   - Definir SLA (cotización <10min para SOAT)
          //   - Decidir Service Fee vs Comisión sobre prima
          //   El enum DemoInsurerSpecialty y el case 'insurer' en
          //   _onContinueService siguen vivos para reactivación trivial.
          //
          // BROKER vs INMOBILIARIO/VEHÍCULOS — modelo "Marketplace abierto":
          //   Self-onboarding en Q3. Oferta fragmentada (cada gestor tiene
          //   inventario propio). Necesitamos volumen de gestores para tener
          //   catálogo competitivo vs Metrocuadrado/Fincaraíz/Tucarro.
          //
          //   Scope actual: solo capturar el rol + identidad (Q4).
          //   Listings, leads, visitas, pagos in-app van a sprints siguientes
          //   — NO se prometen aún en UI.
          _SectionCard(
            key: _sectionKeys[5],
            active: block5Active,
            expansionStates: [
              _expandedService == 'broker_inmobiliario',
              _expandedService == 'broker_vehiculos',
              _expandedService == 'legal',
            ],
            title: 'Profesionales especializados',
            subtitle: 'Servicios profesionales para activos',
            children: [
              _ServiceItem(
                key: _itemKeys['broker_inmobiliario'],
                label: 'Gestión inmobiliaria',
                tagline: 'Arriendos, ventas y administración',
                icon: Icons.home_work_rounded,
                expanded: _expandedService == 'broker_inmobiliario',
                selectedValue: _selectedServiceOption,
                expansionPrompt: '¿Qué tipo de gestión inmobiliaria realizas?',
                options: const [
                  _ServiceOption(
                    value: 'inmobiliario',
                    icon: Icons.handshake_rounded,
                    title: 'Compra-venta y arriendo de inmuebles',
                    subtitle:
                        'Conecto propietarios con compradores e inquilinos',
                  ),
                ],
                onTap: () => _toggleService('broker_inmobiliario'),
                onOptionSelected: _selectServiceOption,
                onContinue: _onContinueService,
              ),
              _ServiceItem(
                key: _itemKeys['broker_vehiculos'],
                label: 'Gestión de vehículos',
                tagline: 'Venta, trámites y comercialización',
                icon: Icons.directions_car_rounded,
                expanded: _expandedService == 'broker_vehiculos',
                selectedValue: _selectedServiceOption,
                expansionPrompt: '¿Qué tipo de gestión vehicular realizas?',
                options: const [
                  _ServiceOption(
                    value: 'vehiculos',
                    icon: Icons.handshake_rounded,
                    title: 'Compra-venta y trámites de vehículos',
                    subtitle:
                        'Conecto propietarios con compradores y gestiono trámites',
                  ),
                ],
                onTap: () => _toggleService('broker_vehiculos'),
                onOptionSelected: _selectServiceOption,
                onContinue: _onContinueService,
              ),
              _ServiceItem(
                key: _itemKeys['legal'],
                label: 'Servicios jurídicos',
                tagline: 'Abogados, trámites y reclamaciones',
                icon: Icons.gavel_rounded,
                expanded: _expandedService == 'legal',
                selectedValue: _selectedServiceOption,
                expansionPrompt: '¿Cuál es tu especialidad?',
                options: const [
                  _ServiceOption(
                    value: 'civil',
                    icon: Icons.balance_rounded,
                    title: 'Especialista civil',
                    subtitle: 'Derecho civil, contractual, comercial',
                  ),
                  _ServiceOption(
                    value: 'penal',
                    icon: Icons.gavel_rounded,
                    title: 'Especialista en penal',
                    subtitle: 'Derecho penal y procedimiento criminal',
                  ),
                  _ServiceOption(
                    value: 'ambas',
                    icon: Icons.account_balance_rounded,
                    title: 'Ambas',
                    subtitle: 'Civil y penal',
                  ),
                ],
                onTap: () => _toggleService('legal'),
                onOptionSelected: _selectServiceOption,
                onContinue: _onContinueService,
              ),
            ],
          ),
          // Spacer al final del Q3 — da margen de overscroll suficiente para
          // que `Scrollable.ensureVisible` pueda subir los últimos bloques
          // (Asesores comerciales / Profesionales especializados) a la
          // alignment 0.1 del viewport. Sin esto los bloques al final de
          // la lista no pueden scrollearse arriba porque no hay espacio
          // debajo para "empujarlos".
          SizedBox(height: MediaQuery.of(context).size.height * 0.5),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SECTION CARD — contenedor agrupador con header + items separados por línea.
// Patrón visual inspirado en card "Mis pacientes" (header arriba, ListTiles
// abajo con dividers, sin cards anidadas).
// ════════════════════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  /// Estado de expansión paralelo a `children`. Tamaño debe coincidir con
  /// `children.length`. Si `expansionStates[i] == true`, el divider DESPUÉS
  /// del item `i` se renderiza full-width con color primary fuerte (cierre
  /// visual del item expandido). Si false, divider con leading-inset 50 y
  /// color suave (estado base, neutro).
  final List<bool> expansionStates;

  /// Indica si algún item dentro del bloque está expandido. Cuando es true,
  /// el header del bloque pinta su bg en `cs.primary` y los textos en
  /// `cs.onPrimary` (alto contraste, accesible para daltónicos). Animación
  /// de 300ms — más lenta que la del item (180ms) para que el cambio de
  /// header complete la jerarquía después de aparecer la expansión.
  ///
  /// Estado base (active=false): bg con tint sutil `primaryContainer 0.18`
  /// para dar identidad de bloque siempre visible (saturación distinta del
  /// active item row 0.4 — evita ambigüedad visual).
  final bool active;

  const _SectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.expansionStates,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Lista intercalada: child / divider / child / divider / ...
    // Divider DINÁMICO según expansion state del item ANTERIOR:
    //  - Item NO expandido: leading-inset 50 + color outlineVariant 0.45
    //    (estado base, patrón "Mis pacientes" — divider arranca donde
    //    arranca el texto, sin tocar la zona de iconos).
    //  - Item expandido (anterior): full-width + color primary 0.5 — cierre
    //    visual fuerte del item, marca explícita "aquí termina el item activo".
    //  - Animación 220ms entre estados (margin + color smooth).
    final interleaved = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      interleaved.add(children[i]);
      if (i < children.length - 1) {
        final isPrevExpanded = i < expansionStates.length && expansionStates[i];
        interleaved.add(
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(left: isPrevExpanded ? 0 : 50),
            height: 1,
            color: isPrevExpanded
                ? cs.primary.withValues(alpha: 0.5)
                : cs.outlineVariant.withValues(alpha: 0.45),
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        // Fondo blanco puro (vs tinte gris previo) para mayor limpieza.
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          // Visible — define el bloque sin sentirse pesado.
          color: cs.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header — título en color de marca (cs.primary), tamaño titleMedium
            // (16px) w700. Sin icono — la jerarquía visual la da el tamaño,
            // peso y color sobre los items (bodyMedium 14px w600 onSurface).
            // Cuando `active`: bg vira a cs.primary y textos a cs.onPrimary
            // (alto contraste, refuerza "estás en este bloque"). Animación
            // 300ms más lenta que la del item para cascada visual ordenada.
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              // Estado base: tint sutil primaryContainer 0.18 → da identidad
              // de bloque siempre visible (saturación clara y distinta del
              // active item row 0.4, evita ambigüedad).
              // Estado active: cs.primary sólido + texto onPrimary.
              color: active
                  ? cs.primary
                  : cs.primaryContainer.withValues(alpha: 0.18),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: active ? cs.onPrimary : cs.primary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: active
                            ? cs.onPrimary.withValues(alpha: 0.85)
                            : cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Divider header → primer item: full-width (sin indent), más visible
            // porque marca un cambio jerárquico (categoría → contenido).
            Divider(
              color: cs.outlineVariant.withValues(alpha: 0.5),
              height: 1,
            ),
            // Items con dividers leading-inset
            ...interleaved,
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ASSET ITEM — fila tappable + expansion con relaciones (owner / admin).
// Vive dentro de un _SectionCard, sin contenedor propio (solo bg al expandirse).
// ════════════════════════════════════════════════════════════════════════════

class _AssetItem extends StatelessWidget {
  final DemoAssetType type;
  final IconData icon;
  final String label;
  final String tagline;
  final bool expanded;
  final DemoRoleCode? selectedRelation;
  final VoidCallback onTap;
  final ValueChanged<DemoRoleCode> onRelationSelected;
  final VoidCallback onContinue;

  const _AssetItem({
    super.key,
    required this.type,
    required this.icon,
    required this.label,
    required this.tagline,
    required this.expanded,
    required this.selectedRelation,
    required this.onTap,
    required this.onRelationSelected,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    // Bg LOCALIZADO solo al row del head (no a toda la expansión).
    // Más fuerte (0.4) que antes porque está acotado al head — marca claro
    // "estás dentro de este item activo" sin inundar el contenido debajo.
    final headBg = cs.primaryContainer.withValues(alpha: 0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ROW (head) — bg tintado solo cuando expanded.
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          color: expanded ? headBg : Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: expanded ? cs.primary : cs.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          // Peso w600 colapsado / w800 expandido (anclaje visual
                          // claro: el item activo "pesa más" que las opciones
                          // que despliega — w600/w700 en option tiles).
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight:
                                expanded ? FontWeight.w800 : FontWeight.w600,
                            color: expanded ? cs.primary : null,
                          ),
                        ),
                        Text(
                          tagline,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      // Chevron sutil cuando colapsado (no compite con texto).
                      color: expanded
                          ? cs.primary
                          : cs.onSurfaceVariant.withValues(alpha: 0.6),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // EXPANSIÓN (contenido) — bg neutro (cs.surface) para contrastar con
        // el head tintado. Patrón iOS: section header tintado, contenido neutro.
        AnimatedSize(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          child: expanded
              ? Container(
                  color: cs.surface,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                        child: Text(
                          '¿Qué relación tienes con ${_articulo(type)}?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ..._buildRelationTiles(theme, cs),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: FilledButton(
                          onPressed:
                              selectedRelation != null ? onContinue : null,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 46),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Continuar'),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  List<Widget> _buildRelationTiles(ThemeData theme, ColorScheme cs) {
    final relations = _relationsFor(type);
    final tiles = <Widget>[];
    for (var i = 0; i < relations.length; i++) {
      final r = relations[i];
      final isSelected = selectedRelation == r.role;
      tiles.add(
        InkWell(
          onTap: () => onRelationSelected(r.role),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  r.icon,
                  size: 20,
                  // Mismo color (cs.primary) en ambos estados, intensidad
                  // distinta: full al seleccionar, soft (alpha 0.65) en reposo.
                  color: isSelected
                      ? cs.primary
                      : cs.primary.withValues(alpha: 0.65),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected
                              ? cs.primary
                              : cs.primary.withValues(alpha: 0.65),
                        ),
                      ),
                      Text(
                        r.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: cs.primary, size: 20),
              ],
            ),
          ),
        ),
      );
      if (i < relations.length - 1) {
        tiles.add(
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Divider(
              color: cs.outlineVariant.withValues(alpha: 0.35),
              height: 1,
            ),
          ),
        );
      }
    }
    return tiles;
  }

  static String _articulo(DemoAssetType t) => switch (t) {
        DemoAssetType.vehiculo => 'el vehículo',
        DemoAssetType.inmueble => 'el inmueble',
        DemoAssetType.maquinaria => 'la maquinaria',
        DemoAssetType.equipo => 'el equipo',
        DemoAssetType.otro => 'el activo',
      };

  /// SOLO 2 opciones: Propietario / Administrador. Renter vive en su propio
  /// bloque (Bloque 2) con expansion de mercados.
  static List<_RelationOption> _relationsFor(DemoAssetType t) {
    // Owner: solo declara propiedad (sin "y quiero gestionarlo" — redundante).
    final ownerSubtitle = switch (t) {
      DemoAssetType.vehiculo => 'Soy dueño del vehículo',
      DemoAssetType.inmueble => 'Soy dueño del inmueble',
      DemoAssetType.maquinaria => 'Soy dueño de la maquinaria',
      DemoAssetType.equipo => 'Soy dueño del equipo',
      DemoAssetType.otro => 'Soy dueño del activo',
    };
    // Admin: cubre EXPLÍCITAMENTE ambos casos (propios o de terceros).
    // La relación real (% propios vs ajenos) se modela downstream en el
    // sistema de relaciones (AssetOwnership + AssetAdministration).
    // Concordancia: maquinaria es femenino singular invariante → "propia".
    final adminSubtitle = switch (t) {
      DemoAssetType.vehiculo => 'Gestiono vehículos propios o de terceros',
      DemoAssetType.inmueble => 'Gestiono inmuebles propios o de terceros',
      DemoAssetType.maquinaria => 'Gestiono maquinaria propia o de terceros',
      DemoAssetType.equipo => 'Gestiono equipos propios o de terceros',
      DemoAssetType.otro => 'Gestiono activos propios o de terceros',
    };
    return [
      _RelationOption(
        role: DemoRoleCode.owner,
        icon: Icons.workspace_premium_rounded,
        title: 'Soy el propietario',
        subtitle: ownerSubtitle,
      ),
      _RelationOption(
        role: DemoRoleCode.assetAdmin,
        icon: Icons.engineering_rounded,
        title: 'Lo administro',
        subtitle: adminSubtitle,
      ),
    ];
  }
}

class _RelationOption {
  final DemoRoleCode role;
  final IconData icon;
  final String title;
  final String subtitle;

  const _RelationOption({
    required this.role,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// SERVICE ITEM — fila tappable + expansion con opciones genéricas.
// Usado por renter / provider / asesor / insurer / legal.
// Vive dentro de un _SectionCard, sin contenedor propio.
// ════════════════════════════════════════════════════════════════════════════

class _ServiceItem extends StatelessWidget {
  final String label;
  final String tagline;
  final IconData icon;
  final bool expanded;
  final String? selectedValue;
  final String expansionPrompt;
  final List<_ServiceOption> options;
  final VoidCallback onTap;
  final ValueChanged<String> onOptionSelected;
  final VoidCallback onContinue;

  const _ServiceItem({
    super.key,
    required this.label,
    required this.tagline,
    required this.icon,
    required this.expanded,
    required this.selectedValue,
    required this.expansionPrompt,
    required this.options,
    required this.onTap,
    required this.onOptionSelected,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    // Bg LOCALIZADO solo al row del head (no a toda la expansión).
    // Más fuerte (0.4) que antes porque está acotado al head — marca claro
    // "estás dentro de este item activo" sin inundar el contenido debajo.
    final headBg = cs.primaryContainer.withValues(alpha: 0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ROW (head) — bg tintado solo cuando expanded.
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          color: expanded ? headBg : Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: expanded ? cs.primary : cs.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          // Peso w600 colapsado / w800 expandido (anclaje visual
                          // claro: el item activo "pesa más" que las opciones
                          // que despliega — w600/w700 en option tiles).
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight:
                                expanded ? FontWeight.w800 : FontWeight.w600,
                            color: expanded ? cs.primary : null,
                          ),
                        ),
                        Text(
                          tagline,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      // Chevron sutil cuando colapsado (no compite con texto).
                      color: expanded
                          ? cs.primary
                          : cs.onSurfaceVariant.withValues(alpha: 0.6),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // EXPANSIÓN (contenido) — bg neutro (cs.surface) para contrastar con
        // el head tintado. Patrón iOS: section header tintado, contenido neutro.
        AnimatedSize(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          child: expanded
              ? Container(
                  color: cs.surface,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                        child: Text(
                          expansionPrompt,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ..._buildOptionTiles(theme, cs),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: FilledButton(
                          onPressed: selectedValue != null ? onContinue : null,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 46),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Continuar'),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  List<Widget> _buildOptionTiles(ThemeData theme, ColorScheme cs) {
    final tiles = <Widget>[];
    for (var i = 0; i < options.length; i++) {
      final opt = options[i];
      final isSelected = selectedValue == opt.value;
      tiles.add(
        InkWell(
          onTap: () => onOptionSelected(opt.value),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  opt.icon,
                  size: 20,
                  // Mismo color (cs.primary) en ambos estados, intensidad
                  // distinta: full al seleccionar, soft (alpha 0.65) en reposo.
                  color: isSelected
                      ? cs.primary
                      : cs.primary.withValues(alpha: 0.65),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opt.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected
                              ? cs.primary
                              : cs.primary.withValues(alpha: 0.65),
                        ),
                      ),
                      Text(
                        opt.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: cs.primary, size: 20),
              ],
            ),
          ),
        ),
      );
      if (i < options.length - 1) {
        tiles.add(
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Divider(
              color: cs.outlineVariant.withValues(alpha: 0.35),
              height: 1,
            ),
          ),
        );
      }
    }
    return tiles;
  }
}

class _ServiceOption {
  final String value;
  final IconData icon;
  final String title;
  final String subtitle;

  const _ServiceOption({
    required this.value,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
