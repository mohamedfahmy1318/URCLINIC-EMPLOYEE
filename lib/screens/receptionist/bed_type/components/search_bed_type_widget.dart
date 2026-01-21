import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/receptionist/bed_type/receptionist_bed_type_controller.dart';

class SearchBedTypeWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final ReceptionistBedTypeController bedTypeCont;

  const SearchBedTypeWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.bedTypeCont,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: bedTypeCont.searchBedTypeCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        bedTypeCont.isSearchText(bedTypeCont.searchBedTypeCont.text.trim().isNotEmpty);
        bedTypeCont.searchRx.value = p0;
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            bedTypeCont.searchBedTypeCont.clear();
            bedTypeCont.isSearchText(bedTypeCont.searchBedTypeCont.text.trim().isNotEmpty);
            bedTypeCont.filterBedTypes('');
          },
          size: 11,
        ).visible(bedTypeCont.isSearchText.value),
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
