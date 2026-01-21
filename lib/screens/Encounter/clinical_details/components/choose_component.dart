import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/model/problems_observations_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import 'search_n_add_widget.dart';

class ChooseComponent extends StatelessWidget {
  final RxList<CMNElement> list;
  final RxList<CMNElement> selectedList;
  final String title;
  final String hintText;

  const ChooseComponent({
    super.key,
    required this.list,
    required this.selectedList,
    required this.title,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height * 0.8,
        // padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: boxDecorationDefault(
          color: context.cardColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        ),
        child: Column(
          children: [
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: primaryTextStyle(size: 18),
                ).paddingOnly(left: 16),
                appCloseIconButton(
                  context,
                  onPressed: () {
                    Get.back();
                  },
                  size: 11,
                ),
              ],
            ),
            commonDivider,
            16.height,
            Obx(
              () => AnimatedListView(
                listAnimationType: ListAnimationType.None,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Obx(
                    () => GestureDetector(
                      onTap: () {
                        list[index].isSelected(!list[index].isSelected.value);
                        selectedList.value = list.where((e) => e.isSelected.value).toList();
                      },
                      child: Container(
                        height: Get.height * 0.05,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: boxDecorationDefault(
                          borderRadius: BorderRadius.circular(6),
                          color: context.scaffoldBackgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              list[index].name,
                              style: primaryTextStyle(size: 12, color: dividerColor),
                            ).flexible(),
                            const Icon(
                              Icons.check_rounded,
                              size: 22,
                              color: appColorPrimary,
                            ).visible(list[index].isSelected.value),
                          ],
                        ),
                      ).paddingBottom(8),
                    ),
                  );
                },
              ),
            ).expand(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: boxDecorationDefault(color: lightPrimaryColor),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SearchAndAddWidget(
                      type: EncounterDropdownTypes.encounterProblem,
                      hintText: hintText,
                      onAddButton: (val) {
                        final CMNElement problem = CMNElement(
                          id: -list.length,
                          name: val,
                          type: EncounterDropdownTypes.encounterProblem,
                        );
                        problem.isSelected(true);
                        list.add(problem);
                        selectedList.add(problem);
                        hideKeyboard(context);
                      },
                      onFieldSubmitted: (p0) {
                        hideKeyboard(context);
                      },
                    ),
                  ),
                  16.width,
                  Expanded(
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: radius(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      fillColor: appColorPrimary,
                      onPressed: () {
                        hideKeyboard(context);
                        Get.back();
                      },
                      child: Text(locale.value.done, style: boldTextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
