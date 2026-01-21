import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/suppliers/controller/supplier_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../../generated/assets.dart';

class SearchSupplierComponent extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final SupplierController allSuppliersCont;

  const SearchSupplierComponent({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.allSuppliersCont,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: allSuppliersCont.searchSupplierCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        allSuppliersCont.isSearchSupplierText(allSuppliersCont.searchSupplierCont.text.trim().isNotEmpty);
        allSuppliersCont.searchSupplierStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            allSuppliersCont.searchSupplierCont.clear();
            allSuppliersCont.isSearchSupplierText(allSuppliersCont.searchSupplierCont.text.trim().isNotEmpty);
            allSuppliersCont.page(1);
            allSuppliersCont.getSuppliers();
          },
          size: 11,
        ).visible(allSuppliersCont.isSearchSupplierText.value),
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText ?? locale.value.searchSupplierHere,
        filled: true,
        fillColor: context.cardColor,
        prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 18).paddingAll(14),
      ),
    );
  }
}
