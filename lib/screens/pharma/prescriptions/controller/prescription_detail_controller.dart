import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/pharma_apis.dart';
import 'package:kivicare_clinic_admin/screens/pharma/prescriptions/model/prescription_detail_res_model.dart';
import 'package:nb_utils/nb_utils.dart';

class PrescriptionDetailController extends GetxController {
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
}
