import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../utils/colors.dart';
import '../filter_controller.dart';

class FilterTypeListComponent extends StatelessWidget {
  FilterTypeListComponent({super.key});

  final FilterController filterCont = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: 80,
      decoration: boxDecorationDefault(borderRadius: radius(0), color: context.cardColor),
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: filterCont.filterList.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Obx(
            () => InkWell(
              onTap: () {
                filterCont.filterType(filterCont.filterList[index]);
                filterCont.filterType.refresh();
              },
              child: Container(
                height: 50,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                color: filterCont.filterType.value == filterCont.filterList[index]
                    ? isDarkMode.value
                        ? appScreenBackgroundDark
                        : appScreenBackground
                    : context.cardColor,
                child: Text(
                  "${filterCont.filterList[index]}",
                  style: filterCont.filterType.value == filterCont.filterList[index] ? boldTextStyle(size: 12, color: appColorPrimary) : primaryTextStyle(size: 12),
                ).paddingSymmetric(horizontal: 16),
              ),
            ),
          );
        },
      ),
    );
  }

  bool checkFilterType(String type) {
    if (filterCont.filterType.value == type) {
      return true;
    }
    return false;
  }
}
