// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/add_clinic_form/model/clinic_session_response.dart';
import 'package:kivicare_clinic_admin/screens/clinic/clinic_session/clinic_session_controller.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/components/time_picker_components.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../../components/app_time_dropdown_widget.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';

class EditBreakComponent extends StatelessWidget {
  final int index;
  final ClinicSessionModel weekListModel;
  bool isAdd = true;
  EditBreakComponent({super.key, required this.index, required this.weekListModel, required this.isAdd});

  ClinicSessionController editClinicBreakCont = Get.put(ClinicSessionController());

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
                      editClinicBreakCont.clinicSessionList.refresh();
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
                    value: timeFormate(time: editClinicBreakCont.breStartTime.value),
                    hintText: locale.value.selectTime,
                    bgColor: isDarkMode.value ? lightCanvasColor : white,
                    listWidget: TimePickerComponent(
                      time: timeFormate(time: editClinicBreakCont.breStartTime.value),
                      onTap: (DateTime value) {
                        if (DateFormat("hh:mm a").parse(timeFormate(time: editClinicBreakCont.breEndTime.value)).isBefore(value)) {
                          toast(locale.value.startDateMustBeBeforeEndDate);
                        } else {
                          editClinicBreakCont.breStartTime.value = DateFormat("HH:mm:ss").format(value);
                          editClinicBreakCont.breStartTime.refresh();
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
                    value: timeFormate(time: editClinicBreakCont.breEndTime.value),
                    hintText: locale.value.selectTime,
                    bgColor: isDarkMode.value ? lightCanvasColor : white,
                    listWidget: TimePickerComponent(
                      time: timeFormate(time: editClinicBreakCont.breEndTime.value),
                      onTap: (DateTime value) {
                        if (DateFormat("hh:mm a").parse(timeFormate(time: editClinicBreakCont.breStartTime.value)).isAfter(value)) {
                          toast(locale.value.endDateMustBeAfterStartDate);
                        } else {
                          editClinicBreakCont.breEndTime.value = DateFormat("HH:mm:ss").format(value);
                          editClinicBreakCont.breEndTime.refresh();
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
                if (checkValidation()) {
                  if (isAdd) {
                    editClinicBreakCont.clinicSessionList[index].breaks.add(BreakListModel(breakStartTime: editClinicBreakCont.breStartTime.value, breakEndTime: editClinicBreakCont.breEndTime.value));
                  } else {
                    weekListModel.breaks[index].breakStartTime = editClinicBreakCont.breStartTime.value;
                    weekListModel.breaks[index].breakEndTime = editClinicBreakCont.breEndTime.value;
                  }
                  editClinicBreakCont.breStartTime.refresh();
                  editClinicBreakCont.breEndTime.refresh();
                  editClinicBreakCont.clinicSessionList.refresh();
                  Get.back();
                } else {
                  toast(locale.value.breakTimeIsOutsideShiftTime);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool checkValidation() {
    return checkBreakValidationWithShift(breakStartTime: editClinicBreakCont.breStartTime.value, breakEndTime: editClinicBreakCont.breEndTime.value, shiftStartTime: weekListModel.startTime, shiftEndTime: weekListModel.endTime);
  }
}
