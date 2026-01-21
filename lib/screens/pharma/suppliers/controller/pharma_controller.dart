import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/clinic_api.dart';
import 'package:kivicare_clinic_admin/api/pharma_apis.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

class PharmaController extends GetxController {
  /// --- Observables ---
  Rx<Future<RxList<Pharma>>> pharmaListFuture = Future(() => RxList<Pharma>([])).obs;

  RxList<Pharma> pharmaList = <Pharma>[].obs;
  RxBool isLoading = false.obs;
  RxInt page = 1.obs;
  RxBool isLastPage = false.obs;

  RxBool isSearchPharmaText = false.obs;
  TextEditingController searchPharmaCont = TextEditingController();
  StreamController<String> searchPharmaStream = StreamController<String>();
  final ScrollController scrollController = ScrollController();

  Rx<ClinicData> clinicData = ClinicData().obs;
  RxInt clinicId = 0.obs;
  Rx<Pharma> selectedPharma = Pharma.fromJson({}).obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      var id = Get.arguments['clinicId'];
      log("Clinic ID: $id");
      clinicId(id);
      getClinicDetail();
    }

    /// --- Debounced Search ---
    searchPharmaStream.stream.debounce(const Duration(seconds: 1)).listen((query) {
      page.value = 1;
      isLastPage.value = false;
      getPharmas(showLoader: true);
    });

    /// --- Infinite Scroll Pagination ---
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 && !isLoading.value && !isLastPage.value) {
        page.value++;
        getPharmas(showLoader: false);
      }
    });

    /// --- Initial Fetch ---
    pharmaListFuture(getPharmas());
  }

  /// --- Fetch Pharma List ---
  Future<RxList<Pharma>> getPharmas({bool showLoader = true}) async {
    if (showLoader) isLoading(true);

    try {
      final fetchedList = await PharmaApis.getPharmaList(
        pharmaList: pharmaList,
        page: page.value,
        clinicId: loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist) ? selectedAppClinic.value.id : -1,
        search: searchPharmaCont.text.trim(),
      );

      if (page.value == 1) pharmaList.clear();

      for (var pharma in fetchedList) {
        if (!pharmaList.any((p) => p.id == pharma.id)) {
          pharmaList.add(pharma);
        }
      }

      isLastPage.value = fetchedList.length < Constants.perPageItem;

      return pharmaList;
    } catch (e, st) {
      log('getPharmas Error: $e');
      log('$st');
      toast('Failed to load pharmacy list');
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  /// --- Delete Pharma ---
  Future<void> deletePharma({
    required List<Pharma> pharmalist,
    required int index,
    required BuildContext context,
  }) async {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: "Are you sure want to delete this pharma?",
      positiveText: locale.value.yes,
      negativeText: locale.value.no,
      onAccept: (ctx) async {
        isLoading(true);
        PharmaApis.deleteSupplier(id: pharmalist[index].id).then((value) async {
          pharmaListFuture(getPharmas(showLoader: true));
          toast(value.message);
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => isLoading(false));
      },
    );
  }

  /// --- Clinic Details ---
  Future<void> getClinicDetail({bool showLoader = true}) async {
    if (showLoader) isLoading(true);
    await ClinicApis.getClinicDetails(clinicId: clinicData.value.id).then((value) {
      clinicData(value.data);
    }).catchError((e) {
      log('ClinicDetail getClinicDetail err ==> $e');
    }).whenComplete(() => isLoading(false));
  }
}
