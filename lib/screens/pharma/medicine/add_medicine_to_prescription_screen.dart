import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/controller/add_medicine_to_prescription_controller.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/medicine_list_screen.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import 'model/medicine_resp_model.dart';

class AddMedToPresScreen extends StatelessWidget {
  AddMedToPresScreen({super.key});

  final AddMedToPrescController addMedToPresCont = Get.put(AddMedToPrescController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffoldNew(
        appBartitleText: addMedToPresCont.isEdit.value ? locale.value.editMedicine : locale.value.addMedicine,
        appBarVerticalSize: Get.height * 0.12,
        isBlurBackgroundinLoader: true,
        isLoading: addMedToPresCont.isLoading,
        actions: [
          Obx(
            () => IconButton(
              onPressed: () async {
                final result = await Get.to(
                  () => MedicinesListScreen(isSelectMedicineScreen: true),
                  arguments: addMedToPresCont.prescriptionId.toInt(),
                );

                if (result is List<Medicine>) {
                  addMedToPresCont.setMedicineForms(result);
                }
              },
              icon: const Icon(Icons.add_circle_outline_sharp, size: 25, color: Colors.white),
            ).paddingOnly(right: 8, top: 12, bottom: 12).visible(!addMedToPresCont.isEdit.value),
          ),
        ],
        body: Container(
          width: double.infinity,
          decoration: boxDecorationDefault(
            color: context.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
          ),
          child: Form(
            key: addMedToPresCont.addPrescriptionFormKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  if (addMedToPresCont.isEdit.value) EditPrescMedicineComponent(addMedToPresCont: addMedToPresCont),
                  Obx(() {
                    if (addMedToPresCont.selectedMedicines.isEmpty && !addMedToPresCont.isEdit.value) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Text(
                            'No medicines currently selected.',
                            style: primaryTextStyle(size: 14, color: grey),
                          ),
                        ),
                      );
                    }

                    return MultiSelectedPrescMedsComponent(addMedToPresCont: addMedToPresCont);
                  }),

                  80.height, // padding for save button at bottom
                ],
              ),
            ),
          ),
        ),
        widgetsStackedOverBody: [
          Positioned(
            bottom: 16,
            height: 50,
            width: Get.width,
            child: AppButton(
              width: Get.width,
              text: locale.value.save,
              color: appColorSecondary,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
              onTap: () {
                if (addMedToPresCont.addPrescriptionFormKey.currentState!.validate()) {
                  addMedToPresCont.saveMedToPrescription();
                }
              },
            ).paddingSymmetric(horizontal: 16),
          ),
        ],
      ),
    );
  }
}

class MultiSelectedPrescMedsComponent extends StatelessWidget {
  const MultiSelectedPrescMedsComponent({
    super.key,
    required this.addMedToPresCont,
  });

