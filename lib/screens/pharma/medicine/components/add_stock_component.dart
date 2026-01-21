import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/pharma_apis.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/common_base.dart';
import '../controller/medicine_list_controller.dart';

class AddStockComponent extends StatefulWidget {
  final int medicineId;
  final bool isPlaceOrder;

  const AddStockComponent({
    super.key,
    required this.medicineId,
    this.isPlaceOrder = false,
  });

  @override
  State<AddStockComponent> createState() => _AddStockComponentState();
}

class _AddStockComponentState extends State<AddStockComponent> {
  final TextEditingController quantityCont = TextEditingController();
  final TextEditingController deliveryDateCont = TextEditingController();
  final TextEditingController batchNoCont = TextEditingController();
  final TextEditingController startSerialNoCont = TextEditingController();
  final TextEditingController endSerialNoCont = TextEditingController();

  final FocusNode quantityFocus = FocusNode();
  final FocusNode batchNoFocus = FocusNode();
  final FocusNode startSerialNoFocus = FocusNode();
  final FocusNode endSerialNoFocus = FocusNode();

  final RxString errorMessageSerialNumber = "".obs;
  final GlobalKey<FormState> addStockFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    quantityCont.dispose();
    deliveryDateCont.dispose();
    batchNoCont.dispose();
    startSerialNoCont.dispose();
    endSerialNoCont.dispose();
    quantityFocus.dispose();
    batchNoFocus.dispose();
    startSerialNoFocus.dispose();
    endSerialNoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: Form(
        key: addStockFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isPlaceOrder ? locale.value.addOrder : locale.value.addStock,
              style: boldTextStyle(color: isDarkMode.value ? null : darkGrayTextColor),
            ),
            16.height,
            Text("Batch No (Series No.)", style: primaryTextStyle()),
            AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: batchNoCont,
              textFieldType: TextFieldType.NAME,
              focus: batchNoFocus,
              isValidationRequired: true,
              decoration: inputDecoration(
                context,
                fillColor: context.cardColor,
                filled: true,
                hintText: locale.value.batchNumber,
              ),
            ).paddingTop(4),
            16.height,
            Text(locale.value.startSerialNumber, style: primaryTextStyle()),
            AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: startSerialNoCont,
              textFieldType: TextFieldType.NUMBER,
              focus: startSerialNoFocus,
              isValidationRequired: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              decoration: inputDecoration(
                context,
                fillColor: context.cardColor,
                filled: true,
                hintText: locale.value.startSerialNumber,
              ),
              validator: (value) {
                if (startSerialNoCont.text.isEmpty) {
                  quantityCont.clear();
                  return locale.value.thisFieldIsRequired;
                } else if (endSerialNoCont.text.isNotEmpty) {
                  int start = int.tryParse(startSerialNoCont.text) ?? 0;
                  int end = int.tryParse(endSerialNoCont.text) ?? 0;
                  if (end < start) {
                    quantityCont.clear();
                    errorMessageSerialNumber.value = "End serial number cannot be less than start serial number.";
                  } else {
                    errorMessageSerialNumber.value = "";
                  }
                }
                return null;
              },
              onChanged: (value) {
                if (endSerialNoCont.text.isNotEmpty && value.isNotEmpty) {
                  int start = int.tryParse(value) ?? 0;
                  int end = int.tryParse(endSerialNoCont.text) ?? 0;
                  if (end < start) {
                    quantityCont.clear();
                    errorMessageSerialNumber.value = "End serial number cannot be less than start serial number.";
                  } else {
                    quantityCont.text = ((end - start) + 1).toString();
                    errorMessageSerialNumber.value = "";
                  }
                } else {
                  quantityCont.clear();
                }
              },
              suffix: commonLeadingWid(
                imgPath: Assets.iconsIcListNumbers,
                color: iconColor.withValues(alpha: 0.6),
                size: 12,
              ).paddingAll(16),
            ).paddingTop(4),
            16.height,
            Text(locale.value.endSerialNumber, style: primaryTextStyle()),
            Obx(
              () => AppTextField(
                textStyle: primaryTextStyle(size: 12),
                controller: endSerialNoCont,
                textFieldType: TextFieldType.NUMBER,
                focus: endSerialNoFocus,
                isValidationRequired: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                decoration: inputDecoration(
                  context,
                  fillColor: context.cardColor,
                  filled: true,
                  hintText: locale.value.endSerialNumber,
                  errorText: errorMessageSerialNumber.value.isNotEmpty ? errorMessageSerialNumber.value : null,
                ),
                onChanged: (value) {
                  if (startSerialNoCont.text.isNotEmpty) {
                    int start = int.tryParse(startSerialNoCont.text) ?? 0;
                    int end = int.tryParse(value) ?? 0;
                    if (end < start) {
                      quantityCont.clear();
                      errorMessageSerialNumber.value = "End serial number cannot be less than start serial number.";
                    } else {
                      quantityCont.text = ((end - start) + 1).toString();
                      errorMessageSerialNumber.value = "";
                    }
                  } else {
                    quantityCont.clear();
                  }
                },
                suffix: commonLeadingWid(
                  imgPath: Assets.iconsIcListNumbers,
                  color: iconColor.withValues(alpha: 0.6),
                  size: 12,
                ).paddingAll(16),
              ).paddingTop(4),
            ),
            16.height,
            Text(locale.value.addStock, style: primaryTextStyle()),
            AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: quantityCont,
              textFieldType: TextFieldType.NUMBER,
              focus: quantityFocus,
              isValidationRequired: true,
              errorThisFieldRequired: locale.value.thisFieldIsRequired,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              decoration: inputDecoration(
                context,
                fillColor: context.cardColor,
                filled: true,
                hintText: locale.value.quantity,
              ),
            ).paddingTop(4),
            AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: deliveryDateCont,
              textFieldType: TextFieldType.NAME,
              readOnly: true,
              isValidationRequired: true,
              errorThisFieldRequired: locale.value.thisFieldIsRequired,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime(2101),
                );

                if (selectedDate != null) {
                  deliveryDateCont.text = selectedDate.formatDateYYYYmmdd();
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
                color: iconColor.withValues(alpha: 0.6),
                size: 12,
              ).paddingAll(16),
            ).paddingTop(16).visible(widget.isPlaceOrder),
            32.height,
            AppButton(
              width: Get.width,
              text: locale.value.save,
              color: appColorSecondary,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: radius(defaultAppButtonRadius / 2),
              ),
              onTap: () {
                hideKeyboard(context);
                if (addStockFormKey.currentState!.validate()) {
                  final controller = Get.find<MedicinesListController>();
                  controller.isLoading(true);

                  PharmaApis.addMedicineStock(
                    id: widget.medicineId,
                    request: {
                      "quantity": quantityCont.text.trim(),
                      "batch_no": batchNoCont.text,
                      "start_serial_no": startSerialNoCont.text.toInt(),
                      "end_serial_no": endSerialNoCont.text.toInt(),
                      if (widget.isPlaceOrder) "delivery_date": deliveryDateCont.text.trim(),
                    },
                  ).then((value) {
                    if (Get.isRegistered<MedicinesListController>()) {
                      controller.getMedicineList();
                    }
                    controller.isLoading(false);
                    Get.back();
                    toast(value.message.trim().isEmpty ? locale.value.medicineStockUpdated : value.message.trim());
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
