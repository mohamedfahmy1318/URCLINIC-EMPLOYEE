import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/clinical_details/clinical_details_controller.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../main.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/view_all_label_component.dart';
import 'choose_component.dart';

class ObservationComponent extends StatelessWidget {
  final ClinicalDetailsController clincalDetailCont;

  const ObservationComponent({super.key, required this.clincalDetailCont});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: locale.value.observations,
          trailingText: locale.value.add,
          isShowAll: clincalDetailCont.encounterData.value.status,
          onTap: () {
            Get.bottomSheet(
              ChooseComponent(
                title: locale.value.chooseOrAddObservation,
                hintText: locale.value.writeObservation,
                list: clincalDetailCont.observations,
                selectedList: clincalDetailCont.selectedObservation,
              ),
              isScrollControlled: true,
            );
          },
        ).paddingLeft(16),
        Obx(
          () => clincalDetailCont.selectedObservation.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: boxDecorationDefault(
                    color: context.cardColor,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(locale.value.noObservationAdded, style: primaryTextStyle(size: 12, color: appColorSecondary)),
                )
              : AnimatedListView(
                  listAnimationType: ListAnimationType.None,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: clincalDetailCont.selectedObservation.length,
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
                            clincalDetailCont.selectedObservation[index].name,
                            style: primaryTextStyle(size: 12, color: dividerColor),
                          ).flexible(),
                          IconButton(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            style: const ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              clincalDetailCont.selectedObservation.removeAt(index);
                              clincalDetailCont.setSelectedValues(type: EncounterDropdownTypes.encounterObservations);
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
                    ).paddingBottom(clincalDetailCont.selectedObservation.length - 1 == index ? 0 : 8);
                  },
                ),
        ).paddingSymmetric(horizontal: 16),
        16.height,
      ],
    );
  }
}
