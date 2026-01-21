import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../api/core_apis.dart';
import '../../models/base_response_model.dart';
import '../../utils/app_common.dart';
import '../../utils/constants.dart';
import 'model/encounters_list_model.dart';

class AllEncountersController extends GetxController {
  Rx<Future<RxList<EncounterElement>>> encounterListFuture = Future(() => RxList<EncounterElement>()).obs;
  RxBool isLoading = false.obs;
  RxList<EncounterElement> encounterList = RxList();
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  RxBool isSearchEncounterText = false.obs;
  TextEditingController searchEncouterCont = TextEditingController();

  StreamController<String> searchEncounterStream = StreamController<String>();
  final _scrollController = ScrollController();

  //TextFiled Controller
  final GlobalKey<FormState> addEncounterFormKey = GlobalKey();
  TextEditingController selectClinic = TextEditingController();
  TextEditingController dateCont = TextEditingController();

  //Delete Encounter Details
  Rx<Future<Rx<BaseResponseModel>>> deleteEncounterFuture = Future(() => BaseResponseModel().obs).obs;
  Rx<BaseResponseModel> deleteEncounterResp = BaseResponseModel().obs;

  @override
  void onReady() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchEncounterStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getAllEncounters();
    });
    getAllEncounters();
    super.onReady();
  }

  Future<void> getAllEncounters({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await encounterListFuture(
      CoreServiceApis.getEncounterList(
        page: page.value,
        encounterList: encounterList,
        clinicId: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? selectedAppClinic.value.id : null,
        // search: searchEncouterCont.text.trim(),
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getEncounterList Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  @override
  void onClose() {
    searchEncounterStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }

  //Delete Encounter
  Future<void> deletEncounter({bool showloader = true, required int id}) async {
    if (showloader) {
      isLoading(true);
    }
    await deleteEncounterFuture(CoreServiceApis.deleteEncounter(id: id)).then((value) async {
      deleteEncounterResp(value.value);
      if (deleteEncounterResp.value.status) {
        page(1);
        await getAllEncounters();
      }
      toast(deleteEncounterResp.value.message);
    }).catchError((e) {
      toast("Error: $e");
      log("getDeleteEncounterResp err: $e");
    }).whenComplete(() => isLoading(false));
  }
}
