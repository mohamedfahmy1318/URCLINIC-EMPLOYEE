import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../../utils/colors.dart';
import '../../../doctor/model/doctor_list_res.dart';
import '../add_encounter_controller.dart';

class DoctorListWidget extends StatelessWidget {
  final List<Doctor> doctorList;

  DoctorListWidget({super.key, required this.doctorList});

  final AddEncountersController addEncountersCont = Get.put(AddEncountersController());

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      shrinkWrap: true,
      itemCount: doctorList.length,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () {
            hideKeyboard(context);
            addEncountersCont.selectDoctor(doctorList[index]);
            addEncountersCont.doctorCont.text = doctorList[index].fullName;
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
                  url: doctorList[index].profileImage,
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
                    Text(doctorList[index].fullName, style: boldTextStyle(size: 16, color: isDarkMode.value ? null : darkGrayTextColor)),
                    2.height,
                    Text(doctorList[index].aboutSelf, style: primaryTextStyle(size: 12, color: dividerColor)),
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
