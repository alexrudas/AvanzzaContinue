import 'dart:typed_data';

import 'package:avanzza/presentation/auth/scanners/escanner_document_model.dart';
import 'package:avanzza/presentation/auth/scanners/show_scanner_with_camera.dart';
import 'package:avanzza/presentation/auth/scanners/user_barcode_decoder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';

class ScannerController {
  Uint8List? createdCodeBytes;
  bool isMultiScan = false;
  bool showDebugInfo = true;
  int successScans = 0;
  int failedScans = 0;
  ScannerDocumentModel user =
      ScannerDocumentModel(userDocument: UserDocument.cardId);
  UserDecoder decoder = UserDecoder();

  //Obtiene una imagen de la caleria e intenta buscar el codigo de barras de cedula de identidad en el para obtener los datos del usuario
  Future<ScannerDocumentModel?> scanCodeFromGalaryImage(
      Function(Barcode) onScanSucced) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      final BarcodeScanner barcodeScanner = BarcodeScanner();

      final barcodes = await barcodeScanner
          .processImage(InputImage.fromFilePath(pickedFile.path));
      if (barcodes.isNotEmpty) {
        return onScanSucced(barcodes.first);
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text("No se encontro ningun codigo")),
        );
      }
    }
    return null;
  }

  Future<ScannerDocumentModel?> scanCodeFromCamera(
      Function(Barcode) onScanSucced) async {
    final barcode = await Get.to(() => const ShowScannerWithCamera());
    if (barcode != null) {
      return onScanSucced(barcode);
    }
    return null;
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) =>
    //           ShowScannerWithCamera(onScanSucced: onScanSucced)),
    // );
  }

  ScannerDocumentModel? _decode(
    Barcode barcode, {
    required ScannerDocumentModel Function(Uint8List rawBytes) first,
    required ScannerDocumentModel Function(Uint8List rawBytes) secondTry,
  }) {
    try {
      ScannerDocumentModel usuarioEscaneado = first(barcode.rawBytes!);

      // showCustomSnackbar("Scanner", "Escaneado con exito",
      //     type: CustomSnackbarType.success);
      return usuarioEscaneado;
    } catch (e) {
      try {
        ScannerDocumentModel usuarioEscaneado = secondTry(barcode.rawBytes!);
        return usuarioEscaneado;
      } catch (e) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text("Scanner - error $e")),
        );
        return null;
      }
    }
  }

  ///Convierte el codigo de barras de la cedula en bits e intenta otener los datos del usuario a partir de el
  ScannerDocumentModel? onScanSuccedCI(Barcode barcode) {
    return _decode(barcode,
        first: decoder.getUserCiCode,
        secondTry: decoder.getUserDeBarcodeLicenciaDeConducir);
  }

  ///Convierte el codigo de barras de la licencia de conducir en bits e intenta otener los datos del usuario a partir de el
  ScannerDocumentModel? onScanSuccedLicenciaConducir(Barcode barcode) {
    return _decode(barcode,
        first: decoder.getUserDeBarcodeLicenciaDeConducir,
        secondTry: decoder.getUserDeBarcodeLicenciaDeConducir);
  }

  ///Convierte el codigo de barras de la libreta de operacion en bits e intenta otener los datos del usuario a partir de el
  ScannerDocumentModel? onScanSuccedLibretaOperacion(Barcode barcode) {
    return _decode(barcode,
        first: decoder.getUserFromTarjetaOperacionCode,
        secondTry: decoder.getUserDeBarcodeLicenciaDeConducir);
  }

  ScannerDocumentModel? onScanSuccedTarjetaPropiedad(Barcode barcode) {
    return _decode(barcode,
        first: decoder.getUserFromTarjetaPropiedadCode,
        secondTry: decoder.getUserDeBarcodeLicenciaDeConducir);
  }
}
