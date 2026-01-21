import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/common_base.dart';
import '../../../pharma/medicine/medicine_list_screen.dart';
import '../../../pharma/medicine/model/medicine_resp_model.dart';
import '../clinical_details_controller.dart';

class AddPrescriptionComponent extends StatelessWidget {
  final bool isEdit;
  final int? index;
  AddPrescriptionComponent({super.key, this.isEdit = false, this.index});

  final ClinicalDetailsController clincalDetailCont = Get.put(ClinicalDetailsController());

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
        key: clincalDetailCont.addPrescriptionFormKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isEdit ? locale.value.editPrescription : locale.value.addPrescription, style: secondaryTextStyle(size: 16, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor)),
                16.height,
                if (appConfigs.value.isPharma.getBoolInt()) pharmaForm(context) else normalForm(context),
              AppTextField(
                textStyle: primaryTextStyle(size: 12),
                controller: clincalDetailCont.nameCont,
                textFieldType: TextFieldType.NAME,
                focus: clincalDetailCont.nameFocus,
                isValidationRequired: true,
                decoration: inputDecoration(
                  context,
                  fillColor: context.cardColor,
                  filled: true,
                  hintText: locale.value.name,
                ),
                suffix: commonLeadingWid(imgPath: Assets.iconsIcUser, color: iconColor, size: 10).paddingAll(16),
              ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: clincalDetailCont.frequencyCont,
                  textFieldType: TextFieldType.NUMBER,
                  focus: clincalDetailCont.frequencyFocus,
                  decoration: inputDecoration(
                    context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: locale.value.frequency,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcTimeOutlined, color: iconColor, size: 10).paddingAll(16),
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: clincalDetailCont.durationCont,
                  textFieldType: TextFieldType.NUMBER,
                  focus: clincalDetailCont.durationFocus,
                  decoration: inputDecoration(
                    context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: locale.value.duration,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcClock, color: iconColor, size: 10).paddingAll(16),
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: clincalDetailCont.instructionCont,
                  minLines: 3,
                  focus: clincalDetailCont.instructionFocus,
                  textFieldType: TextFieldType.MULTILINE,
                  keyboardType: TextInputType.multiline,
                  isValidationRequired: false,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.instruction,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                ),
                16.height,
                AppButton(
                  width: Get.width,
                  text: locale.value.save,
                  color: appColorSecondary,
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                  onTap: () {
                    if (clincalDetailCont.addPrescriptionFormKey.currentState!.validate()) {
                      if (isEdit) {
                        clincalDetailCont.saveEditData(index!);
                      } else {
                        clincalDetailCont.savePrescription();
                      }
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

  Widget normalForm(BuildContext context) {
    return AppTextField(
      textStyle: primaryTextStyle(size: 12),
      controller: clincalDetailCont.nameCont,
      textFieldType: TextFieldType.NAME,
      focus: clincalDetailCont.nameFocus,
      decoration: inputDecoration(
        context,
        fillColor: context.cardColor,
        filled: true,
        hintText: locale.value.name,
      ),
      suffix: commonLeadingWid(imgPath: Assets.iconsIcUser, color: iconColor, size: 10).paddingAll(16),
    );
  }

  Widget pharmaForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: clincalDetailCont.nameCont,
          textFieldType: TextFieldType.NAME,
          focus: clincalDetailCont.nameFocus,
          readOnly: true,
          onTap: () async {
            Get.to(
              () => MedicinesListScreen(),
              arguments: clincalDetailCont.selectedMedicines,
            )?.then((value) {
              if (value is Medicine) {
                clincalDetailCont.selectedMedicines();
                clincalDetailCont.nameCont.text = value.name;
                clincalDetailCont.formCont.text = value.form.name;
                clincalDetailCont.dosageCont.text = value.dosage;
              }
            });
          },
          decoration: inputDecoration(
            context,
            hintText: locale.value.selectMedicine,
            fillColor: context.cardColor,
            filled: true,
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: dividerColor,
              size: 22,
            ),
          ),
        ),
        16.height,
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: clincalDetailCont.dosageCont,
          textFieldType: TextFieldType.NAME,
          focus: clincalDetailCont.dosageFocus,
          isValidationRequired: false,
          readOnly: true,
          decoration: inputDecoration(
            context,
            fillColor: context.cardColor,
            filled: true,
            hintText: locale.value.dosage,
          ),
          suffix: const Icon(Icons.arrow_drop_down, color: iconColor),
        ),
        16.height,
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: clincalDetailCont.formCont,
          textFieldType: TextFieldType.NAME,
          focus: clincalDetailCont.formFocus,
          isValidationRequired: false,
          readOnly: true,
          decoration: inputDecoration(
            context,
            fillColor: context.cardColor,
            filled: true,
            hintText: locale.value.form,
          ),
        ),
        16.height,
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: clincalDetailCont.quantityCont,
          textFieldType: TextFieldType.NUMBER,
          focus: clincalDetailCont.quantityFocus,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          ],
          decoration: inputDecoration(
            context,
            fillColor: context.cardColor,
            filled: true,
            hintText: locale.value.quantity,
          ),
        ),
      ],
    );
  }
}
