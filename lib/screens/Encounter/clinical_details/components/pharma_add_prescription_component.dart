import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/clinical_details/components/prescription_form_data.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/medicine_list_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../components/app_scaffold.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/common_base.dart';
import '../../../pharma/medicine/model/medicine_resp_model.dart';
import '../clinical_details_controller.dart';

class AddPrescriptionComponentPharma extends StatelessWidget {
  final bool isEdit;
  final int? index;

  AddPrescriptionComponentPharma({super.key, this.isEdit = false, this.index});

  final ClinicalDetailsController clincalDetailCont = Get.put(ClinicalDetailsController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: isEdit ? locale.value.editPrescription : locale.value.addPrescription,
      appBarVerticalSize: Get.height * 0.12,
      isBlurBackgroundinLoader: true,
      isLoading: clincalDetailCont.isLoading,
      actions: [
        Obx(
          () => IconButton(
            onPressed: () {
              handleSelectMedicineTap();
            },
            icon: const Icon(Icons.add_circle_outline_sharp, size: 25, color: Colors.white),
          ).paddingOnly(right: 8, top: 12, bottom: 12).visible(prescriptionFormDataList.isNotEmpty),
        ),
      ],
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: boxDecorationDefault(
          color: context.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: clincalDetailCont.nameCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    await handleSelectMedicineTap();
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectMedicine,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: dividerColor, size: 22),
                  ),
                ).paddingTop(16).visible(prescriptionFormDataList.isEmpty),
              ),
              16.height,
              Form(
                key: clincalDetailCont.addPrescriptionFormKey,
                child: Obx(
                  () => Column(
                    children: prescriptionFormDataList.map((form) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(form.medicine.name, style: boldTextStyle()),
                              8.width,
                              AppButton(
                                textStyle: boldTextStyle(color: appColorSecondary, size: 14),
                                color: isDarkMode.value ? scaffoldDarkColor : Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                                onTap: () {
                                  form.quantityCont.text = "";

                                  prescriptionFormDataList.remove(form);
                                },
                                child: const Icon(Icons.delete, size: 20, color: Colors.red),
                              ),
                            ],
                          ),
                          8.height,
                          AppTextField(
                            textStyle: primaryTextStyle(size: 12),
                            controller: form.dosageCont,
                            readOnly: true,
                            textFieldType: TextFieldType.NAME,
                            decoration: inputDecoration(
                              context,
                              fillColor: context.cardColor,
                              filled: true,
                              hintText: locale.value.dosageHint,
                              border: OutlineInputBorder(
                                borderRadius: radius(defaultRadius / 2),
                                borderSide: const BorderSide(color: borderColor, width: 0.0),
                              ),
                            ),
                          ),
                          16.height,
                          AppTextField(
                            textStyle: primaryTextStyle(size: 12),
                            controller: form.formCont,
                            readOnly: true,
                            textFieldType: TextFieldType.NAME,
                            decoration: inputDecoration(
                              context,
                              fillColor: context.cardColor,
                              filled: true,
                              hintText: locale.value.form1,
                              border: OutlineInputBorder(
                                borderRadius: radius(defaultRadius / 2),
                                borderSide: const BorderSide(color: borderColor, width: 0.0),
                              ),
                            ),
                          ),
                          16.height,
                          AppTextField(
                            textStyle: primaryTextStyle(size: 12),
                            controller: form.frequencyCont,
                            textInputAction: TextInputAction.next,
                            textFieldType: TextFieldType.NUMBER,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            isValidationRequired: true,
                            decoration: inputDecoration(
                              context,
                              fillColor: context.cardColor,
                              filled: true,
                              hintText: "${locale.value.frequency} (1-0-1)",
                            ),
                            onChanged: (value) {
                              String digits = value.replaceAll(RegExp(r'[^0-9]'), '');

                              if (digits.length > 3) digits = digits.substring(0, 3);

                              String formatted = '';
                              for (int i = 0; i < digits.length; i++) {
                                formatted += digits[i];
                                if (i < digits.length - 1) formatted += '-';
                              }

                              if (formatted != value) {
                                form.frequencyCont.value = TextEditingValue(
                                  text: formatted,
                                  selection: TextSelection.collapsed(offset: formatted.length),
                                );
                              }

                              final parts = formatted.split('-');
                              form.morningCount = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
                              form.afternoonCount = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
                              form.eveningCount = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;

                              final duration = int.tryParse(form.durationCont.text) ?? 0;
                              form.quantityCont.text = ((form.morningCount + form.afternoonCount + form.eveningCount) * duration).toString();

                              // Check stock availability
                              checkStockAvilability(form);
                            },
                          ),
                          16.height,
                          AppTextField(
                            textStyle: primaryTextStyle(size: 12),
                            controller: form.durationCont,
                            textFieldType: TextFieldType.NUMBER,
                            keyboardType: TextInputType.number,
                            isValidationRequired: true,
                            decoration: inputDecoration(
                              context,
                              fillColor: context.cardColor,
                              filled: true,
                              hintText: "${locale.value.duration} (in days)",
                            ),
                            onChanged: (value) {
                              var duration = value.toInt();
                              form.quantityCont.text = ((form.morningCount + form.afternoonCount + form.eveningCount) * duration).toString();

                              // Check stock availability
                              checkStockAvilability(form);
                            },
                          ),
                          16.height,
                          AppTextField(
                            textStyle: primaryTextStyle(size: 12),
                            controller: form.quantityCont,
                            textFieldType: TextFieldType.NUMBER,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            isValidationRequired: true,
                            readOnly: true,
                            decoration: inputDecoration(
                              context,
                              fillColor: context.cardColor,
                              filled: true,
                              hintText: locale.value.quantity,
                              border: OutlineInputBorder(
                                borderRadius: radius(defaultRadius / 2),
                                borderSide: const BorderSide(color: borderColor, width: 0.0),
                              ),
                            ),
                          ),
                          4.height,
                          Obx(() => Text("⚠️ ${form.stockWarning.value}", style: secondaryTextStyle(color: Colors.deepOrange.shade500)).paddingLeft(4).visible(form.stockWarning.value.isNotEmpty)),
                          16.height,
                          AppTextField(
                            textStyle: primaryTextStyle(size: 12),
                            controller: form.instructionCont,
                            textFieldType: TextFieldType.MULTILINE,
                            minLines: 2,
                            maxLines: 3,
                            isValidationRequired: false,
                            decoration: inputDecoration(context, fillColor: context.cardColor, filled: true, hintText: locale.value.instruction),
                          ),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              80.height, // padding for save button at bottom
            ],
          ),
        ),
      ),
      widgetsStackedOverBody: [
        Positioned(
          bottom: 16,
          height: 50,
          width: Get.width,
          child: Obx(
            () => AppButton(
              width: Get.width,
              text: locale.value.save,
              color: appColorSecondary,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
              onTap: () {
                handleSaveClick();
              },
            ).paddingSymmetric(horizontal: 16).visible(prescriptionFormDataList.isNotEmpty),
          ),
        ),
      ],
    );
  }

  void checkStockAvilability(PrescriptionFormData form) {
    if (form.quantityCont.text.toInt() > form.medicine.quntity.toInt()) {
      form.stockWarning(locale.value.stockNotEnoughAvailable(form.medicine.quntity));
    } else {
      form.stockWarning('');
    }
  }

  void handleSaveClick() {
    if (clincalDetailCont.addPrescriptionFormKey.currentState!.validate()) {
      clincalDetailCont.saveMultiplePrescription();
    }
  }

  Future<void> handleSelectMedicineTap() async {
    final result = await Get.to(
        () => MedicinesListScreen(
              isSelectMedicineScreen: true,
            ),
        arguments: {
          'medsAlreadyInPresc': prescriptionFormDataList.map((e) => e.medicine.id).toSet().toList(),
          'pharmaId': clincalDetailCont.selectedPharma.value.id,
        }
        //  arguments: clincalDetailCont.selectedMedicines,
        );
    if (result is List<Medicine>) {
      clincalDetailCont.setMedicineForms(result);
    }
  }
}
