import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../main.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_base.dart';
import '../../../../utils/constants.dart';
import '../clinical_details_controller.dart';

class SearchAndAddWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function(String)? onAddButton;
  final String type;

  SearchAndAddWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onAddButton,
    required this.type,
  });

  final ClinicalDetailsController encounterDashCont = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: encounterDashCont.searchCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        encounterDashCont.isSearchText(encounterDashCont.searchCont.text.trim().isNotEmpty);
        encounterDashCont.searchStream.add(type);
      },
      suffix: Obx(
        () => TextButton(
          onPressed: () {
            if (onAddButton != null) {
              onAddButton!.call(encounterDashCont.searchCont.text.trim());
            }
            hideKeyboard(context);
            encounterDashCont.searchCont.clear();
            encounterDashCont.isSearchText(encounterDashCont.searchCont.text.trim().isNotEmpty);
            if (type == EncounterDropdownTypes.encounterProblem) {
              encounterDashCont.getEncProblems();
            } else if (type == EncounterDropdownTypes.encounterObservations) {
              encounterDashCont.getEncObservations();
            }
          },
          child: Text(locale.value.add, style: boldTextStyle(color: appColorSecondary, size: 14)),
        ).visible(encounterDashCont.isSearchText.value),
      )
      /* Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            encounterDashCont.searchCont.clear();
            encounterDashCont.isSearchText(encounterDashCont.searchCont.text.trim().isNotEmpty);
            if (type == EncounterDropdownTypes.encounterProblem) {
              encounterDashCont.getEncProblems();
            } else if (type == EncounterDropdownTypes.encounterObservations) {
              encounterDashCont.getEncObservations();
            }
          },
          size: 11,
        ).visible(encounterDashCont.isSearchText.value),
      ) */
      ,
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText ?? locale.value.searchHere,
        // prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 14).paddingAll(12),
        filled: true,
        fillColor: context.cardColor,
      ),
    );
  }
}
