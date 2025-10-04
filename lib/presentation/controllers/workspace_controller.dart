import 'package:get/get.dart';

class WorkspaceController extends GetxController {
  final RxInt index = 0.obs;
  void setIndex(int i) => index.value = i;
}
