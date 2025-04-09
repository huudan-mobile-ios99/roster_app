import 'package:get/get.dart';
import 'package:vegas_roster/Util/string.dart';

class MyGetXController extends GetxController {
  RxString shiftCode = MyString.edit_dialog.obs;
  RxString shiftCode2 = "".obs;
  RxString shiftCodeOld = "".obs;
  RxInt totalNotification = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  decreaseTotalNotification() {
    totalNotification--;
    update();
  }

  saveNotification(v) {
    totalNotification = v;
    update();
  }

  removeNotification() {
    totalNotification = 0.obs;
    update();
  }

  saveShiftCode(v, v2, v3) {
    shiftCode = v;
    shiftCode2 = v2;
    shiftCodeOld = v3;
    update();
  }

  removeShiftCode() {
    shiftCode = MyString.edit_dialog.obs;
    shiftCode2 = "".obs;
    shiftCodeOld = "".obs;
    update();
  }
}
