import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/model/doctor_list_res.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/add_session_controller.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/select_doctor/select_doctor_controller.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../../../components/cached_image_widget.dart';

class SelectDoctorCardComponents extends StatelessWidget {
  final Doctor doctorData;
  SelectDoctorCardComponents({super.key, required this.doctorData});

  final SelectDoctorController selectDoctorCon = Get.put(SelectDoctorController());
  final AddSessionController addSessionController = Get.put(AddSessionController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectDoctorCon.selectDoctorData(doctorData);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: boxDecorationDefault(
          color: white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageWidget(
              url: doctorData.profileImage,
              height: 52,
              width: 52,
              fit: BoxFit.cover,
              circle: true,
            ),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                2.height,
                Text(doctorData.fullName, style: boldTextStyle(size: 14)),
                Text(doctorData.aboutSelf, style: primaryTextStyle(size: 12, color: lightSlateGrey)),
              ],
            ).expand(),
            8.width,
            Obx(
              () => InkWell(
                onTap: () {
                  selectDoctorCon.selectDoctorData(doctorData);
                },
                child: selectDoctorCon.selectDoctorData.value.fullName.isEmpty
                    ? addSessionController.selectDoctorData.value.fullName != doctorData.fullName
                        ? const Icon(
                            Icons.circle_outlined,
                            size: 20,
                            color: lightGrey,
                          )
                        : const Icon(
                            Icons.radio_button_checked_outlined,
                            size: 20,
                            color: appColorPrimary,
                          )
                    : selectDoctorCon.selectDoctorData.value.fullName != doctorData.fullName
                        ? const Icon(
                            Icons.circle_outlined,
                            size: 20,
                            color: lightGrey,
                          )
                        : const Icon(
                            Icons.radio_button_checked_outlined,
                            size: 20,
                            color: appColorPrimary,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
