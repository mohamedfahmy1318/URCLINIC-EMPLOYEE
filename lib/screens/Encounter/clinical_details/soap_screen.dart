import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import 'soap_controller.dart';

class SOAPScreen extends StatelessWidget {
  SOAPScreen({super.key});
  final SOAPController sOAPController = Get.put(SOAPController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: "SOAP",
      isBlurBackgroundinLoader: true,
      isLoading: sOAPController.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: Form(
        key: sOAPController.clinicalDetailsFormKey,
        child: AnimatedScrollView(
          mainAxisSize: MainAxisSize.min,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          children: [
            Text(
              "* ${locale.value.noteTheAcronymSoapStandsForSubjectiveObjectiv}",
              style: secondaryTextStyle(color: appColorSecondary, size: 11, fontStyle: FontStyle.italic),
            ),
            AppTextField(
              title: locale.value.subjective,
              titleTextStyle: boldTextStyle(),
              textStyle: primaryTextStyle(size: 12),
              controller: sOAPController.subjectiveCont,
              textFieldType: TextFieldType.MULTILINE,
              minLines: 4,
              enabled: sOAPController.encounterData.value.status,
              readOnly: !sOAPController.encounterData.value.status,
              decoration: inputDecoration(
                context,
                fillColor: context.cardColor,
                filled: true,
                hintText: "",
              ),
            ).paddingTop(16),
            AppTextField(
              title: locale.value.objective,
              titleTextStyle: boldTextStyle(),
              textStyle: primaryTextStyle(size: 12),
              controller: sOAPController.objectiveCont,
              textFieldType: TextFieldType.MULTILINE,
              minLines: 4,
              enabled: sOAPController.encounterData.value.status,
              readOnly: !sOAPController.encounterData.value.status,
              decoration: inputDecoration(
                context,
                fillColor: context.cardColor,
                filled: true,
                hintText: "",
              ),
            ).paddingTop(16),
            AppTextField(
              title: locale.value.assessment,
              titleTextStyle: boldTextStyle(),
              textStyle: primaryTextStyle(size: 12),
              controller: sOAPController.assessmentCont,
              textFieldType: TextFieldType.MULTILINE,
              minLines: 4,
              enabled: sOAPController.encounterData.value.status,
              readOnly: !sOAPController.encounterData.value.status,
              decoration: inputDecoration(
                context,
                fillColor: context.cardColor,
                filled: true,
                hintText: "",
              ),
            ).paddingTop(16),
            AppTextField(
              title: locale.value.plan,
              textStyle: primaryTextStyle(size: 12),
              controller: sOAPController.planCont,
              textFieldType: TextFieldType.MULTILINE,
              minLines: 4,
              enabled: sOAPController.encounterData.value.status,
              readOnly: !sOAPController.encounterData.value.status,
              decoration: inputDecoration(
                context,
                fillColor: context.cardColor,
                filled: true,
                hintText: "",
              ),
            ).paddingTop(16),
            54.height,
          ],
        ),
      ),
      widgetsStackedOverBody: [
        Positioned(
          bottom: 16,
          height: 50,
          width: Get.width,
          child: AppButton(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: Get.width,
            text: locale.value.save,
            color: appColorSecondary,
            textStyle: appButtonTextStyleWhite,
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
            onTap: () {
              if (sOAPController.clinicalDetailsFormKey.currentState!.validate()) {
                sOAPController.saveSOAP();
              }
            },
          ).visible(sOAPController.encounterData.value.status),
        ),
      ],
    );
  }
}
