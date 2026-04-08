// ignore_for_file: avoid_print, invalid_use_of_protected_member
import 'dart:math';

import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_type_form_screen.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../network/network_utils.dart';
import '../../../utils/api_end_points.dart';
import 'model/bed_type_model.dart';
import 'dart:async';
import '../../../api/core_apis.dart';
import '../../../main.dart';

class ReceptionistBedTypeController extends GetxController {
  final isLoading = false.obs;
  RxList<BedTypeElement> bedTypes = <BedTypeElement>[].obs;
  RxList<BedTypeElement> filteredBedTypes = <BedTypeElement>[].obs;

  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController searchBedTypeCont = TextEditingController();

  final isSearchText = false.obs;
  RxString searchRx = ''.obs;

  RxInt page = 1.obs;
  RxBool isLastPage = false.obs;
  Rx<Future<RxList<BedTypeElement>>> bedTypesFuture =
      Future(() => RxList<BedTypeElement>()).obs;

  bool get isBedFeatureAvailable => CoreServiceApis.isBedFeatureAvailable;

  @override
  void onInit() {
    super.onInit();
    if (isBedFeatureAvailable) {
      getBedTypes(showloader: true);
    }
    ever(searchRx, (String s) {
      filterBedTypes(s);
    });
  }

  @override
  void onClose() {
    typeController.dispose();
    descriptionController.dispose();
    searchBedTypeCont.dispose();
    super.onClose();
  }

  Future<void> getBedTypes({bool showloader = true}) async {
    if (!isBedFeatureAvailable) {
      bedTypes.clear();
      filteredBedTypes.clear();
      isLoading(false);
      return;
    }

    if (showloader) {
      bedTypesFuture(Future(() async {
        try {
          final types = await CoreServiceApis.getBedTypes();
          if (page.value == 1) {
            bedTypes.clear();
            filteredBedTypes.clear();
          }
          bedTypes
            ..clear()
            ..addAll(types);
          filteredBedTypes
            ..clear()
            ..addAll(types);
          return bedTypes;
        } catch (e) {
          if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
            toast(e.toString());
          }
          rethrow;
        } finally {
          isLoading(false);
        }
      }));

      await bedTypesFuture.value;
    } else {
      try {
        final types = await CoreServiceApis.getBedTypes();
        if (page.value == 1) {
          bedTypes.clear();
          filteredBedTypes.clear();
        }
        bedTypes
          ..clear()
          ..addAll(types);
        filteredBedTypes
          ..clear()
          ..addAll(types);
      } catch (e) {
        if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
          toast(e.toString());
        }
      }
    }
  }

  void filterBedTypes(String query) {
    if (query.isEmpty) {
      filteredBedTypes.value = bedTypes.value;
    } else {
      filteredBedTypes.value = bedTypes
          .where((bedType) =>
              bedType.type.toLowerCase().contains(query.toLowerCase()) ||
              bedType.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> addBedType(Map<String, dynamic> bedType) async {
    if (!isBedFeatureAvailable) return;

    if (isLoading.value) return;
    isLoading(true);
    try {
      var multiPartRequest = await getMultiPartRequest(APIEndPoints.bedType);
      multiPartRequest.fields.addAll(await getMultipartFields(val: bedType));
      multiPartRequest.headers.addAll(buildHeaderTokens());

      await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
        final response = jsonDecode(temp);
        if (response['status'] == true) {
          await getBedTypes();
          Get.back();
          toast(e.toString());
        } else {
          toast(response['message'] ?? locale.value.somethingWentWrong);
        }
      }, onError: (error) {
        toast(error.toString());
      });
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateBedType(Map<String, dynamic> bedType) async {
    if (!isBedFeatureAvailable) return;

    if (isLoading.value) return;
    isLoading(true);
    try {
      final response = await handleResponse(await buildHttpResponse(
          '${APIEndPoints.bedType}/${bedType['id']}',
          request: {
            'type': bedType['type'],
            'description': bedType['description'],
            '_method': 'PUT'
          },
          method: HttpMethodType.POST));

      if (response['status'] == true) {
        await getBedTypes();
        Get.back();
        toast(locale.value.bedTypeUpdatedSuccessfully);
      } else if ((response['message'] ?? '').toString().isNotEmpty) {
        toast(response['message'] ?? locale.value.somethingWentWrong);
      }
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteBedType(int id) async {
    if (!isBedFeatureAvailable) return;

    isLoading(true);
    try {
      final response = await handleResponse(await buildHttpResponse(
          '${APIEndPoints.bedType}/$id',
          method: HttpMethodType.DELETE));
      if (response['status'] == true) {
        await getBedTypes();
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        toast('${locale.value.deleteBedType} ${locale.value.successfully}');
      } else if ((response['message'] ?? '').toString().isNotEmpty) {
        toast(response['message'] ?? locale.value.somethingWentWrong);
      }
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  void showAddBedType() {
    typeController.clear();
    descriptionController.clear();

    Get.to(() => BedTypeFormScreen())?.then((result) {
      if (result == true) {
        getBedTypes();
      }
    });
  }

  void showEditBedTypeDialog(BedTypeElement bedType) {
    typeController.text = bedType.type;
    descriptionController.text = bedType.description;

    Get.to(() => BedTypeFormScreen(bedTypeData: bedType.toJson()))
        ?.then((result) {
      if (result == true) {
        getBedTypes();
      }
    });
  }

  void showDeleteConfirmationDialog(BedTypeElement bedType) {
    showConfirmDialogCustom(
      Get.context!,
      primaryColor: appColorSecondary,
      title: locale.value.deleteBedType,
      subTitle: '${locale.value.deleteConfirmation} ${bedType.type}?',
      onAccept: (context) {
        deleteBedType(bedType.id);
        Get.back();
      },
    );
  }

  void onNextPage() {
    if (!isLastPage.value) {
      page(page.value + 1);
      getBedTypes(showloader: false);
    }
  }

  Future<void> onRefresh() async {
    page(1);
    return await getBedTypes(showloader: false);
  }
}
