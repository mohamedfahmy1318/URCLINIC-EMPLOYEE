import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/clinical_details/clinical_details_controller.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import '../../../../utils/view_all_label_component.dart';

class OtherInfoComponent extends StatelessWidget {
  final ClinicalDetailsController clincalDetailCont;
  const OtherInfoComponent({super.key, required this.clincalDetailCont});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() => clincalDetailCont.prescriptionList.isEmpty ? 16.height : 0.height),
        ViewAllLabel(
          label: locale.value.otherInformation,
          isShowAll: false,
        ).paddingLeft(16),
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: clincalDetailCont.otherInfoCont,
          textFieldType: TextFieldType.OTHER,
          enabled: clincalDetailCont.encounterData.value.status,
          readOnly: !clincalDetailCont.encounterData.value.status,
          minLines: 1,
          decoration: inputDecoration(
            context,
            fillColor: context.cardColor,
            filled: true,
            hintText: locale.value.write,
          ),
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }
}
