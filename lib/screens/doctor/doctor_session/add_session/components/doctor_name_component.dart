import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/add_session_controller.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/select_doctor/select_doctor_screen.dart';
import '../../../../../main.dart';
import '../../../../../utils/colors.dart';
import '../select_doctor/select_doctor_controller.dart';

class DoctorNameComponent extends StatelessWidget {
  DoctorNameComponent({super.key});

  final AddSessionController doctorController = Get.put(AddSessionController());
  final SelectDoctorController selDocController = Get.put(SelectDoctorController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selDocController.getDoctorList();
        Get.to(() => SelectDoctorScreen(selectDoctorName: doctorController.selectDoctorData.value));
      },
      child: Obx(
        () => Container(
          height: 48.0,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: boxDecorationDefault(
            color: context.cardColor,
            borderRadius: BorderRadius.all(radiusCircular(6)),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                doctorController.selectDoctorData.value.fullName.isEmpty ? locale.value.doctorName : doctorController.selectDoctorData.value.fullName,
                style: secondaryTextStyle(
                  size: 12,
                  color: isDarkMode.value ? null : blackColor,
                ),
              ),
              if (doctorController.selectDoctorData.value.fullName.isEmpty)
                Text(
                  "*",
                  style: secondaryTextStyle(
                    size: 12,
                    color: redTextColor,
                  ),
                ).expand(),
              const Icon(
                Icons.keyboard_arrow_down_outlined,
                size: 16,
                color: appBodyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
