import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/all_beds_screen.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_type/receptionist_bed_type_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/all_encounters_screen.dart';
import 'package:kivicare_clinic_admin/screens/clinic/clinic_list_screen.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_list_screen.dart';
import '../../../components/app_scaffold.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../doctor/add_doctor/add_doctor_form.dart';
import '../../doctor/doctor_session/add_session/add_session_screen.dart';
import '../../doctor/doctor_session/add_session/model/doctor_session_model.dart';
import '../../doctor/model/commission_list_model.dart';
import '../../doctor/model/doctor_list_res.dart';
import '../../receptionist/receptionist_list_screen.dart';
import '../../requests/request_list_screen.dart';
import 'common_horizontal_profile_widget.dart';
import 'edit_user_profile.dart';
import 'edit_user_profile_controller.dart';
import 'profile_controller.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../other/settings_screen.dart';
import '../other/about_us_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffoldNew(
        appBartitleText: locale.value.profile,
        hasLeadingWidget: false,
        isLoading: profileController.isLoading,
        appBarVerticalSize: Get.height * 0.12,
        body: AnimatedScrollView(
          padding: const EdgeInsets.only(top: 16, bottom: 80),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => ProfilePicHorizotalWidget(
                    heroTag: loginUserData.value.profileImage,
                    profileImage: loginUserData.value.profileImage,
                    firstName: loginUserData.value.firstName,
                    lastName: loginUserData.value.lastName,
                    userName: loginUserData.value.userName,
                    subInfo: loginUserData.value.email,
                    commission: profileController.commission,
                    onCameraTap: () {
                      final EditUserProfileController
                          editUserProfileController =
                          EditUserProfileController(isProfilePhoto: true);
                      editUserProfileController.showBottomSheet(context);
                    },
                  ).onTap(() {
                    if (loginUserData.value.userRole
                            .contains(EmployeeKeyConst.doctor) &&
                        loginUserData.value.userRole
                            .contains((EmployeeKeyConst.vendor))) {
                      final doctorData = Doctor(
                        id: loginUserData.value.id,
                        doctorId: loginUserData.value.id,
                        firstName: loginUserData.value.firstName,
                        lastName: loginUserData.value.lastName,
                        email: loginUserData.value.email,
                        profileImage: loginUserData.value.profileImage,
                        address: loginUserData.value.address,
                      );
                      Get.to(() => AddDoctorForm(isFromEditProfile: true),
                          arguments: doctorData);
                    } else {
                      Get.to(() => EditUserProfileScreen(),
                          duration: const Duration(milliseconds: 800));
                    }
                  }),
                ),
                SettingItemWidget(
                  decoration: boxDecorationDefault(color: context.cardColor),
                  title: locale.value.editProfile,
                  subTitle: locale.value.personalizeYourProfile,
                  splashColor: transparentColor,
                  onTap: () {
                    if (loginUserData.value.userRole
                        .contains(EmployeeKeyConst.doctor)) {
                      final doctorData = Doctor(
                        id: loginUserData.value.id,
                        doctorId: loginUserData.value.id,
                        firstName: loginUserData.value.firstName,
                        lastName: loginUserData.value.lastName,
                        email: loginUserData.value.email,
                        profileImage: loginUserData.value.profileImage,
                        address: loginUserData.value.address,
                      );
                      Get.to(() => AddDoctorForm(isFromEditProfile: true),
                          arguments: doctorData);
                    } else {
                      Get.to(() => EditUserProfileScreen(),
                          duration: const Duration(milliseconds: 800));
                    }
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcEditprofileOutlined,
                          color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  trailing: trailing,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16),
                SettingItemWidget(
                  decoration: boxDecorationDefault(color: context.cardColor),
                  title: locale.value.clinics,
                  subTitle: locale.value.manageClinics,
                  splashColor: transparentColor,
                  onTap: () {
                    Get.to(() => ClinicListScreen());
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcClinic, color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  trailing: trailing,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16).visible(loginUserData.value.userRole
                        .contains(EmployeeKeyConst.vendor) &&
                    CoreServiceApis.isBedFeatureAvailable),
                SettingItemWidget(
                  decoration: boxDecorationDefault(color: context.cardColor),
                  title: locale.value.manageSessions,
                  subTitle: locale.value.changeOrAddYourSessions,
                  splashColor: transparentColor,
                  onTap: () {
                    Get.to(
                      () => AddSessionScreen(),
                      arguments: DoctorSessionModel(
                        doctorId: loginUserData.value.id,
                        clinicId: selectedAppClinic.value.id,
                        fullName: loginUserData.value.userName,
                      ),
                    );
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcTimeOutlined,
                          color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  trailing: trailing,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16).visible(loginUserData.value.userRole
                    .contains(EmployeeKeyConst.doctor)),
                SettingItemWidget(
                  decoration: boxDecorationDefault(color: context.cardColor),
                  title: locale.value.doctors,
                  subTitle: locale.value.manageDoctors,
                  splashColor: transparentColor,
                  onTap: () {
                    Get.to(() => DoctorsListScreen());
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcDoctor, color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  trailing: trailing,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16).visible(loginUserData.value.userRole
                        .contains(EmployeeKeyConst.vendor) ||
                    loginUserData.value.userRole
                        .contains(EmployeeKeyConst.receptionist)),
                SettingItemWidget(
                  decoration: boxDecorationDefault(color: context.cardColor),
                  title: locale.value.bedType,
                  subTitle: locale.value.manageBedTypes,
                  splashColor: transparentColor,
                  onTap: () {
                    Get.to(() => ReceptionistBedTypeScreen());
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcBedType,
                          color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  trailing: trailing,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16).visible(loginUserData.value.userRole
                    .contains(EmployeeKeyConst.vendor)),
                SettingItemWidget(
                  decoration: boxDecorationDefault(color: context.cardColor),
                  title: locale.value.allBeds,
                  subTitle: locale.value.allBedType,
                  splashColor: transparentColor,
                  onTap: () {
                    Get.to(() => AllBedScreen());
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcBed, color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  trailing: trailing,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16).visible(!loginUserData.value.userRole
                        .contains(EmployeeKeyConst.pharma) &&
                    CoreServiceApis.isBedFeatureAvailable),
                SettingItemWidget(
                  decoration: boxDecorationDefault(color: context.cardColor),
                  title: locale.value.requests,
                  subTitle:
                      locale.value.requestForServiceCategoryAndSpecialization,
                  splashColor: transparentColor,
                  onTap: () {
                    Get.to(() => RequestListScreen());
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcRequest,
                          color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  trailing: trailing,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16).visible(loginUserData.value.userRole
                    .contains(EmployeeKeyConst.vendor)),
                SettingItemWidget(
                  decoration: boxDecorationDefault(color: context.cardColor),
                  title: locale.value.receptionists,
                  subTitle: locale.value.allReceptionist,
                  splashColor: transparentColor,
                  onTap: () {
                    Get.to(() => ReceptionistListScreen());
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcReceptionist,
                          color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  trailing: trailing,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16).visible(loginUserData.value.userRole
                    .contains(EmployeeKeyConst.vendor)),
                SettingItemWidget(
                  decoration: boxDecorationDefault(color: context.cardColor),
                  title: locale.value.encounters,
                  subTitle: locale.value.manageEncouterData,
                  splashColor: transparentColor,
                  onTap: () {
                    Get.to(() => AllEncountersScreen());
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcEncounter,
                          color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  trailing: trailing,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16).visible(!loginUserData.value.userRole
                    .contains(EmployeeKeyConst.pharma)),
                SettingItemWidget(
                  title: locale.value.settings,
                  decoration: boxDecorationDefault(color: context.cardColor),
                  subTitle:
                      "${locale.value.changePassword},${locale.value.themeAndMore}",
                  splashColor: transparentColor,
                  onTap: () {
                    Get.to(() => SettingScreen());
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcSetting,
                          color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  trailing: trailing,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16),
                SettingItemWidget(
                  title: locale.value.aboutApp,
                  decoration: boxDecorationDefault(color: context.cardColor),
                  subTitle: locale.value.privacyPolicyTerms,
                  splashColor: transparentColor,
                  onTap: () {
                    Get.to(() => const AboutScreen());
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcInfo, color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  trailing: trailing,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16),
                /*  SettingItemWidget(
                  title: locale.value.rateApp,
                  decoration: boxDecorationDefault(color: context.cardColor),
                  subTitle: locale.value.showSomeLoveShare,
                  splashColor: transparentColor,
                  onTap: () async {
                    handleRate();
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcStar, color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16),*/
                SettingItemWidget(
                  title: locale.value.logout,
                  decoration: boxDecorationDefault(color: context.cardColor),
                  subTitle: locale.value.securelyLogOutOfAccount,
                  splashColor: transparentColor,
                  onTap: () {
                    showConfirmDialogCustom(
                      primaryColor: appColorPrimary,
                      context,
                      negativeText: locale.value.cancel,
                      positiveText: locale.value.logout,
                      onAccept: (_) {
                        profileController.handleLogout();
                      },
                      subTitle: locale.value.doYouWantToLogout,
                      title: locale.value.ohNoYouAreLeaving,
                    );
                  },
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: commonLeadingWid(
                          imgPath: Assets.iconsIcLogout, color: appColorPrimary)
                      .circularLightPrimaryBg(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ).paddingTop(16),
                30.height,
                VersionInfoWidget(
                        prefixText: '${locale.value.version}  ',
                        textStyle: primaryTextStyle(color: secondaryTextColor))
                    .center(),
                32.height,
              ],
            ).paddingSymmetric(horizontal: 16),
          ],
        ),
      ),
    );
  }

  Widget get trailing =>
      const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: darkGray);

  Widget commissionListWid(List<CommissionElement> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Obx(
          () => SettingItemWidget(
            title:
                "${list[index].title}  (${list[index].commissionValue} ${list[index].commissionType.toLowerCase().trim().contains(TaxType.PERCENT) ? "%" : appCurrency.value.currencySymbol})",
            titleTextStyle: primaryTextStyle(size: 14),
            /*leading: list[index].isSelected.value
                ? const Icon(
                    Icons.check_rounded,
                    color: appColorPrimary,
                  )
                : null,*/
            subTitleTextStyle: secondaryTextStyle(),
            onTap: () {
              list[index].isSelected(!list[index].isSelected.value);
              profileController.setCommissionContValue(commissionList: list);
            },
          ),
        );
      },
      separatorBuilder: (context, index) =>
          commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}
