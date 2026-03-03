import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/components/doctor_card.dart';
import 'package:kivicare_clinic_admin/screens/doctor/components/search_doctor_widget.dart';
import '../../../components/app_scaffold.dart';
import 'package:get/get.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/empty_error_state_widget.dart';
import 'doctor_detail_screen.dart';
import 'doctor_list_controller.dart';

class DoctorsListScreen extends StatelessWidget {
  DoctorsListScreen({super.key});
  final DoctorListController doctorsListCont = Get.put(DoctorListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffoldNew(
        appBartitleText: locale.value.doctors,
        scaffoldBackgroundColor: context.scaffoldBackgroundColor,
        appBarVerticalSize: Get.height * 0.12,
        isLoading: doctorsListCont.isLoading,
        actions: null,
        body: RefreshIndicator(
          onRefresh: () async {
            doctorsListCont.page(1);
            return doctorsListCont.getDoctors();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => SearchDoctorWidget(
                  doctorListCont: doctorsListCont,
                  onFieldSubmitted: (p0) {
                    hideKeyboard(context);
                  },
                )
                    .paddingSymmetric(horizontal: 16)
                    .paddingTop(16)
                    .visible(doctorsListCont.doctors.length > 6),
              ),
              Obx(
                () => SnapHelperWidget(
                  future: doctorsListCont.doctorsFuture.value,
                  errorBuilder: (error) {
                    return NoDataWidget(
                      title: error,
                      retryText: locale.value.reload,
                      imageWidget: const ErrorStateWidget(),
                      onRetry: () {
                        doctorsListCont.page(1);
                        doctorsListCont.getDoctors();
                      },
                    ).paddingSymmetric(horizontal: 32);
                  },
                  loadingWidget: doctorsListCont.isLoading.value
                      ? const Offstage()
                      : const LoaderWidget(),
                  onSuccess: (p0) {
                    if (doctorsListCont.doctors.isEmpty) {
                      return NoDataWidget(
                        title: locale.value.noDoctorsFound,
                        imageWidget: const EmptyStateWidget(),
                      )
                          .paddingSymmetric(horizontal: 32)
                          .paddingBottom(Get.height * 0.15)
                          .visible(!doctorsListCont.isLoading.value);
                    } else {
                      return AnimatedScrollView(
                        children: [
                          AnimatedWrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: List.generate(
                              doctorsListCont.doctors.length,
                              (index) {
                                return Obx(
                                  () => InkWell(
                                    onTap: () {
                                      Get.to(() => DoctorDetailScreen(),
                                          arguments:
                                              doctorsListCont.doctors[index]);
                                    },
                                    child: DoctorCard(
                                      doctor: doctorsListCont.doctors[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        onNextPage: () async {
                          if (!doctorsListCont.isLastPage.value) {
                            doctorsListCont
                                .page(doctorsListCont.page.value + 1);
                            doctorsListCont.getDoctors();
                          }
                        },
                      ).paddingSymmetric(horizontal: 16);
                    }
                  },
                ),
              ).paddingTop(16).expand(),
            ],
          ).makeRefreshable,
        ),
      ),
    );
  }
}
