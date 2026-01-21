// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/components/time_picker_components.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../../../components/app_time_dropdown_widget.dart';
import '../../../../../components/cached_image_widget.dart';
import '../../../../../generated/assets.dart';
import '../../../../../utils/app_common.dart';
import '../../../../clinic/add_clinic_form/model/clinic_session_response.dart';
import '../add_session_controller.dart';

class AddBreakComponent extends StatelessWidget {
  final int index;
  final ClinicSessionModel weekListModel;
  bool isAdd = true;
  AddBreakComponent({super.key, required this.index, required this.weekListModel, required this.isAdd});

  AddSessionController addSessionCont = Get.put(AddSessionController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isAdd ? locale.value.addBreak : locale.value.editBreak, style: boldTextStyle()).expand(),
                if (!isAdd)
                  InkWell(
                    onTap: () {
                      weekListModel.breaks.removeAt(index);
                      addSessionCont.doctorSessionList.refresh();
                      Get.back();
                    },
                    child: const CachedImageWidget(
                      url: Assets.iconsIcDelete,
                      height: 16,
                      width: 16,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
            16.height,
            Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTimeDropDownWidget(
                    value: timeFormate(time: addSessionCont.breStartTime.value),
                    hintText: locale.value.selectTime,
                    bgColor: isDarkMode.value ? lightCanvasColor : white,
                    listWidget: TimePickerComponent(
                      time: timeFormate(time: addSessionCont.breStartTime.value),
                      onTap: (DateTime value) {
                        if (DateFormat("hh:mm a").parse(timeFormate(time: addSessionCont.breEndTime.value)).isBefore(value)) {
                          toast(locale.value.startDateMustBeBeforeEndDate);
                        } else {
                          addSessionCont.breStartTime.value = DateFormat("HH:mm:ss").format(value);
                          addSessionCont.breStartTime.refresh();
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
                    value: timeFormate(time: addSessionCont.breEndTime.value),
                    hintText: locale.value.selectTime,
                    bgColor: isDarkMode.value ? lightCanvasColor : white,
                    listWidget: TimePickerComponent(
                      time: timeFormate(time: addSessionCont.breEndTime.value),
                      onTap: (DateTime value) {
                        if (DateFormat("hh:mm a").parse(timeFormate(time: addSessionCont.breStartTime.value)).isAfter(value)) {
                          toast(locale.value.endDateMustBeAfterStartDate);
                        } else {
                          addSessionCont.breEndTime.value = DateFormat("HH:mm:ss").format(value);
                          addSessionCont.breEndTime.refresh();
                          Get.back();
                        }
                      },
                    ),
                  ).expand(),
                ],
              ),
            ),
            32.height,
            AppButton(
              width: Get.width,
              text: locale.value.save,
              color: appColorSecondary,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
              onTap: () {
                if (isAdd) {
                  if (checkValidation()
                      // && addSessionCont.isBreakValid(weekStartTime: weekListModel.startTime, weekEndTime: weekListModel.endTime, breaks: weekListModel.breaks, breakEnd: addSessionCont.breEndTime.value, breakStart: addSessionCont.breStartTime.value)
                      ) {
                    addSessionCont.doctorSessionList[index].breaks.add(BreakListModel(breakStartTime: addSessionCont.breStartTime.value, breakEndTime: addSessionCont.breEndTime.value));
                    getSessionRefresh();
                  } else {
                    getToast();
                  }
                } else {
                  if (weekListModel.breaks[index].breakStartTime == addSessionCont.breStartTime.value && weekListModel.breaks[index].breakEndTime == addSessionCont.breEndTime.value) {
                    weekListModel.breaks[index].breakStartTime = addSessionCont.breStartTime.value;
                    weekListModel.breaks[index].breakEndTime = addSessionCont.breEndTime.value;
                    getSessionRefresh();
                  } else {
                    if (checkValidation()
                        //  && addSessionCont.isBreakValid(weekStartTime: weekListModel.startTime, weekEndTime: weekListModel.endTime, breaks: weekListModel.breaks, breakEnd: addSessionCont.breEndTime.value, breakStart: addSessionCont.breStartTime.value)
                        ) {
                      weekListModel.breaks[index].breakStartTime = addSessionCont.breStartTime.value;
                      weekListModel.breaks[index].breakEndTime = addSessionCont.breEndTime.value;
                      getSessionRefresh();
                    } else {
                      getToast();
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void getSessionRefresh() {
    addSessionCont.breStartTime.refresh();
    addSessionCont.breEndTime.refresh();
    addSessionCont.doctorSessionList.refresh();
    Get.back();
  }

  void getToast() {
    toast(locale.value.breakTimeIsOutsideShiftTime);
  }

  bool checkValidation() {
    return checkBreakValidationWithShift(breakStartTime: addSessionCont.breStartTime.value, breakEndTime: addSessionCont.breEndTime.value, shiftStartTime: weekListModel.startTime, shiftEndTime: weekListModel.endTime);
  }
}
