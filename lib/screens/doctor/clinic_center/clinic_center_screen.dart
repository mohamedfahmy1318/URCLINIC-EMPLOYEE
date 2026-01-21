import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/empty_error_state_widget.dart';
import 'clinic_center_controller.dart';
import 'components/clinic_center_card_component.dart';
import 'components/search_clinic_center_widget.dart';

class ClinicCenterScreen extends StatelessWidget {
  ClinicCenterScreen({super.key});

  final ClinicCenterController clinicListController = Get.put(ClinicCenterController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.clinics,
      isLoading: clinicListController.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        Obx(() {
          return IconButton(
            onPressed: () async {
              if (clinicListController.isSingleSelect.value) {
                Get.back(result: clinicListController.singleClinicSelect.value);
              } else {
                Get.back(result: clinicListController.selectedClinics);
              }
            },
            icon: const Icon(Icons.check, size: 20, color: Colors.white),
          ).paddingOnly(right: 8, top: 12, bottom: 12).visible(clinicListController.selectedClinics.isNotEmpty || clinicListController.singleClinicSelect.value.id > 0);
        })
      ],
      body: SizedBox(
        height: Get.height,
        child: Obx(
          () => Column(
            children: [
              SearchClinicCenterWidget(
                  clinicListController: clinicListController,
                  onFieldSubmitted: (p0) {
                    hideKeyboard(context);
                  },
                  onClearButton: () {
                    clinicListController.searchClinicCont.clear();
                    clinicListController.getClinicList();
                  }).paddingSymmetric(horizontal: 16),
              16.height,
              SnapHelperWidget(
                future: clinicListController.getClinics.value,
                loadingWidget: clinicListController.isLoading.value ? const Offstage() : const LoaderWidget(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      clinicListController.page(1);
                      clinicListController.getClinicList();
                    },
                  );
                },
                onSuccess: (res) {
                  return Obx(
                    () => AnimatedListView(
                      shrinkWrap: true,
                      itemCount: clinicListController.clinicList.length,
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      listAnimationType: ListAnimationType.None,
                      emptyWidget: NoDataWidget(
                        title: locale.value.noClinicsFound,
                        subTitle: locale.value.oppsNoClinicsFoundAtMomentTryAgainLater,
                        imageWidget: const EmptyStateWidget(),
                        onRetry: () {
                          clinicListController.page(1);
                          clinicListController.getClinicList();
                        },
                      ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!clinicListController.isLoading.value),
                      onSwipeRefresh: () async {
                        clinicListController.page(1);
                        return await clinicListController.getClinicList(showloader: false);
                      },
                      onNextPage: () async {
                        if (!clinicListController.isLastPage.value) {
                          clinicListController.page++;
                          clinicListController.getClinicList();
                        }
                      },
                      itemBuilder: (ctx, index) {
                        return ClinicCenterCardWidget(
                          clinicListController: clinicListController,
                          clinicData: clinicListController.clinicList[index],
                        ).paddingBottom(16);
                      },
                    ),
                  );
                },
              ).expand(),
            ],
          ),
        ).paddingTop(16),
      ),
    );
  }
}
