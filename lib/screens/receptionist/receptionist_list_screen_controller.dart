import 'dart:async';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/clinic_list_controller.dart';
import '../../api/core_apis.dart';
import 'model/receptionist_res_model.dart';

class ReceptionistsController extends GetxController {
  Rx<Future<RxList<ReceptionistData>>> getReceptionistList = Future(() => RxList<ReceptionistData>()).obs;
  RxList<ReceptionistData> receptionistList = RxList();
  RxInt page = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;

  ClinicListController clinicListCont = ClinicListController();

  Rx<ReceptionistData> receptionist = ReceptionistData().obs;

  @override
  void onReady() {
    getReceptionist();
    clinicListCont.getClinicList();
    super.onReady();
  }

  Future<void> getReceptionist({bool showloader = true, String search = ""}) async {
    if (showloader) {
      isLoading(true);
    }
    await getReceptionistList(
      CoreServiceApis.getReceptionistList(
        receptionists: receptionistList,
        page: page.value,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      log('getReceptionist E: $e');
    }).whenComplete(() => isLoading(false));
  }
}
