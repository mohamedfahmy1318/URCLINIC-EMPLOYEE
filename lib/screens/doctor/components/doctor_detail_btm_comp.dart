import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/doctor_session_screen.dart';
import 'package:kivicare_clinic_admin/screens/service/all_service_list_screen.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../doctor_about_screen.dart';
import '../doctor_detail_controller.dart';
import '../doctor_qualification_screen.dart';
import '../doctor_session/add_session/add_session_screen.dart';
import '../doctor_session/add_session/model/doctor_session_model.dart';
import '../reviews/doctor_review_screen.dart';

class DoctorDetailBtmComp extends StatelessWidget {
  DoctorDetailBtmComp({
    super.key,
  });

  final DoctorDetailController doctorDetailCont = Get.put(DoctorDetailController());

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: Get.width,
      child: Column(
        children: [
          SettingItemWidget(
            title: locale.value.aboutMyself,
            decoration: boxDecorationDefault(color: context.cardColor),
            subTitle: locale.value.experienceSpecializationContactInfo,
            splashColor: transparentColor,
            onTap: () {
              Get.to(
                () => DoctorAboutScreen(
                  doctorData: doctorDetailCont.doctorDetails.value,
                ),
              );
            },
            titleTextStyle: boldTextStyle(size: 14),
            leading: commonLeadingWid(imgPath: Assets.iconsIcInfo, color: appColorSecondary),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: darkGray),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          ).paddingTop(16),
          SettingItemWidget(
            title: locale.value.sessions,
            decoration: boxDecorationDefault(color: context.cardColor),
            subTitle: locale.value.doctorSessionsInformation,
            splashColor: transparentColor,
            onTap: () {
              if (loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist) | loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)) {
                Get.to(
                  () => AddSessionScreen(),
                  arguments: DoctorSessionModel(
                    doctorId: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? loginUserData.value.id : doctorDetailCont.doctorDetails.value.doctorId,
                    clinicId: selectedAppClinic.value.id,
                    fullName: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? loginUserData.value.userName : doctorDetailCont.doctorDetails.value.fullName,
                  ),
                );
              } else {
                Get.to(() => DoctorSessionScreen(), arguments: doctorDetailCont.doctorDetails.value);
              }
            },
            titleTextStyle: boldTextStyle(size: 14),
            leading: commonLeadingWid(imgPath: Assets.iconsIcClock, color: appColorSecondary),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: darkGray),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          ).paddingTop(16),
          SettingItemWidget(
            title: locale.value.sessions,
            decoration: boxDecorationDefault(color: context.cardColor),
            subTitle: doctorDetailCont.doctorDetails.value.services.isEmpty ? locale.value.noServicesTillNow : "${locale.value.total} ${doctorDetailCont.doctorDetails.value.services.length} ${locale.value.serviceAvaliable}",
            splashColor: transparentColor,
            onTap: () {
              if (doctorDetailCont.doctorDetails.value.services.isEmpty) {
                toast(locale.value.oopsThisDoctorDoesntHaveAnyServicesYet);
              } else {
                Get.to(() => AllServicesScreen(), arguments: doctorDetailCont.doctorDetails.value);
              }
            },
            titleTextStyle: boldTextStyle(size: 14),
            leading: commonLeadingWid(imgPath: Assets.iconsIcServices, color: appColorSecondary),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: darkGray),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          ).paddingTop(16).visible(!loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)),
          SettingItemWidget(
            title: locale.value.reviews,
            decoration: boxDecorationDefault(color: context.cardColor),
            subTitle: doctorDetailCont.doctorDetails.value.totalReviews < 0 ? locale.value.noReviewsTillNow : "${locale.value.total} ${doctorDetailCont.doctorDetails.value.totalReviews} ${locale.value.reviews}",
            splashColor: transparentColor,
            onTap: () {
              if (doctorDetailCont.doctorDetails.value.totalReviews < 0) {
                toast(locale.value.oopsThisDoctorDoesntHaveAnyReviewsYet);
              } else {
                Get.to(() => DoctorReviewsScreen(), arguments: doctorDetailCont.doctorDetails.value);
              }
            },
            titleTextStyle: boldTextStyle(size: 14),
            leading: commonLeadingWid(imgPath: Assets.iconsIcStar, color: appColorSecondary),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: darkGray),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          ).paddingTop(16),
          SettingItemWidget(
            title: locale.value.qualification,
            decoration: boxDecorationDefault(color: context.cardColor),
            subTitle: doctorDetailCont.doctorDetails.value.qualifications.isEmpty ? locale.value.qualificationDetailIsNotAvilable : locale.value.qualificationInDetail,
            splashColor: transparentColor,
            onTap: () {
              if (doctorDetailCont.doctorDetails.value.qualifications.isEmpty) {
                toast(locale.value.qualificationDetailIsNotAvilable);
              } else {
                Get.to(() => QualificationScreen(doctorData: doctorDetailCont.doctorDetails.value));
              }
            },
            titleTextStyle: boldTextStyle(size: 14),
            leading: commonLeadingWid(imgPath: Assets.iconsIcQualification, color: appColorSecondary),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: darkGray),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          ).paddingTop(16),
        ],
      ),
    );
  }
}
