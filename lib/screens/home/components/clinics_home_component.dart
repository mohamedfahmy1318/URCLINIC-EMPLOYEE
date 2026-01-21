import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../api/clinic_api.dart';
import '../../clinic/add_clinic_form/add_clinic_form.dart';
import '../../clinic/components/clinic_component.dart';
import '../../clinic/model/clinics_res_model.dart';
import '../home_controller.dart';

class ClinicsHomeComponent extends StatelessWidget {
  ClinicsHomeComponent({super.key});

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: Get.width,
        child: Column(
          children: [
            Obx(
              () => ExpandablePageView.builder(
                controller: homeController.clinicsPageController,
                onPageChanged: (int page) {
                  hideKeyboard(context);
                  homeController.currentClinicPage(page);
                },
                itemCount: homeController.dashboardData.value.data.clinics.length,
                itemBuilder: (context, index) {
                  return ClinicComponent(
                    clinicData: homeController.dashboardData.value.data.clinics[index],
                    onEditClick: () {
                      Get.to(() => AddClinicForm(isEdit: true), arguments: homeController.dashboardData.value.data.clinics[index])?.then((value) {
                        if (value == true) {
                          homeController.getDashboardDetail();
                        }
                      });
                    },
                    onDeleteClick: () => handleDeleteClinicClick(homeController.dashboardData.value.data.clinics, index, context),
                  );
                },
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  homeController.dashboardData.value.data.clinics.length,
                  (index) {
                    return InkWell(
                      onTap: () {
                        homeController.clinicsPageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Container(
                        height: 8,
                        width: homeController.currentClinicPage.value == index ? 35 : 8,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: homeController.currentClinicPage.value == index ? const Color(0xFF6E8192) : const Color(0xFF6E8192).withValues(alpha: 0.5),
                        ),
                      ),
                    );
                  },
                ),
              ).paddingTop(8).visible(homeController.dashboardData.value.data.clinics.length > 1),
            ),
          ],
        ),
      ).visible(homeController.dashboardData.value.data.clinics.isNotEmpty),
    );
  }

  Future<void> handleDeleteClinicClick(List<ClinicData> clinicList, int index, BuildContext context) async {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.areYouSureYouWantToDeleteThisClinic,
      positiveText: locale.value.delete,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        homeController.isLoading(true);
        ClinicApis.deleteClinic(clinicId: clinicList[index].id).then((value) {
          clinicList.removeAt(index);
          toast(value.message.trim().isEmpty ? locale.value.clinicDeleteSuccessfully : value.message.trim());
          homeController.getDashboardDetail();
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => homeController.isLoading(false));
      },
    );
  }
}
