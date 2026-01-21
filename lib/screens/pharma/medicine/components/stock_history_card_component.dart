import 'package:flutter/material.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/stock_history_resp_model.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../utils/common_base.dart';
import '../../../../utils/price_widget.dart';

class StockHistoryCardWidget extends StatelessWidget {
  final MedicineHistoryElement medHistData;

  const StockHistoryCardWidget({
    super.key,
    required this.medHistData,
  });

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
          buildInfoContainer(),
        ],
      ),
    );
  }

  Widget buildInfoContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            label1: locale.value.date,
            value1: medHistData.updatedAt.dateInDMMMMyyyyFormat,
            label2: locale.value.batchNumber,
            value2: medHistData.batchNo,
          ),
          16.height,
          _buildInfoRow(
            label1: locale.value.startSerialNumber,
            value1: medHistData.startSerialNo,
            label2: locale.value.endSerialNumber,
            value2: medHistData.endSerialNo,
          ),
          16.height,
          _buildInfoRow(
            label1: locale.value.quantity,
            value1: medHistData.quantity.toString(),
            label2: locale.value.stockValue,
            value2: medHistData.stockValue,
            isPrice2: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label1,
    required String value1,
    String label2 = "",
    String value2 = "",
    bool isPrice1 = false,
    bool isPrice2 = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label1,
                    style: primaryTextStyle(color: dividerColor, size: 12),
                  ),
                  const SizedBox(height: 4),
                  isPrice1
                      ? PriceWidget(price: value1.toDouble(), size: 14, isSemiBoldText: true)
                      : Text(
                          value1,
                          style: boldTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                        ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label2,
                    style: primaryTextStyle(color: dividerColor, size: 12),
                  ),
                  const SizedBox(height: 4),
                  isPrice2
                      ? PriceWidget(price: value2.toDouble(), size: 14, isSemiBoldText: true)
                      : Text(
                          value2,
                          style: boldTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                        ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
