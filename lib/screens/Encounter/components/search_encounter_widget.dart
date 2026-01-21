import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/all_encounters_controller.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';

class SearchEncounterWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final AllEncountersController allEncountersCont;

  const SearchEncounterWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.allEncountersCont,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: allEncountersCont.searchEncouterCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        allEncountersCont.isSearchEncounterText(allEncountersCont.searchEncouterCont.text.trim().isNotEmpty);
        allEncountersCont.searchEncounterStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            allEncountersCont.searchEncouterCont.clear();
            allEncountersCont.isSearchEncounterText(allEncountersCont.searchEncouterCont.text.trim().isNotEmpty);
            allEncountersCont.page(1);
            allEncountersCont.encounterListFuture();
          },
          size: 11,
        ).visible(allEncountersCont.isSearchEncounterText.value),
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText ?? locale.value.searchHere,
        filled: true,
        fillColor: context.cardColor,
        prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 18).paddingAll(14),
      ),
    );
  }
}
