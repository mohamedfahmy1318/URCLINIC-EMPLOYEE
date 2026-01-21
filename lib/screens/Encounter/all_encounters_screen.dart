import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/components/all_encounter_card.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/medical_Report/medical_reports_screen.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/empty_error_state_widget.dart';
import 'add_encounter/add_encounter_screen.dart';
import 'all_encounters_controller.dart';
import 'body_chart/body_chart_screen.dart';
import 'clinical_details/clinical_details_screen.dart';
import 'encounter_dashboard/encounter_dashboard.dart';
import 'invoice_details/invoice_details_screen.dart';

class AllEncountersScreen extends StatelessWidget {
  AllEncountersScreen({super.key});

  final AllEncountersController allEncountersCont = Get.put(AllEncountersController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.encounters,
      isLoading: allEncountersCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        IconButton(
          onPressed: () async {
            Get.to(() => AddEncounterScreen(), arguments: [false])?.then((value) {
              if (value == true) {
                allEncountersCont.page(1);
                allEncountersCont.getAllEncounters(showloader: false);
              }
            });
          },
          icon: const Icon(Icons.add_circle_outline_rounded, size: 28, color: Colors.white),
        ).paddingOnly(right: 8).visible(!loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)),
      ],
      body: SizedBox(
        height: Get.height,
        child: Column(
          children: [
            Obx(
              () => SnapHelperWidget(
                future: allEncountersCont.encounterListFuture.value,
                loadingWidget: allEncountersCont.isLoading.value ? const Offstage() : const LoaderWidget(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      allEncountersCont.page(1);
                      allEncountersCont.getAllEncounters();
                    },
                  );
                },
                onSuccess: (res) {
                  return Obx(
                    () => AnimatedListView(
                      shrinkWrap: true,
                      itemCount: allEncountersCont.encounterList.length,
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      emptyWidget: NoDataWidget(
                        title: locale.value.noEncountersFound,
                        imageWidget: const EmptyStateWidget(),
                      ).paddingSymmetric(horizontal: 32).visible(!allEncountersCont.isLoading.value),
                      onSwipeRefresh: () async {
                        allEncountersCont.page(1);
                        return allEncountersCont.getAllEncounters(showloader: false);
                      },
                      onNextPage: () async {
                        if (!allEncountersCont.isLastPage.value) {
                          allEncountersCont.page++;
                          allEncountersCont.getAllEncounters();
                        }
                      },
                      itemBuilder: (ctx, index) {
                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => EncountersDashboardScreen(encounterDetail: allEncountersCont.encounterList[index]),
                              arguments: allEncountersCont.encounterList[index].id,
                            );
                          },
                          child: AllEncounterCard(
                            encounterElement: allEncountersCont.encounterList[index],
                            onEditClick: () {
                              Get.to(() => AddEncounterScreen(), arguments: [true, allEncountersCont.encounterList[index]])?.then((value) {
                                if (value == true) {
                                  allEncountersCont.page(1);
                                  allEncountersCont.getAllEncounters(showloader: false);
                                }
                              });
                            },
                            onDeleteClick: () {
                              showConfirmDialogCustom(
                                context,
                                primaryColor: appColorPrimary,
                                title: locale.value.areYouSureYouWantToDeleteThisEncounter,
                                positiveText: locale.value.delete,
                                negativeText: locale.value.cancel,
                                onAccept: (ctx) async {
                                  allEncountersCont.deletEncounter(id: allEncountersCont.encounterList[index].id);
                                },
                              );
                            },
                            onEncounterClick: () {
                              Get.to(() => ClinicalDetailsScreen(), arguments: allEncountersCont.encounterList[index]);
                            },
                            onMedicalReportClick: () {
                              Get.to(() => MedicalReportsScreen(), arguments: allEncountersCont.encounterList[index]);
                            },
                            onBodyChartClick: () {
                              Get.to(() => BodyChartScreen(), arguments: allEncountersCont.encounterList[index]);
                            },
                            onInvoiceClick: () {
                              Get.to(() => InvoiceDetailsScreen(), arguments: allEncountersCont.encounterList[index]);
                            },
                          ).paddingBottom(16),
                        );
                      },
                    ),
                  );
                },
              ).expand(),
            ),
          ],
        ),
      ).paddingTop(16),
    );
  }
}
