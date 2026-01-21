import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/generate_invoice/model/encounter_details_resp.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';

import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/price_widget.dart';

class FinalAmountWidget extends StatelessWidget {
  final ServiceDetails serviceDetails;
  const FinalAmountWidget({super.key, required this.serviceDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(locale.value.servicePrice, style: primaryTextStyle(size: 12, color: dividerColor)).expand(),
            PriceWidget(
              price: serviceDetails.servicePriceData.servicePrice,
              color: isDarkMode.value ? null : darkGrayTextColor,
              size: 12,
            ),
          ],
        ),
        8.height,
        Row(
          children: [
            Text(locale.value.discountAmount, style: primaryTextStyle(size: 12, color: dividerColor)).expand(),
            PriceWidget(
              price: num.parse(serviceDetails.servicePriceData.discountAmount.toString()).toStringAsFixed(Constants.DECIMAL_POINT).toDouble(),
              color: isDarkMode.value ? null : darkGrayTextColor,
              size: 12,
            ),
          ],
        ),
        8.height,
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: serviceDetails.taxData.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Text(serviceDetails.taxData[index].title, style: primaryTextStyle(size: 12, color: dividerColor)).expand(),
                PriceWidget(
                  price: serviceDetails.taxData[index].amount,
                  color: isDarkMode.value ? null : darkGrayTextColor,
                  size: 12,
                ),
              ],
            ).paddingBottom(8);
          },
        ),
        Row(
          children: [
            Text(locale.value.totalPayableAmountWithTax, style: primaryTextStyle(size: 12, color: isDarkMode.value ? null : darkGrayTextColor)).expand(),
            PriceWidget(
              price: serviceDetails.servicePriceData.totalAmount,
              color: appColorPrimary,
              size: 14,
            ),
          ],
        ),
        8.height,
      ],
    );
  }
}
