import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/components/cancellations_booking_charge_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_base.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../../../utils/price_widget.dart';
import '../../home/home_controller.dart';
import '../appointment_detail.dart';
import '../appointments_controller.dart';
import '../model/appointments_res_model.dart';

class AppointmentCard extends StatelessWidget {
  final Function? onCheckIn;
  final Function? onEncounter;
  final AppointmentData appointment;

  AppointmentCard({
    super.key,
    required this.appointment,
    this.onCheckIn,
    this.onEncounter,
  });

  final AppointmentsController appointmentsCont =
      Get.put(AppointmentsController());

  bool get isDoctor =>
      loginUserData.value.userRole.contains(EmployeeKeyConst.doctor);

  bool get showBtns {
    // Doctor can only access Encounter screen (when status is check_in), no Confirm/Cancel/Check-In
    if (isDoctor) {
      return appointment.status == StatusConst.check_in;
    }
    return (appointment.status != StatusConst.checkout &&
            appointment.status != StatusConst.completed &&
            appointment.status != StatusConst.cancelled) ||
        (appointment.isEnableAdvancePayment &&
            appointment.paymentStatus == PaymentStatus.ADVANCE_PAID);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        Get.to(() => AppointmentDetail(), arguments: appointment)
            ?.then((value) {
          if (value == true) {
            final AppointmentsController appointmentsCont =
                Get.put(AppointmentsController());
            appointmentsCont.page(1);
            appointmentsCont.getAppointmentList();
          }
        });
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: boxDecorationDefault(
                color: context.cardColor, shape: BoxShape.rectangle),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${locale.value.appointment} #${appointment.id}',
                    style: boldTextStyle(size: 14, color: appColorPrimary),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                8.height,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: boxDecorationDefault(
                      color: isDarkMode.value
                          ? Colors.grey.withValues(alpha: 0.1)
                          : lightSecondaryColor,
                      borderRadius: radius(22),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          appointment.appointmentDate.dateInDMMMMyyyyFormat,
                          style:
                              boldTextStyle(size: 12, color: appColorSecondary),
                        ),
                        6.width,
                        Text(
                          "|",
                          style:
                              boldTextStyle(size: 12, color: appColorSecondary),
                        ),
                        6.width,
                        Text(
                          '${appointment.appointmentTime.format24HourtoAMPM} - ${appointment.endTime.format24HourtoAMPM}',
                          style:
                              boldTextStyle(size: 12, color: appColorSecondary),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ).flexible(),
                      ],
                    ),
                  ),
                ),
                12.height,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.serviceName,
                        style: boldTextStyle(size: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        appointment.clinicName,
                        style: primaryTextStyle(
                            size: 14, color: secondaryTextColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ).paddingTop(8),
                    ],
                  ),
                ),
                16.height,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isOnlineService
                                ? locale.value.online
                                : locale.value.inClinic,
                            style: secondaryTextStyle(
                                size: 12, color: secondaryTextColor),
                          ),
                          6.height,
                          Row(
                            children: [
                              Text(
                                '${locale.value.patient}:',
                                style: primaryTextStyle(
                                    size: 12, color: secondaryTextColor),
                              ),
                              6.width,
                              Text(
                                appointment.userName,
                                overflow: TextOverflow.ellipsis,
                                style: boldTextStyle(size: 12),
                              ).expand(),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${locale.value.doctor}:',
                                style: primaryTextStyle(
                                    size: 12, color: secondaryTextColor),
                              ),
                              6.width,
                              Text(
                                appointment.doctorName,
                                overflow: TextOverflow.ellipsis,
                                style: boldTextStyle(size: 12),
                              ).expand(),
                            ],
                          ).paddingTop(6).visible(!loginUserData.value.userRole
                              .contains(EmployeeKeyConst.doctor)),
                        ],
                      ).expand(),
                      PriceWidget(
                        price: getAppointmentDisplayAmount(),
                        color: appColorPrimary,
                        size: 18,
                        isExtraBoldText: true,
                      ),
                    ],
                  ),
                ),
                24.height,
                commonDivider,
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            color: secondaryTextColor, size: 12),
                        4.width,
                        Text("${locale.value.appointment}:",
                            style: secondaryTextStyle()),
                        4.width,
                        Text(
                          getBookingStatus(status: appointment.status),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: primaryTextStyle(
                              size: 12,
                              color: getBookingStatusColor(
                                  status: appointment.status)),
                        ).expand(),
                      ],
                    ).flexible(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const CachedImageWidget(
                            url: Assets.iconsIcTotalPayout, height: 14),
                        4.width,
                        Text("${locale.value.payment}:",
                                style: secondaryTextStyle())
                            .flexible(),
                        4.width,
                        Text(
                          getBookingPaymentStatus(
                              status: appointment.paymentStatus),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.end,
                          style: primaryTextStyle(
                              size: 12,
                              color: getNewPriceStatusColor(
                                  paymentStatus: appointment.paymentStatus)),
                        ).flexible(),
                      ],
                    ).flexible(),
                  ],
                ),
                if (appointment.bookForName.isNotEmpty) ...[
                  16.height,
                  commonDivider,
                  16.height,
                  Row(
                    children: [
                      Text(
                        "${locale.value.bookedForWithColon} ",
                        style: secondaryTextStyle(size: 14), // Text style
                      ),
                      10.width,
                      TextIcon(
                        edgeInsets: EdgeInsets.zero,
                        prefix: CachedImageWidget(
                          url: appointment.booForImage,
                          height: 25,
                          width: 25,
                          fit: BoxFit.cover,
                          circle: true,
                        ),
                        text: appointment.bookForName,
                        expandedText: true,
                        useMarquee: true,
                        textStyle: boldTextStyle(),
                      ).expand(flex: 2),
                    ],
                  ),
                ],
                Row(
                  children: [
                    if (appointment.status != StatusConst.check_in)
                      AppButton(
                        width: Get.width,
                        height: 48,
                        padding: EdgeInsets.zero,
                        color: isDarkMode.value
                            ? Colors.grey.withValues(alpha: 0.1)
                            : extraLightPrimaryColor,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: radius(defaultAppButtonRadius / 2)),
                        onTap: () {
                          Get.bottomSheet(
                            isScrollControlled: true,
                            Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: CancellationsBookingChargeDialog(
                                appointmentData: appointment,
                                isDurationMode: checkTimeDifference(
                                    inputDateTime: DateTime.parse(appointment
                                        .appointmentDate
                                        .validate())),
                                loaderOnOFF: (p0) {
                                  appointmentsCont.isLoading(p0);
                                },
                                onBookingCancelled: () {
                                  appointmentsCont.page(1);
                                  appointmentsCont.getAppointmentList();
                                  final HomeController homeScreenController =
                                      Get.find();
                                  homeScreenController.getDashboardDetail();
                                },
                              ),
                            ),
                          );
                        },
                        text: locale.value.cancel,
                        textStyle: appButtonPrimaryColorText,
                      ).expand(),
                    8.width,
                    AppButton(
                      width: Get.width,
                      height: 48,
                      padding: EdgeInsets.zero,
                      color: isDarkMode.value
                          ? Colors.grey.withValues(alpha: 0.1)
                          : extraLightPrimaryColor,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: radius(defaultAppButtonRadius / 2)),
                      text: getUpdateStatusText(status: appointment.status),
                      textStyle: appButtonPrimaryColorText,
                      onTap: onCheckIn,
                    ).expand(),
                  ],
                ).paddingTop(24).visible(showBtns),
              ],
            ).paddingSymmetric(vertical: 16),
          ),
          Positioned(
            top: 16,
            right: 16,
            height: 40,
            width: 40,
            child: GestureDetector(
              onTap: () {
                if (canLaunchVideoCall(status: appointment.status)) {
                  if (isOnlineService) {
                    if (appointment.googleLink.isNotEmpty) {
                      commonLaunchUrl(appointment.googleLink,
                          launchMode: LaunchMode.externalApplication);
                    } else if (appointment.zoomLink.isNotEmpty) {
                      commonLaunchUrl(appointment.zoomLink,
                          launchMode: LaunchMode.externalApplication);
                    } else {
                      toast(locale.value.videoCallLinkIsNotFound);
                    }
                  } else {
                    toast(locale.value.thisIsNotAOnlineService);
                  }
                } else {
                  if (appointment.status
                      .toLowerCase()
                      .contains(StatusConst.pending)) {
                    toast(locale.value.oppsThisAppointmentIsNotConfirmedYet);
                  } else if (appointment.status
                          .toLowerCase()
                          .contains(StatusConst.cancel) ||
                      appointment.status
                          .toLowerCase()
                          .contains(StatusConst.cancelled)) {
                    toast(locale.value.oppsThisAppointmentHasBeenCancelled);
                  } else if (appointment.status
                      .toLowerCase()
                      .contains(StatusConst.completed)) {
                    toast(locale.value.oppsThisAppointmentHasBeenCompleted);
                  }
                }
              },
              child: Container(
                decoration: boxDecorationDefault(
                    shape: BoxShape.circle, color: appColorPrimary),
                padding: const EdgeInsets.all(10),
                child: const CachedImageWidget(
                  url: Assets.imagesVideoCamera,
                  height: 22,
                  width: 22,
                  circle: true,
                  color: white,
                ),
              ),
            ).visible(appointment.isVideoConsultancy &&
                (appointment.zoomLink.isNotEmpty ||
                    appointment.googleLink.isNotEmpty)),
          ),
        ],
      ),
    );
  }

  bool get isOnlineService =>
      appointment.serviceType.toLowerCase() == ServiceTypes.online;

  /// Returns the appropriate amount to display based on payment status
  num getAppointmentDisplayAmount() {
    // Always show full price (total amount) if available
    if (appointment.totalAmount > 0) {
      return appointment.totalAmount;
    }

    // Fallbacks when total amount is not available
    if (appointment.serviceAmount > 0) {
      return appointment.serviceAmount;
    }

    return appointment.servicePrice;
  }
}
