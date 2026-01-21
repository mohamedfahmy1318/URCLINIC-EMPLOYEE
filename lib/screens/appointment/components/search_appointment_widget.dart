import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/appointment/appointments_controller.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';

class SearchAppoinmentWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final AppointmentsController appointmentsCont;

  const SearchAppoinmentWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.appointmentsCont,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: appointmentsCont.searchCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        appointmentsCont.isSearchText(appointmentsCont.searchCont.text.trim().isNotEmpty);
        appointmentsCont.searchStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            appointmentsCont.searchCont.clear();
            appointmentsCont.isSearchText(appointmentsCont.searchCont.text.trim().isNotEmpty);
            appointmentsCont.page(1);
            appointmentsCont.getAppointmentList();
          },
          size: 11,
        ).visible(appointmentsCont.isSearchText.value),
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText ?? locale.value.searchAppoinmentHere,
        filled: true,
        fillColor: context.cardColor,
        prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 18).paddingAll(14),
      ),
    );
  }
}
