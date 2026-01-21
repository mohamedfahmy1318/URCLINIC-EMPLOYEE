import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_base.dart';
import '../../../../utils/price_widget.dart';
import '../../medicine/model/medicine_resp_model.dart';
import '../../prescriptions/medicine_detail_screen.dart';
import '../controller/expired_medicine_controller.dart';

class ExpiredMedicineCard extends StatelessWidget {
  final Medicine medicineData;
  final ExpiredMedicineController expiredMedicineController;

  const ExpiredMedicineCard({
    super.key,
    required this.medicineData,
    required this.expiredMedicineController,
  });

  bool get isExpired => DateTime.now().isAfter(DateTime.parse(medicineData.expiryDate));

  bool get isLowStock => medicineData.quntity.toInt() <= medicineData.reOrderLevel.toInt();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(
        borderRadius: BorderRadius.circular(12),
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleRow(),
              16.height,
              _buildInfoContainer(),
            ],
          ).paddingAll(16),
        ],
      ),
    ).onTap(() {
      Get.to(() => MedicineDetailScreen(medicineData: medicineData));
    }).paddingOnly(bottom: 16);
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            medicineData.name,
            style: boldTextStyle(size: 16, color: isDarkMode.value ? null : primaryTextColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        8.width,
        if (isExpired)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: appColorSecondary, borderRadius: BorderRadius.circular(8)),
            child: Text(locale.value.expired, style: primaryTextStyle(color: white)),
          ),
        8.width,
        PriceWidget(
          price: medicineData.sellingPrice.toDouble(),
          size: 16,
          isBoldText: true,
        ),
      ],
    );
  }

  Widget _buildInfoContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode.value ? Colors.black : appColorlightGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon1: Assets.iconsIcRuler,
            label1: locale.value.dosage,
            value1: medicineData.dosage,
            icon2: Assets.iconsIcListCheck,
            label2: locale.value.form,
            value2: medicineData.form.name,
          ),
          16.height,
          _buildInfoRow(
            icon1: Assets.iconsIcCalenderx,
            label1: locale.value.expiryDate,
            value1: medicineData.expiryDate.dateInDMMMMyyyyFormat,
            icon2: Assets.iconsIcGitBranch,
            label2: locale.value.category,
            value2: medicineData.category.name,
          ),
          16.height,
          _buildInfoRow(
            icon1: Assets.iconsIcServices,
            label1: locale.value.stock,
            value1: medicineData.quntity.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String icon1,
    required String label1,
    required String value1,
    String icon2 = "",
    String label2 = "",
    String value2 = "",
  }) {
    return Row(
      children: [
        Expanded(
          child: _infoItem(icon1, label1, value1),
        ),
        Expanded(
          child: icon2.isNotEmpty ? _infoItem(icon2, label2, value2) : const SizedBox(),
        ),
      ],
    );
  }

  Widget _infoItem(String icon, String label, String value) {
    return Row(
      children: [
        CachedImageWidget(
          url: icon,
          height: 18,
          width: 18,
          color: dividerColor,
        ).paddingTop(2),
        6.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: primaryTextStyle(color: dividerColor, size: 12)),
            4.height,
            Text(
              value,
              style: boldTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
            ),
          ],
        ),
      ],
    );
  }
}
