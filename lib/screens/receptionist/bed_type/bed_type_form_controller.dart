import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/models/base_response_model.dart';

class BedTypeFormController extends GetxController {
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;
  RxBool isLoading = false.obs;

  FocusNode bedTypeNameFocus = FocusNode();
  FocusNode bedTypeFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  final _descriptionCharCount = 0.obs;
  int get descriptionCharCount => _descriptionCharCount.value;
  set descriptionCharCount(int value) => _descriptionCharCount.value = value;

  TextEditingController get descriptionCont => descriptionController.value;

  Map<String, dynamic>? bedTypeData;

  bool get isBedFeatureAvailable => CoreServiceApis.isBedFeatureAvailable;

  BedTypeFormController({this.bedTypeData});

  @override
  void onInit() {
    super.onInit();
    if (bedTypeData != null) {
      nameController.value.text = bedTypeData!['type'] ?? '';
      descriptionController.value.text = bedTypeData!['description'] ?? '';
    }
    _descriptionCharCount.value = descriptionController.value.text.length;
    descriptionController.value.addListener(() {
      _descriptionCharCount.value = descriptionController.value.text.length;
    });
  }

  @override
  void onClose() {
    nameController.value.dispose();
    descriptionController.value.dispose();
    bedTypeNameFocus.dispose();
    bedTypeFocus.dispose();
    descriptionFocus.dispose();
    super.onClose();
  }

  Future<void> saveBedType() async {
    if (!isBedFeatureAvailable) {
      return;
    }

    if (nameController.value.text.isEmpty) {
      toast(locale.value.pleaseEnterBedTypeName);
      return;
    }

    isLoading(true);
    try {
      final request = {
        'type': nameController.value.text,
        'description': descriptionController.value.text,
      };

      BaseResponseModel response;
      if (bedTypeData == null) {
        response = await CoreServiceApis.addBedType(request: request);
      } else {
        response = await CoreServiceApis.updateBedType(
          id: bedTypeData!['id'],
          request: request,
        );
      }

      if (response.status == true) {
        toast(response.message);
        Get.back(result: true); // Pass true to indicate successful save
      } else if (response.message.isNotEmpty) {
        toast(response.message);
      }
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }
}
