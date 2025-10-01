import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final RxInt index = 0.obs;

  void setIndex(int i) => index.value = i;
  void setIndexIfDifferent(int i) {
    if (index.value != i) index.value = i;
  }
}
