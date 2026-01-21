import 'dart:async';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../api/core_apis.dart';
import '../../../utils/common_base.dart';
import '../model/enc_dashboard_detail_res.dart';
import '../model/encounter_invoice_resp.dart';

class EncountersDashboardController extends GetxController {
  Rx<Future<Rx<EncounterDashboardDetail>>> encounterDetailFuture = Future(() => EncounterDashboardDetail().obs).obs;
  RxBool isLoading = false.obs;
  Rx<EncounterDashboardDetail> encounterDetail = EncounterDashboardDetail().obs;

  Rx<Future<Rx<EncounterInvoiceResp>>> encounterInvoiceFuture = Future(() => EncounterInvoiceResp().obs).obs;
  Rx<EncounterInvoiceResp> encounterInvoice = EncounterInvoiceResp().obs;

  int encounterId = -1;

  @override
  void onInit() {
    if (Get.arguments is int) {
      encounterId = Get.arguments;
      getEncounterDashboardDetail();
    }
    super.onInit();
  }


  Future<void> getEncounterDashboardDetail({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await CoreServiceApis.encounterDashboardDetail(encounterId).then((res) {
      encounterDetail(res.value);
    }).catchError((e) {
      log("getEncounterDashboardDetail Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getEncounterInvoice({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await encounterInvoiceFuture(CoreServiceApis.downloadEncounter(encounterId)).then((encounterInvoices) {
      encounterInvoice(encounterInvoices.value);
      if (encounterInvoice.value.status == true && encounterInvoice.value.link.isNotEmpty) {
        viewFiles(encounterInvoice.value.link);
      }
    }).catchError((e) {
      log("getEncounterDashboardDetail Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}