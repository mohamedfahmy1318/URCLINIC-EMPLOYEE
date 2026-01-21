import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/loader_widget.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/manufacturer/controller/manufacturer_controller.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:nb_utils/nb_utils.dart';

class AddManufacturerComponent extends StatelessWidget {
  AddManufacturerComponent({
    super.key,
  });

  final ManufacturerController manufacturerController = Get.put(ManufacturerController(),permanent: false);

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
        key: manufacturerController.manufacturerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(locale.value.addManufacturer, style: secondaryTextStyle(size: 16, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor)),
            16.height,
            AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: manufacturerController.nameCont,
              textFieldType: TextFieldType.NAME,
              focus: manufacturerController.nameFocus,
              isValidationRequired: true,
              errorThisFieldRequired: locale.value.thisFieldIsRequired,
              validator: (value){
                if (value!.trim().isEmpty) {
                  return locale.value.thisFieldIsRequired;
                }
                return null;
              },
              decoration: inputDecoration(
                context,
                fillColor: context.cardColor,
                filled: true,
                hintText: locale.value.enterTheManufacturerName,
              ),
            ),
            Obx(()=>LoaderWidget().visible(manufacturerController.isLoading.value)),
            // Date Input

            32.height,
            AppButton(
              width: Get.width,
              text: locale.value.save,
              color: appColorSecondary,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
              onTap: () async {
                hideKeyboard(context);
                manufacturerController.addManufacturer();
              },

            ),
          ],
        ),
      ),
    );
  }
}
