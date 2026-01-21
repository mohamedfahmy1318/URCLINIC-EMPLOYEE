import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/appointment/model/appointments_res_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screens/appointment/appointment_detail.dart';
import '../screens/appointment/appointments_controller.dart';

class BookingCancelledDialog extends StatefulWidget {
  final AppointmentData status;
  final String? currentStatus;

  const BookingCancelledDialog({super.key, required this.status, this.currentStatus});

  @override
  State<BookingCancelledDialog> createState() => _BookingCancelledDialogState();
}

class _BookingCancelledDialogState extends State<BookingCancelledDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: Get.width,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      16.height,
                      Image.asset(Assets.iconsIcCheck, height: 62),
                      32.height,
                      Text(locale.value.yourAppointmentHasBeenSuccessfullyCancelled, style: boldTextStyle(size: 16)),
                      8.height,
                      Text(locale.value.appointmentRefundWillBeProcessedWithingHoursIfApplicable, textAlign: TextAlign.center, style: primaryTextStyle(size: 12, color: textSecondaryColor)),
                      32.height,
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: boxDecorationDefault(
                          color: appColorSecondary.withValues(alpha: 0.1),
                          border: Border.all(color: appColorSecondary),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          locale.value.noteCheckYourAppointmentHistoryForRefundDetailsIfApplicable,
                          style: boldTextStyle(color: appColorSecondary, size: 12),
                        ),
                      ),
                      24.height,
                      Row(
                        children: [
                          AppButton(
                            shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                            color: appColorPrimary,
                            height: 40,
                            text: locale.value.goToHistory,
                            textStyle: boldTextStyle(color: Colors.white, weight: FontWeight.w600, size: 12),
                            width: Get.width - context.navigationBarHeight,
                            onTap: () {
                              Get.to(() => AppointmentDetail(), arguments: widget.status)?.then((value) {
                                if (value == true) {
                                  final AppointmentsController appointmentsCont = Get.put(AppointmentsController());
                                  appointmentsCont.page(1);
                                  appointmentsCont.getAppointmentList();
                                }
                              });
                            },
                          ).expand(),
                          16.width,
                          AppButton(
                            shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                            color: appColorSecondary,
                            height: 40,
                            text: locale.value.ok,
                            textStyle: boldTextStyle(color: Colors.white, weight: FontWeight.w600, size: 12),
                            width: Get.width - context.navigationBarHeight,
                            onTap: () {
                              finish(context, true);
                            },
                          ).expand(),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      8.height,
                    ],
                  ).paddingAll(16),
                ],
              ),
            ),
          ),
        ),
        // Obx(
        //         () => LoaderWidget().withSize(height: 80, width: 80)//.visible(appStore.isLoading),
        // )
      ],
    );
  }
}
