import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/components/add_stock_component.dart';
import 'package:kivicare_clinic_admin/screens/pharma/suppliers/supplier_details.dart';
import 'package:kivicare_clinic_admin/utils/view_all_label_component.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/price_widget.dart';
import '../medicine/model/medicine_resp_model.dart';
import '../medicine/stock_history_screen.dart';

class MedicineDetailScreen extends StatelessWidget {
  final Medicine medicineData;

  const MedicineDetailScreen({super.key, required this.medicineData});

  String get expiryDateString => medicineData.expiryDate;
  DateTime get expiryDate => DateTime.parse(expiryDateString);
  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isLowStock => medicineData.quntity.toInt() <= medicineData.reOrderLevel.toInt();

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.medicineDetail,
      appBarVerticalSize: Get.height * 0.12,
      body: Obx(
        () => AnimatedScrollView(
          listAnimationType: ListAnimationType.FadeIn,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 64),
          children: [
            16.height,
            ViewAllLabel(
              label: locale.value.aboutMedicine,
              isShowAll: false,
            ),
            if (isLowStock && !isExpired) // Assuming there's a stock field
              Container(
                padding: const EdgeInsets.only(left: 16, right: 8),
                decoration: BoxDecoration(
                  color: appColorSecondary.withValues(alpha: 0.25),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.red[400], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          locale.value.lowStock,
                          style: boldTextStyle(
                            size: 14,
                            color: Colors.red[600],
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      style: ButtonStyle().copyWith(
                        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Get.bottomSheet(
                          AddStockComponent(medicineId: medicineData.id),
                          isScrollControlled: true,
                        );
                      },
                      child: Text(locale.value.addStock, style: boldTextStyle(size: 14, fontFamily: fontFamilyWeight700, color: Colors.green[600])).paddingSymmetric(horizontal: 8),
                    ),
                  ],
                ),
              ),
            Container(
              width: Get.width,
              decoration: boxDecorationDefault(color: context.cardColor),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            medicineData.name,
                            style: boldTextStyle(size: 16, color: isDarkMode.value ? null : primaryTextColor),
                          ),
                          Spacer(),
                          PriceWidget(
                            price: medicineData.sellingPrice.toDouble(),
                            size: 16,
                            isBoldText: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
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
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              icon1: Assets.iconsIcCalenderx,
                              label1: locale.value.expiryDate,
                              value1: medicineData.expiryDate.dateInDMMMMyyyyFormat,
                              icon2: Assets.iconsIcGitBranch,
                              label2: locale.value.category,
                              value2: medicineData.category.name,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).paddingAll(16),
                ],
              ),
            ),
            16.height,
            ViewAllLabel(
              label: locale.value.suppliers,
              isShowAll: false,
            ),
            Container(
              width: Get.width,
              decoration: boxDecorationDefault(color: context.cardColor),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CachedImageWidget(
                            url: medicineData.supplier.imageUrl,
                            height: 44,
                            width: 44,
                            circle: true,
                            fit: BoxFit.cover,
                            // color: isDarkMode.value ? context.primaryColor : primaryTextColor,
                          ),
                          10.width,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicineData.supplier.fullName,
                                style: boldTextStyle(),
                              ),
                              Text(
                                medicineData.supplier.email,
                                style: secondaryTextStyle().copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            locale.value.contactNumber,
                            style: secondaryTextStyle(),
                          ),
                          Text(
                            medicineData.supplier.contactNumber,
                            style: primaryTextStyle(),
                          )
                        ],
                      ),
                      Divider(
                        color: isDarkMode.value ? Colors.grey.shade600 : Colors.grey.shade200,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            locale.value.paymentTerms,
                            style: secondaryTextStyle(),
                          ),
                          Text(
                            medicineData.supplier.paymentTerms,
                            style: primaryTextStyle(),
                          )
                        ],
                      ),
                      Divider(
                        color: isDarkMode.value ? Colors.grey.shade600 : Colors.grey.shade200,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => Get.to(() => SupplierDetails(supplier: medicineData.supplier)),
                            child: Text(locale.value.viewDetail, style: boldTextStyle(size: 14, fontFamily: fontFamilyWeight700, color: appColorSecondary)),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => Get.to(() => StockHistoryScreen(), arguments: medicineData.id),
                            child: Text("Stock History", style: boldTextStyle(size: 14, fontFamily: fontFamilyWeight700, color: appColorSecondary)),
                          ),
                        ],
                      ),
                    ],
                  ).paddingAll(16),
                ],
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildInfoRow({
    required String icon1,
    required String label1,
    required String value1,
    required String icon2,
    required String label2,
    required String value2,
  }) {
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

  Widget detailWidgetPrice({Widget? leadingWidget, Widget? trailingWidget, String? title, num? value, Color? textColor, bool isSemiBoldText = false, double? paddingBottom}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leadingWidget ?? Text(title.validate(), style: secondaryTextStyle()),
        trailingWidget ??
            PriceWidget(
              price: value.validate(),
              color: textColor ?? appColorPrimary,
              size: 14,
              isSemiBoldText: isSemiBoldText,
            )
      ],
    ).paddingBottom(paddingBottom ?? 10);
  }
}
