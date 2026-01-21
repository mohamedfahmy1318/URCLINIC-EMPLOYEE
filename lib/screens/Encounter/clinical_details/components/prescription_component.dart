import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/clinical_details/clinical_details_controller.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/view_all_label_component.dart';
import 'add_prescription_component.dart';

class PrescriptionComponent extends StatelessWidget {
  final ClinicalDetailsController clincalDetailCont;

  const PrescriptionComponent({super.key, required this.clincalDetailCont});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ViewAllLabel(
          label: locale.value.prescription,
          trailingText: locale.value.add,
          isShowAll: clincalDetailCont.encounterData.value.status,
          onTap: () {
            clincalDetailCont.getClearPrescription();
            Get.bottomSheet(AddPrescriptionComponent());
          },
        ).paddingLeft(16),
        Obx(
          () => clincalDetailCont.prescriptionList.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: boxDecorationDefault(
                    color: context.cardColor,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(locale.value.noPatientFound, style: primaryTextStyle(size: 12, color: appColorSecondary)),
                )
              : Obx(
                  () => AnimatedListView(
                    shrinkWrap: true,
                    listAnimationType: ListAnimationType.None,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: clincalDetailCont.prescriptionList.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: boxDecorationDefault(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clincalDetailCont.prescriptionList[index].name,
                                  style: boldTextStyle(size: 14, color: isDarkMode.value ? null : darkGrayTextColor),
                                ).expand(),
                                InkWell(
                                  onTap: () {
                                    clincalDetailCont.getEditData(index);
                                    Get.bottomSheet(AddPrescriptionComponent(isEdit: true, index: index));
                                  },
                                  child:  CachedImageWidget(
                                    url: Assets.iconsIcEditReview,
                                    height: 14,
                                    width: 14,
                                    color: isDarkMode.value?Colors.white:Colors.black,
                                  ),
                                ).visible(clincalDetailCont.encounterData.value.status),
                                12.width.visible(clincalDetailCont.encounterData.value.status),
                                InkWell(
                                  onTap: () {
                                    clincalDetailCont.prescriptionList.removeAt(index);
                                  },
                                  child:  CachedImageWidget(
                                    url: Assets.iconsIcDelete,
                                    height: 14,
                                    width: 14,
                                    color: isDarkMode.value?Colors.white:Colors.black,
                                  ),
                                ).visible(clincalDetailCont.encounterData.value.status),
                              ],
                            ),
                            6.height,
                            Text(clincalDetailCont.prescriptionList[index].instruction, style: primaryTextStyle(size: 12, color: dividerColor)),
                            16.height,
                            Divider(color: isDarkMode.value ? borderColor.withValues(alpha: 0.2) : context.dividerColor.withValues(alpha: 0.2), height: 1),
                            16.height,
                            Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${locale.value.frequency}: ',
                                        style: primaryTextStyle(color: dividerColor, size: 12),
                                      ),
                                      TextSpan(
                                        text: clincalDetailCont.prescriptionList[index].frequency,
                                        style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                      ),
                                    ],
                                  ),
                                ).expand(),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${locale.value.days}: ',
                                        style: primaryTextStyle(color: dividerColor, size: 12),
                                      ),
                                      TextSpan(
                                        text: clincalDetailCont.prescriptionList[index].duration,
                                        style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                      ),
                                    ],
                                  ),
                                ).expand(),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }
}
