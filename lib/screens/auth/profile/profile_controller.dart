// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/local_storage.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../api/auth_apis.dart';
import '../../../utils/app_common.dart';
import '../../doctor/model/commission_list_model.dart';
import '../../doctor/model/doctor_list_res.dart';
import '../sign_in_sign_up/signin_screen.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isAutoUpdateOn = false.obs;
  RxString commissionIds = "".obs;
  RxList<CommissionElement> commissionFilterList = RxList();
  TextEditingController searchCont = TextEditingController();
  RxList<CommissionElement> commissionList = RxList();
  RxBool isEdit = false.obs;
  Rx<Doctor> doctorData = Doctor().obs;
  RxBool hasErrorFetchingCommission = false.obs;
  RxString errorMessageCommission = "".obs;

num commission = 0;
  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    getAboutPageData();
    commission = getValueFromLocal(SharedPreferenceConst.COMMISSION)??0;

    isAutoUpdateOn(getValueFromLocal(AutoUpdateConst.isAutoUpdateOn) ?? false);
  }

  Future<void> handleLogout() async {
    if (isLoading.value) return;
    isLoading(true);
    log('HANDLELOGOUT: called');
    await AuthServiceApis.logoutApi().then((value) {
      isLoading(false);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() {
      AuthServiceApis.clearData();
      isLoading(false);
      Get.offAll(() => SignInScreen());
    });

  }

  ///Get About Pages
  void getAboutPageData({bool isFromSwipeRefresh = false}) {
    if (!isFromSwipeRefresh) {
      isLoading(true);
    }
    isLoading(true);
    AuthServiceApis.getAboutPageData().then((value) {
      isLoading(false);
      aboutPages(value.data);
    }).onError((error, stackTrace) {
      isLoading(false);
      toast(error.toString());
    });
  }

  bool get isShowFullList => commissionFilterList.isEmpty && searchCont.text.trim().isEmpty;

  void setCommissionContValue({required List<CommissionElement> commissionList}) {
    commissionIds(commissionList.where((item) => item.isSelected.value && !item.id.isNegative).map((item) => item.id.toString()).toList().join(","));
  }
}
