# IA Arquitecta – Avanzza 2.0 Models (Assets-first + Multi-Country + AI Transversal)

You are an AI software architect and Flutter/Dart code generator.
Generate Dart data models using **freezed** (+ json_serializable), targeting Clean Architecture:

- domain/entities (pure entities)
- data/models (Firestore + Isar mapping)
- repository interfaces

## Global Requirements

- Every entity: id (string), createdAt, updatedAt
- Use `@freezed` for immutability, withJson/fromJson
- Relationships by IDs (no nested documents)
- Firestore collections partitioned by orgId and/or countryId
- Multi-country aware: countryId, regionId?, cityId? in all relevant models
- All operational modules must reference `assetId` (not vehicleId)
- Support asset specializations (vehiculo, inmueble, maquinaria, etc.)

========================
A) GEO / LOCALE MODELS
========================

1. CountryModel

- id (ISO-3166 alpha-2), name, iso3
- phoneCode, timezone, currencyCode, currencySymbol
- taxName?, taxRateDefault?
- documentTypes[]
- plateFormatRegex?
- nationalHolidays: List<String> (YYYY-MM-DD)
- isActive

2. RegionModel

- id, countryId, name, code?, isActive

3. CityModel

- id, countryId, regionId, name, lat?, lng?, timezoneOverride?, isActive

4. LocalRegulationModel

- id, countryId, cityId
- picoYPlacaRules: [{ dayOfWeek, digitsRestricted[], startTime, endTime, notes? }]
- circulationExceptions?, maintenanceBlackoutDates[]
- updatedBy, sourceUrl?

5. AddressModel

- countryId, regionId?, cityId?, line1, line2?, postalCode?, lat?, lng?

========================
B) USERS / ORGS
======================== 6) OrganizationModel

- id, nombre, tipo ("empresa"|"personal")
- countryId, regionId?, cityId?
- ownerUid?, logoUrl?, metadata?
- isActive

7. UserModel

- uid, name, email, phone
- tipoDoc, numDoc
- countryId? (home), preferredLanguage?
- activeContext { orgId, orgName, rol }
- addresses?: List<AddressModel>

8. MembershipModel

- userId, orgId, orgName, roles[], estatus ("activo"|"inactivo")
- primaryLocation { countryId, regionId?, cityId? }

========================
C) ASSETS (root entity)
======================== 9) AssetModel

- id, orgId, assetType ("vehiculo"|"inmueble"|"maquinaria"|"otro")
- countryId, regionId?, cityId?
- ownerType ("org"|"user"), ownerId
- estado ("activo"|"inactivo")
- etiquetas[], fotosUrls[]

10. AssetDocumentModel

- id, assetId, tipoDoc (ej: "SOAT","Escritura","CertificadoTécnico")
- countryId, cityId?
- fechaEmision?, fechaVencimiento, estado ("vigente"|"vencido"|"por_vencer")

### Specializations

11. AssetVehiculoModel

- assetId
- refCode (3 letters+3 numbers), placa, marca, modelo, anio

12. AssetInmuebleModel

- assetId
- matriculaInmobiliaria, estrato?, metrosCuadrados?, uso ("residencial"|"comercial"), valorCatastral?

13. AssetMaquinariaModel

- assetId
- serie, marca, capacidad, categoria, certificadoOperacion?

========================
D) INCIDENTS / MAINTENANCE
======================== 14) IncidenciaModel

- id, orgId, assetId, descripcion, fotosUrls?, prioridad?
- estado ("abierta"|"cerrada"), reportedBy, cityId?

15. MaintenanceProgrammingModel

- id, orgId, assetId, incidenciasIds[]
- programmingDates[] (multi-date)
- assignedToTechId?, notes?, cityId?

16. MaintenanceProcessModel

- id, orgId, assetId, descripcion, tecnicoId
- estado ("en_proceso"), startedAt, purchaseRequestId?, cityId?

17. MaintenanceFinishedModel

- id, orgId, assetId, descripcion, fechaFin, costoTotal
- itemsUsados[], comprobantesUrls?, cityId?

