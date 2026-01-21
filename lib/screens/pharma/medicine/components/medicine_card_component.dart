import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/add_purchase_order.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/controller/order_controller.dart';
import 'package:kivicare_clinic_admin/screens/pharma/prescriptions/medicine_detail_screen.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/price_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/common_base.dart';
import '../../inventory/add_stock_screen.dart';
import 'add_stock_component.dart';
import '../controller/medicine_list_controller.dart';
import '../model/medicine_resp_model.dart';

class MedicineCardWidget extends StatelessWidget {
  final Medicine medicineData;
  final MedicinesListController medicinesListCont;
  final bool isSelectMedicineScreen;

  const MedicineCardWidget({
    super.key,
    required this.medicineData,
    required this.medicinesListCont,
    this.isSelectMedicineScreen = false,
  });

  String get expiryDateString => medicineData.expiryDate;
  DateTime get expiryDate => DateTime.parse(expiryDateString);
  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isLowStock => medicineData.quntity.toInt() <= medicineData.reOrderLevel.toInt();

  @override
  Widget build(BuildContext context) {
    Widget buildHeader() {
      return Container(
        padding: const EdgeInsets.only(left: 16, right: 8),
        decoration: BoxDecoration(
          color: appColorSecondary.withAlpha(25),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red[400], size: 20),
                8.width,
                Text(
                  locale.value.lowStock,
                  style: boldTextStyle(size: 14, color: Colors.red[600]),
                ),
              ],
            ),
            TextButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => Get.bottomSheet(AddStockComponent(medicineId: medicineData.id), isScrollControlled: true),
              child: Text(locale.value.addStock, style: boldTextStyle(size: 14, fontFamily: fontFamilyWeight700, color: Colors.green[600])).paddingSymmetric(horizontal: 8),
            ),
          ],
        ),
      );
    }

    Widget buildInfoContainer() {
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
              value1: medicineData.quntity,
            ),
          ],
        ),
      );
    }

    Widget buildActions() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => Get.to(() => MedicineDetailScreen(medicineData: medicineData)),
            child: Text(locale.value.viewDetail, style: boldTextStyle(size: 14, fontFamily: fontFamilyWeight700, color: appColorSecondary)).paddingOnly(right: 8),
          ),
          if (!isExpired)
            Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: () => Get.to(() => AddStockScreen(), arguments: medicineData)?.then((value) {
                    if (value == true) {
                      medicinesListCont.medicinePage(1);
                      medicinesListCont.getMedicineList();
                    }
                  }),
                  icon: const CachedImageWidget(
                    url: Assets.iconsIcEditReview,
                    color: iconColorPrimaryDark,
                    height: 20,
                    width: 20,
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    if (Get.isRegistered<OrderController>()) {
                      Get.find<OrderController>().quantityCont.text = "";
                      Get.find<OrderController>().deliveryDateCont.text = "";
                    }
                    Get.bottomSheet(
                      AddPurchaseOrder(medicineData: medicineData),
                      isScrollControlled: true,
                    );
                  },
                  icon: const CachedImageWidget(
                    url: Assets.iconsIcCart,
                    color: iconColorPrimaryDark,
                    height: 20,
                    width: 20,
                  ),
                ),
              ],
            )
        ],
      ).paddingSymmetric(horizontal: 8);
    }

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
          if (isLowStock && !isExpired) buildHeader(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Medicine Name (flexible to avoid overflow)
                  Expanded(
                    child: Text(
                      medicineData.name,
                      style: boldTextStyle(size: 16, color: isDarkMode.value ? null : primaryTextColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  8.width,

                  /// Expired Badge
                  if (isExpired)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: appColorSecondary, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        locale.value.expired,
                        style: primaryTextStyle(color: white),
                      ),
                    ),

                  8.width,

                  /// Price
                  PriceWidget(
                    price: medicineData.sellingPrice.toDouble(),
                    size: 16,
                    isBoldText: true,
                  ),

                  /// Checkbox (only on select screen and if not expired)
                  if (isSelectMedicineScreen && !isExpired)
                    Obx(
                      () => Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: medicinesListCont.selectedMedicines.contains(medicineData),
                        onChanged: (val) {
                          if (val == true) {
                            medicinesListCont.selectedMedicines.add(medicineData);
                          } else {
                            medicinesListCont.selectedMedicines.remove(medicineData);
                          }
                        },
                      ).paddingSymmetric(horizontal: 8),
                    ),
                ],
              ),
              16.height,
              buildInfoContainer(),
              if (!isSelectMedicineScreen) ...[
                8.height,
                buildActions(),
              ],
            ],
          ).paddingAll(16),
        ],
      ),
    ).onTap(() => Get.to(() => MedicineDetailScreen(medicineData: medicineData)));
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon1 != "")
                CachedImageWidget(
                  url: icon1,
                  height: 18,
                  width: 18,
                  color: dividerColor,
                ).paddingTop(2),
              6.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label1,
                    style: primaryTextStyle(color: dividerColor, size: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
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
              if (icon2.isNotEmpty)
                CachedImageWidget(
                  url: icon2,
                  height: 18,
                  width: 18,
                  color: dividerColor,
                ).paddingTop(2),
              6.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label2,
                    style: primaryTextStyle(color: dividerColor, size: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
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
