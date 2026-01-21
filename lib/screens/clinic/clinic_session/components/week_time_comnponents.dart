import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/add_clinic_form/model/clinic_session_response.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';

import '../../../../components/app_time_dropdown_widget.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/constants.dart';
import '../../../doctor/doctor_session/add_session/components/time_picker_components.dart';
import '../clinic_session_controller.dart';
import 'edit_break_component.dart';

class WeekTimeComponent extends StatelessWidget {
  final ClinicSessionModel weekData;

  WeekTimeComponent({super.key, required this.weekData});

  final ClinicSessionController clinicSessionController = Get.put(ClinicSessionController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        16.height,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTimeDropDownWidget(
              value: timeFormate(time: weekData.startTime),
              hintText: locale.value.selectTime,
              bgColor: isDarkMode.value ? lightCanvasColor : appScreenBackground,
              listWidget: TimePickerComponent(
                time: timeFormate(time: weekData.startTime),
                onTap: (date) {
                  if (DateFormat("hh:mm a").parse(timeFormate(time: weekData.endTime)).isBefore(date)) {
                    toast(locale.value.startDateMustBeBeforeEndDate);
                  } else {
                    weekData.startTime = DateFormat("HH:mm:ss").format(date);
                    clinicSessionController.clinicSessionList.refresh();
                    Get.back();
                  }
                },
              ),
            ).expand(),
            16.width,
            Text(
              "-",
              style: boldTextStyle(size: 20),
            ),
            16.width,
            AppTimeDropDownWidget(
              value: timeFormate(time: weekData.endTime),
              hintText: locale.value.selectTime,
              bgColor: isDarkMode.value ? lightCanvasColor : appScreenBackground,
              listWidget: TimePickerComponent(
                time: timeFormate(time: weekData.endTime),
                onTap: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)
                    ? null
                    : (date) {
                        if (DateFormat("hh:mm a").parse(timeFormate(time: weekData.startTime)).isAfter(date)) {
                          toast(locale.value.endDateMustBeAfterStartDate);
                        } else {
                          weekData.endTime = DateFormat("HH:mm:ss").format(date);
                          clinicSessionController.clinicSessionList.refresh();
                          Get.back();
                        }
                      },
              ),
            ).expand(),
          ],
        ),
        if (weekData.breaks.isEmpty) 0.height else 24.height,
        AnimatedListView(
          shrinkWrap: true,
          itemCount: weekData.breaks.length,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          listAnimationType: ListAnimationType.None,
          itemBuilder: (ctx, index) {
            final BreakListModel breakReport = weekData.breaks[index];
            if (breakReport.breakStartTime == "" || breakReport.breakEndTime == "") {
              return const Offstage();
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${locale.value.lblBreak}: ${timeFormate(time: breakReport.breakStartTime)} - ${timeFormate(time: breakReport.breakEndTime)}",
                  style: primaryTextStyle(size: 12, color: textSecondaryColor),
                ).expand(),
                InkWell(
                  onTap: () {
                    clinicSessionController.breStartTime(breakReport.breakStartTime);
                    clinicSessionController.breEndTime(breakReport.breakEndTime);
                    Get.bottomSheet(
                      EditBreakComponent(
                        index: index,
                        isAdd: false,
                        weekListModel: weekData,
                      ),
                    );
                  },
                  child: Text(locale.value.editBreak, style: boldTextStyle(size: 12, color: appColorSecondary)),
                ),
              ],
            ).paddingBottom(6);
          },
        ),
      ],
    );
  }
}