  final AddMedToPrescController addMedToPresCont;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: addMedToPresCont.selectedMedicines.map((form) {
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
                  color: isDarkMode.value ? scaffoldDarkColor : context.scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                  onTap: () {
                    form.quantityCont.text = "";
                    addMedToPresCont.selectedMedicines.remove(form);
                  },
                  child: const Icon(Icons.delete, size: 20, color: Colors.red),
                ),
              ],
            ),
            8.height,
            AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: form.dosageCont,
              textFieldType: TextFieldType.NAME,
              readOnly: true,
              decoration: inputDecoration(
                context,
                hintText: locale.value.dosage,
                border: OutlineInputBorder(
                  borderRadius: radius(defaultRadius / 2),
                  borderSide: const BorderSide(color: borderColor, width: 0.0),
                ),
                fillColor: context.cardColor,
                filled: true,
              ),
            ),
            16.height,
            AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: form.formCont,
              textFieldType: TextFieldType.NAME,
              readOnly: true,
              decoration: inputDecoration(
                context,
                hintText: locale.value.form,
                border: OutlineInputBorder(
                  borderRadius: radius(defaultRadius / 2),
                  borderSide: const BorderSide(color: borderColor, width: 0.0),
                ),
                fillColor: context.cardColor,
                filled: true,
              ),
            ),
            16.height,
            AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: form.frequencyCont,
              textInputAction: TextInputAction.next,
              textFieldType: TextFieldType.NUMBER,
              isValidationRequired: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                // Automatically format input as 1-0-1 (numbers only, with '-' separator)
                // Only format when adding, not when deleting
                if (value.isNotEmpty && value[value.length - 1] != '-') {
                  String digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (digits.length > 3) digits = digits.substring(0, 3);
                  String result = '';
                  for (int i = 0; i < digits.length; i++) {
                    result += digits[i];
                    if (i < 2 && i < digits.length - 1) result += '-';
                  }
                  if (value != result) {
                    form.frequencyCont.value = TextEditingValue(
                      text: result,
                      selection: TextSelection.collapsed(offset: result.length),
                    );
                    value = result;
                  }
                }

                //value = 1-0-1
                if (value.isNotEmpty) {
                  final parts = value.split('-');
                  if (parts.length == 3) {
                    form.morningCount = parts[0].toInt();
                    form.afternoonCount = parts[1].toInt();
                    form.eveningCount = parts[2].toInt();
                  }
                }
                var duration = form.durationCont.text.toInt();
                form.quantityCont.text = ((form.morningCount + form.afternoonCount + form.eveningCount) * duration).toString();

                // Check stock availability
                checkStockAvilability(form);
              },
              decoration: inputDecoration(
                context,
                hintText: "${locale.value.frequency} (1-0-1)",
                fillColor: context.cardColor,
                filled: true,
              ),
            ),
            16.height,
            AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: form.durationCont,
              textFieldType: TextFieldType.NUMBER,
              isValidationRequired: true,
              decoration: inputDecoration(
                context,
                hintText: "${locale.value.duration} (in days)",
                fillColor: context.cardColor,
                filled: true,
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
              decoration: inputDecoration(
                context,
                hintText: locale.value.quantity,
                fillColor: context.cardColor,
                filled: true,
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
              decoration: inputDecoration(
                context,
                hintText: locale.value.instruction,
                fillColor: context.cardColor,
                filled: true,
              ),
            ),
            if (addMedToPresCont.selectedMedicines.length > 1) const Divider(),
          ],
        );
      }).toList(),
    );
  }

  void checkStockAvilability(MedicineFormData form) {
    if (form.quantityCont.text.toInt() > form.stock) {
      form.stockWarning(locale.value.stockNotEnoughAvailable(form.stock.toString()));
    } else {
      form.stockWarning('');
    }
  }
}

class EditPrescMedicineComponent extends StatelessWidget {
  const EditPrescMedicineComponent({
    super.key,
    required this.addMedToPresCont,
  });

