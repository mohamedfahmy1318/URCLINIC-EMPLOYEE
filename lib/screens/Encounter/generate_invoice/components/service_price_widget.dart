import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/generate_invoice/model/encounter_details_resp.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/price_widget.dart';

class ServicePriceWidget extends StatelessWidget {
  final ServiceDetails serviceDetails;
  const ServicePriceWidget({super.key, required this.serviceDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(serviceDetails.name, style: boldTextStyle(size: 14, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor)),
          10.height,
          Row(
            children: [
              Text(locale.value.price, style: primaryTextStyle(size: 12, color: dividerColor)).expand(),
              PriceWidget(
                price: serviceDetails.servicePriceData.serviceAmount,
                color: appColorPrimary,
                size: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
