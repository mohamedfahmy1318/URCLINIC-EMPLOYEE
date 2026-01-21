import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../generated/assets.dart';
import '../../../../../main.dart';
import '../../../../../utils/common_base.dart';
import '../../filter_controller.dart';

class FilterSearchDoctorComponent extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final FilterController filterClinicController;

  const FilterSearchDoctorComponent({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.filterClinicController,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: filterClinicController.searchDoctorCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        filterClinicController.isDoctorSearchText(filterClinicController.searchDoctorCont.text.trim().isNotEmpty);
        filterClinicController.searchDoctorStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            filterClinicController.searchDoctorCont.clear();
            filterClinicController.isDoctorSearchText(filterClinicController.searchDoctorCont.text.trim().isNotEmpty);
            filterClinicController.doctorPage(1);
            filterClinicController.getDoctorsList();
          },
          size: 11,
        ).visible(filterClinicController.isDoctorSearchText.value),
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText ?? locale.value.searchDoctorHere,
        filled: true,
        fillColor: context.cardColor,
        prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 18).paddingAll(14),
      ),
    );
  }
}
