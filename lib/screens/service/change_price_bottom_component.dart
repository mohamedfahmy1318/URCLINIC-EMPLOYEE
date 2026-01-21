import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../generated/assets.dart';
import '../../../utils/common_base.dart';
import '../../components/decimal_input_formater.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import 'model/service_list_model.dart';

class ChangePriceComponent extends StatelessWidget {
  final ServiceElement serviceElement;
  final Function(String) onSave;
  final TextEditingController changePriceCont;

  ChangePriceComponent({
    super.key,
    required this.serviceElement,
    required this.onSave,
    required this.changePriceCont,
  });

  final GlobalKey<FormState> changePriceFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      ),
      child: Form(
        key: changePriceFormKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                2.height,
                Row(
                  children: [
                    Text(serviceElement.name, style: secondaryTextStyle(size: 16, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor)).expand(),
                  ],
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: changePriceCont,
                  textFieldType: TextFieldType.NUMBER,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                    DecimalTextInputFormatter(decimalRange: 2),
                  ],
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.price,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcTotalPayout, color: secondaryTextColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
                ).paddingTop(8),
                32.height,
                AppButton(
                  width: Get.width,
                  text: locale.value.save,
                  color: appColorSecondary,
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                  onTap: () {
                    if (changePriceFormKey.currentState!.validate()) {
                      hideKeyboard(context);
                      onSave.call(changePriceCont.text);
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
