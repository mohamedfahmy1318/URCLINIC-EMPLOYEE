import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/components/loader_widget.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/add_session_controller.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/components/add_break_component.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../../components/app_time_dropdown_widget.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_common.dart';
import '../../../../../utils/common_base.dart';
import '../../../../../utils/empty_error_state_widget.dart';
import '../../../../clinic/add_clinic_form/model/clinic_session_response.dart';
import 'break_list_component.dart';
import 'time_picker_components.dart';

class WeeklyTimeSessionComponent extends StatelessWidget {
  WeeklyTimeSessionComponent({super.key});

  final AddSessionController addSessionCont = Get.put(AddSessionController());

  @override
  Widget build(BuildContext context) {
    return SnapHelperWidget(
      future: addSessionCont.getDoctorsSessionFuture.value,
      loadingWidget: addSessionCont.isLoading.isTrue ? const Offstage() : const LoaderWidget(),
      errorBuilder: (error) {
        return NoDataWidget(
          title: error,
          retryText: locale.value.reload,
          imageWidget: const ErrorStateWidget(),
          onRetry: () {
            addSessionCont.getDoctorSessionList();
          },
        );
      },
      onSuccess: (res) {
        return Obx(
          () => AnimatedListView(
            shrinkWrap: true,
            itemCount: addSessionCont.doctorSessionList.length,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            physics: const NeverScrollableScrollPhysics(),
            emptyWidget: addSessionCont.isLoading.isTrue
                ? const Offstage()
                : NoDataWidget(
                    title: locale.value.noWeekListFound,
                    subTitle: locale.value.oppsNoWeekListFoundAtMomentTryAgainLater,
                    imageWidget: const EmptyStateWidget(),
                    onRetry: () async {
                      addSessionCont.getDoctorSessionList();
                    },
                  ).paddingTop(Get.height * 0.15).paddingSymmetric(horizontal: 16),
            itemBuilder: (ctx, index) {
              final ClinicSessionModel weekReport = addSessionCont.doctorSessionList[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weekReport.day.capitalizeFirst.toString(),
                        style: boldTextStyle(size: 16),
                      ).expand(),
                      GestureDetector(
                        onTap: () {
                          if (weekReport.isHoliday == 1) {
                            weekReport.isHoliday = 0;
                          } else {
                            weekReport.isHoliday = 1;
                          }
                          weekReport.breaks.clear();
                          addSessionCont.doctorSessionList.refresh();
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: weekReport.isHoliday == 1 ? appColorPrimary : white,
                                border: Border.all(
                                  color: weekReport.isHoliday == 1 ? appColorPrimary : borderColor,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.check,
                                size: 12,
                                color: white,
                              ),
                            ),
                            8.width,
                            Text(locale.value.addDayOff, style: primaryTextStyle(size: 14, color: dividerColor)),
                          ],
                        ),
                      ).visible(weekReport.isHoliday == 1),
                    ],
                  ).paddingBottom(8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTimeDropDownWidget(
                        value: timeFormate(time: weekReport.startTime),
                        hintText: locale.value.selectTime,
                        bgColor: isDarkMode.value ? lightCanvasColor : white,
                        listWidget: TimePickerComponent(
                          time: timeFormate(time: weekReport.startTime),
                          onTap: (date) {
                            if (DateFormat("hh:mm a").parse(timeFormate(time: weekReport.endTime)).isBefore(date)) {
                              toast(locale.value.startDateMustBeBeforeEndDate);
                            } else {
                              weekReport.startTime = DateFormat("HH:mm:ss").format(date);
                              addSessionCont.doctorSessionList.refresh();
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
                        value: timeFormate(time: weekReport.endTime),
                        hintText: locale.value.selectTime,
                        bgColor: isDarkMode.value ? lightCanvasColor : white,
                        listWidget: TimePickerComponent(
                          time: timeFormate(time: weekReport.endTime),
                          onTap: (date) {
                            if (DateFormat("hh:mm a").parse(timeFormate(time: weekReport.startTime)).isAfter(date)) {
                              toast(locale.value.endDateMustBeAfterStartDate);
                            } else {
                              weekReport.endTime = DateFormat("HH:mm:ss").format(date);
                              addSessionCont.doctorSessionList.refresh();
                              Get.back();
                            }
                          },
                        ),
                      ).expand(),
                    ],
                  ).visible(weekReport.isHoliday == 0),
                  14.height,
                  if (weekReport.breaks.isNotEmpty && weekReport.isHoliday == 0)
                    BreakListComponent(
                      weeksReport: weekReport,
                    ),
                  if (weekReport.breaks.isNotEmpty && weekReport.isHoliday == 0) 10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          addSessionCont.breStartTime("09:00:00");
                          addSessionCont.breEndTime("18:00:00");
                          Get.bottomSheet(
                            AddBreakComponent(
                              index: index,
                              isAdd: true,
                              weekListModel: weekReport,
                            ),
                          );
                        },
                        child: Text(
                          locale.value.addBreak,
                          style: boldTextStyle(
                            size: 14,
                            color: appColorSecondary,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ).visible(weekReport.isHoliday == 0),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          // weekReport.isHoliday = !weekReport.isHoliday;
                          if (weekReport.isHoliday == 1) {
                            weekReport.isHoliday = 0;
                          } else {
                            weekReport.isHoliday = 1;
                          }
                          weekReport.breaks.clear();
                          addSessionCont.doctorSessionList.refresh();
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: weekReport.isHoliday == 1 ? appColorPrimary : white,
                                border: Border.all(
                                  color: weekReport.isHoliday == 1 ? appColorPrimary : borderColor,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.check,
                                size: 12,
                                color: white,
                              ),
                            ),
                            8.width,
                            Text(locale.value.addDayOff, style: primaryTextStyle(size: 14, color: dividerColor)),
                          ],
                        ),
                      ).visible(weekReport.isHoliday == 0),
                    ],
                  ),
                ],
              ).paddingBottom(16);
            },
          ),
        );
      },
    );
  }
}
