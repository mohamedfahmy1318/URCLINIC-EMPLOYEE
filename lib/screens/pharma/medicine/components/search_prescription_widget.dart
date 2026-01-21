import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../../generated/assets.dart';
import '../../prescriptions/controller/all_prescription_controller.dart';

class SearchPrescriptionWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final AllPrescriptionsController allPrescriptionsCont;

  const SearchPrescriptionWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.allPrescriptionsCont,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: allPrescriptionsCont.searchPrescriptionCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        allPrescriptionsCont.isSearchPrescriptionText(allPrescriptionsCont.searchPrescriptionCont.text.trim().isNotEmpty);
        allPrescriptionsCont.searchPrescriptionStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            allPrescriptionsCont.searchPrescriptionCont.clear();
            allPrescriptionsCont.isSearchPrescriptionText(allPrescriptionsCont.searchPrescriptionCont.text.trim().isNotEmpty);
            allPrescriptionsCont.page(1);
            allPrescriptionsCont.getPrescriptions();
          },
          size: 11,
        ).visible(allPrescriptionsCont.isSearchPrescriptionText.value),
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText ?? locale.value.searchPrescriptionHere,
        filled: true,
        fillColor: context.cardColor,
        prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 18).paddingAll(14),
      ),
    );
  }
}
