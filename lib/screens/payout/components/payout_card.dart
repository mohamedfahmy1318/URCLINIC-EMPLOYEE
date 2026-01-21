import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../utils/price_widget.dart';
import '../model/payout_model.dart';

class PayoutCardWid extends StatelessWidget {
  final PayoutModel payout;

  const PayoutCardWid({super.key, required this.payout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(payout.doctorName, style: boldTextStyle(size: 16)),
              8.height,
              Text(payout.paymentDate.dateInDMMMMyyyyFormat, style: secondaryTextStyle(size: 12)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PriceWidget(
                price: payout.totalAmount,
                color: appColorPrimary,
                size: 18,
                isExtraBoldText: true,
              ),
              Text(
                payout.paymentType,
                style: boldTextStyle(size: 12, color: secondaryTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
