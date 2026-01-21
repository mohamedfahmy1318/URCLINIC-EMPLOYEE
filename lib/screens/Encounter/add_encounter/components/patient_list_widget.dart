import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/add_encounter/model/patient_model.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/colors.dart';
import '../add_encounter_controller.dart';

class PatientListWidget extends StatelessWidget {
  final List<PatientModel> patientList;

  PatientListWidget({super.key, required this.patientList});

  final AddEncountersController addEncountersCont = Get.put(AddEncountersController());

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      shrinkWrap: true,
      itemCount: patientList.length,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () {
            hideKeyboard(context);
            addEncountersCont.selectPatient(patientList[index]);
            addEncountersCont.patientCont.text = patientList[index].fullName;
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    2.height,
                    Text(patientList[index].fullName, style: boldTextStyle(size: 16, color: isDarkMode.value ? null : darkGrayTextColor)),
                    2.height,
                    Text(
                      patientList[index].email,
                      style: secondaryTextStyle(
                        size: 12,
                        color: dividerColor,
                      ),
                    ),
                  ],
                ).expand(),
              ],
            ),
          ),
        );
      },
    );
  }
}
