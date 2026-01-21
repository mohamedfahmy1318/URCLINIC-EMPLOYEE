import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/payout/payout_history.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/price_widget.dart';
import '../../pharma/medicine/controller/medicine_list_controller.dart';
import '../../pharma/medicine/medicine_list_screen.dart';
import '../home_controller.dart';
import 'analytics_card.dart';

class PharmaAnalyticComponent extends StatelessWidget {
  final HomeController homeScreenCont;

  const PharmaAnalyticComponent({super.key, required this.homeScreenCont});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            AnalyticsCard(
              title: locale.value.totalMedicine,
              countText: "${homeScreenCont.dashboardData.value.data.pharmaTotalMedicine}".padLeft(2, "0"),
              icon: Assets.iconsIcMedicine,
              onTap: () {
                Get.to(
                  () => MedicinesListScreen(),
                  preventDuplicates: false,
                  arguments: MedicineScreenType.all,
                );
              },
            ).expand(),
            16.width,
            AnalyticsCard(
              title: locale.value.topMedicine,
              countText: "${homeScreenCont.dashboardData.value.data.pharmaTopMedicine}".padLeft(2, "0"),
              icon: Assets.iconsIcPrescription,
              onTap: () {
                Get.to(
                  () => MedicinesListScreen(),
                  preventDuplicates: false,
                  arguments: MedicineScreenType.top,
                );
              },
            ).expand(),
          ],
        ),
        16.height,
        Row(
          children: [
            AnalyticsCard(
              title: locale.value.upcomingExpiryMedicine,
              countText: "${homeScreenCont.dashboardData.value.data.pharmaExpiredMedicine}".padLeft(2, "0"),
              icon: Assets.iconsIcExpired,
              onTap: () {
                Get.to(
                  () => MedicinesListScreen(),
                  arguments: MedicineScreenType.expired,
                );
              },
            ).expand(),
            16.width,
            AnalyticsCard(
              title: locale.value.lowStockMedicine,
              countText: "${homeScreenCont.dashboardData.value.data.pharmaLowStockMedicine}".padLeft(2, "0"),
              icon: Assets.iconsIcStock,
              onTap: () {
                Get.to(
                  () => MedicinesListScreen(),
                  arguments: MedicineScreenType.lowStock,
                );
              },
            ).expand(),
          ],
        ),
        16.height,
        Row(
          children: [
            AnalyticsCard(
              title: locale.value.totalEarning,
              countText:
                  "${leftCurrencyFormat()}${homeScreenCont.dashboardData.value.data.pharmaTotalEarning.validate().toStringAsFixed(appCurrency.value.noOfDecimal).formatNumberWithComma(seperator: appCurrency.value.thousandSeparator)}${rightCurrencyFormat()}",
              icon: Assets.iconsIcPharmaEarnings,
              onTap: () {
                Get.to(() => PayoutHistory());
              },
            ).expand(),
            16.width,
            AnalyticsCard(
              title: locale.value.totalRevenue,
              countText:
                  "${leftCurrencyFormat()}${homeScreenCont.dashboardData.value.data.pharmaTotalRevenue.validate().toStringAsFixed(appCurrency.value.noOfDecimal).formatNumberWithComma(seperator: appCurrency.value.thousandSeparator)}${rightCurrencyFormat()}",
              icon: Assets.iconsIcPharmaRevenue,
            ).expand(),
          ],
        ),
      ],
    );
  }
}
