import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/components/doctor_name_component.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../../../components/app_scaffold.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constants.dart';
import 'add_session_controller.dart';
import 'components/weekly_time_session_component.dart';

class AddSessionScreen extends StatelessWidget {
  AddSessionScreen({super.key});
  final AddSessionController addSessionCont = Get.put(AddSessionController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.doctorSession,
      scaffoldBackgroundColor: context.scaffoldBackgroundColor,
      appBarVerticalSize: Get.height * 0.12,
      isLoading: addSessionCont.isLoading,
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) || loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)) ...[
                Text(
                  "*${locale.value.selectDoctor}",
                  style: boldTextStyle(
                    size: 14,
                    color: appColorSecondary,
                    weight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ).paddingOnly(left: 16, right: 8, top: 16, bottom: 16),
                DoctorNameComponent().paddingSymmetric(horizontal: 16),
              ],
              if ((addSessionCont.selectClinicName.value.id > 0 && addSessionCont.selectDoctorData.value.doctorId > 0).obs.value) WeeklyTimeSessionComponent().paddingTop(16).paddingBottom(52),
            ],
          ),
        ),
      ),
      widgetsStackedOverBody: [
        Obx(
          () => addSessionCont.doctorSessionList.isNotEmpty
              ? Positioned(
                  bottom: 16,
                  height: 50,
                  width: Get.width,
                  child: AppButton(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: Get.width,
                    text: locale.value.save,
                    color: appColorSecondary,
                    textStyle: appButtonTextStyleWhite,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                    onTap: () {
                      if (addSessionCont.isLoading.value) {
                      } else if (addSessionCont.selectDoctorData.value.doctorId.isNegative) {
                        toast(locale.value.pleaseSelectDoctor);
                      } else if (addSessionCont.selectClinicName.value.id.isNegative) {
                        toast(locale.value.pleaseSelectClinic);
                      } else {
                        addSessionCont.saveSession();
                      }
                    },
                  ),
                )
              : const Offstage(),
        ),
      ],
    );
  }
}
