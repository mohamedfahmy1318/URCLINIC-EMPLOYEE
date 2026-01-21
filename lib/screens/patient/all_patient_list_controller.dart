import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';

import '../../api/core_apis.dart';
import '../../utils/app_common.dart';
import '../../utils/constants.dart';
import '../Encounter/add_encounter/model/patient_model.dart';

class AllPatientListcontroller extends GetxController {
  Rx<ClinicData> clinicData = ClinicData().obs;
  RxBool isLoading = false.obs;
  Rx<Future<RxList<PatientModel>>> patientFuture = Future(() => RxList<PatientModel>()).obs;
  RxList<PatientModel> patientList = RxList();
  RxBool isPatientLastPage = false.obs;
  RxInt patientPage = 1.obs;
  Rx<PatientModel> selectPatient = PatientModel().obs;

  @override
  void onInit() {
    getPatientList();
    super.onInit();
  }

  Future<void> getPatientList({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await patientFuture(
      CoreServiceApis.getPatientsList(
        patientsList: patientList,
        page: patientPage.value,
        clinicId: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? selectedAppClinic.value.id : null,
        lastPageCallBack: (p0) {
          isPatientLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      toast("Error: $e");
      log("getPatientsList err: $e");
    }).whenComplete(() => isLoading(false));
  }
}
