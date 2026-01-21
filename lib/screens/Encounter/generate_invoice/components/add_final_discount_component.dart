import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../components/decimal_input_formater.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/common_base.dart';
import '../../invoice_details/invoice_details_controller.dart';
import '../../invoice_details/model/billing_details_resp.dart';

class AddFinalDiscountComponent extends StatelessWidget {
  final BillingDetailModel paymentData;

  AddFinalDiscountComponent({super.key, required this.paymentData});

  final InvoiceDetailsController invoiceDetailsCon = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      ),
      child: Form(
        key: invoiceDetailsCon.finalDiscoutFormKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  paymentData.enableFinalBillingDiscount && paymentData.billingFinalDiscountValue > 0 ? locale.value.editDiscount : locale.value.addDiscount,
                  style: secondaryTextStyle(size: 16, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                ),
                16.height,
                Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          invoiceDetailsCon.finalDiscoutType(DiscountType.PERCENTAGE);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor.withValues(alpha: 0.5))),
                          child: Row(
                            children: [
                              Text(locale.value.percent, style: primaryTextStyle(size: 12, color: dividerColor)).expand(),
                              Icon(
                                invoiceDetailsCon.finalDiscoutType.value == DiscountType.PERCENTAGE ? Icons.radio_button_checked_outlined : Icons.radio_button_off_outlined,
                                size: 20,
                                color: invoiceDetailsCon.finalDiscoutType.value == DiscountType.PERCENTAGE ? appColorPrimary : borderColor,
                              ),
                            ],
                          ),
                        ),
                      ).expand(),
                      10.width,
                      InkWell(
                        onTap: () {
                          invoiceDetailsCon.finalDiscoutType(DiscountType.FIXED);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor.withValues(alpha: 0.5))),
                          child: Row(
                            children: [
                              Text(locale.value.fixed, style: primaryTextStyle(size: 12, color: dividerColor)).expand(),
                              Icon(
                                invoiceDetailsCon.finalDiscoutType.value == DiscountType.FIXED ? Icons.radio_button_checked_outlined : Icons.radio_button_off_outlined,
                                size: 20,
                                color: invoiceDetailsCon.finalDiscoutType.value == DiscountType.FIXED ? appColorPrimary : borderColor,
                              ),
                            ],
                          ),
                        ),
                      ).expand(),
                    ],
                  ),
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: invoiceDetailsCon.finalDiscoutValueCont,
                  textFieldType: TextFieldType.NUMBER,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                    DecimalTextInputFormatter(decimalRange: 2),
                  ],
                  focus: invoiceDetailsCon.priceFocus,
                  decoration: inputDecoration(
                    context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: locale.value.discoutValue,
                  ),
                ),
                8.height,
                AppButton(
                  width: Get.width,
                  text: locale.value.save,
                  color: appColorSecondary,
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                  onTap: () {
                    if (invoiceDetailsCon.finalDiscoutFormKey.currentState!.validate()) {
                      Get.back();
                      invoiceDetailsCon.saveGenerateInvoice(showLoader: true);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
