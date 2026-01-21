import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../../generated/assets.dart';
import '../../../../../main.dart';
import '../../../../../utils/common_base.dart';
import '../../filter_controller.dart';

class SearchPatientWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final FilterController patientListCont;
  final int filterType;

  const SearchPatientWidget({super.key, this.hintText, this.onTap, this.onFieldSubmitted, this.onClearButton, required this.patientListCont, required this.filterType});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: filterType == 0
          ? patientListCont.patientSearchCont
          : filterType == 1
              ? patientListCont.searchServiceCont
              : patientListCont.searchDoctorCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        if (filterType == 0) {
          patientListCont.isSearchText(patientListCont.patientSearchCont.text.trim().isNotEmpty);
          patientListCont.patientPage(1);
          patientListCont.searchStream.add(p0);
        } else if (filterType == 1) {
          patientListCont.isSearchServiceText(patientListCont.searchServiceCont.text.trim().isNotEmpty);
          patientListCont.servicePage(1);
          patientListCont.searchServiceStream.add(p0);
        } else {
          patientListCont.isDoctorSearchText(patientListCont.searchDoctorCont.text.trim().isNotEmpty);
          patientListCont.doctorPage(1);
          patientListCont.searchDoctorStream.add(p0);
        }
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            if (filterType == 0) {
              patientListCont.patientSearchCont.clear();
              patientListCont.isSearchText(patientListCont.patientSearchCont.text.trim().isNotEmpty);
              patientListCont.patientPage(1);
              patientListCont.getPatientList();
            } else if (filterType == 1) {
              patientListCont.searchServiceCont.clear();
              patientListCont.isSearchServiceText(patientListCont.searchServiceCont.text.trim().isNotEmpty);
              patientListCont.servicePage(1);
              patientListCont.getServicesList();
            } else {
              patientListCont.searchDoctorCont.clear();
              patientListCont.isDoctorSearchText(patientListCont.searchDoctorCont.text.trim().isNotEmpty);
              patientListCont.doctorPage(1);
              patientListCont.getDoctorsList();
            }
          },
          size: 11,
        ).visible(
          filterType == 0
              ? patientListCont.isSearchText.value
              : filterType == 1
                  ? patientListCont.isSearchServiceText.value
                  : patientListCont.isDoctorSearchText.value,
        ),
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
