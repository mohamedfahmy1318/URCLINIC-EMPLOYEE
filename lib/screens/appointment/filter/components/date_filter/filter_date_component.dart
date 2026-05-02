import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../generated/assets.dart';
import '../../../../../utils/app_common.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/common_base.dart';
import '../../filter_controller.dart';

class FilterDateComponent extends StatelessWidget {
  final FilterController filterCont;
  const FilterDateComponent({super.key, required this.filterCont});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Obx(() {
          return AppTextField(
            readOnly: true,
            textStyle: primaryTextStyle(size: 12),
            textFieldType: TextFieldType.NAME,
            controller: filterCont.selectedFirstDateCont,
            decoration: inputDecoration(
              suffixIcon: commonLeadingWid(
                      imgPath: Assets.iconsIcCalendar,
                      color: iconColor,
                      size: 10)
                  .paddingAll(16),
              getContext,
              fillColor: isDarkMode.value ? black : white,
              filled: true,
              hintText: 'Select the First Date',
            ),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: getContext,
                firstDate: DateTime(2000),
                lastDate: DateTime(2050),
                initialDate: DateTime.now(),
              );

              if (pickedDate != null) {
                filterCont.selectedFirstDate(pickedDate.formatDateddmmYYYY());
                filterCont.selectedFirstDateCont.text =
                    pickedDate.formatDateDDMMYY();
                // Default to single-day filtering unless user picks a new end date.
                filterCont.selectedLastDate(pickedDate.formatDateddmmYYYY());
                filterCont.selectedLastDateCont.text =
                    pickedDate.formatDateDDMMYY();
                filterCont.tampDate.value = pickedDate;
              }
            },
          ).paddingSymmetric(horizontal: 8);
        }),
        16.height,
        Obx(() {
          return AppTextField(
            readOnly: true,
            controller: filterCont.selectedLastDateCont,
            textStyle: primaryTextStyle(size: 12),
            textFieldType: TextFieldType.NAME,
            decoration: inputDecoration(
              suffixIcon: commonLeadingWid(
                      imgPath: Assets.iconsIcCalendar,
                      color: iconColor,
                      size: 10)
                  .paddingAll(16),
              getContext,
              fillColor: isDarkMode.value ? black : white,
              filled: true,
              hintText: 'Select the Last Date (Optional)',
            ),
            suffixPasswordVisibleWidget: commonLeadingWid(
                    imgPath: Assets.iconsIcEye,
                    color: appColorPrimary,
                    size: 12)
                .paddingAll(14),
            suffixPasswordInvisibleWidget: commonLeadingWid(
                    imgPath: Assets.iconsIcEyeSlash, color: appColorPrimary)
                .paddingAll(14),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: getContext,
                firstDate: filterCont.tampDate.value,
                lastDate: DateTime(2050),
                initialDate: filterCont.tampDate.value,
              );
              if (pickedDate != null) {
                filterCont.selectedLastDate(pickedDate.formatDateddmmYYYY());
                filterCont.selectedLastDateCont.text =
                    pickedDate.formatDateDDMMYY();
              }
            },
          ).paddingSymmetric(horizontal: 8);
        }),
      ],
    );
  }
}
