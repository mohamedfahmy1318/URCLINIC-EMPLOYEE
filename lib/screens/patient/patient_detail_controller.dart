// ignore_for_file: depend_on_referenced_packages
import 'package:get/get.dart';
import '../Encounter/add_encounter/model/patient_model.dart';

class PatientDetailController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<PatientModel> patientModel = PatientModel().obs;

  @override
  void onInit() {
    if (Get.arguments is PatientModel) {
      patientModel(Get.arguments);
    }
    super.onInit();
  }
}
