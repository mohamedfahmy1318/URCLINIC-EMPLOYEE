// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../api/auth_apis.dart';
import 'password_set_success.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';
import '../../../utils/secure_storage_helper.dart';

class ChangePassController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newpasswordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  FocusNode oldPasswordFocus = FocusNode();
  FocusNode newpasswordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  RxBool hasUppercase = false.obs;
  RxBool hasNumber = false.obs;
  RxBool hasSpecial = false.obs;
  RxBool hasLetter = false.obs;

  RxBool passContHasFocus = false.obs;

  void checkPasswordRules(String password) {
    hasUppercase.value = RegExp(r'[A-Z]').hasMatch(password);
    hasNumber.value = RegExp(r'[0-9]').hasMatch(password);
    hasSpecial.value = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    hasLetter.value = RegExp(r'[a-z]').hasMatch(password);
  }

  @override
  void onInit() async {
    oldPasswordCont.text = await SecureStorageHelper.getUserPassword();

    // Remove any old insecure password value if it exists.
    removeValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
    super.onInit();
  }

  RxBool newPasshasFocus = false.obs;

  Future<void> saveForm() async {
    isLoading(true);
    final storedPassword = await SecureStorageHelper.getUserPassword();

    if (storedPassword != oldPasswordCont.text.trim()) {
      isLoading(false);
      return toast(locale.value.yourOldPasswordDoesnT);
    } else if (newpasswordCont.text.trim() != confirmPasswordCont.text.trim()) {
      isLoading(false);
      return toast(locale.value.yourNewPasswordDoesnT);
    } else if ((oldPasswordCont.text.trim() == newpasswordCont.text.trim()) &&
        oldPasswordCont.text.trim() == confirmPasswordCont.text.trim()) {
      isLoading(false);
      return toast(locale.value.oldAndNewPassword);
    }
    hideKeyBoardWithoutContext();

    final Map<String, dynamic> req = {
      'old_password': storedPassword,
      'new_password': confirmPasswordCont.text.trim(),
    };

    await AuthServiceApis.changePasswordAPI(request: req).then((value) async {
      isLoading(false);
      await SecureStorageHelper.saveUserPassword(
          confirmPasswordCont.text.trim());
      removeValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
      loginUserData.value.apiToken = value.data.apiToken;
      Get.to(() => const PasswordSetSuccess());
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }
}
