import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/pharma_apis.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../inventory/controller/add_stock_controller.dart';

class ManufacturerController extends GetxController {
  final TextEditingController nameCont = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  final GlobalKey<FormState> manufacturerFormKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    nameCont.text = "";
    super.onInit();
  }

  @override
  void onClose() {
    nameCont.dispose();
    nameFocus.dispose();
    super.onClose();
  }

  void addManufacturer() async {
    if (manufacturerFormKey.currentState!.validate()) {
      isLoading(true);
      var request = {
        'name': nameCont.text,
      };
      await PharmaApis.saveManufacturer(request: request).then((value) async {
        if (value.status) {
          toast(locale.value.manufacturerAddedSuccessfully);
          isLoading(false);

                      Get.put<AddStockController>(AddStockController()).getManufacturers();

          Get.back(); // Corrected here
        }
      }).catchError((e) {
        isLoading(false);
      }).whenComplete(() {
        nameCont.clear();
        isLoading(false);
      });
    }
  }
}