  final AddMedToPrescController addMedToPresCont;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          addMedToPresCont.nameCont.text,
          style: primaryTextStyle(),
        ),
        16.height,
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: addMedToPresCont.dosageCont,
          textFieldType: TextFieldType.NAME,
          readOnly: true,
          decoration: inputDecoration(
            context,
            hintText: locale.value.dosage,
            fillColor: context.cardColor,
            filled: true,
          ),
        ),
        16.height,
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: addMedToPresCont.formCont,
          textFieldType: TextFieldType.NAME,
          readOnly: true,
          decoration: inputDecoration(
            context,
            hintText: locale.value.form,
            fillColor: context.cardColor,
            filled: true,
          ),
        ),
        16.height,
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: addMedToPresCont.frequencyCont,
          textFieldType: TextFieldType.NUMBER,
          isValidationRequired: true,
          decoration: inputDecoration(
            context,
            hintText: "${locale.value.frequency} (1-0-1)",
            fillColor: context.cardColor,
            filled: true,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            // Automatically format input as 1-0-1 (numbers only, with '-' separator)
            // Only format when adding, not when deleting
            if (value.isNotEmpty && value[value.length - 1] != '-') {
              String digits = value.replaceAll(RegExp(r'[^0-9]'), '');
              if (digits.length > 3) digits = digits.substring(0, 3);
              String result = '';
              for (int i = 0; i < digits.length; i++) {
                result += digits[i];
                if (i < 2 && i < digits.length - 1) result += '-';
              }
              if (value != result) {
                addMedToPresCont.frequencyCont.value = TextEditingValue(
                  text: result,
                  selection: TextSelection.collapsed(offset: result.length),
                );
                value = result;
              }
            }
            //value = 1-0-1
            if (value.isNotEmpty) {
              final parts = value.split('-');
              if (parts.length == 3) {
                addMedToPresCont.morningCount = parts[0].toInt();
                addMedToPresCont.afternoonCount = parts[1].toInt();
                addMedToPresCont.eveningCount = parts[2].toInt();
              }
            }
            var duration = addMedToPresCont.durationCont.text.toInt();
            addMedToPresCont.quantityCont.text = ((addMedToPresCont.morningCount + addMedToPresCont.afternoonCount + addMedToPresCont.eveningCount) * duration).toString();

            // Check stock availability
            checkStockAvilability();
          },
        ),
        16.height,
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: addMedToPresCont.durationCont,
          textFieldType: TextFieldType.NUMBER,
          isValidationRequired: true,
          decoration: inputDecoration(
            context,
            hintText: "${locale.value.duration} (in days)",
            fillColor: context.cardColor,
            filled: true,
          ),
          onChanged: (value) {
            var duration = value.toInt();
            addMedToPresCont.quantityCont.text = ((addMedToPresCont.morningCount + addMedToPresCont.afternoonCount + addMedToPresCont.eveningCount) * duration).toString();

            // Check stock availability
            checkStockAvilability();
          },
        ),
        16.height,
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: addMedToPresCont.quantityCont,
          textFieldType: TextFieldType.NUMBER,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          isValidationRequired: true,
          decoration: inputDecoration(
            context,
            hintText: locale.value.quantity,
            fillColor: context.cardColor,
            filled: true,
          ),
        ),
        4.height,
        Obx(() => Text("⚠️ ${addMedToPresCont.stockWarning.value}", style: secondaryTextStyle(color: Colors.deepOrange.shade500)).paddingLeft(4).visible(addMedToPresCont.stockWarning.value.isNotEmpty)),
        16.height,
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: addMedToPresCont.instructionCont,
          textFieldType: TextFieldType.MULTILINE,
          minLines: 2,
          maxLines: 3,
          isValidationRequired: false,
          decoration: inputDecoration(
            context,
            hintText: locale.value.instruction,
            fillColor: context.cardColor,
            filled: true,
          ),
        ),
      ],
    );
  }

  void checkStockAvilability() {
    if (addMedToPresCont.quantityCont.text.toInt() > addMedToPresCont.availableStock) {
      addMedToPresCont.stockWarning(locale.value.stockNotEnoughAvailable(addMedToPresCont.availableStock.toString()));
    } else {
      addMedToPresCont.stockWarning('');
    }
  }
}

class MedicineFormData {
  final Medicine medicine;
  final TextEditingController dosageCont = TextEditingController();
  final TextEditingController formCont = TextEditingController();
  final TextEditingController quantityCont = TextEditingController();
  final TextEditingController frequencyCont = TextEditingController();
  final TextEditingController durationCont = TextEditingController();
  final TextEditingController instructionCont = TextEditingController();
  int morningCount = 0;
  int afternoonCount = 0;
  int eveningCount = 0;
  RxString stockWarning = ''.obs;
  int stock = 0;

  MedicineFormData({required this.medicine}) {
    dosageCont.text = medicine.dosage;
    formCont.text = medicine.form.name;

    stock = int.parse(medicine.quntity);
  }

  Map<String, dynamic> toRequest() => {
        'medicine_id': medicine.id.toString(),
        'quantity': quantityCont.text.trim(),
        'frequency': frequencyCont.text.trim(),
        'duration': durationCont.text.trim(),
        'instruction': instructionCont.text.trim(),
      };
}
