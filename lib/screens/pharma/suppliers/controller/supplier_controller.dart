import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/pharma_apis.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../../main.dart';
import '../../../../utils/colors.dart';

class SupplierController extends GetxController {
  Rx<Future<RxList<Supplier>>> supplierListFuture = Future(() => RxList<Supplier>()).obs;
  RxBool isLoading = false.obs;
  RxList<Supplier> supplierList = RxList();
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  //Search
  RxBool isSearchSupplierText = false.obs;
  TextEditingController searchSupplierCont = TextEditingController();
  StreamController<String> searchSupplierStream = StreamController<String>();
  final _scrollController = ScrollController();

  @override
  void onReady() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchSupplierStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getSuppliers();
    });
    getSuppliers();
    super.onReady();
  }

  Future<void> getSuppliers({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await supplierListFuture(
      PharmaApis.getSupplierList(
        supplierList: supplierList,
        page: page.value,
        search: searchSupplierCont.text.trim(),
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getSuppliers Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> deleteSupplier({required List<Supplier> supplierList, required int index, required BuildContext context}) async {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.areYouSureWantToDeleteSupplier,
      positiveText: locale.value.yes,
      negativeText: locale.value.no,
      onAccept: (ctx) async {
        isLoading(true);
        PharmaApis.deleteSupplier(id: supplierList[index].id).then((value) async {
          await getSuppliers(showLoader: true);
          toast(value.message);
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => isLoading(false));
      },
    );
  }

  @override
  void onClose() {
    searchSupplierStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}
