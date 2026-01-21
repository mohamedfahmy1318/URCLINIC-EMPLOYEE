import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/clinical_details/clinical_details_controller.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import '../../../../main.dart';
import '../../../../utils/view_all_label_component.dart';
import 'choose_component.dart';

class ProblemComponent extends StatelessWidget {
  final ClinicalDetailsController clincalDetailCont;

  const ProblemComponent({super.key, required this.clincalDetailCont});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: locale.value.problems,
          trailingText: locale.value.add,
          isShowAll: clincalDetailCont.encounterData.value.status,
          onTap: () {
            Get.bottomSheet(
              ChooseComponent(
                title: locale.value.chooseOrAddProblems,
                hintText: locale.value.writeProblem,
                list: clincalDetailCont.problems,
                selectedList: clincalDetailCont.selectedProblems,
              ),
              isScrollControlled: true,
            );
          },
        ).paddingLeft(16),
        Obx(
          () => clincalDetailCont.selectedProblems.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: boxDecorationDefault(
                    color: context.cardColor,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(locale.value.noProblemAdded, style: primaryTextStyle(size: 12, color: appColorSecondary)),
                )
              : AnimatedListView(
                  listAnimationType: ListAnimationType.None,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: clincalDetailCont.selectedProblems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: Get.height * 0.05,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(6),
                        color: context.cardColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            clincalDetailCont.selectedProblems[index].name,
                            style: primaryTextStyle(size: 12, color: dividerColor),
                          ).flexible(),
                          IconButton(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            style: const ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              clincalDetailCont.selectedProblems.removeAt(index);
                              clincalDetailCont.setSelectedValues(type: EncounterDropdownTypes.encounterProblem);
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: boxDecorationDefault(color: lightPrimaryColor, shape: BoxShape.circle),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: iconColor,
                              ),
                            ),
                          ).visible(clincalDetailCont.encounterData.value.status),
                        ],
                      ),
                    ).paddingBottom(clincalDetailCont.selectedProblems.length - 1 == index ? 0 : 8);
                  },
                ),
        ).paddingSymmetric(horizontal: 16),
        16.height,
      ],
    );
  }
}
