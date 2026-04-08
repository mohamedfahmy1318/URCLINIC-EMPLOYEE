// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_assign_screen.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/invoice_details/invoice_details_screen.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/medical_Report/medical_reports_screen.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../bed_management/all_beds_screen.dart';
import '../../../bed_management/bed_type/receptionist_bed_type_screen.dart';
import '../../clinical_details/soap_screen.dart';
import '../encounter_dashboard_controller.dart';
import '../../model/encounters_list_model.dart';
import '../../../bed_management/components/bed_component.dart';

class MoreInfoComponent extends StatelessWidget {
  final EncounterElement encounterData;

  const MoreInfoComponent({super.key, required this.encounterData});

  @override
  Widget build(BuildContext context) {
    final EncountersDashboardController encountersCont =
        Get.find<EncountersDashboardController>();
    final isBedDetailsVisible = false.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(locale.value.moreInformation,
            style: boldTextStyle(
                size: 14,
                weight: FontWeight.w600,
                color: isDarkMode.value ? null : darkGrayTextColor)),
        8.height,
        SettingItemWidget(
          title: locale.value.viewReport,
          decoration: boxDecorationDefault(
            color: context.cardColor,
          ),
          subTitle: locale.value.showReportRelatedInformation,
          splashColor: transparentColor,
          onTap: () {
            Get.to(() => MedicalReportsScreen(), arguments: encounterData);
          },
          titleTextStyle: boldTextStyle(size: 14),
          leading: commonLeadingWid(
              imgPath: Assets.iconsIcFile, color: appColorSecondary),
          trailing: const Icon(Icons.arrow_forward_ios_rounded,
              size: 12, color: darkGray),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        ).paddingTop(16),
        SettingItemWidget(
          title: "SOAP",
          //Don't Translate its sort form of Subjective, Objective, Assessment, and Plan
          decoration: boxDecorationDefault(
            color: context.cardColor,
          ),
          subTitle: locale.value.subjectiveObjectiveAssessmentAndPlan,
          splashColor: transparentColor,
          onTap: () {
            Get.to(() => SOAPScreen(), arguments: encounterData);
          },
          titleTextStyle: boldTextStyle(size: 14),
          leading: commonLeadingWid(
              imgPath: Assets.iconsIcSoap, color: appColorSecondary),
          trailing: const Icon(Icons.arrow_forward_ios_rounded,
              size: 12, color: darkGray),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        ).paddingTop(16).visible(appConfigs.value.viewPatientSoap),
        SettingItemWidget(
          title: locale.value.billDetails,
          decoration: boxDecorationDefault(
            color: context.cardColor,
          ),
          subTitle: locale.value.showBillDetailsRelatedInformation,
          splashColor: transparentColor,
          onTap: () {
            Get.to(() => InvoiceDetailsScreen(), arguments: encounterData);
          },
          titleTextStyle: boldTextStyle(size: 14),
          leading: commonLeadingWid(
              imgPath: Assets.iconsIcInvoice, color: appColorSecondary),
          trailing: const Icon(Icons.arrow_forward_ios_rounded,
              size: 12, color: darkGray),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        ).paddingTop(16),
        if (CoreServiceApis.isBedFeatureAvailable)
          Obx(
            () {
              var detail = encountersCont.encounterDetail.value;

              // Check if encounter is closed (status = false)
              bool isEncounterClosed = !encounterData.status;

              if (detail.bedAllocations.isNotEmpty) {
                // Show bed details if bed is allocated
                return Column(
                  children: [
                    SettingItemWidget(
                      title: locale.value.bedDetails,
                      decoration:
                          boxDecorationDefault(color: context.cardColor),
                      subTitle: locale.value.viewAssignedBedDetails,
                      splashColor: transparentColor,
                      onTap: () {
                        isBedDetailsVisible.value = !isBedDetailsVisible.value;
                      },
                      titleTextStyle: boldTextStyle(size: 14),
                      leading: commonLeadingWid(
                          imgPath: Assets.iconsIcBed, color: appColorSecondary),
                      trailing: Obx(() => Icon(
                          isBedDetailsVisible.value
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 24,
                          color: darkGray)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 16),
                    ).paddingTop(16),
                    Obx(
                      () => BedComponent(
                        bedData: detail.bedAllocations.first,
                        patientId: detail.userId,
                        patientName: detail.userName,
                        encounterId: detail.id,
                        isEncounterOpen: encounterData.status,
                      ).visible(isBedDetailsVisible.value),
                    ),
                  ],
                );
              } else if (!isEncounterClosed) {
                // Show assign bed option only if encounter is not closed
                return SettingItemWidget(
                  title: locale.value.assignBed,
                  decoration: boxDecorationDefault(color: context.cardColor),
                  subTitle: locale.value.assignBedToPatient,
                  splashColor: transparentColor,
                  onTap: () {
                    Get.to(() => BedAssignScreen(), arguments: {
                      'patientId': encounterData.userId,
                      'patientName': encounterData.userName,
                      'encounter_id': encounterData.id,
                      'clinicId': encounterData.clinicId,
                      'clinicName': encounterData.clinicName,
                    });
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                      imgPath: Assets.iconsIcBed, color: appColorSecondary),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      size: 12, color: darkGray),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16);
              } else {
                // Encounter is closed and no bed allocated - show no bed option
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 16),
                  decoration: boxDecorationDefault(color: context.cardColor),
                  child: Row(
                    children: [
                      commonLeadingWid(
                          imgPath: Assets.iconsIcBed, color: Colors.grey),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locale.value.bedDetails,
                              style: boldTextStyle(size: 14),
                            ),
                            4.height,
                            Text(
                              'No bed assigned',
                              style: secondaryTextStyle(
                                  size: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        if (encounterData.status == true &&
            CoreServiceApis.isBedFeatureAvailable)
          Obx(
            () {
              return SettingItemWidget(
                decoration: boxDecorationDefault(color: context.cardColor),
                title: locale.value.bedType,
                subTitle: locale.value.manageBedTypes,
                splashColor: transparentColor,
                onTap: () {
                  Get.to(() => ReceptionistBedTypeScreen());
                },
                titleTextStyle: boldTextStyle(size: 14),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 12, color: darkGray),
                leading: commonLeadingWid(
                    imgPath: Assets.iconsIcBed, color: appColorSecondary),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              ).paddingTop(16).visible(!loginUserData.value.userRole
                  .contains(EmployeeKeyConst.doctor));

              // Return empty widget if encounter is open
            },
          ),
        if (encounterData.status == true &&
            CoreServiceApis.isBedFeatureAvailable)
          Obx(
            () {
              return SettingItemWidget(
                decoration: boxDecorationDefault(color: context.cardColor),
                title: locale.value.allBeds,
                subTitle: locale.value.allBedType,
                splashColor: transparentColor,
                onTap: () {
                  Get.to(() => AllBedScreen());
                },
                titleTextStyle: boldTextStyle(size: 14),
                leading: commonLeadingWid(
                    imgPath: Assets.iconsIcBed, color: appColorSecondary),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 12, color: darkGray),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              ).paddingSymmetric(vertical: 16).visible(!loginUserData
                  .value.userRole
                  .contains(EmployeeKeyConst.doctor));
            },
          ),
      ],
    );
  }
}
