import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/pharma_apis.dart';
import 'package:kivicare_clinic_admin/screens/pharma/prescriptions/model/prescription_detail_res_model.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../main.dart';
import '../../../../utils/colors.dart';
import '../../../home/home_controller.dart';
import 'all_prescription_controller.dart';

class EditPrescriptionController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Future<Rx<PrescriptionDetail>>> getPrescriptionDetails = Future(() => PrescriptionDetail.fromJson({}).obs).obs;
  Rx<PrescriptionDetail> prescriptionDetail = PrescriptionDetail.fromJson({}).obs;

  int prescriptionId = -1;

  @override
  void onInit() {
    if (Get.arguments is int) {
      prescriptionId = Get.arguments;
    }
    init();
    super.onInit();
  }

  ///Get Prescription Detail
  Future<void> init({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getPrescriptionDetails(PharmaApis.getPrescriptionDetail(prescriptionId)).then((value) {
      prescriptionDetail = value;
    }).catchError((e) {
      isLoading(false);
      log('getPrescriptionDetail Err: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> handlePrescriptionMedicineDeleteClick({required List<MedicineInfo> medicineList, required int index, required BuildContext context}) async {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title:locale.value.areYousureYouWantToRemove,
      positiveText: locale.value.yes,
      negativeText: locale.value.no,
      onAccept: (ctx) async {
        isLoading(true);
        PharmaApis.prescriptionMedicineDelete(id: medicineList[index].id).then((value) {
          init(showLoader: true);
          toast(value.message.trim().isEmpty ? "${medicineList[index].name} ${locale.value.isRemovedSuccessfully}" : value.message.trim());
          if (Get.isRegistered<AllPrescriptionsController>()) {
            Get.find<AllPrescriptionsController>().getPrescriptions();
          }
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().getDashboardDetail();
          }
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => isLoading(false));
      },
    );
  }
}
