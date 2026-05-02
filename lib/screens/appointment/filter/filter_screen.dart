import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import 'components/type_list_component.dart';
import 'filter_controller.dart';

class FilterScreen extends StatelessWidget {
  FilterScreen({super.key});

  final FilterController filterCont =
      Get.put(FilterController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.filterBy,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        TextButton(
          onPressed: () {
            filterCont.clearFilter();
          },
          child: Text(locale.value.clearAllFilters,
              style: boldTextStyle(size: 14, color: whiteTextColor)),
        ),
      ],
      body: Container(
        height: Get.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color:
              isDarkMode.value ? appScreenBackgroundDark : appScreenBackground,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterTypeListComponent().expand(),
                Obx(() => filterCont.viewFilterWidget(filterCont: filterCont)),
              ],
            ).expand(),
            Obx(
              () => Container(
                decoration: boxDecorationDefault(
                    borderRadius: radius(0), color: context.cardColor),
                width: Get.width,
                padding: const EdgeInsets.all(16),
                child: filterCont.applyButton(),
              ).visible(
                filterCont.screenType.value == "bed_management" ||
                    filterCont.hasActiveAppointmentFilters,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
