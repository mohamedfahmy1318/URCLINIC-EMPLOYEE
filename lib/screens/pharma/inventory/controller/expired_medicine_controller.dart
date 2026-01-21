// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../api/pharma_apis.dart';
import '../../../../utils/constants.dart';
import '../../medicine/model/medicine_resp_model.dart';

enum MedicineScreenType { all, top, expired, lowStock, select }

class ExpiredMedicineController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<Future<RxList<Medicine>>> getMedicines = Future(() => RxList<Medicine>()).obs;

  RxList<Medicine> expiredMedicineList = RxList();

  RxBool isMedicineLastPage = false.obs;
  RxInt medicinePage = 1.obs;

  TextEditingController filterMedicinesCont = TextEditingController();
  StreamController<String> searchMedicinesStream = StreamController<String>();

  final _scrollController = ScrollController();

  RxString emptyMessageText = locale.value.noMedicineFound.obs;
  RxString emptySubMessageText = locale.value.oopsNoMedicinesFound.obs;

  MedicineScreenType screenType = MedicineScreenType.all;
  int clinicId = 0;
  RxString appBarTitle = locale.value.medicines.obs;

  RxInt pharmaId = 0.obs;
  RxList<int> medsAlreadyInPresc = RxList();

  @override
  void onInit() {
    clinicId = loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? selectedAppClinic.value.id : -1;

    getAppBarTitle();
    super.onInit();
  }

  @override
  void onReady() {
    getAppBarTitle();
    getEmptyMessageText();

    _scrollController.addListener(() {
      if (Get.context != null) hideKeyboard(Get.context);
    });

    if (!searchMedicinesStream.hasListener) {
      searchMedicinesStream.stream.debounce(const Duration(seconds: 1)).listen((_) => getMedicineList(clinicId: clinicId));
    }

    getMedicineList(clinicId: clinicId);

    super.onReady();
  }

  /// Set screen title
  void getAppBarTitle() {
    switch (screenType) {
      case MedicineScreenType.top:
        appBarTitle(locale.value.topMedicines);
        break;
      case MedicineScreenType.expired:
        appBarTitle(locale.value.upcomingExpiryMedicine);
        break;
      case MedicineScreenType.lowStock:
        appBarTitle(locale.value.lowStockMedicines);
        break;
      case MedicineScreenType.select:
        appBarTitle(locale.value.selectMedicine);
        break;
      default:
        appBarTitle(locale.value.medicines);
    }
  }

  /// Set empty-state messages
  void getEmptyMessageText() {
    switch (screenType) {
      case MedicineScreenType.top:
        emptyMessageText(locale.value.noTopMedicineFound);
        emptySubMessageText(locale.value.oopsNoTopMedicines);
        break;
      case MedicineScreenType.expired:
        emptyMessageText(locale.value.noExpiredMedicineFound);
        emptySubMessageText(locale.value.oopsNoExpiredMedicines);
        break;
      case MedicineScreenType.lowStock:
        emptyMessageText(locale.value.noLowStockMedicinesFound);
        emptySubMessageText(locale.value.oopsNoLowStockMedicines);
        break;
      default:
        emptyMessageText(locale.value.noMedicineFound);
        emptySubMessageText(locale.value.oopsNoMedicinesFound);
    }
  }

  /// Load Medicines
  Future<void> getMedicineList({
    bool showLoader = true,
    int clinicId = 0,
  }) async {
    if (showLoader) isLoading(true);

    await getMedicines(
      PharmaApis.getMedicineList(
        isExpiredMedicine: true,
        medicineList: expiredMedicineList,
        searchMedicineName: [],
        searchMedicineForm: [],
        searchMedicineCategory: [],
        searchMedicineSupplier: [],
        pharmaId: pharmaId.value,
        clinicId: clinicId,
        page: medicinePage.value,
        lastPageCallBack: (isLast) => isMedicineLastPage(isLast),
      ),
    ).catchError((e) {
      log("getMedicineList err: $e");
    }).whenComplete(() {
      isLoading(false);

      DateTime today = DateTime.now();
      expiredMedicineList.value = expiredMedicineList.where((med) {
        DateTime exp = DateTime.tryParse(med.expiryDate) ?? today;
        return exp.isBefore(today);
      }).toList();
      expiredMedicineList.refresh();
    });
  }

  @override
  void onClose() {
    searchMedicinesStream.close();

    if (_scrollController.hasClients && Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }

    super.onClose();
  }
}
