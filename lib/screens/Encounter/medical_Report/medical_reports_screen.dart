import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/medical_Report/medical_reports_controller.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/loader_widget.dart';
import '../../../utils/colors.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../model/medical_reports_res_model.dart';
import 'add_medical_report_form.dart';
import 'components/reports_card_components.dart';

class MedicalReportsScreen extends StatelessWidget {
  MedicalReportsScreen({super.key});

  final MedicalReportsController medicalReportsCont = Get.put(MedicalReportsController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.medicalReports,
      isLoading: medicalReportsCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        Obx(
          () => IconButton(
            onPressed: () async {
              Get.to(() => AddMedicalReportForm())?.then((value) {
                if (value == true) {
                  medicalReportsCont.page(1);
                  medicalReportsCont.getMedicalReports();
                }
              });
            },
            icon: const Icon(Icons.add_circle_outline_rounded, size: 28, color: Colors.white),
          ).paddingOnly(right: 8).visible(medicalReportsCont.encounterData.value.status.obs.value),
        ),
      ],
      body: Obx(
        () => SnapHelperWidget(
          future: medicalReportsCont.medicalReportsFuture.value,
          loadingWidget: medicalReportsCont.isLoading.value ? const Offstage() : const LoaderWidget(),
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                medicalReportsCont.page(1);
                medicalReportsCont.getMedicalReports();
              },
            );
          },
          onSuccess: (res) {
            return Obx(
              () => AnimatedListView(
                shrinkWrap: true,
                itemCount: medicalReportsCont.medicalReports.length,
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                listAnimationType: ListAnimationType.None,
                emptyWidget: NoDataWidget(
                  subTitle: locale.value.thereIsNoMedicalReportsAvilableAtThisMoment,
                  title: locale.value.noMedicalReportsFound,
                  imageWidget: const EmptyStateWidget(),
                ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.1).visible(!medicalReportsCont.isLoading.value),
                onSwipeRefresh: () async {
                  medicalReportsCont.page(1);
                  return medicalReportsCont.getMedicalReports(showloader: false);
                },
                onNextPage: () async {
                  if (!medicalReportsCont.isLastPage.value) {
                    medicalReportsCont.page++;
                    medicalReportsCont.getMedicalReports();
                  }
                },
                itemBuilder: (ctx, index) {
                  return MedicalReportCard(
                    medicalReport: medicalReportsCont.medicalReports[index],
                    onEditClick: () {
                      Get.to(() => AddMedicalReportForm(isEdit: true), arguments: medicalReportsCont.medicalReports[index])?.then((value) {
                        if (value == true) {
                          medicalReportsCont.page(1);
                          medicalReportsCont.getMedicalReports();
                        }
                      });
                    },
                    onDeleteClick: () => handleDeleteMedicalReportClick(medicalReportsCont.medicalReports, index, context),
                  ).paddingBottom(16);
                },
              ),
            );
          },
        ),
      ).paddingTop(16),
    );
  }

  Future<void> handleDeleteMedicalReportClick(List<MedicalReport> medicalReports, int index, BuildContext context) async {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.areYouSureYouWantToDeleteThisMedicalReport,
      positiveText: locale.value.delete,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        medicalReportsCont.isLoading(true);
        CoreServiceApis.deleteMedicalReports(reportId: medicalReports[index].id).then((value) {
          medicalReports.removeAt(index);
          toast(value.message.trim().isEmpty ? locale.value.medicalReportDeleteSuccessfully : value.message.trim());
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => medicalReportsCont.isLoading(false));
      },
    );
  }
}
