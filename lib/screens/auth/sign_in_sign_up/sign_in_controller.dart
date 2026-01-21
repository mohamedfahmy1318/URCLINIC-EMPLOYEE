// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../clinic/model/clinics_res_model.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../home/choose_clinic_screen.dart';
import '../../home/home_controller.dart';
import '../model/clinic_center_argument_model.dart';
import '../model/login_response.dart';
import '../../../api/auth_apis.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';
import '../model/login_roles_model.dart';
import '../services/social_logins.dart';

class SignInController extends GetxController {
  RxBool isNavigateToDashboard = false.obs;
  final GlobalKey<FormState> signInformKey = GlobalKey();

  RxBool isRememberMe = false.obs;
  RxBool isLoading = false.obs;
  RxString userName = "".obs;

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  Rx<LoginRoleData> selectedLoginRole = LoginRoleData().obs;

  void toggleSwitch() {
    isRememberMe.value = !isRememberMe.value;
  }

  @override
  void onInit() {
    if (appConfigs.value.isDummyCredential != 1) {
      emailCont.text = '';
      passwordCont.text = '';
      isRememberMe.value = false;
    }

    isRememberMe.value = getValueFromLocal(SharedPreferenceConst.IS_REMEMBER_ME) ?? false;
    if (!appConfigs.value.isMultiVendor) {
      loginRoles.removeWhere((item) => item.userType == EmployeeKeyConst.vendor);
      if (getValueFromLocal(SharedPreferenceConst.IS_REMEMBER_ME) ?? false) {
        removeValueFromLocal(SharedPreferenceConst.IS_REMEMBER_ME);
      }
    } else if (loginRoles.indexWhere((item) => item.userType == EmployeeKeyConst.vendor) == -1) {
      loginRoles.add(vendorLoginRole);
    }
    if (!appConfigs.value.isPharma.getBoolInt()) {
      loginRoles.removeWhere((item) => item.userType == EmployeeKeyConst.pharma);
    } else if (loginRoles.indexWhere((item) => item.userType == EmployeeKeyConst.pharma) == -1) {
      loginRoles.add(pharmaLoginRole);
    }
    if (Get.arguments is bool) {
      isNavigateToDashboard(Get.arguments == true);
    }
    final userIsRemeberMe = getValueFromLocal(SharedPreferenceConst.IS_REMEMBER_ME);
    final userNameFromLocal = getValueFromLocal(SharedPreferenceConst.USER_NAME);
    if (userNameFromLocal is String) {
      userName(userNameFromLocal);
    }
    if (userIsRemeberMe == true) {
      final userEmail = getValueFromLocal(SharedPreferenceConst.USER_EMAIL);
      if (userEmail is String) {
        emailCont.text = userEmail;
      }
      final userPASSWORD = getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
      if (userPASSWORD is String) {
        passwordCont.text = userPASSWORD;
      }
    }
    if ((!appConfigs.value.isMultiVendor) && (selectedLoginRole.value.userType == EmployeeKeyConst.vendor)) {
      emailCont.text = "";
      passwordCont.text = "";
      selectedLoginRole(LoginRoleData());
    }

    super.onInit();
  }

  Future<void> saveForm() async {
    hideKeyBoardWithoutContext();
    if (!selectedLoginRole.value.id.isNegative) {
      isLoading(true);
      final Map<String, dynamic> req = {
        'email': emailCont.text.trim(),
        'password': passwordCont.text.trim(),
        UserKeys.userType: selectedLoginRole.value.userType,
      };

      await AuthServiceApis.loginUser(request: req).then((value) async {
        handleLoginResponse(loginResponse: value);
      }).catchError((e) {
        isLoading(false);
        toast(e.toString(), print: true);
      });
    } else {
      toast(locale.value.pleaseSelectRoleToLogin);
    }
  }

