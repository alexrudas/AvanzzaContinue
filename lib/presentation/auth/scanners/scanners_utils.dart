import 'package:avanzza/presentation/auth/scanners/escanner_document_model.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import 'scanner_controller.dart';

extension UserDocumentsUtils on UserDocument {
  String getTitle() {
    switch (this) {
      case UserDocument.cardId:
        return "Cédula de ciudadanía";
      case UserDocument.drivingLicense:
        return "Licencia de conducción";
      case UserDocument.operationCard:
        return "Operation de tránsito";
      case UserDocument.ownershipCard:
        return "Tarjeta de propiedad";
    }
  }

  Future<ScannerDocumentModel?> scanDocumentFromGallery() {
    ScannerController scannerController = Get.find();
    switch (this) {
      case UserDocument.cardId:
        return scannerController.scanCodeFromGalaryImage(
          scannerController.onScanSuccedCI,
        );
      case UserDocument.drivingLicense:
        return scannerController.scanCodeFromGalaryImage(
          scannerController.onScanSuccedLicenciaConducir,
        );
      case UserDocument.operationCard:
        return scannerController.scanCodeFromGalaryImage(
          scannerController.onScanSuccedLibretaOperacion,
        );
      case UserDocument.ownershipCard:
        return scannerController.scanCodeFromGalaryImage(
          scannerController.onScanSuccedLicenciaConducir,
        );
    }
  }

  Future<ScannerDocumentModel?> scanDocumentFromCamera() {
    ScannerController scannerController = Get.find();
    ScannerDocumentModel? Function(Barcode barcode) function;
    switch (this) {
      case UserDocument.cardId:
        function = scannerController.onScanSuccedCI;
        break;
      case UserDocument.drivingLicense:
        function = scannerController.onScanSuccedLicenciaConducir;
        break;
      case UserDocument.operationCard:
        function = scannerController.onScanSuccedLibretaOperacion;
        break;
      case UserDocument.ownershipCard:
        function = scannerController.onScanSuccedTarjetaPropiedad;
        break;
    }
    return scannerController.scanCodeFromCamera(function);
  }
}
