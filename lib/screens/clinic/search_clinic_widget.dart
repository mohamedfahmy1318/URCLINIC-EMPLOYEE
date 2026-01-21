import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/common_base.dart';
import 'clinic_list_controller.dart';

class SearchClinicWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final ClinicListController clinicListController;

  const SearchClinicWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.clinicListController,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: clinicListController.searchClinicCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        clinicListController.isSearchClincText(clinicListController.searchClinicCont.text.trim().isNotEmpty);
        clinicListController.searchClincStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            clinicListController.searchClinicCont.clear();
            clinicListController.isSearchClincText(clinicListController.searchClinicCont.text.trim().isNotEmpty);
            clinicListController.page(1);
            clinicListController.getClinicList();
          },
          size: 11,
        ).visible(clinicListController.isSearchClincText.value),
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
