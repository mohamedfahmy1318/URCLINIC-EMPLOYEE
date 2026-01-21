import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/components/doctor_session_card.dart';
import '../../../../components/app_scaffold.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../../utils/view_all_label_component.dart';
import 'add_session/add_session_screen.dart';
import 'add_session/model/doctor_session_model.dart';
import 'doctor_session_controller.dart';

class DoctorSessionScreen extends StatelessWidget {
  DoctorSessionScreen({super.key});

  final DoctorSessionController doctorsListCont = Get.put(DoctorSessionController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffoldNew(
      appBartitleText: locale.value.doctorSession,
      scaffoldBackgroundColor: context.scaffoldBackgroundColor,
      appBarVerticalSize: Get.height * 0.12,
      isLoading: doctorsListCont.isLoading,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewAllLabel(
            label: locale.value.allSession,
            trailingText: locale.value.addSession,
            trailingTextColor: appColorSecondary,
            onTap: () {
              Get.to(
                () => AddSessionScreen(),
                arguments: DoctorSessionModel(
                  doctorId: doctorsListCont.selectDoctorData.value.doctorId,
                  fullName: doctorsListCont.selectDoctorData.value.fullName,
                ),
              )?.then((value) {
                if (value == true) {
                  doctorsListCont.getDcotorsSession();
                }
              });
            },
          ).paddingOnly(left: 16, right: 8, top: 8),
          Obx(
            () => SnapHelperWidget(
              future: doctorsListCont.getDoctorSession.value,
              initialData: doctorsListCont.doctorSession.isNotEmpty ? doctorsListCont.doctorSession : null,
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    doctorsListCont.page(1);
                    doctorsListCont.getDcotorsSession();
                  },
                ).paddingSymmetric(horizontal: 12);
              },
              loadingWidget: doctorsListCont.isLoading.value ? const Offstage() : const LoaderWidget(),
              onSuccess: (booking) {
                return Obx(
                  () => AnimatedListView(
                    shrinkWrap: true,
                    itemCount: doctorsListCont.doctorSession.length,
                    listAnimationType: ListAnimationType.None,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    emptyWidget: NoDataWidget(
                      title: locale.value.noDoctorSessionFound,
                      imageWidget: const EmptyStateWidget(),
                      subTitle: locale.value.thereAreCurrentlyNoDoctorSessionAvailable,
                    ).paddingSymmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      return DcotorSessionCard(doctorSession: doctorsListCont.doctorSession[index]).paddingBottom(16);
                    },
                    onNextPage: () async {
                      if (!doctorsListCont.isLastPage.value) {
                        doctorsListCont.page(doctorsListCont.page.value + 1);
                        doctorsListCont.getDcotorsSession();
                      }
                    },
                    onSwipeRefresh: () async {
                      doctorsListCont.page(1);
                      return doctorsListCont.getDcotorsSession(showloader: false);
                    },
                  ),
                ).paddingSymmetric(horizontal: 12);
              },
            ).makeRefreshable,
          ).expand(),
        ],
      ),
    ),);
  }
}
