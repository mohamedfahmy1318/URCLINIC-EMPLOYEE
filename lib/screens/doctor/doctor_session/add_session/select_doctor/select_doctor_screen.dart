import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import 'package:kivicare_clinic_admin/screens/doctor/model/doctor_list_res.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/select_doctor/components/search_select_doctor_widget.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/select_doctor/components/select_doctor_card_component.dart';
import '../../../../../components/app_scaffold.dart';
import '../../../../../components/loader_widget.dart';
import '../../../../../main.dart';
import '../../../../../utils/empty_error_state_widget.dart';
import '../add_session_controller.dart';
import 'select_doctor_controller.dart';

class SelectDoctorScreen extends StatelessWidget {
  final Doctor selectDoctorName;
  SelectDoctorScreen({super.key, required this.selectDoctorName});

  final SelectDoctorController doctorsController = Get.put(SelectDoctorController());
  final AddSessionController addSessionController = Get.put(AddSessionController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.assignDoctor,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        InkWell(
          onTap: () {
            if (doctorsController.selectDoctorData.value.fullName.isNotEmpty) {
              addSessionController.selectDoctorData(doctorsController.selectDoctorData.value);
              doctorsController.selectClinicData(ClinicData());
              addSessionController.selectClinicName(ClinicData());
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
            () => SearchSelectDoctorWidget(
              doctorListCont: doctorsController,
              onFieldSubmitted: (p0) {
                hideKeyboard(context);
              },
            ).paddingSymmetric(horizontal: 16).paddingTop(16).visible(doctorsController.doctors.length > 6),
          ),
          Obx(
            () => SnapHelperWidget(
              future: doctorsController.doctorsFuture.value,
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    doctorsController.doctorsPage(1);
                    doctorsController.getDoctors();
                  },
                ).paddingSymmetric(horizontal: 32);
              },
              loadingWidget: const LoaderWidget(),
              onSuccess: (p0) {
                if (doctorsController.doctors.isEmpty) {
                  return NoDataWidget(
                    title: locale.value.noDoctorsFound,
                    subTitle: locale.value.oppsNoDoctorFoundAtMomentTryAgainLater,
                    imageWidget: const EmptyStateWidget(),
                    onRetry: () async {
                      doctorsController.doctorsPage(1);
                      doctorsController.getDoctors();
                    },
                  ).paddingSymmetric(horizontal: 32).visible(!doctorsController.isLoading.value);
                } else {
                  return AnimatedListView(
                    shrinkWrap: true,
                    itemCount: doctorsController.doctors.length,
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    listAnimationType: ListAnimationType.None,
                    onSwipeRefresh: () async {
                      doctorsController.doctorsPage(1);
                      return doctorsController.getDoctors(showLoader: false);
                    },
                    onNextPage: () async {
                      if (!doctorsController.isDoctorsLastPage.value) {
                        doctorsController.doctorsPage++;
                        doctorsController.getDoctors();
                      }
                    },
                    itemBuilder: (ctx, index) {
                      return SelectDoctorCardComponents(
                        doctorData: doctorsController.doctors[index],
                      );
                    },
                  );
                }
              },
            ),
          ).paddingTop(16),
        ],
      ),
    );
  }
}
