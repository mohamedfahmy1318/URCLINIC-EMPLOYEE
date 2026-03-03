import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/model/doctor_session_model.dart';

import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../model/doctor_list_res.dart';

class DoctorSessionController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  Rx<Future<RxList<DoctorSessionModel>>> getDoctorSession =
      Future(() => RxList<DoctorSessionModel>()).obs;
  RxList<DoctorSessionModel> doctorSession = RxList();
  RxInt page = 1.obs;
  Rx<Doctor> selectDoctorData = Doctor().obs;

  @override
  void onInit() {
    if (Get.arguments is Doctor) {
      selectDoctorData(Get.arguments as Doctor);
    }
    getDcotorsSession();
    super.onInit();
  }

  Future<void> getDcotorsSession(
      {bool showloader = true, String search = ""}) async {
    if (showloader) {
      isLoading(true);
    }
    await getDoctorSession().then((value) {}).catchError((e) {
      log('getDoctorSession: $e');
    }).whenComplete(() => isLoading(false));
  }
}
