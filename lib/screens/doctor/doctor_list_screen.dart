import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/doctor_apis.dart';
import 'package:kivicare_clinic_admin/screens/doctor/components/doctor_card.dart';
import 'package:kivicare_clinic_admin/screens/doctor/components/search_doctor_widget.dart';
import '../../../components/app_scaffold.dart';
import 'package:get/get.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import '../home/home_controller.dart';
import 'add_doctor/add_doctor_form.dart';
import 'doctor_detail_screen.dart';
import 'doctor_list_controller.dart';
import 'model/doctor_list_res.dart';

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
        actions: loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) || loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)
            ? [
                IconButton(
                  onPressed: () async {
                    Get.to(() => AddDoctorForm())?.then((value) {
                      if (value == true) {
                        doctorsListCont.page(1);
                        doctorsListCont.getDoctors();
                      }
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 28, color: Colors.white),
                ).paddingOnly(right: 8),
              ]
            : null,
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
                ).paddingSymmetric(horizontal: 16).paddingTop(16).visible(doctorsListCont.doctors.length > 6),
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
                  loadingWidget: doctorsListCont.isLoading.value ? const Offstage() : const LoaderWidget(),
                  onSuccess: (p0) {
                    if (doctorsListCont.doctors.isEmpty) {
                      return NoDataWidget(
                        title: locale.value.noDoctorsFound,
                        retryText: !loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) ? null : locale.value.addNewDoctor,
                        imageWidget: const EmptyStateWidget(),
                        onRetry: !loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)
                            ? null
                            : () async {
                                Get.to(() => AddDoctorForm())?.then((result) {
                                  if (result == true) {
                                    doctorsListCont.page(1);
                                    doctorsListCont.getDoctors();
                                  }
                                });
                              },
                      ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!doctorsListCont.isLoading.value);
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
                                      Get.to(() => DoctorDetailScreen(), arguments: doctorsListCont.doctors[index]);
                                    },
                                    child: DoctorCard(
                                      doctor: doctorsListCont.doctors[index],
                                      onEditClick: () {
                                        Get.to(() => AddDoctorForm(isEdit: true), arguments: doctorsListCont.doctors[index])?.then((value) {
                                          if (value == true) {
                                            doctorsListCont.page(1);
                                            doctorsListCont.getDoctors();
                                          }
                                        });
                                      },
                                      onDeleteClick: () => handleDeleteDoctorClick(doctorsListCont.doctors, index, context),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        onNextPage: () async {
                          if (!doctorsListCont.isLastPage.value) {
                            doctorsListCont.page(doctorsListCont.page.value + 1);
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

  Future<void> handleDeleteDoctorClick(List<Doctor> doctors, int index, BuildContext context) async {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.areYouSureYouWantToDeleteThisDoctor,
      positiveText: locale.value.delete,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        doctorsListCont.isLoading(true);
        DoctorApis.deleteDoctor(doctorId: doctors[index].doctorId).then((value) {
          doctors.removeAt(index);
          toast(value.message.trim().isEmpty ? locale.value.doctorDeleteSuccessfully : value.message.trim());
          try {
            final HomeController hcont = Get.find();
            hcont.getDashboardDetail();
          } catch (e) {
            debugPrint('deleteDoctor hcont = Get.find() E: $e');
          }
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => doctorsListCont.isLoading(false));
      },
    );
  }
}
