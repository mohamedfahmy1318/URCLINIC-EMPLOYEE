import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/screens/payout/model/payout_model.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';

class PayoutHistoryCont extends GetxController {
  Rx<ClinicData> clinicData = ClinicData().obs;

  RxBool isLoading = false.obs;
  Rx<Future<RxList<PayoutModel>>> getPayoutFuture = Future(() => RxList<PayoutModel>()).obs;
  RxList<PayoutModel> payoutList = RxList();
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  @override
  void onInit() {
    getPayoutList();
    super.onInit();
  }

  Future<void> getPayoutList({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await getPayoutFuture(
      CoreServiceApis.getPayoutList(
        payoutList: payoutList,
        page: page.value,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      toast("Error: $e");
      log("getPayoutsList err: $e");
    }).whenComplete(() => isLoading(false));
  }
}
