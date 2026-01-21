import 'dart:async';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../api/core_apis.dart';
import '../model/encounters_list_model.dart';
import '../model/medical_reports_res_model.dart';

class MedicalReportsController extends GetxController {
  Rx<Future<RxList<MedicalReport>>> medicalReportsFuture = Future(() => RxList<MedicalReport>()).obs;
  RxBool isLoading = false.obs;
  RxList<MedicalReport> medicalReports = RxList();
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  Rx<EncounterElement> encounterData = EncounterElement().obs;

  @override
  void onReady() {
    if (Get.arguments is EncounterElement) {
      encounterData(Get.arguments as EncounterElement);
      getMedicalReports();
    } else {}
    super.onReady();
  }

  Future<void> getMedicalReports({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await medicalReportsFuture(
      CoreServiceApis.getMedicalReports(
        page: page.value,
        encounterId: encounterData.value.id,
        medicalReports: medicalReports,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
    }).catchError((e) {
      log("getViewReportsList Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}
