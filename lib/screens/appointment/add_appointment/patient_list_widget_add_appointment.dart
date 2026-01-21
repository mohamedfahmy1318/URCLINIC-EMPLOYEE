import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/add_encounter/model/patient_model.dart';
import '../../../components/cached_image_widget.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import 'add_appointment_controller.dart';

class PatientListWidgetAddAppointment extends StatelessWidget {
  final List<PatientModel> patientList;
  PatientListWidgetAddAppointment({super.key, required this.patientList});

  final AddAppointmentController addAppointmentCont = Get.put(AddAppointmentController());

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
            addAppointmentCont.selectPatient(patientList[index]);
            addAppointmentCont.patientCont.text = addAppointmentCont.selectPatient.value.fullName;

            /// Get Other Patient Api Call
            addAppointmentCont.getOtherPatientList(patientId: addAppointmentCont.selectPatient.value.id.toString());

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
      onNextPage: () {
        if (!addAppointmentCont.isPatientLastPage.value) {
          addAppointmentCont.patientPage++;
          addAppointmentCont.isLoading(true);
          addAppointmentCont.getPatientList();
        }
      },
      onSwipeRefresh: () async {
        addAppointmentCont.patientPage(1);
        addAppointmentCont.getPatientList();
        return Future.delayed(const Duration(seconds: 2));
      },
    );
  }
}
