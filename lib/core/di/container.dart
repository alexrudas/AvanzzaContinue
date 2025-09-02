import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar_community/isar.dart';

import '../../data/repositories/accounting_repository_impl.dart';
import '../../data/repositories/ai_repository_impl.dart';
import '../../data/repositories/asset_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/geo_repository_impl.dart';
import '../../data/repositories/insurance_repository_impl.dart';
import '../../data/repositories/maintenance_repository_impl.dart';
import '../../data/repositories/org_repository_impl.dart';
import '../../data/repositories/purchase_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/sources/local/accounting_local_ds.dart';
import '../../data/sources/local/ai_local_ds.dart';
import '../../data/sources/local/asset_local_ds.dart';
import '../../data/sources/local/chat_local_ds.dart';
import '../../data/sources/local/geo_local_ds.dart';
import '../../data/sources/local/insurance_local_ds.dart';
import '../../data/sources/local/maintenance_local_ds.dart';
import '../../data/sources/local/org_local_ds.dart';
import '../../data/sources/local/purchase_local_ds.dart';
import '../../data/sources/local/user_local_ds.dart';
import '../../data/sources/remote/accounting_remote_ds.dart';
import '../../data/sources/remote/ai_remote_ds.dart';
import '../../data/sources/remote/asset_remote_ds.dart';
import '../../data/sources/remote/chat_remote_ds.dart';
import '../../data/sources/remote/geo_remote_ds.dart';
import '../../data/sources/remote/insurance_remote_ds.dart';
import '../../data/sources/remote/maintenance_remote_ds.dart';
import '../../data/sources/remote/org_remote_ds.dart';
import '../../data/sources/remote/purchase_remote_ds.dart';
import '../../data/sources/remote/user_remote_ds.dart';
import '../../domain/repositories/accounting_repository.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/repositories/asset_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/geo_repository.dart';
import '../../domain/repositories/insurance_repository.dart';
import '../../domain/repositories/maintenance_repository.dart';
import '../../domain/repositories/org_repository.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../platform/offline_sync_service.dart';

class DIContainer {
  static final DIContainer _instance = DIContainer._internal();
  factory DIContainer() => _instance;
  DIContainer._internal();

  late final Isar _isar;
  late final FirebaseFirestore _firestore;
  late final OfflineSyncService _syncService;

  // Data sources
  late final GeoLocalDataSource geoLocal;
  late final GeoRemoteDataSource geoRemote;
  late final OrgLocalDataSource orgLocal;
  late final OrgRemoteDataSource orgRemote;
  late final UserLocalDataSource userLocal;
  late final UserRemoteDataSource userRemote;
  late final AssetLocalDataSource assetLocal;
  late final AssetRemoteDataSource assetRemote;
  late final MaintenanceLocalDataSource maintenanceLocal;
  late final MaintenanceRemoteDataSource maintenanceRemote;
  late final PurchaseLocalDataSource purchaseLocal;
  late final PurchaseRemoteDataSource purchaseRemote;
  late final AccountingLocalDataSource accountingLocal;
  late final AccountingRemoteDataSource accountingRemote;
  late final InsuranceLocalDataSource insuranceLocal;
  late final InsuranceRemoteDataSource insuranceRemote;
  late final ChatLocalDataSource chatLocal;
  late final ChatRemoteDataSource chatRemote;
  late final AILocalDataSource aiLocal;
  late final AIRemoteDataSource aiRemote;

  // Repositories
  late final GeoRepository geoRepository;
  late final OrgRepository orgRepository;
  late final UserRepository userRepository;
  late final AssetRepository assetRepository;
  late final MaintenanceRepository maintenanceRepository;
  late final PurchaseRepository purchaseRepository;
  late final AccountingRepository accountingRepository;
  late final InsuranceRepository insuranceRepository;
  late final ChatRepository chatRepository;
  late final AIRepository aiRepository;

  Isar get isar => _isar;
  FirebaseFirestore get firestore => _firestore;
  OfflineSyncService get syncService => _syncService;
}

Future<void> initDI(
    {required Isar isar, required FirebaseFirestore firestore}) async {
  final c = DIContainer();
  c._isar = isar;
  c._firestore = firestore;
  c._syncService = OfflineSyncService();

  // Instantiate data sources
  c.geoLocal = GeoLocalDataSource(isar);
  c.geoRemote = GeoRemoteDataSource(firestore);
  c.orgLocal = OrgLocalDataSource(isar);
  c.orgRemote = OrgRemoteDataSource(firestore);
  c.userLocal = UserLocalDataSource(isar);
  c.userRemote = UserRemoteDataSource(firestore);
  c.assetLocal = AssetLocalDataSource(isar);
  c.assetRemote = AssetRemoteDataSource(firestore);
  c.maintenanceLocal = MaintenanceLocalDataSource(isar);
  c.maintenanceRemote = MaintenanceRemoteDataSource(firestore);
  c.purchaseLocal = PurchaseLocalDataSource(isar);
  c.purchaseRemote = PurchaseRemoteDataSource(firestore);
  c.accountingLocal = AccountingLocalDataSource(isar);
  c.accountingRemote = AccountingRemoteDataSource(firestore);
  c.insuranceLocal = InsuranceLocalDataSource(isar);
  c.insuranceRemote = InsuranceRemoteDataSource(firestore);
  c.chatLocal = ChatLocalDataSource(isar);
  c.chatRemote = ChatRemoteDataSource(firestore);
  c.aiLocal = AILocalDataSource(isar);
  c.aiRemote = AIRemoteDataSource(firestore);

  // Instantiate repositories
  c.geoRepository = GeoRepositoryImpl(local: c.geoLocal, remote: c.geoRemote);
  c.orgRepository = OrgRepositoryImpl(local: c.orgLocal, remote: c.orgRemote);
  c.userRepository =
      UserRepositoryImpl(local: c.userLocal, remote: c.userRemote);
  c.assetRepository =
      AssetRepositoryImpl(local: c.assetLocal, remote: c.assetRemote);
  c.maintenanceRepository = MaintenanceRepositoryImpl(
      local: c.maintenanceLocal, remote: c.maintenanceRemote);
  c.purchaseRepository =
      PurchaseRepositoryImpl(local: c.purchaseLocal, remote: c.purchaseRemote);
  c.accountingRepository = AccountingRepositoryImpl(
      local: c.accountingLocal, remote: c.accountingRemote);
  c.insuranceRepository = InsuranceRepositoryImpl(
      local: c.insuranceLocal, remote: c.insuranceRemote);
  c.chatRepository =
      ChatRepositoryImpl(local: c.chatLocal, remote: c.chatRemote);
  c.aiRepository = AIRepositoryImpl(local: c.aiLocal, remote: c.aiRemote);
}
