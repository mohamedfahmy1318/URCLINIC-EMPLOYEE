import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/clinical_details/components/pharma_prescription_component.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_assign_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import 'clinical_details_controller.dart';
import 'components/notes_component.dart';
import 'components/observation_component.dart';
import 'components/otherinfo_component.dart';
import 'components/prescription_component.dart';
import 'components/problem_component.dart';
import '../../bed_management/components/bed_component.dart';

class ClinicalDetailsScreen extends StatelessWidget {
  ClinicalDetailsScreen({super.key});

  final ClinicalDetailsController clincalDetailCont =
      Get.put(ClinicalDetailsController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.clinicalDetail,
      isBlurBackgroundinLoader: true,
      isLoading: clincalDetailCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: Form(
        key: clincalDetailCont.clinicalDetailsFormKey,
        child: AnimatedScrollView(
          mainAxisSize: MainAxisSize.min,
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            ProblemComponent(clincalDetailCont: clincalDetailCont)
                .visible(appConfigs.value.isEncounterProblem),
            ObservationComponent(clincalDetailCont: clincalDetailCont)
                .visible(appConfigs.value.isEncounterObservation),
            NotesComponent(clincalDetailCont: clincalDetailCont)
                .visible(appConfigs.value.isEncounterNote),
            // 24.height,
            // Divider(color: context.dividerColor.withValues(alpha: 0.2),height: 1),
            appConfigs.value.isPharma.getBoolInt()
                ? PharmaPrescriptionComponent(
                        clincalDetailCont: clincalDetailCont)
                    .visible(appConfigs.value.isEncounterPrescription)
                : PrescriptionComponent(clincalDetailCont: clincalDetailCont)
                    .visible(appConfigs.value.isEncounterPrescription),

            // IPD Checkbox - Only show if patient doesn't have allocated bed
            if (CoreServiceApis.isBedFeatureAvailable)
              Obx(
                () {
                  return clincalDetailCont.hasAllocatedBed.value &&
                          clincalDetailCont.encounterDashboardDetail.value !=
                              null &&
                          clincalDetailCont.encounterDashboardDetail.value!
                              .bedAllocations.isNotEmpty
                      ? BedComponent(
                          bedData: clincalDetailCont.encounterDashboardDetail
                              .value!.bedAllocations.first,
                          isEncounterOpen:
                              clincalDetailCont.encounterData.value.status,
                          patientId:
                              clincalDetailCont.encounterData.value.userId,
                          patientName:
                              clincalDetailCont.encounterData.value.userName,
                          encounterId: clincalDetailCont.encounterData.value.id,
                        )
                      : Column(
                          children: [
                            16.height,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Text(
                                    locale.value.ipdInPatientDepartment,
                                    style: primaryTextStyle(
                                      color: clincalDetailCont
                                              .encounterData.value.status
                                          ? null
                                          : Colors.grey,
                                    ),
                                  ),
                                  Spacer(),
                                  Checkbox(
                                    value: clincalDetailCont.isIPD.value,
                                    onChanged: clincalDetailCont
                                            .encounterData.value.status
                                        ? (value) {
                                            clincalDetailCont.isIPD.value =
                                                value ?? false;
                                          }
                                        : null, // Disable checkbox for closed encounters
                                    activeColor: appColorSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                },
              ),

            // Bed Allocation Section
            if (CoreServiceApis.isBedFeatureAvailable)
              Obx(
                () {
                  return clincalDetailCont.isIPD.value &&
                          clincalDetailCont.encounterData.value.status
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                locale.value.bedAssign,
                                style: boldTextStyle(size: 14),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await Get.to(() => BedAssignScreen(),
                                      arguments: {
                                        'patientId': clincalDetailCont
                                            .encounterData.value.userId,
                                        'patientName': clincalDetailCont
                                            .encounterData.value.userName,
                                        'encounter_id': clincalDetailCont
                                            .encounterData.value.id,
                                        'clinicId': clincalDetailCont
                                            .encounterData.value.clinicId,
                                        'clinicName': clincalDetailCont
                                            .encounterData.value.clinicName,
                                      });
                                  // Refresh bed allocation status after returning
                                  clincalDetailCont.getEncouterDetails();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: appColorSecondary,
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          radius(defaultAppButtonRadius / 2)),
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                child: Text(
                                  locale.value.add,
                                  style: primaryTextStyle(
                                      color: appColorSecondary),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),
            OtherInfoComponent(clincalDetailCont: clincalDetailCont)
                .paddingBottom(16),
            54.height,
          ],
        ),
      ),
      widgetsStackedOverBody: [
        Positioned(
          bottom: 16,
          height: 50,
          width: Get.width,
          child: Obx(
            () => AppButton(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: Get.width,
              text: locale.value.save,
              color: appColorSecondary,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: radius(defaultAppButtonRadius / 2)),
              onTap: () {
                if (clincalDetailCont.clinicalDetailsFormKey.currentState!
                    .validate()) {
                  clincalDetailCont.saveEncounterDashboard();
                }
              },
            ).visible(
              clincalDetailCont.encounterData.value.status &&
                  (clincalDetailCont.selectedProblems.isNotEmpty ||
                      clincalDetailCont.selectedObservation.isNotEmpty ||
                      clincalDetailCont.selectedNotes.isNotEmpty ||
                      clincalDetailCont.prescriptionList.isNotEmpty),
            ),
          ),
        ),
      ],
    );
  }
}
