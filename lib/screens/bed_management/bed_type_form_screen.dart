// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_type/bed_type_form_controller.dart';

class BedTypeFormScreen extends StatelessWidget {
  final Map<String, dynamic>? bedTypeData;

  const BedTypeFormScreen({super.key, this.bedTypeData});

  @override
  Widget build(BuildContext context) {
    BedTypeFormController bedTypeFromController = Get.put(BedTypeFormController(bedTypeData: bedTypeData));

    return AppScaffoldNew(
      appBartitleText: locale.value.bedType,
      scaffoldBackgroundColor: context.scaffoldBackgroundColor,
      isLoading: bedTypeFromController.isLoading,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Obx(
                    () => AppTextField(
                      controller: bedTypeFromController.nameController.value,
                      textFieldType: TextFieldType.NAME,
                      focus: bedTypeFromController.bedTypeNameFocus,
                      nextFocus: bedTypeFromController.bedTypeFocus,
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.enterBedTypeName,
                        fillColor: context.cardColor,
                        filled: true,
                        borderRadius: 10,
                      ),
                    ),
                  ),
                  16.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        controller: bedTypeFromController.descriptionCont,
                        focus: bedTypeFromController.descriptionFocus,
                        textStyle: primaryTextStyle(size: 12),
                        maxLines: 5,
                        maxLength: 250,
                        textInputAction: TextInputAction.newline,
                        onChanged: (value) {
                          bedTypeFromController.descriptionCharCount = value.length;
                        },
                        decoration: inputDecoration(
                          hintText: locale.value.descriptionLabel,
                          context,
                          fillColor: context.cardColor,
                          filled: true,
                          borderRadius: 10,
                        ),
                        textFieldType: TextFieldType.MULTILINE,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Obx(
                          () => Text(
                            '${bedTypeFromController.descriptionCharCount}/250',
                            style: secondaryTextStyle(size: 12, color: bedTypeFromController.descriptionCharCount > 240 ? Colors.orange : null),
                          ),
                        ),
                      ),
                    ],
                  ),
                  8.height,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => AppButton(
                onTap: () => bedTypeFromController.saveBedType(isEdit: bedTypeData != null ? true : false),
                text: bedTypeFromController.isLoading.value ? locale.value.save : locale.value.save,
                width: MediaQuery.of(context).size.width,
                color: appColorSecondary,
                textColor: white,
                enableScaleAnimation: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
