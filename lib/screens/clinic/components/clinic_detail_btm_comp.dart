import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/clinic_session/clinic_session_screen.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_list_screen.dart';
import 'package:kivicare_clinic_admin/screens/service/all_service_list_screen.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../clinic_gallery_list_screen.dart';
import '../model/clinics_res_model.dart';

class ClinicDetailBtmComp extends StatelessWidget {
  final ClinicData clinicData;
  const ClinicDetailBtmComp({super.key, required this.clinicData});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: Get.width,
      child: Column(
        children: [
          SettingItemWidget(
            title: locale.value.sessions,
            decoration: boxDecorationDefault(color: context.cardColor),
            subTitle: locale.value.clinicSessionsInformation,
            splashColor: transparentColor,
            onTap: () {
              Get.to(() => ClinicSessionScreen(), arguments: clinicData);
            },
            titleTextStyle: boldTextStyle(size: 14),
            leading: commonLeadingWid(imgPath: Assets.iconsIcClock, color: appColorSecondary),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: darkGray),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          ).visible(!loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)),
          SettingItemWidget(
            title: locale.value.services,
            decoration: boxDecorationDefault(color: context.cardColor),
            subTitle: "${locale.value.total} ${clinicData.totalServices} ${locale.value.serviceAvaliable}",
            splashColor: transparentColor,
            onTap: () {
              Get.to(() => AllServicesScreen(), arguments: clinicData);
            },
            titleTextStyle: boldTextStyle(size: 14),
            leading: commonLeadingWid(imgPath: Assets.iconsIcServices, color: appColorSecondary),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: darkGray),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          ).paddingTop(16).visible(!loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)),
          SettingItemWidget(
            title: locale.value.doctors,
            decoration: boxDecorationDefault(color: context.cardColor),
            subTitle: "${locale.value.total} ${clinicData.totalDoctors} ${locale.value.doctorsAvaliable}",
            splashColor: transparentColor,
            onTap: () {
              Get.to(() => DoctorsListScreen(), arguments: clinicData);
            },
            titleTextStyle: boldTextStyle(size: 14),
            leading: commonLeadingWid(imgPath: Assets.iconsIcDoctor, color: appColorSecondary),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: darkGray),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          ).paddingTop(16).visible(!loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)),
          SettingItemWidget(
            title: locale.value.gallery,
            decoration: boxDecorationDefault(color: context.cardColor),
            subTitle: "${locale.value.total} ${clinicData.totalGalleryImages} ${locale.value.photosAvaliable}",
            splashColor: transparentColor,
            onTap: () {
              Get.to(() => ClinicGalleryListScreen(), arguments: clinicData.id);
            },
            titleTextStyle: boldTextStyle(size: 14),
            leading: commonLeadingWid(imgPath: Assets.iconsIcGallery, color: appColorSecondary),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: darkGray),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          ).paddingTop(16).visible(!loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)),
        ],
      ),
    );
  }
}
