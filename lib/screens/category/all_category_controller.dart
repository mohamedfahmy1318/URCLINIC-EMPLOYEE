import 'dart:developer';
import 'package:get/get.dart';
import '../../api/core_apis.dart';
import 'model/all_category_model.dart';

class AllCategoriesCont extends GetxController {
  Rx<Future<RxList<CategoryElement>>> categoryListFuture = Future(() => RxList<CategoryElement>()).obs;
  RxBool isLoading = false.obs;
  RxList<CategoryElement> categoryList = RxList();
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  @override
  void onInit() {
    getCategoryList();
    super.onInit();
  }

  Future<void> getCategoryList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await categoryListFuture(
      CoreServiceApis.getCategoryList(
        page: page.value,
        categories: categoryList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      isLoading(false);
      log('CategoryList getCategoryList err ==> $e');
    }).whenComplete(() => isLoading(false));
  }
}
