import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/screens/doctor/model/review_model.dart';

import '../model/doctor_list_res.dart';

class DoctorReviewController extends GetxController {
  Rx<Future<RxList<ReviewModel>>> doctorsFuture = Future(() => RxList<ReviewModel>()).obs;
  RxBool isLoading = false.obs;
  RxList<ReviewModel> reviewList = RxList();
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  Rx<Doctor> doctorDet = Doctor().obs;

  @override
  void onInit() {
    if (Get.arguments is Doctor) {
      doctorDet(Get.arguments);
    }
    getReviews();
    super.onInit();
  }

  Future<void> getReviews({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await doctorsFuture(
      CoreServiceApis.getReviewList(
        doctorId: doctorDet.value.doctorId,
        page: page.value,
        reviewList: reviewList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getDoctors error $e");
    }).whenComplete(() => isLoading(false));
  }
}
