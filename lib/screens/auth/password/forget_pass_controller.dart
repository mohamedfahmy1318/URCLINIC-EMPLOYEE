// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../api/auth_apis.dart';
import '../../../utils/common_base.dart';

class ForgetPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  final GlobalKey<FormState> forgotPassFormKey = GlobalKey();

  TextEditingController emailCont = TextEditingController();

  Future<void> saveForm() async {
    isLoading(true);
    hideKeyBoardWithoutContext();

    final Map<String, dynamic> req = {
      'email': emailCont.text.trim(),
    };

    await AuthServiceApis.forgotPasswordAPI(request: req).then((value) async {
      isLoading(false);
      if (value.status) {
        toast(value.message.validate());
        Get.back();
      } else {
        toast(value.message.validate(), print: true);
      }
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }
}
