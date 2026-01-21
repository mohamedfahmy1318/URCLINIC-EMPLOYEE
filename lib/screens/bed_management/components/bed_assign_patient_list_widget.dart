import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_assign_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/add_encounter/model/patient_model.dart'; 
import '../../../../components/cached_image_widget.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/colors.dart';

class BedAssignPatientListWidget extends StatelessWidget {
  final List<PatientModel> patientList;

  BedAssignPatientListWidget({super.key, required this.patientList});
  final BedAssignController controller = Get.find<BedAssignController>();

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      shrinkWrap: true,
      itemCount: patientList.length,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      listAnimationType: ListAnimationType.Slide,
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () {
            hideKeyboard(context);
            // controller.selectedPatient.value = patientList[index];
            controller.patientController.text = patientList[index].fullName.validate();
            Get.back(); 
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: boxDecorationDefault(
              borderRadius: BorderRadius.circular(6),
              color: isDarkMode.value ? appScreenBackgroundDark : appScreenBackground,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedImageWidget(
                  url: patientList[index].profileImage,
                  width: 40,
                  radius: 6,
                  fit: BoxFit.cover,
                  height: 40,
                ),
                12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    2.height,
                    Text(patientList[index].fullName.toString(), style: boldTextStyle(size: 16, color: isDarkMode.value ? null : darkGrayTextColor)),
                    2.height,
                    Text(
                      patientList[index].email,
                      style: secondaryTextStyle(
                        size: 12,
                        color: dividerColor,
                      ),
                    ),
                  ],
                ).expand()
              ],
            ),
          ),
        );
      },
    );
  }
}