import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../api/core_apis.dart';
import '../../utils/app_common.dart';
import 'model/service_list_model.dart';

class AddServiceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isSearchServiceText = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  var serviceListFuture = Rx<Future<List<ServiceElement>>?>(null);

  RxList<ServiceElement> doctorAssignServices = <ServiceElement>[].obs;
  RxList<ServiceElement> serviceList = <ServiceElement>[].obs;
  RxList<int> selectedServiceId = RxList();
  RxSet<int> userUnselectedServices = <int>{}.obs;

  TextEditingController searchServiceCont = TextEditingController();
  StreamController<String> searchServiceStream = StreamController<String>();

  @override
  void onInit() {
    try {
      if (Get.arguments is List && Get.arguments[0] is ServiceElement) {
        doctorAssignServices.addAll(Get.arguments);
      }
    } catch (e) {
      log('Billing ServicesCont Get.arguments onInit E: $e');
    }
    getAllServices();
    super.onInit();
  }

  void toggleService(ServiceElement service, bool isSelected) {
    if (isSelected) {
      selectedServiceId.add(service.id);
      userUnselectedServices.remove(service.id);
    } else {
      selectedServiceId.remove(service.id);
      userUnselectedServices.add(service.id);
    }
  }

  void mergeServices(List<ServiceElement> newServices) {
    final existingIds = serviceList.map((e) => e.id).toSet();
    final uniqueNewServices = newServices.where((e) => !existingIds.contains(e.id)).toList();
    serviceList.addAll(uniqueNewServices);
  }

  Future<void> getAllServices({bool showloader = true}) async {
    if (showloader) isLoading(true);
    serviceListFuture(
      CoreServiceApis.getServiceList(
        isAllSer: 1,
        page: page.value,
        serviceList: serviceList,
        clinicId: selectedAppClinic.value.id,
        search: searchServiceCont.text.trim(),
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    )?.then((res) {
      if (res.isNotEmpty) {
        mergeServices(res);

        for (var service in res) {
          if (doctorAssignServices.any((e) => e.id == service.id) &&
              !selectedServiceId.contains(service.id) &&
              !userUnselectedServices.contains(service.id)) {
            selectedServiceId.add(service.id);
          }
        }
      }
    }).catchError((e) {
      toast(e);
    }).whenComplete(() {
      isLoading(false);
    });
  }

  Future assignServices() async {
    Map<String, dynamic> req = {
      "service_ids": selectedServiceId,
      "clinic_id": selectedAppClinic.value.id,
      "doctor_id": loginUserData.value.id,
    };
    await CoreServiceApis.assignDoctorService(
      request: req,
    ).then((val) {
      toast(val.message);
    });
  }
}
