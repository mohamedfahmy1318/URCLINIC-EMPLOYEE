import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/select_doctor/select_doctor_controller.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../../main.dart';
import '../../../../../../utils/common_base.dart';

class SearchSelectClinicWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final int doctorId;
  final SelectDoctorController clinicListCont;

  const SearchSelectClinicWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.doctorId,
    required this.clinicListCont,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: clinicListCont.searchClinicCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        clinicListCont.isSearchClinicText(clinicListCont.searchClinicCont.text.trim().isNotEmpty);
        clinicListCont.searchClinicStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            clinicListCont.searchClinicCont.clear();
            clinicListCont.isSearchClinicText(clinicListCont.searchClinicCont.text.trim().isNotEmpty);
            clinicListCont.clinicPage(1);
            clinicListCont.getClinicsData(doctorId);
          },
          size: 11,
        ).visible(clinicListCont.isSearchClinicText.value),
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText ?? locale.value.searchClinicHere,
        filled: true,
        fillColor: context.cardColor,
        prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 18).paddingAll(14),
      ),
    );
  }
}
