import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_list_screen.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/price_widget.dart';
import '../../clinic/clinic_list_screen.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../patient/all_patient_list.dart';
import '../../service/all_service_list_screen.dart';
import '../home_controller.dart';
import 'analytics_card.dart';

class ClinicAdminAnalyticComponent extends StatelessWidget {
  final HomeController homeScreenCont;

  const ClinicAdminAnalyticComponent({super.key, required this.homeScreenCont});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            AnalyticsCard(
              title: locale.value.totalClinic,
              countText: "${homeScreenCont.dashboardData.value.data.vendorTotalClinic}".padLeft(2, "0"),
              icon: Assets.iconsIcTotalClinic,
              onTap: () {
                Get.to(() => ClinicListScreen());
              },
            ).expand(),
            16.width,
            AnalyticsCard(
              title: locale.value.totalServices,
              countText: "${homeScreenCont.dashboardData.value.data.vendorTotalService}".padLeft(2, "0"),
              icon: Assets.iconsIcTotalService,
              onTap: () {
                Get.to(() => AllServicesScreen());
              },
            ).expand(),
          ],
        ),
        16.height,
        Row(
          children: [
            AnalyticsCard(
              title: locale.value.totalAppointments,
              countText: "${homeScreenCont.dashboardData.value.data.vendorTotalAppoinment}".padLeft(2, "0"),
              icon: Assets.navigationIcCalenderOutlined,
              onTap: () {
                changebottomIndex(1);
              },
            ).expand(),
            16.width,
            AnalyticsCard(
              title: locale.value.totalDoctors,
              countText: "${homeScreenCont.dashboardData.value.data.vendorTotalDoctors}".padLeft(2, "0"),
              icon: Assets.iconsIcDoctor,
              onTap: () {
                Get.to(() => DoctorsListScreen());
              },
            ).expand(),
          ],
        ),
        16.height,
        Row(
          children: [
            AnalyticsCard(
              title: locale.value.totalPatient,
              countText: "${homeScreenCont.dashboardData.value.data.vendorTotalPatient}".padLeft(2, "0"),
              icon: Assets.iconsIcPatients,
              onTap: () {
                Get.to(() => AllPatientList());
              },
            ).expand(),
            16.width,
            AnalyticsCard(
              title: locale.value.totalEarning,
              countText:
                  "${leftCurrencyFormat()}${homeScreenCont.dashboardData.value.data.vendorTotalEarning.validate().toStringAsFixed(appCurrency.value.noOfDecimal).formatNumberWithComma(seperator: appCurrency.value.thousandSeparator)}${rightCurrencyFormat()}",
              icon: Assets.iconsIcTotalPayout,
            ).expand(),
          ],
        ),
      ],
    );
  }
}
