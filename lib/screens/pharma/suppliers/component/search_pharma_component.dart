import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/pharma/suppliers/controller/pharma_controller.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchPharmaComponent extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final PharmaController allPharmaCont;
  const SearchPharmaComponent({super.key, this.hintText, this.onFieldSubmitted, this.onTap, this.onClearButton, required this.allPharmaCont});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: allPharmaCont.searchPharmaCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        allPharmaCont.isSearchPharmaText(allPharmaCont.searchPharmaCont.text.trim().isNotEmpty);
        allPharmaCont.searchPharmaStream.add(p0);
      },
      suffix: Obx(
            () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            allPharmaCont.searchPharmaCont.clear();
            allPharmaCont.isSearchPharmaText(allPharmaCont.searchPharmaCont.text.trim().isNotEmpty);
            allPharmaCont.page(1);
            allPharmaCont.getPharmas();
          },
          size: 11,
        ).visible(allPharmaCont.isSearchPharmaText.value),
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText ?? "Search Pharma Here",
        filled: true,
        fillColor: context.cardColor,
        prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 18).paddingAll(14),
      ),
    );
  }
}