========================
E) PURCHASES
======================== 18) PurchaseRequestModel

- id, orgId, assetId?, tipoRepuesto, specs?, cantidad
- ciudadEntrega (cityId), proveedorIdsInvitados[]
- estado ("abierta"|"cerrada"|"asignada"), respuestasCount
- currencyCode, expectedDate?

19. SupplierResponseModel

- id, purchaseRequestId, proveedorId
- precio, disponibilidad, currencyCode
- catalogoUrl?, notas?, leadTimeDays?

========================
F) ACCOUNTING
======================== 20) AccountingEntryModel

- id, orgId, countryId, cityId?
- tipo ("ingreso"|"egreso"), monto, currencyCode
- descripcion, fecha
- referenciaType ("asset"|"purchase"|"maintenance"|"insurance"), referenciaId
- counterpartyId?, method ("cash"|"card"|"bank"), taxAmount?, taxRate?

21. AdjustmentModel

- id, entryId, tipo ("descuento"|"recargo"), valor, motivo

========================
G) INSURANCE
======================== 22) InsurancePolicyModel

- id, assetId, tipo ("SOAT"|"todo_riesgo"|"inmueble"), aseguradora
- tarifaBase, currencyCode
- countryId, cityId?
- fechaInicio, fechaFin, estado ("vigente"|"vencido"|"por_vencer")

23. InsurancePurchaseModel

- id, assetId, compradorId
- orgId, contactEmail, address: AddressModel
- currencyCode, estadoCompra ("pendiente"|"pagado"|"confirmado")

========================
H) CHAT
======================== 24) ChatMessageModel

- id, chatId, senderId, receiverId?, groupId?
- message, attachments?, timestamp
- orgId?, cityId?, assetId?

25. BroadcastMessageModel

- id, adminId, orgId, rolObjetivo?
- message, timestamp, countryId?

========================
I) AI TRANSVERSAL
======================== 26) AIAdvisorModel

- id, orgId, userId
- modulo ("activos"|"mantenimiento"|"compras"|"contabilidad"|"seguros"|"chat")
- inputText, structuredContext (JSON with assetId, assetType, cityId, etc.)
- outputText, suggestions[]
- createdAt

27. AIPredictionModel

- id, orgId, tipo ("fallas"|"compras"|"riesgos"|"contabilidad")
- targetId (assetId, purchaseId, etc)
- score (0–1), explicacion, recomendaciones[]
- createdAt

28. AIAuditLogModel

- id, orgId, userId
- accion ("consulta"|"ejecución sugerida"|"rechazo")
- modulo, contexto, resultado
- createdAt

========================
J) REPOSITORIES
========================

- GeoRepository: countries(), regions(), cities(), localRegulations()
- OrgRepository: orgsByUser(uid), getOrg(orgId), updateOrgLocation
- UserRepository: getUser(uid), updateActiveContext, memberships(uid)
- AssetRepository: listAssetsByOrg(orgId, filters by type/city), getAssetDetails(assetId)
- MaintenanceRepository: incidencias(), programaciones(), procesos(), finalizados()
- PurchaseRepository: requestsByOrg(orgId), responsesByRequest(requestId)
- AccountingRepository: entriesByOrg(orgId), adjustments(entryId)
- InsuranceRepository: policiesByAsset(assetId), purchasesByOrg(orgId)
- ChatRepository: messagesByChat(chatId), broadcastsByOrg(orgId)
- AIRepository: analyzeAsset(), analyzeMaintenance(), recommendSuppliers(), predictCashflow(), chatAssistant(), auditLogs()

========================
K) IMPLEMENTATION NOTES
========================

- Value objects: Money {amount, currencyCode}, DateRange, GeoCoord {lat,lng}
- Models always carry countryId/cityId where locale-dependent
- All business flows reference assetId (not vehicleId)
- Specializations extend AssetModel only when needed (vehiculo, inmueble, maquinaria)
- AI logs are persisted for explainability & compliance
