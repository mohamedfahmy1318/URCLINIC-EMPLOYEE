import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import 'model/bed_master_model.dart';

class BedController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  Rx<Future<RxList<BedMasterModel>>> bedListFuture = Future(() => RxList<BedMasterModel>()).obs;
  RxList<BedMasterModel> bedList = RxList();
  RxInt page = 1.obs;

  ///Search
  TextEditingController searchCont = TextEditingController();
  RxBool isSearchText = false.obs;
  StreamController<String> searchStream = StreamController<String>();

  @override
  void onInit() {
    searchStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getBedList();
    });
    getBedList();
    super.onInit();
  }

  Future<void> getBedList({bool showLoader = true, String search = ""}) async {
    isLoading(showLoader);
    await bedListFuture(
      CoreServiceApis.getBedList(
        bedList: bedList,
        page: page.value,
        perPage: 10,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      log('getAppointments E: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> onRefresh() async {
    page(1);
    await getBedList(showLoader: false);
    isLoading(false);
  }

  Future<void> onNextPage() async {
    if (!isLastPage.value) {
      page(page.value++);
      await getBedList(showLoader: false);
    }
  }
}
