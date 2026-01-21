import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/appointment/components/appointment_card.dart';
import '../../../utils/constants.dart';
import '../../Encounter/encounter_dashboard/encounter_dashboard.dart';
import '../../Encounter/model/encounters_list_model.dart';
import '../../appointment/model/appointments_res_model.dart';
import '../home_controller.dart';

class AppointmentsHomeComponent extends StatelessWidget {
  AppointmentsHomeComponent({super.key});

  final HomeController homeController = Get.find();

  bool get showBtns => homeController.dashboardData.value.data.upcomingAppointment.any((element) => element.status != StatusConst.checkout && element.status != StatusConst.completed && element.status != StatusConst.cancelled);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: Get.width,
        child: Column(
          children: [
            Obx(
              () => ExpandablePageView.builder(
                controller: homeController.recentAppointmentPageController,
                onPageChanged: (int page) {
                  hideKeyboard(context);
                  homeController.currentAppoinmentPage(page);
                },
                itemCount: homeController.dashboardData.value.data.upcomingAppointment.length,
                itemBuilder: (context, index) {
                  return AppointmentCard(
                    appointment: homeController.dashboardData.value.data.upcomingAppointment[index],
                    onCheckIn: () {
                      if (homeController.dashboardData.value.data.upcomingAppointment[index].status == StatusConst.check_in) {
                        navigateToEncounter(index);
                      } else {
                        homeController.updateStatus(
                          id: homeController.dashboardData.value.data.upcomingAppointment[index].id,
                          status: getUpdateStatusText(status: homeController.dashboardData.value.data.upcomingAppointment[index].status),
                          context: context,
                          isBack: false,
                        );
                      }
                    },
                    onEncounter: () {
                      navigateToEncounter(index);
                    },
                  );
                },
              ),
            ),
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    homeController.dashboardData.value.data.upcomingAppointment.length,
                    (index) {
                      return InkWell(
                        onTap: () {
                          homeController.recentAppointmentPageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Container(
                          height: 8,
                          width: homeController.currentAppoinmentPage.value == index ? 35 : 8,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: homeController.currentAppoinmentPage.value == index ? const Color(0xFF6E8192) : const Color(0xFF6E8192).withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ).paddingTop(16).visible(
                    homeController.dashboardData.value.data.upcomingAppointment.length > 1,
                  ),
            ),
          ],
        ),
      ).visible(homeController.dashboardData.value.data.upcomingAppointment.isNotEmpty),
    );
  }

  void navigateToEncounter(int index) {
    final AppointmentData appointmentData = homeController.dashboardData.value.data.upcomingAppointment[index];
    final encounterDetail = EncounterElement(
      id: appointmentData.encounterId,
      appointmentId: appointmentData.id,
      clinicId: appointmentData.clinicId,
      clinicName: appointmentData.clinicName,
      description: appointmentData.encounterDescription,
      doctorId: appointmentData.doctorId,
      doctorName: appointmentData.doctorName,
      encounterDate: appointmentData.appointmentDate,
      userId: appointmentData.userId,
      userName: appointmentData.userName,
      userImage: appointmentData.userImage,
      address: appointmentData.address,
      userEmail: appointmentData.userEmail,
      status: appointmentData.encounterStatus,
    );
    Get.to(
      () => EncountersDashboardScreen(encounterDetail: encounterDetail),
      arguments: appointmentData.encounterId,
    )?.then((value) {
      if (value == true) {
        homeController.getDashboardDetail();
      }
    });
  }
}
