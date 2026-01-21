import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../api/core_apis.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../../service/assing_doctor_screen.dart';
import '../../service/assing_doctor_screen_controller.dart';
import '../../service/change_price_bottom_component.dart';
import '../../service/components/all_service_card.dart';
import '../../service/manage_service/service_apis.dart';
import '../home_controller.dart';

class ServicesHomeComponent extends StatelessWidget {
  ServicesHomeComponent({super.key});

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
                controller: homeController.servicesPageController,
                onPageChanged: (int page) {
                  hideKeyboard(context);
                  homeController.currentServicePage(page);
                },
                itemCount: homeController.dashboardData.value.data.doctorServices.length,
                itemBuilder: (context, index) {
                  return AllServiceCard(
                    serviceElement: homeController.dashboardData.value.data.doctorServices[index],
                    onClickAssignDoctor: () {
                      if (loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)) {
                        Get.bottomSheet(
                          ChangePriceComponent(
                            serviceElement: homeController.dashboardData.value.data.doctorServices[index],
                            changePriceCont: TextEditingController(text: homeController.dashboardData.value.data.doctorServices[index].doctorCharges.toString()),
                            onSave: (p0) {
                              changeServicePrice(serviceId: homeController.dashboardData.value.data.doctorServices[index].id, price: p0);
                            },
                          ),
                        );
                      } else {
                        Get.to(() => AssingDoctorScreen(), arguments: homeController.dashboardData.value.data.doctorServices[index])?.then((value) {
                          if (value == true) {
                            homeController.getDashboardDetail();
                          }
                        });
                      }
                    },
                  );
                },
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  homeController.dashboardData.value.data.doctorServices.length,
                  (index) {
                    return InkWell(
                      onTap: () {
                        homeController.servicesPageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Container(
                        height: 8,
                        width: homeController.currentServicePage.value == index ? 35 : 8,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: homeController.currentServicePage.value == index ? const Color(0xFF6E8192) : const Color(0xFF6E8192).withValues(alpha: 0.5),
                        ),
                      ),
                    );
                  },
                ),
              ).paddingTop(16).visible(homeController.dashboardData.value.data.upcomingAppointment.length > 1),
            ),
          ],
        ),
      ).visible(homeController.dashboardData.value.data.doctorServices.isNotEmpty),
    );
  }

  Future<void> handleStatusChangeClick({required BuildContext context, required bool statusValue, required int index}) async {
    if (homeController.isLoading.value) return;
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.doYouWantToPerformThisChange,
      positiveText: locale.value.yes,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        homeController.isLoading(true);
        log('VALUE: $statusValue');
        homeController.dashboardData.value.data.doctorServices[index].status(statusValue);
        ServiceFormApis.updateServicesStatus(
          serviceId: homeController.dashboardData.value.data.doctorServices[index].id,
          request: {"status": homeController.dashboardData.value.data.doctorServices[index].status.value.getIntBool()},
        ).then((value) {
          toast(value.message.trim().isNotEmpty ? value.message.trim() : locale.value.statusUpdatedSuccessfully);
          homeController.getDashboardDetail();
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => homeController.isLoading(false));
      },
    );
  }

  Future<void> changeServicePrice({required int serviceId, required String price}) async {
    if (homeController.isLoading.value) return;
    homeController.isLoading(true);
    await CoreServiceApis.assignDoctor(
      request: {
        "service_id": serviceId,
        "clinic_id": selectedAppClinic.value.id,
        "assign_doctors": [SelectDoctor(doctorId: loginUserData.value.id, price: price.trim()).toJson()],
      },
    ).then((value) async {
      Get.back(result: true);
      toast(value.message.isNotEmpty ? value.message : locale.value.priceUpdatedSuccessfully);
      homeController.getDashboardDetail();
    }).catchError((e) {
      toast(e.toString());
      log('changeServicePrice Errr: $e');
    }).whenComplete(() => homeController.isLoading(false));
  }
}
