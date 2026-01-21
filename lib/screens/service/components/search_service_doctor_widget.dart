import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/service/assing_doctor_screen_controller.dart';

import '../../../../../generated/assets.dart';
import '../../../../../utils/common_base.dart';
import '../../../main.dart';

class SearchServiceDoctorWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final AssingDoctorController doctorListCont;

  const SearchServiceDoctorWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.doctorListCont,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: doctorListCont.searchCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        doctorListCont.isSearchText(doctorListCont.searchCont.text.trim().isNotEmpty);
        doctorListCont.searchStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            doctorListCont.searchCont.clear();
            doctorListCont.isSearchText(doctorListCont.searchCont.text.trim().isNotEmpty);
            doctorListCont.page(1);
            doctorListCont.getDoctors();
          },
          size: 11,
        ).visible(doctorListCont.isSearchText.value),
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
