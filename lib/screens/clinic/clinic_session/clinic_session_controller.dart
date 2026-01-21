import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/clinic_api.dart';
import '../../clinic/model/clinics_res_model.dart';
import '../add_clinic_form/model/clinic_session_response.dart';

class ClinicSessionController extends GetxController {
  Rx<String> breStartTime = "09:00:00".obs;
  Rx<String> breEndTime = "18:00:00".obs;
  RxBool isLoading = true.obs;

  Rx<ClinicData> selectClinic = ClinicData().obs;

  //Save Clinic Session
  Rx<Future<RxList<ClinicSessionModel>>> saveClinicSessionFuture = Future(() => RxList<ClinicSessionModel>()).obs;
  RxList<ClinicSessionModel> clinicSessionResp = RxList();

  //Get Sesstion List
  Rx<Future<RxList<ClinicSessionModel>>> getClinicsFuture = Future(() => RxList<ClinicSessionModel>()).obs;
  RxList<ClinicSessionModel> clinicSessionList = RxList();

  // RxList<WeekListModel> weeklyList = <WeekListModel>[].obs;

  @override
  void onInit() {
    if (Get.arguments is ClinicData) {
      selectClinic(Get.arguments);
    }
    getClinicSessionList();
    super.onInit();
  }

  Future<void> getClinicSessionList({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await saveClinicSessionFuture(ClinicApis.getClinicSessionList(clinicId: selectClinic.value.id, clinicSessionResp: clinicSessionList)).then((value) {
      // clinicSessionList(value);
      // for (var element in clinicSessionList) {
      //   weeklyList.add(
      //     WeekListModel(day: element.day, startTime: element.startTime, endTime: element.endTime, isHoliday: element.isHoliday, breaks: element.breaks)
      //   );
      // }
    }).catchError((e) {
      toast("Error: $e");
      log("getClinicSession err: $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> saveClinicSession({bool showloader = true}) async {
    // log(weeklyList.toJson());
    final Map<String, dynamic> request = {
      "clinic_id": selectClinic.value.id.toString(),
      "weekdays": clinicSessionList.toJson(),
    };
    if (showloader) {
      isLoading(true);
    }
    await saveClinicSessionFuture(ClinicApis.saveClinicSession(request: request, clinicSessionResp: clinicSessionResp)).then((value) {
      clinicSessionResp(value);
      Get.back(result: true);
    }).catchError((e) {
      toast("Error: $e");
      log("getClinicSession err: $e");
    }).whenComplete(() => isLoading(false));
  }
}
