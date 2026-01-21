import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/add_session_controller.dart';
import '../../../../../main.dart';
import '../../../../../utils/colors.dart';
import '../select_clinic/select_clinic_screen.dart';
import '../select_doctor/select_doctor_controller.dart';

class ClinicNameComponent extends StatelessWidget {
  ClinicNameComponent({super.key});

  final AddSessionController clinicController = Get.put(AddSessionController());
  final SelectDoctorController selDocController = Get.put(SelectDoctorController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selDocController.getClinics(doctorId: clinicController.selectDoctorData.value.doctorId);
        Get.to(() => SelectClinicScreen(selectClinics: clinicController.selectClinicName.value));
      },
      child: Obx(
        () => Container(
          height: 48.0,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: boxDecorationDefault(
            color: white,
            borderRadius: BorderRadius.all(radiusCircular(6)),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                clinicController.selectClinicName.value.name.isEmpty ? locale.value.clinicName : clinicController.selectClinicName.value.name,
                style: secondaryTextStyle(
                  size: 12,
                  color: blackColor,
                ),
              ),
              if (clinicController.selectClinicName.value.name.isEmpty)
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
    ).paddingBottom(16);
  }
}
