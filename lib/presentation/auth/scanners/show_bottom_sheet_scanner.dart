import 'package:avanzza/presentation/auth/scanners/escanner_document_model.dart';
import 'package:avanzza/presentation/auth/scanners/scanners_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<T?> showBottomSheetWidget<T>(
  BuildContext context, {
  required List<Widget> widgets,
  String title = "",
  String subTitle = "",
  Map<String, dynamic>? settingMainButtom,
}) {
  return showModalBottomSheet<T>(
    context: context,
    clipBehavior: Clip.antiAlias,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (subTitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            subTitle,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade400, thickness: 1),
              ],
              ...widgets,
              const SizedBox(height: 20),
              if (settingMainButtom != null)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  // child: WidgetButton(
                  //   typeMain: false,
                  //   text: settingMainButtom["title"],
                  //   onPressed: settingMainButtom["onTap"],
                  // ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

showBottomSheetScanner(
  BuildContext context, {
  UserDocument userDocument = UserDocument.cardId,
  required void Function(ScannerDocumentModel? user, String? error) onResult,
}) {
  showBottomSheetWidget(
    widgets: [
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
        //height: 40,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              userDocument.getTitle(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              "Selecciona un método de ingreso.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
      Divider(
        height: 5,
        thickness: 1,
        indent: 30,
        endIndent: 30,
        color: Colors.grey.shade500,
      ),
      const SizedBox(height: 10),
      ListTile(
        title: const Text("Escaner"),
        subtitle: const Text(
          "Valida la cédula escaneando el código de barra o QR y realiza consultas online.",
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: Colors.black,
        ),
        onTap: () async {
          Get.back();
          print("[showBottomSheetScanner] OnTap");

          try {
            final result = await userDocument.scanDocumentFromCamera();
            print("[showBottomSheetScanner] OnTap [result $result]");

            onResult(result, null);
          } catch (e) {
            onResult(null, e.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      "Escaner ${userDocument.getTitle()} \n ${e.toString()}")),
            );
          }
        },
      ),
      ListTile(
        title: const Text("Galería"),
        subtitle: const Text(
          "Valida la cédula seleccionando el documento desde tu galería y realiza consultas online.",
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: Colors.black,
        ),
        onTap: () async {
          Get.back();

          try {
            final result = await userDocument.scanDocumentFromGallery();
            onResult(result, null);
          } catch (e) {
            onResult(null, e.toString());

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      "Escaner ${userDocument.getTitle()} \n ${e.toString()}")),
            );
          }
        },
      ),
    ],
    context,
  );
}
