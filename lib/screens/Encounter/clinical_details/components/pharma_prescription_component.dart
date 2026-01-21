import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/clinical_details/clinical_details_controller.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/view_all_label_component.dart';
import '../../../pharma/medicine/medicine_list_screen.dart';
import '../../invoice_details/components/select_pharma_bottomsheet.dart';
import 'pharma_add_prescription_component.dart';

class PharmaPrescriptionComponent extends StatelessWidget {
  final ClinicalDetailsController clincalDetailCont;

  const PharmaPrescriptionComponent({super.key, required this.clincalDetailCont});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => ViewAllLabel(
            label: locale.value.prescription,
            trailingText: clincalDetailCont.prescriptionList.isNotEmpty ? locale.value.change : locale.value.add,
            isShowAll: clincalDetailCont.encounterData.value.status,
            onTap: () {
              clincalDetailCont.getClearPrescription();
              Get.bottomSheet(
                SelectPharmaBottomSheet(
                  clinicId: clincalDetailCont.encounterData.value.clinicId,
                ),
              ).then((result) {
                if (result is Pharma && result.id > 0) {
                  if (clincalDetailCont.selectedPharma.value.id != result.id) {
                    clincalDetailCont.prescriptionList.clear();
                  }
                  clincalDetailCont.selectedPharma(result);
                  Get.to(
                      () => MedicinesListScreen(
                            isSelectMedicineScreen: true,
                          ),
                      arguments: {
                        'encounterId': clincalDetailCont.encounterData.value.id,
                        'pharmaId': clincalDetailCont.selectedPharma.value.id,
                      }
                      //  arguments: clincalDetailCont.selectedMedicines,
                      )?.then((res) {
                    if (res is List<Medicine>) {
                      clincalDetailCont.setMedicineForms(res);
                    }
                    Get.to(() => AddPrescriptionComponentPharma());
                  });
                } else {
                  toast("Please select a pharmacy");
                }
              });
            },
          ).paddingLeft(16),
        ),
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
                  child: Text(locale.value.prescription, style: primaryTextStyle(size: 12, color: appColorSecondary)),
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
                                  clincalDetailCont.prescriptionList[index].medicine.name,
                                  style: boldTextStyle(size: 14, color: isDarkMode.value ? null : darkGrayTextColor),
                                ).expand(),
                                InkWell(
                                  onTap: () {
                                    clincalDetailCont.getEditData(index);
                                    Get.to(() => AddPrescriptionComponentPharma(isEdit: true, index: index));
                                  },
                                  child: const CachedImageWidget(
                                    url: Assets.iconsIcEditReview,
                                    height: 22,
                                    width: 22,
                                    color: iconColor,
                                  ),
                                ).visible(clincalDetailCont.encounterData.value.status),
                                12.width.visible(clincalDetailCont.encounterData.value.status),
                                InkWell(
                                  onTap: () {
                                    clincalDetailCont.prescriptionList.removeAt(index);
                                  },
                                  child: const CachedImageWidget(
                                    url: Assets.iconsIcDelete,
                                    height: 22,
                                    width: 22,
                                    color: iconColor,
                                  ),
                                ).visible(clincalDetailCont.encounterData.value.status),
                              ],
                            ),
                            16.height,
                            Divider(color: isDarkMode.value ? borderColor.withValues(alpha: 0.2) : context.dividerColor.withValues(alpha: 0.2), height: 1),
                            16.height,
                            Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${locale.value.dosage}: ',
                                        style: primaryTextStyle(color: dividerColor, size: 12),
                                      ),
                                      TextSpan(
                                        text: clincalDetailCont.prescriptionList[index].medicine.dosage,
                                        style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                      ),
                                    ],
                                  ),
                                ).expand(),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${locale.value.form}: ',
                                        style: primaryTextStyle(color: dividerColor, size: 12),
                                      ),
                                      TextSpan(
                                        text: clincalDetailCont.prescriptionList[index].medicine.form.name,
                                        style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                      ),
                                    ],
                                  ),
                                ).expand(),
                              ],
                            ),
                            8.height,
                            Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${locale.value.quantity}: ',
                                        style: primaryTextStyle(color: dividerColor, size: 12),
                                      ),
                                      TextSpan(
                                        text: clincalDetailCont.prescriptionList[index].quantity.toString(),
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
                            8.height,
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
                              ],
                            ),
                            8.height,
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${locale.value.instruction}: ',
                                    style: primaryTextStyle(color: dividerColor, size: 12),
                                  ),
                                  TextSpan(
                                    text: clincalDetailCont.prescriptionList[index].instruction,
                                    style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                  ),
                                ],
                              ),
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
