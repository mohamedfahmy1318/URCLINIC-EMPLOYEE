import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/loader_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/controller/order_controller.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:nb_utils/nb_utils.dart';

import '../medicine/model/medicine_resp_model.dart';

class AddPurchaseOrder extends StatelessWidget {
  final Medicine medicineData;
  final bool isEdit;

  AddPurchaseOrder({super.key, required this.medicineData, this.isEdit = false});

  final OrderController orderController = Get.put(OrderController(), permanent: false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            decoration: boxDecorationDefault(
              color: context.cardColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            ),
            child: Form(
              key: orderController.addStockFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEdit ? locale.value.editOrder : locale.value.addOrder,
                    style: secondaryTextStyle(size: 16, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                  ),
                  16.height,
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: orderController.quantityCont,
                    textFieldType: TextFieldType.NUMBER,
                    focus: orderController.quantityFocus,
                    isValidationRequired: true,
                    errorThisFieldRequired: locale.value.thisFieldIsRequired,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                    onChanged: (p0) {
                      if (p0.isNotEmpty) {
                        orderController.totalAmountCont.text = (p0.toDouble() * medicineData.purchasePrice.toDouble()).toStringAsFixed(2);
                      } else {
                        orderController.totalAmountCont.text = "";
                      }
                    },
                    decoration: inputDecoration(
                      context,
                      fillColor: context.cardColor,
                      filled: true,
                      hintText: locale.value.quantity,
                    ),
                  ),
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: TextEditingController(text: medicineData.purchasePrice.toDouble().toStringAsFixed(2)),
                    textFieldType: TextFieldType.NAME,
                    readOnly: true,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                    decoration: inputDecoration(
                      context,
                      fillColor: context.cardColor,
                      filled: true,
                      hintText: locale.value.purchasePrice,
                    ),
                  ).paddingTop(16),
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: orderController.totalAmountCont,
                    textFieldType: TextFieldType.NAME,
                    focus: orderController.totalAmountFocus,
                    readOnly: true,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                    decoration: inputDecoration(
                      context,
                      fillColor: context.cardColor,
                      filled: true,
                      hintText: locale.value.totalAmount,
                    ),
                  ).paddingTop(16),
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: orderController.orderDateCont,
                    textFieldType: TextFieldType.NAME,
                    readOnly: true,
                    isValidationRequired: true,
                    errorThisFieldRequired: locale.value.thisFieldIsRequired,
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.orderDate,
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                    suffix: commonLeadingWid(
                      imgPath: Assets.iconsIcCalendar,
                      color: iconColor.withAlpha(150),
                      size: 12,
                    ).paddingAll(16),
                  ).paddingOnly(top: 16).visible(isEdit),
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: orderController.deliveryDateCont,
                    textFieldType: TextFieldType.NAME,
                    readOnly: true,
                    isValidationRequired: true,
                    errorThisFieldRequired: locale.value.thisFieldIsRequired,
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: isEdit ? orderController.deliveryDateCont.text.dateInyyyyMMddFormat : DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null) {
                        orderController.deliveryDateCont.text = selectedDate.formatDateYYYYmmdd();
                      } else {
                        log(locale.value.dateIsNotSelected);
                      }
                    },
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.deliveryDate,
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                    suffix: commonLeadingWid(
                      imgPath: Assets.iconsIcCalendar,
                      color: iconColor.withAlpha(150),
                      size: 12,
                    ).paddingAll(16),
                  ).paddingOnly(top: 16, bottom: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Change Order Status
                      Text(isEdit ? locale.value.changeOrderStatus : locale.value.orderStatus, style: secondaryTextStyle()),
                      16.height,
                      Obx(() => Container(
                            width: double.infinity,
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isDarkMode.value ? context.cardColor : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDarkMode.value ? Colors.grey.shade700 : Colors.grey.shade300,
                                width: 1.0,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: orderController.selectedOrderStatus.value,
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(10),
                                dropdownColor: isDarkMode.value ? cardDarkColor : Colors.white,
                                icon: Icon(Icons.keyboard_arrow_down_rounded, color: isDarkMode.value ? Colors.white70 : Colors.grey[700], size: 22),
                                style: primaryTextStyle(color: isDarkMode.value ? Colors.white70 : textPrimaryColorGlobal, size: 14),
                                items: orderController.orderStatusList
                                    .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value, style: secondaryTextStyle(color: isDarkMode.value ? Colors.white70 : textPrimaryColorGlobal)),
                                      );
                                    })
                                    .toSet()
                                    .toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    orderController.selectedOrderStatus.value = newValue;
                                  }
                                },
                              ),
                            ),
                          )),

                      /// Change Payment Status
                      16.height,
                      Text(isEdit ? locale.value.changePaymentStatus : locale.value.paymentStatus, style: secondaryTextStyle()),
                      8.height,
                      Obx(() => Container(
                            width: double.infinity,
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isDarkMode.value ? context.cardColor : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDarkMode.value ? Colors.grey.shade700 : Colors.grey.shade300,
                                width: 1.0,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: orderController.selectedPaymentStatus.value,
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(10),
                                dropdownColor: isDarkMode.value ? cardDarkColor : Colors.white,
                                icon: Icon(Icons.keyboard_arrow_down_rounded, color: isDarkMode.value ? Colors.white70 : Colors.grey[700], size: 22),
                                style: primaryTextStyle(color: isDarkMode.value ? Colors.white70 : textPrimaryColorGlobal, size: 14),
                                items: orderController.orderPaymentStatusList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: secondaryTextStyle(color: isDarkMode.value ? Colors.white70 : textPrimaryColorGlobal)),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    orderController.selectedPaymentStatus.value = newValue;
                                  }
                                },
                              ),
                            ),
                          )),
                      32.height,
                    ],
                  ),
                  AppButton(
                    width: Get.width,
                    text: locale.value.save,
                    color: appColorSecondary,
                    textStyle: appButtonTextStyleWhite,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                    onTap: () async {
                      hideKeyboard(context);
                      orderController.medicineId.value = medicineData.id;
                      await orderController.placeOrder(isEdit: isEdit);
                      orderController.getOrders(showLoader: false).then((value) {
                        Get.back();
                      }).catchError((e) {
                        toast(e.toString());
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() => Positioned(bottom: 50, left: 0, right: 0, child: LoaderWidget().visible(orderController.isLoading.value))),
      ],
    );
  }
}
