import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/price_widget.dart';
import '../model/save_booking_res.dart';

class BookingSuccessScreen extends StatelessWidget {
  BookingSuccessScreen({super.key});

  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideAppBar: true,
      isLoading: isLoading,
      body: Container(
        height: Get.height * 0.7,
        decoration: boxDecorationDefault(color: context.cardColor),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 50, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    decoration: boxDecorationDefault(color: appColorPrimary, shape: BoxShape.circle),
                    child: Image.asset(Assets.imagesConfirm, scale: 1),
                  ),
                  24.height,
                  Text(locale.value.great, style: boldTextStyle(color: appColorSecondary), textAlign: TextAlign.center),
                  16.height,
                  Text(locale.value.bookingSuccessful, style: primaryTextStyle(size: 18)),
                  8.height,
                  Text(locale.value.yourAppointmentHasBeenBookedSuccessfully, textAlign: TextAlign.center, style: secondaryTextStyle()),
                  32.height,
                  Wrap(
                    runSpacing: 8,
                    spacing: 4,
                    children: List.generate(Get.width ~/ 14, (index) => Container(width: 8, height: 2, decoration: boxDecorationDefault(color: context.dividerColor.withValues(alpha: 0.3)))),
                  ),
                  32.height,
                  Text(
                    "To ${saveBookingRes.value.saveBookingResData.clinicName} On ${saveBookingRes.value.saveBookingResData.appointmentDate.dateInDMMMMyyyyFormat} At ${saveBookingRes.value.saveBookingResData.appointmentTime.format24HourtoAMPM} ${saveBookingRes.value.saveBookingResData.endTime.isNotEmpty ? "-" : ""} ${saveBookingRes.value.saveBookingResData.endTime.isNotEmpty ? saveBookingRes.value.saveBookingResData.endTime.format24HourtoAMPM : ""}",
                    textAlign: TextAlign.center,
                    style: secondaryTextStyle(),
                  ).paddingSymmetric(horizontal: 16),
                  32.height,
                  Text(locale.value.totalPayment, textAlign: TextAlign.center, style: boldTextStyle(color: secondaryTextColor)),
                  16.height,
                  PriceWidget(
                    price: saveBookingRes.value.saveBookingResData.totalAmount,
                    color: appColorPrimary,
                    size: 20,
                  ),
                ],
              ),
            ).paddingBottom(80),
            Positioned(
              bottom: 22,
              left: 16,
              right: 16,
              child: AppButton(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                text: locale.value.goToAppointments,
                color: appColorSecondary,
                textStyle: appButtonTextStyleWhite,
                onTap: () {
                  /// To Clear Value
                  saveBookingRes(SaveBookingRes(saveBookingResData: SaveBookingResData()));
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ).paddingSymmetric(horizontal: 16).center(),
    );
  }
}
