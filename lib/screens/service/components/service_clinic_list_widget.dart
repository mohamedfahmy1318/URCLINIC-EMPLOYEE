import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../../utils/colors.dart';
import '../../../utils/app_common.dart';
import '../../doctor/model/doctor_list_res.dart';
import '../assing_doctor_screen_controller.dart';

class ServiceClinicListWidget extends StatelessWidget {
  final List<ClinicData> clinicList;

  ServiceClinicListWidget({super.key, required this.clinicList});

  final AssingDoctorController serviceClinicCont = Get.put(AssingDoctorController());

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      shrinkWrap: true,
      itemCount: clinicList.length,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () {
            hideKeyboard(context);
            serviceClinicCont.selectClinic(clinicList[index]);
            serviceClinicCont.clinicCont.text = clinicList[index].name;
            serviceClinicCont.selectedDoctor.value = Doctor();
            serviceClinicCont.doctors.clear();
            serviceClinicCont.getDoctors();
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
                  url: clinicList[index].clinicImage,
                  width: 60,
                  radius: 6,
                  fit: BoxFit.cover,
                  height: 60,
                ),
                12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(clinicList[index].name, style: boldTextStyle(size: 16, color: isDarkMode.value ? null : darkGrayTextColor)),
                    2.height,
                    Text(clinicList[index].description, style: primaryTextStyle(size: 12, color: dividerColor)),
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
