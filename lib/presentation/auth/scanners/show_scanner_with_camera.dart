import 'package:avanzza/presentation/auth/scanners/camera_barcode_detecter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowScannerWithCamera extends StatelessWidget {
  const ShowScannerWithCamera({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CameraBarcodeDetecter(
      // onBackButtonPressed: () {
      //   Get.back();
      // },
      customPaint: const CustomPaint(),
      onScanSuccess: (barcode) {
        print("[ShowScannerWithCamera] result => $barcode");
        Get.back(result: barcode);
      },
    ));
  }
}
