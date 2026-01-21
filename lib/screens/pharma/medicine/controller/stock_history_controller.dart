import 'dart:async';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../api/pharma_apis.dart';
import '../model/stock_history_resp_model.dart';

class StockHistoryController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<Future<RxList<MedicineHistoryElement>>> getStockHistoryFuture = Future(() => RxList<MedicineHistoryElement>()).obs;
  RxList<MedicineHistoryElement> medHistoryList = RxList();

  RxBool isMedicineLastPage = false.obs;
  RxInt medicinePage = 1.obs;

  int medicineId = -1;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments is int) {
      medicineId = Get.arguments as int;
      getMedicineHistory();
    }
    super.onInit();
  }

  Future<void> getMedicineHistory({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getStockHistoryFuture(
      PharmaApis.getMedicineHistory(
        medHistoryList: medHistoryList,
        medId: medicineId,
        page: medicinePage.value,
        lastPageCallBack: (p0) {
          isMedicineLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      log("getMedicineList err: $e");
    }).whenComplete(() => isLoading(false));
  }
}
