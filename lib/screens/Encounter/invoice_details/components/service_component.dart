import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/price_widget.dart';
import '../model/billing_details_resp.dart';

class ServiceComponent extends StatelessWidget {
  final BillingDetailModel serviceInfo;
  final bool isEdit;
  final Function(dynamic)? onEdit;
  final Function(dynamic)? onDelete;
  const ServiceComponent({super.key, this.isEdit = false, required this.serviceInfo, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(serviceInfo.serviceName, style: boldTextStyle(size: 14, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor)),
          10.height,
          Row(
            children: [
              Text(locale.value.price, style: primaryTextStyle(size: 12, color: dividerColor)).expand(),
              PriceWidget(
                price: serviceInfo.serviceAmount,
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
