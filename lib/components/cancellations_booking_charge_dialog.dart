import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/components/booking_cancelled_dialog.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/appointment/model/appointments_res_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';

class CancellationsBookingChargeDialog extends StatelessWidget {
  final AppointmentData appointmentData;
  final bool isDurationMode;

  final Function(bool) loaderOnOFF;

  final VoidCallback onBookingCancelled;

  CancellationsBookingChargeDialog({
    super.key,
    required this.appointmentData,
    required this.isDurationMode,
    required this.loaderOnOFF,
    required this.onBookingCancelled,
  });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController textFieldReason = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: Container(
                decoration: boxDecorationDefault(
                  color: context.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    16.height,
                    Image.asset(Assets.iconsIcCheck),
                    32.height,
                    Text(locale.value.cancelAppointment, style: boldTextStyle()),
                    8.height,
                    Text(
                      locale.value.cancellationFeesWillBeAppliedIfYouCancelWithinHoursOfScheduledTime(appConfigs.value.cancellationChargeHours.toString(), appConfigs.value.isCancellationChargeEnabled),
                      textAlign: TextAlign.center,
                      style: primaryTextStyle(size: 12),
                    ),
                    32.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: locale.value.reason,
                                style: boldTextStyle(size: 16, weight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: "*",
                                style: boldTextStyle(color: redColor, size: 12, weight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        8.height,
                        Form(
                          key: formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: AppTextField(
                            controller: textFieldReason,
                            textFieldType: TextFieldType.MULTILINE,
                            minLines: 1,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: locale.value.hintReason,
                              fillColor: context.cardColor,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    24.height,
                    Row(
                      children: [
                        AppButton(
                          color: context.cardColor,
                          height: 40,
                          text: locale.value.goBack,
                          textStyle: boldTextStyle(weight: FontWeight.w600, size: 12),
                          width: MediaQuery.of(context).size.width - context.navigationBarHeight,
                          onTap: () {
                            finish(context);
                          },
                        ).expand(),
                        12.width,
                        AppButton(
                          color: appColorPrimary,
                          height: 40,
                          text: locale.value.cancelAppointment,
                          textStyle: boldTextStyle(color: Colors.white, weight: FontWeight.w600, size: 12),
                          width: MediaQuery.of(context).size.width - context.navigationBarHeight,
                          onTap: () {
                            handleClick();
                          },
                        ).expand(),
                      ],
                    ),
                    8.height,
                  ],
                ).paddingAll(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> updateStatus({required int appointmentId, required String status}) async {
    loaderOnOFF.call(true);
    final Map<String, dynamic> req = {
      CancellationStatusKeys.status: appointmentData.status,
      BookingUpdateKeys.startAt: appointmentData.startDateTime,
      CancellationStatusKeys.reason: textFieldReason.text,
      CancellationStatusKeys.status: RequestStatus.CANCELLED,
      CancellationStatusKeys.advancePaidAmount: appointmentData.advancePaidAmount,
      BookingUpdateKeys.paymentStatus: appointmentData.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : appointmentData.paymentStatus.validate(),
    };

    await CoreServiceApis.updateStatus(request: req, appointmentId: appointmentId).then((value) async {
      handleBookingCancelledBottomSheet();
      onBookingCancelled.call();
    }).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(
      () {
        loaderOnOFF.call(false);
      },
    );
  }

  Future<void> handleBookingCancelledBottomSheet() async {
    Get.bottomSheet(
      backgroundColor: Get.context != null
          ? Get.context!.scaffoldBackgroundColor
          : isDarkMode.value
              ? scaffoldDarkColor
              : scaffoldLightColor,
      BookingCancelledDialog(status: appointmentData),
    );
  }

  Future<void> handleClick() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (appointmentData.status == RequestStatus.pending || appointmentData.status == RequestStatus.hold || appointmentData.status == RequestStatus.accept || appointmentData.status == StatusConst.confirmed) {
        Get.back();
        await updateStatus(
          appointmentId: appointmentData.id.validate(),
          status: appointmentData.status.validate(),
        );
      }
    }
  }
}
