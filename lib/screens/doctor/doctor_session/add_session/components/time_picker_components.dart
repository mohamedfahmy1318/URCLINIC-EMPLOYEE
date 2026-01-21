// ignore_for_file: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/components/custom_time_picker.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';

import '../../../../../main.dart';

class TimePickerComponent extends StatelessWidget {
  String time;
  Function(DateTime value)? onTap;

  TimePickerComponent({super.key, required this.time, required this.onTap});

  Rx<DateTime> dateTime = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locale.value.selectTime,
            style: boldTextStyle(
              size: 16,
            ),
          ).paddingBottom(10),
          TimePickerSpinner(
            time: DateFormat("hh:mm a").parse(time),
            isForce2Digits: true,
            is24HourMode: false,
            itemWidth: 100,
            normalTextStyle: secondaryTextStyle(
              size: 20,
            ),
            highlightedTextStyle: boldTextStyle(
              size: 20,
              color: appColorPrimary,
            ),
            onTimeChange: (time) {
              dateTime(time);
            },
          ).expand(),
          16.height,
          AppButton(
            height: 50,
            width: Get.width,
            disabledColor: appColorSecondary,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: radius(6),
            ),
            color: appColorSecondary,
            onTap: () {
              onTap!(dateTime.value);
            },
            child: Text(
              locale.value.save,
              style: boldTextStyle(size: 14, color: white),
            ),
          ),
        ],
      ),
    );
  }
}
