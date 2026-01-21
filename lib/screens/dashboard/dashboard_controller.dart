// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/medicine_list_screen.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/order_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/payout/payout_history.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../../utils/local_storage.dart';
import '../../utils/push_notification_service.dart';
import '../auth/sign_in_sign_up/signin_screen.dart';
import '../payout/payout_history_controller.dart';
import '../auth/other/settings_screen.dart';
import '../auth/profile/profile_controller.dart';
import '../auth/profile/profile_screen.dart';
import '../../api/auth_apis.dart';
import '../appointment/appointments_controller.dart';
import '../appointment/appointments_screen.dart';
import '../home/home_controller.dart';
import '../home/home_screen.dart';
import '../pharma/prescriptions/all_prescription_screen.dart';
import 'components/menu.dart';

class DashboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  Rx<BottomBarItem> selectedBottonNav = BottomBarItem(title: (locale.value.home).obs, icon: Assets.navigationIcHomeOutlined, activeIcon: Assets.navigationIcHomeFilled, type: BottomItem.home.name).obs;

  RxList<StatelessWidget> screen = [
    HomeScreen(),
    if (!loginUserData.value.userRole.contains(EmployeeKeyConst.pharma)) AppointmentsScreen(),
    if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma) || loginUserData.value.userRole.contains((EmployeeKeyConst.vendor))) AllPrescriptionsScreen(hasLeadingWidget: false),
    if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma) || loginUserData.value.userRole.contains((EmployeeKeyConst.vendor))) MedicinesListScreen(hasLeadingWidget: false),
    if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma) || loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) OrderScreen(),
    if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) PayoutHistory(isFromBottomBar: true),
    isLoggedIn.value ? ProfileScreen() : SettingScreen(),
  ].obs;

  @override
  void onInit() {
    if (!isLoggedIn.value) {
      ProfileController().getAboutPageData();
    }
    // Rebuild bottom tabs when language changes
    ever<String>(selectedLanguageCode, (_) {
      reloadBottomTabs();
    });
    PushNotificationService().registerFCMandTopics();
    getAppConfigurations(isFromDashboard: true).then((value) {
      Future.delayed(const Duration(seconds: 2), () {
        if (Get.context != null) {
          showForceUpdateDialog(Get.context!);
        }
      });
    });
    super.onInit();
  }

  @override
  void onReady() {
    reloadBottomTabs();
    if (Get.context != null) {
      View.of(Get.context!).platformDispatcher.onPlatformBrightnessChanged = () {
        WidgetsBinding.instance.handlePlatformBrightnessChanged();
        try {
          final getThemeFromLocal = getValueFromLocal(SettingsLocalConst.THEME_MODE);
          if (getThemeFromLocal is int) {
            toggleThemeMode(themeId: getThemeFromLocal);
          }
        } catch (e) {
          log('getThemeFromLocal from cache E: $e');
        }
      };
    }
    super.onReady();
  }

  void reloadBottomTabs() {
    log('reloadBottomTabs ISLOGGEDIN.VALUE: ${isLoggedIn.value}');
    bottomNavItems([
      BottomBarItem(title: (locale.value.home).obs, icon: Assets.navigationIcHomeOutlined, activeIcon: Assets.navigationIcHomeFilled, type: BottomItem.home.name),
      if (!loginUserData.value.userRole.contains(EmployeeKeyConst.pharma))
        BottomBarItem(title: (locale.value.appointments).obs, icon: Assets.navigationIcCalenderOutlined, activeIcon: Assets.navigationIcCalenderFilled, type: BottomItem.appointment.name),
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma) || loginUserData.value.userRole.contains((EmployeeKeyConst.vendor)))
        BottomBarItem(title: (locale.value.prescription).obs, icon: Assets.navigationIcPrescriptionOutlined, activeIcon: Assets.navigationIcPrescriptionFilled, type: BottomItem.prescriptions.name),
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma) || loginUserData.value.userRole.contains((EmployeeKeyConst.vendor)))
        BottomBarItem(title: (locale.value.medicines).obs, icon: Assets.navigationIcMedicineOutlined, activeIcon: Assets.navigationIcMedicineFilled, type: BottomItem.medicines.name),
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma) || loginUserData.value.userRole.contains(EmployeeKeyConst.vendor))
        BottomBarItem(title: (locale.value.order).obs, icon: Assets.iconsIcCart, activeIcon: Assets.iconsIcCart, type: BottomItem.order.name),
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) BottomBarItem(title: (locale.value.payouts).obs, icon: Assets.iconsIcTotalPayout, activeIcon: Assets.iconsIcTotalPayout, type: BottomItem.payout.name),
      isLoggedIn.value
          ? BottomBarItem(title: (locale.value.profile).obs, icon: Assets.navigationIcUserOutlined, activeIcon: Assets.navigationIcUserFilled, type: BottomItem.profile.name)
          : BottomBarItem(title: (locale.value.settings).obs, icon: Assets.iconsIcSettingOutlined, activeIcon: Assets.iconsIcSetting, type: BottomItem.settings.name),
    ]);
    bottomNavItems.refresh();
    screen(<StatelessWidget>[
      HomeScreen(),
      if (!loginUserData.value.userRole.contains(EmployeeKeyConst.pharma)) AppointmentsScreen(),
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma) || loginUserData.value.userRole.contains((EmployeeKeyConst.vendor))) AllPrescriptionsScreen(hasLeadingWidget: false),
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma) || loginUserData.value.userRole.contains((EmployeeKeyConst.vendor))) MedicinesListScreen(hasLeadingWidget: false),
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma) || loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) OrderScreen(),
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) PayoutHistory(isFromBottomBar: true),
      isLoggedIn.value ? ProfileScreen() : SettingScreen(),
    ]);

    selectedBottonNav(bottomNavItems[currentIndex.value]);
  }
}

///Get ChooseService List
Future<void> getAppConfigurations({bool isFromDashboard = false}) async {
  await AuthServiceApis.getAppConfigurations().then((value) async {
    appConfigs(value);
    // Apply admin default language dynamically
    await applyLanguageFromConfigIfChanged(value.applicationLanguage);

    /// Place ChatGPT Key Here
    chatGPTAPIkey = value.chatgptKey;

    // Check if multi-vendor is turned off and current user is a Clinic Admin (Vendor)
    if (!value.isMultiVendor && loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) {
      AuthServiceApis.clearData();
      Get.offAll(() => SignInScreen());
      return;
    }
  }).onError((error, stackTrace) {
    toast(error.toString());
  });
}

void changebottomIndex(int index) {
  DashboardController dCont = Get.find();
  dCont.selectedBottonNav(bottomNavItems[index]);
  dCont.currentIndex(index);
  try {
    if (index == 0 || (index == 3 && isLoggedIn.value)) {
      final HomeController hCont = Get.find();
      hCont.getDashboardDetail(showLoader: false);
    } else if (isLoggedIn.value && index == 1) {
      final AppointmentsController aCont = Get.find();
      aCont.page(1);
      aCont.getAppointmentList();
    } else if (index == 2) {
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) {
        final PayoutHistoryCont pCont = Get.find();
        pCont.page(1);
        pCont.getPayoutList();
      }
    }
  } catch (e) {
    log('onItemSelected Err: $e');
  }
}
