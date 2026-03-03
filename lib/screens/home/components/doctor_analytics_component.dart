import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/patient/all_patient_list.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';

import '../../dashboard/dashboard_controller.dart';
import '../../service/all_service_list_screen.dart';
import '../home_controller.dart';
import 'analytics_card.dart';

class DoctorAnalyticComponent extends StatelessWidget {
  final HomeController homeScreenCont;

  const DoctorAnalyticComponent({super.key, required this.homeScreenCont});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            AnalyticsCard(
              title: locale.value.totalAppointments,
              countText:
                  "${homeScreenCont.dashboardData.value.data.doctorTotalAppointments}"
                      .padLeft(2, "0"),
              icon: Assets.navigationIcCalenderOutlined,
              onTap: () {
                changebottomIndex(1);
              },
            ).expand(),
            16.width,
            AnalyticsCard(
              title: locale.value.totalServices,
              countText:
                  "${homeScreenCont.dashboardData.value.data.doctorTotalServiceCount}"
                      .padLeft(2, "0"),
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
              title: locale.value.totalPatient,
              countText:
                  "${homeScreenCont.dashboardData.value.data.doctorTotalPatient}"
                      .padLeft(2, "0"),
              icon: Assets.iconsIcPatients,
              onTap: () {
                Get.to(() => AllPatientList());
              },
            ).expand(),
            16.width,
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
