import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import 'package:kivicare_clinic_admin/screens/home/home_controller.dart';
import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import 'clinic_session/clinic_session_screen.dart';
import 'components/clinic_component.dart';
import 'add_clinic_form/add_clinic_form.dart';
import 'clinic_list_controller.dart';
import 'search_clinic_widget.dart';
import '../../api/clinic_api.dart';

class ClinicListScreen extends StatelessWidget {
  ClinicListScreen({super.key});

  final ClinicListController clinicListController = Get.put(ClinicListController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.clinics,
      isLoading: clinicListController.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      actions: loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)
          ? [
              IconButton(
                onPressed: () async {
                  Get.to(() => AddClinicForm())?.then((value) {
                    if (value == true) {
                      clinicListController.page(1);
                      clinicListController.getClinicList();
                    }
                  });
                },
                icon: const Icon(Icons.add_circle_outline_rounded, size: 28, color: Colors.white),
              ).paddingOnly(right: 8),
            ]
          : null,
      body: SizedBox(
        height: Get.height,
        child: Obx(
          () => Column(
            children: [
              SearchClinicWidget(
                clinicListController: clinicListController,
                onFieldSubmitted: (p0) {
                  hideKeyboard(context);
                },
              ).paddingSymmetric(horizontal: 16),
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
                        retryText: !loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) ? null : locale.value.addNewClinic,
                        imageWidget: const EmptyStateWidget(),
                        onRetry: !loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)
                            ? null
                            : () async {
                                Get.to(() => AddClinicForm())?.then((result) {
                                  if (result == true) {
                                    clinicListController.page(1);
                                    clinicListController.getClinicList();
                                  }
                                });
                              },
                      ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!clinicListController.isLoading.value),
                      onSwipeRefresh: () async {
                        clinicListController.page(1);
                        return clinicListController.getClinicList(showloader: false);
                      },
                      onNextPage: () async {
                        if (!clinicListController.isLastPage.value) {
                          clinicListController.page++;
                          clinicListController.getClinicList();
                        }
                      },
                      itemBuilder: (ctx, index) {
                        return ClinicComponent(
                          clinicData: clinicListController.clinicList[index],
                          onEditClick: () {
                            if (loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)) {
                              Get.to(() => ClinicSessionScreen(), arguments: clinicListController.clinicList[index]);
                            } else {
                              Get.to(() => AddClinicForm(isEdit: true), arguments: clinicListController.clinicList[index])?.then((value) {
                                if (value == true) {
                                  clinicListController.page(1);
                                  clinicListController.getClinicList();
                                }
                              });
                            }
                          },
                          onDeleteClick: () => handleDeleteClinicClick(clinicListController.clinicList, index, context),
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

  Widget buildIconWidget({required String icon, required VoidCallback onTap, Color? iconColor}) {
    return SizedBox(
      height: 38,
      width: 38,
      child: IconButton(padding: EdgeInsets.zero, icon: icon.iconImage(size: 18, color: iconColor), onPressed: onTap),
    );
  }

  Future<void> handleDeleteClinicClick(List<ClinicData> clinicList, int index, BuildContext context) async {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.areYouSureYouWantToDeleteThisClinic,
      positiveText: locale.value.yes,
      negativeText: locale.value.no,
      onAccept: (ctx) async {
        clinicListController.isLoading(true);
        ClinicApis.deleteClinic(clinicId: clinicList[index].id).then((value) {
          clinicList.removeAt(index);

          toast(value.message.trim().isEmpty ? locale.value.clinicDeleteSuccessfully : value.message.trim());
          try {
            final HomeController hcont = Get.find();
            hcont.getDashboardDetail();
          } catch (e) {
            log('deleteClinic hcont = Get.find() E: $e');
          }
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => clinicListController.isLoading(false));
      },
    );
  }
}
