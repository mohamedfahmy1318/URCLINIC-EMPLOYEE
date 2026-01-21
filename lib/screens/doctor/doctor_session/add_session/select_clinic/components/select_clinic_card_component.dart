import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/add_session/add_session_controller.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../../../components/cached_image_widget.dart';
import '../../../../../clinic/model/clinics_res_model.dart';
import '../../select_doctor/select_doctor_controller.dart';

class SelectClinicCardComponents extends StatelessWidget {
  final ClinicData clinicData;
  SelectClinicCardComponents({super.key, required this.clinicData});

  final SelectDoctorController clinicListController = Get.put(SelectDoctorController());
  final AddSessionController addSessionController = Get.put(AddSessionController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clinicListController.selectClinicData(clinicData);
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
              url: clinicData.clinicImage,
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
                Text(clinicData.name, style: boldTextStyle(size: 14)),
                Text(clinicData.description, style: primaryTextStyle(size: 12, color: lightSlateGrey)),
              ],
            ).expand(),
            8.width,
            Obx(
              () => InkWell(
                onTap: () {
                  clinicListController.selectClinicData(clinicData);
                },
                child: clinicListController.selectClinicData.value.name.isEmpty
                    ? addSessionController.selectClinicName.value.name != clinicData.name
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
                    : clinicListController.selectClinicData.value.name != clinicData.name
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
