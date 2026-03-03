import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/model/encounters_list_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../components/loader_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/empty_error_state_widget.dart';
import '../Encounter/encounter_dashboard/encounter_dashboard.dart';
import 'appointments_controller.dart';
import 'components/appointment_card.dart';
import 'filter/filter_screen.dart';
import 'components/search_appointment_widget.dart';

class AppointmentsScreen extends StatelessWidget {
  AppointmentsScreen({super.key});

  final AppointmentsController appointmentsCont =
      Get.put(AppointmentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffoldNew(
        appBartitleText: locale.value.appointments,
        hasLeadingWidget:
            appointmentsCont.patientDetailArgument.value.isFromPatientDetail,
        appBarVerticalSize: Get.height * 0.12,
        resizeToAvoidBottomPadding: true,
        isLoading: appointmentsCont.isLoading,
        actions: null,
        body: Obx(
          () => SnapHelperWidget(
            future: appointmentsCont.getAppointments.value,
            initialData: appointmentsCont.appointments.isNotEmpty
                ? appointmentsCont.appointments
                : null,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  appointmentsCont.page(1);
                  appointmentsCont.getAppointmentList();
                },
              ).paddingSymmetric(horizontal: 24);
            },
            loadingWidget: appointmentsCont.isLoading.value
                ? const Offstage()
                : const LoaderWidget(),
            onSuccess: (res) {
              return Obx(
                () => Column(
                  children: [
                    16.height,
                    Row(
                      children: [
                        SearchAppoinmentWidget(
                          appointmentsCont: appointmentsCont,
                          onFieldSubmitted: (p0) {
                            hideKeyboard(context);
                          },
                        ).expand(),
                        12.width,
                        InkWell(
                          onTap: () {
                            Get.to(
                              () => FilterScreen(),
                              arguments: [
                                appointmentsCont.selectedPatient.value,
                                appointmentsCont.selectedDoctor.value,
                                appointmentsCont.selectedServiceData.value,
                                appointmentsCont.status.value,
                              ],
                            );
                          },
                          child: Container(
                            height: 46,
                            width: 46,
                            alignment: Alignment.center,
                            decoration: boxDecorationDefault(
                                color: appColorPrimary,
                                borderRadius: BorderRadius.circular(12)),
                            child: const CachedImageWidget(
                              url: Assets.iconsIcFilter,
                              height: 28,
                              color: white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    AnimatedListView(
                      shrinkWrap: true,
                      itemCount: appointmentsCont.appointments.length,
                      listAnimationType: ListAnimationType.None,
                      padding: EdgeInsets.only(
                          bottom: appointmentsCont.patientDetailArgument.value
                                  .isFromPatientDetail
                              ? 24
                              : 80),
                      physics: const AlwaysScrollableScrollPhysics(),
                      emptyWidget: NoDataWidget(
                        title: locale.value.noAppointmentsFound,
                        imageWidget: const EmptyStateWidget(),
                        subTitle: locale
                            .value.thereAreCurrentlyNoAppointmentsAvailable,
                      )
                          .paddingSymmetric(horizontal: 24)
                          .paddingBottom(Get.height * 0.15)
                          .visible(!appointmentsCont.isLoading.value),
                      itemBuilder: (context, index) {
                        final encounterDetail = EncounterElement(
                          id: appointmentsCont.appointments[index].encounterId,
                          appointmentId:
                              appointmentsCont.appointments[index].id,
                          clinicId:
                              appointmentsCont.appointments[index].clinicId,
                          clinicName:
                              appointmentsCont.appointments[index].clinicName,
                          description: appointmentsCont
                              .appointments[index].encounterDescription,
                          doctorId:
                              appointmentsCont.appointments[index].doctorId,
                          doctorName:
                              appointmentsCont.appointments[index].doctorName,
                          encounterDate: appointmentsCont
                              .appointments[index].appointmentDate,
                          userId: appointmentsCont.appointments[index].userId,
                          userName:
                              appointmentsCont.appointments[index].userName,
                          userImage:
                              appointmentsCont.appointments[index].userImage,
                          address: appointmentsCont.appointments[index].address,
                          userEmail:
                              appointmentsCont.appointments[index].userEmail,
                          status: appointmentsCont
                              .appointments[index].encounterStatus,
                        );
                        return AppointmentCard(
                          appointment: appointmentsCont.appointments[index],
                          onCheckIn: () {
                            if (appointmentsCont.appointments[index].status ==
                                StatusConst.check_in) {
                              Get.to(
                                () => EncountersDashboardScreen(
                                    encounterDetail: encounterDetail),
                                arguments: appointmentsCont
                                    .appointments[index].encounterId,
                              )?.then((value) {
                                if (value == true) {
                                  appointmentsCont.getAppointmentList();
                                }
                              });
                            } else {
                              appointmentsCont.updateStatus(
                                  id: appointmentsCont.appointments[index].id,
                                  status: getUpdateStatusText(
                                      status: appointmentsCont
                                          .appointments[index].status),
                                  context: context,
                                  isBack: false,
                                  isCheckOut: false);
                            }
                          },
                          onEncounter: () {
                            Get.to(
                              () => EncountersDashboardScreen(
                                  encounterDetail: encounterDetail),
                              arguments: appointmentsCont
                                  .appointments[index].encounterId,
                            )?.then((value) {
                              if (value == true) {
                                appointmentsCont.getAppointmentList();
                              }
                            });
                          },
                        ).paddingBottom(16);
                      },
                      onNextPage: () async {
                        if (!appointmentsCont.isLastPage.value) {
                          appointmentsCont
                              .page(appointmentsCont.page.value + 1);
                          appointmentsCont.getAppointmentList();
                        }
                      },
                      onSwipeRefresh: () async {
                        appointmentsCont.page(1);
                        return appointmentsCont.getAppointmentList(
                            showloader: false);
                      },
                    ).expand(),
                  ],
                ),
              ).paddingSymmetric(horizontal: 16);
            },
          ).makeRefreshable,
        ),
      ),
    );
  }
}
