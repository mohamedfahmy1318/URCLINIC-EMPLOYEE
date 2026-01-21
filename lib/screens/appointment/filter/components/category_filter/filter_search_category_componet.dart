import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../generated/assets.dart';
import '../../../../../main.dart';
import '../../../../../utils/common_base.dart';
import '../../filter_controller.dart';

class FilterSearchCategoryComponent extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final FilterController filterCategoryController;

  const FilterSearchCategoryComponent({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.filterCategoryController,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: filterCategoryController.searchCategoryCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        filterCategoryController.getCategoryList(search: p0);
      },
      suffix: Obx(
            () =>
            appCloseIconButton(
              context,
              onPressed: () {
                if (onClearButton != null) {
                  onClearButton!.call();
                }
                hideKeyboard(context);
                filterCategoryController.searchClinicCont.clear();
                filterCategoryController.isDoctorSearchText(filterCategoryController.searchClinicCont.text
                    .trim()
                    .isNotEmpty);
                filterCategoryController.doctorPage(1);
                filterCategoryController.getDoctorsList();
              },
              size: 11,
            ).visible(filterCategoryController.isDoctorSearchText.value),
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
