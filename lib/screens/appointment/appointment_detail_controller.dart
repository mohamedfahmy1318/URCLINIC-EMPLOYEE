// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../api/core_apis.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../Encounter/encounter_dashboard/encounter_dashboard.dart';
import '../Encounter/model/encounters_list_model.dart';
import '../home/home_controller.dart';
import 'appointments_controller.dart';
import 'model/appointment_invoice_res.dart';
import 'model/appointments_res_model.dart';

class AppointmentDetailController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Future<AppointmentData>> getAppointmentDetails = Future(() => AppointmentData()).obs;
  Rx<AppointmentData> appintmentData = AppointmentData().obs;
  RxBool isUpdateLoading = false.obs;

  Rx<AppointmentInvoiceResp> appointmentInvoice = AppointmentInvoiceResp().obs;

  @override
  void onInit() {
    if (Get.arguments is AppointmentData) {
      appintmentData(Get.arguments);
    }
    init();
    super.onInit();
  }

  ///Get Appointment Detail
  Future<void> init({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getAppointmentDetails(
      CoreServiceApis.getAppointmentDetail(appointmentId: appintmentData.value.id, appointMentDet: appintmentData.value),
    ).then((value) {
      if (appintmentData.value.notificationId.trim().isNotEmpty && unreadNotificationCount.value > 0) {
        unreadNotificationCount(unreadNotificationCount.value - 1);
      }
      appintmentData(value);
    }) /* .catchError((e) {
      isLoading(false);
      log(e.toString());
    }) */
        .whenComplete(() => isLoading(false));
  }

  void updateStatus({required String status, required int id, required BuildContext context, required bool isClockOut, EncounterElement? encountDetails}) {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.doYouWantToPerformThisAction,
      positiveText: locale.value.yes,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        if (isClockOut) {
          Get.to(() => EncountersDashboardScreen(encounterDetail: encountDetails ?? EncounterElement()), arguments: id, preventDuplicates: false);
        } else {
          isUpdateLoading(true);
          CoreServiceApis.changeAppointmentStatus(
            id: id,
            request: {'status': postStatus(status: status)},
          ).then((value) {
            init();
            try {
              final AppointmentsController acont = Get.find();
              acont.getAppointmentList();
            } catch (e) {
              log('AppointmentDetail updateStatus acont = Get.find() E: $e');
            }
            try {
              final HomeController hcont = Get.find();
              hcont.getDashboardDetail();
            } catch (e) {
              log('AppointmentDetail updateStatus hcont = Get.find() E: $e');
            }
            toast(value.message.trim().isEmpty ? locale.value.statusHasBeenUpdated : value.message.trim());
          }).catchError((e) {
            toast(e.toString());
          }).whenComplete(() => isUpdateLoading(false));
        }
      },
    );
  }

  ///Appointment Invoice Download
  Future<void> getAppointmentInvoice({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await CoreServiceApis.appointmentInvoice(appintmentData.value.id).then((appointmentInvoices) {
      appointmentInvoice(appointmentInvoices.value);
      if (appointmentInvoice.value.status == true && appointmentInvoice.value.link.isNotEmpty) {
        viewFiles(appointmentInvoice.value.link);
      } else {
        toast(locale.value.somethingWentWrongPleaseTryAgainLater);
      }
    }).catchError((e) {
      isLoading(false);
      log("getAppointmentInvoiceDetail Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}
