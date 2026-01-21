import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import '../../../../../components/app_scaffold.dart';
import '../../../../../components/loader_widget.dart';
import '../../../../../main.dart';
import '../../../../../utils/empty_error_state_widget.dart';
import '../add_session_controller.dart';
import '../select_doctor/select_doctor_controller.dart';
import 'components/search_select_clinic_widget.dart';
import 'components/select_clinic_card_component.dart';

class SelectClinicScreen extends StatelessWidget {
  final ClinicData selectClinics;
  SelectClinicScreen({super.key, required this.selectClinics});

  final SelectDoctorController clinicListController = Get.put(SelectDoctorController());
  final AddSessionController addSessionController = Get.put(AddSessionController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.assignClinics,
      isLoading: clinicListController.isClinicLoading,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        InkWell(
          onTap: () {
            if (clinicListController.selectClinicData.value.name.isNotEmpty) {
              addSessionController.selectClinicName(clinicListController.selectClinicData.value);
              addSessionController.getDoctorSessionList();
            }
            Get.back();
          },
          child: const Icon(
            Icons.check,
            size: 20,
            color: white,
          ).paddingRight(20.0),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => SearchSelectClinicWidget(
              clinicListCont: clinicListController,
              doctorId: addSessionController.selectDoctorData.value.doctorId,
              onFieldSubmitted: (p0) {
                hideKeyboard(context);
              },
            ).paddingSymmetric(horizontal: 16).paddingTop(16).visible(clinicListController.clinicList.length > 6),
          ),
          Obx(
            () => SnapHelperWidget(
              future: clinicListController.clinicFuture.value,
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    clinicListController.clinicPage(1);
                    clinicListController.getClinicsData(addSessionController.selectDoctorData.value.doctorId);
                  },
                ).paddingSymmetric(horizontal: 32);
              },
              loadingWidget: clinicListController.isClinicLoading.value ? const Offstage() : const LoaderWidget(),
              onSuccess: (p0) {
                return AnimatedListView(
                  shrinkWrap: true,
                  itemCount: clinicListController.clinicList.length,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  listAnimationType: ListAnimationType.None,
                  emptyWidget: NoDataWidget(
                    title: locale.value.noClinicsFound,
                    subTitle: locale.value.oppsNoClinicsFoundAtMomentTryAgainLater,
                    imageWidget: const EmptyStateWidget(),
                    onRetry: () async {
                      clinicListController.clinicPage(1);
                      clinicListController.getClinicsData(addSessionController.selectDoctorData.value.doctorId);
                    },
                  ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!clinicListController.isClinicLoading.value),
                  onSwipeRefresh: () async {
                    clinicListController.clinicPage(1);
                    return clinicListController.getClinicsData(addSessionController.selectDoctorData.value.doctorId, showLoader: false);
                  },
                  onNextPage: () async {
                    if (!clinicListController.isClinicLastPage.value) {
                      clinicListController.clinicPage++;
                      clinicListController.getClinicsData(addSessionController.selectDoctorData.value.doctorId);
                    }
                  },
                  itemBuilder: (ctx, index) {
                    return SelectClinicCardComponents(
                      clinicData: clinicListController.clinicList[index],
                    );
                  },
                );
              },
            ),
          ).paddingTop(16).expand(),
        ],
      ),
    );
  }
}