  Future<void> googleSignIn() async {
    isLoading(true);
    await GoogleSignInAuthService.signInWithGoogle().then((value) async {
      final Map request = {
        UserKeys.contactNumber: value.mobile,
        UserKeys.email: value.email,
        UserKeys.firstName: value.firstName,
        UserKeys.lastName: value.lastName,
        UserKeys.username: value.userName,
        UserKeys.profileImage: value.profileImage,
        UserKeys.userType: selectedLoginRole.value.userType,
        UserKeys.loginType: LoginTypeConst.LOGIN_TYPE_GOOGLE,
      };
      log('signInWithGoogle REQUEST: $request');

      /// Social Login Api
      await AuthServiceApis.loginUser(request: request, isSocialLogin: true).then((value) async {
        handleLoginResponse(loginResponse: value, isSocialLogin: true);
      }).catchError((e) {
        isLoading(false);
        toast(e.toString(), print: true);
      });
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> appleSignIn() async {
    isLoading(true);
    await GoogleSignInAuthService.signInWithApple().then((value) async {
      final Map request = {
        UserKeys.contactNumber: value.mobile,
        UserKeys.email: value.email,
        UserKeys.firstName: value.firstName,
        UserKeys.lastName: value.lastName,
        UserKeys.username: value.userName,
        UserKeys.profileImage: value.profileImage,
        UserKeys.userType: selectedLoginRole.value.userType,
        UserKeys.loginType: LoginTypeConst.LOGIN_TYPE_APPLE,
      };
      log('signInWithGoogle REQUEST: $request');

      /// Social Login Api
      await AuthServiceApis.loginUser(request: request, isSocialLogin: true).then((value) async {
        handleLoginResponse(loginResponse: value, isSocialLogin: true);
      }).catchError((e) {
        isLoading(false);
        toast(e.toString(), print: true);
      });
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }

  void handleLoginResponse({required UserResponse loginResponse, bool isSocialLogin = false}) {
    if (loginResponse.userData.userRole.contains(EmployeeKeyConst.vendor) ||
        loginResponse.userData.userRole.contains(EmployeeKeyConst.doctor) ||
        loginResponse.userData.userRole.contains(EmployeeKeyConst.receptionist) ||
        loginResponse.userData.userRole.contains(EmployeeKeyConst.pharma)) {
      loginUserData(loginResponse.userData);
      loginUserData.value.isSocialLogin = isSocialLogin;
      loginUserData.value.userType = selectedLoginRole.value.userType;
      setValueToLocal(SharedPreferenceConst.USER_DATA, loginUserData.toJson());
      setValueToLocal(SharedPreferenceConst.USER_PASSWORD, isSocialLogin ? "" : passwordCont.text.trim());
      isLoggedIn(true);
      setValueToLocal(SharedPreferenceConst.IS_LOGGED_IN, true);
      setValueToLocal(SharedPreferenceConst.IS_REMEMBER_ME, isRememberMe.value);
      if (loginResponse.userData.userRole.contains(EmployeeKeyConst.pharma)) {
        selectedAppClinic(loginResponse.userData.selectedClinic);
       /* selectedAppCommission(loginResponse.userData.commission);
        log("commission length----${selectedAppCommission.length}");*/
        //setValueToLocal(SharedPreferenceConst.COMMISSION, loginResponse.userData.commission);
      }
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) && selectedAppClinic.value.id.isNegative) {
        Get.to(
          () => ChooseClinicScreen(),
          arguments: ClinicCenterArgumentModel(
            selectedClinc: selectedAppClinic.value,
          ),
        )?.then((value) {
          if (value is ClinicData) {
            selectedAppClinic(value);
            loginUserData.value.selectedClinic = value;
            setValueToLocal(SharedPreferenceConst.USER_DATA, loginUserData.toJson());
            Get.offAll(
              () => DashboardScreen(),
              binding: BindingsBuilder(() {
                Get.put(HomeController());
              }),
            );
          }
        });
      } else {
        Get.offAll(
          () => DashboardScreen(),
          binding: BindingsBuilder(() {
            Get.put(HomeController());
          }),
        );
      }
    } else {
      toast(locale.value.sorryUserCannotSignin);
    }
    isLoading(false);
  }
}
