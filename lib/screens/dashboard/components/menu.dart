import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';

enum BottomItem {
  home,
  appointment,
  prescriptions,
  medicines,
  payout,
  settings,
  profile,
  order,
}

class BottomBarItem {
  RxString title;
  final String icon;
  final String activeIcon;
  final String type;

  BottomBarItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.type,
  });
}

RxList<BottomBarItem> bottomNavItems = [
  BottomBarItem(title: (locale.value.home).obs, icon: Assets.navigationIcHomeOutlined, activeIcon: Assets.navigationIcHomeFilled, type: BottomItem.home.name),
  if (!loginUserData.value.userRole.contains(EmployeeKeyConst.pharma)) BottomBarItem(title: (locale.value.appointments).obs, icon: Assets.navigationIcCalenderOutlined, activeIcon: Assets.navigationIcCalenderFilled, type: BottomItem.appointment.name),
  if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma))
    BottomBarItem(title: (locale.value.prescription).obs, icon: Assets.navigationIcPrescriptionOutlined, activeIcon: Assets.navigationIcPrescriptionFilled, type: BottomItem.prescriptions.name),
  if (loginUserData.value.userRole.contains(EmployeeKeyConst.pharma)) BottomBarItem(title: (locale.value.medicines).obs, icon: Assets.navigationIcMedicineOutlined, activeIcon: Assets.navigationIcMedicineFilled, type: BottomItem.medicines.name),
  if(loginUserData.value.userRole.contains(EmployeeKeyConst.pharma)) BottomBarItem(title: (locale.value.order).obs, icon: Assets.iconsIcShoppingCart, activeIcon: Assets.iconsIcShoppingCart, type: BottomItem
      .order.name),
  if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) BottomBarItem(title: (locale.value.payouts).obs, icon: Assets.iconsIcTotalPayout, activeIcon: Assets.iconsIcTotalPayout, type: BottomItem.payout.name),
  isLoggedIn.value
      ? BottomBarItem(title: (locale.value.profile).obs, icon: Assets.navigationIcUserOutlined, activeIcon: Assets.navigationIcUserFilled, type: BottomItem.profile.name)
      : BottomBarItem(title: (locale.value.settings).obs, icon: Assets.iconsIcSettingOutlined, activeIcon: Assets.iconsIcSetting, type: BottomItem.settings.name),
].obs;

