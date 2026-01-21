import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/clinic/add_clinic_form/model/city_list_response.dart';
import 'package:kivicare_clinic_admin/screens/clinic/add_clinic_form/model/country_list_response.dart';
import 'package:kivicare_clinic_admin/screens/clinic/add_clinic_form/model/state_list_response.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../components/loader_widget.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import '../../../components/app_scaffold.dart';
import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import 'common_profile_widget.dart';
import 'edit_user_profile_controller.dart';
import '../../../utils/app_common.dart';

class EditUserProfileScreen extends StatelessWidget {
  EditUserProfileScreen({super.key});

  final EditUserProfileController editUserProfileController = Get.put(EditUserProfileController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.editProfile,
      appBarVerticalSize: Get.height * 0.12,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              return await editUserProfileController.userDetailAPI();
            },
            child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Obx(
                    () => ProfilePicWidget(
                      heroTag: editUserProfileController.imageFile.value.path.isNotEmpty
                          ? editUserProfileController.imageFile.value.path
                          : loginUserData.value.profileImage.isNotEmpty
                              ? loginUserData.value.profileImage
                              : loginUserData.value.profileImage,
                      profileImage: editUserProfileController.imageFile.value.path.isNotEmpty
                          ? editUserProfileController.imageFile.value.path
                          : loginUserData.value.profileImage.isNotEmpty
                              ? loginUserData.value.profileImage
                              : loginUserData.value.profileImage,
                      firstName: loginUserData.value.firstName,
                      lastName: loginUserData.value.lastName,
                      userName: loginUserData.value.userName,
                      showCameraIconOnCornar: !loginUserData.value.isSocialLogin,
                      showOnlyPhoto: true,
                      onCameraTap: () {
                        editUserProfileController.showBottomSheet(context);
                      },
                      onPicTap: () {
                        editUserProfileController.showBottomSheet(context);
                      },
                    ),
                  ),
                  32.height,
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: editUserProfileController.fNameCont,
                    focus: editUserProfileController.fNameFocus,
                    nextFocus: editUserProfileController.lNameFocus,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.firstName,
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                    suffix: commonLeadingWid(imgPath: Assets.iconsIcUser, color: secondaryTextColor, size: 12).paddingAll(16),
                  ),
                  16.height,
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: editUserProfileController.lNameCont,
                    focus: editUserProfileController.lNameFocus,
                    nextFocus: editUserProfileController.emailFocus,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.lastName,
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                    suffix: commonLeadingWid(imgPath: Assets.iconsIcUser, color: secondaryTextColor, size: 12).paddingAll(16),
                  ),
                  16.height,
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: editUserProfileController.emailCont,
                    focus: editUserProfileController.emailFocus,
                    nextFocus: editUserProfileController.mobileFocus,
                    textFieldType: TextFieldType.EMAIL_ENHANCED,
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.email,
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                    suffix: commonLeadingWid(imgPath: Assets.iconsIcMail, color: secondaryTextColor, size: 12).paddingAll(16),
                  ),
                  16.height,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => AppTextField(
                          textStyle: primaryTextStyle(size: 12),
                          textFieldType: TextFieldType.OTHER,
                          controller: TextEditingController(text: "  +${editUserProfileController.pickedPhoneCode.value.phoneCode}"),
                          focus: editUserProfileController.mobileFocus,
                          nextFocus: editUserProfileController.mobileFocus,
                          errorThisFieldRequired: locale.value.thisFieldIsRequired,
                          readOnly: true,
                          onTap: () {
                            pickCountry(
                              context,
                              onSelect: (Country country) {
                                editUserProfileController.pickedPhoneCode(country);
                                editUserProfileController.phoneCodeCont.text = editUserProfileController.pickedPhoneCode.value.phoneCode;
                              },
                            );
                          },
                          textAlign: TextAlign.center,
                          decoration: inputDecoration(
                            context,
                            hintText: editUserProfileController.pickedPhoneCode.value.phoneCode.isNotEmpty ? "+${editUserProfileController.pickedPhoneCode.value.phoneCode}" : "+91",
                            prefixIcon: Text(
                              editUserProfileController.pickedPhoneCode.value.flagEmoji,
                            ).paddingOnly(top: 2, left: 6),
                            prefixIconConstraints: BoxConstraints.tight(const Size(24, 24)),
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: dividerColor,
                              size: 22,
                            ).paddingOnly(right: 32),
                            suffixIconConstraints: BoxConstraints.tight(const Size(22, 24)),
                            fillColor: context.cardColor,
                            filled: true,
                          ),
                        ),
                      ).expand(flex: 3),
                      10.width,
                      AppTextField(
                        textStyle: primaryTextStyle(size: 12),
                        textFieldType: TextFieldType.PHONE,
                        controller: editUserProfileController.mobileCont,
                        focus: editUserProfileController.mobileFocus,
                        errorThisFieldRequired: locale.value.thisFieldIsRequired,
                        decoration: inputDecoration(
                          context,
                          hintText: locale.value.contactNumber,
                          fillColor: context.cardColor,
                          filled: true,
                        ),
                        suffix: commonLeadingWid(imgPath: Assets.iconsIcCall, color: secondaryTextColor, size: 12).paddingAll(16),
                      ).expand(flex: 8),
                    ],
                  ),
                  16.height,
                  AppTextField(
                    isValidationRequired: false,
                    textStyle: primaryTextStyle(size: 12),
                    textFieldType: TextFieldType.MULTILINE,
                    controller: editUserProfileController.addressCont,
                    focus: editUserProfileController.addressFocus,
                    errorThisFieldRequired: locale.value.thisFieldIsRequired,
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.address,
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                    suffix: commonLeadingWid(imgPath: Assets.iconsIcLocation, color: secondaryTextColor, size: 12).paddingAll(16),
                  ),
                  16.height,
                  Text(locale.value.gender, style: primaryTextStyle()),
                  8.height,
                  Obx(
                    () => HorizontalList(
                      itemCount: genders.length,
                      spacing: 16,
                      runSpacing: 16,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => InkWell(
                            onTap: () {
                              editUserProfileController.selectedGender(genders[index]);
                            },
                            borderRadius: radius(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: boxDecorationDefault(
                                color: editUserProfileController.selectedGender.value.id == genders[index].id ? appColorPrimary : context.cardColor,
                              ),
                              child: Text(
                                genders[index].name,
                                style: secondaryTextStyle(
                                  color: editUserProfileController.selectedGender.value.id == genders[index].id ? white : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  16.height,
                  Text(locale.value.dateOfBirth, style: primaryTextStyle()),
                  16.height,
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: editUserProfileController.dateCont,
                    textFieldType: TextFieldType.NAME,
                    isValidationRequired: true,

                    readOnly: true,
                    //  isValidationRequired: true,
                    onTap: () async {
                      final DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (selectedDate != null) {
                        editUserProfileController.dateCont.text = selectedDate.formatDateYYYYmmdd();
                      }
                    },
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return locale.value.thisFieldIsRequired;
                      return null;
                    },

                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.date,
                      fillColor: context.cardColor,
                      filled: true,
                      suffixIcon: commonLeadingWid(imgPath: Assets.iconsIcCalendar, color: iconColor, size: 10).paddingAll(16),
                    ),
                  ),
                  32.height,
                  AppButton(
                      width: Get.width,
                      text: locale.value.update,
                      textStyle: appButtonTextStyleWhite,
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          hideKeyboard(context);

                          editUserProfileController.updateUserProfile();
                          ifNotTester(() async {
                            editUserProfileController.updateUserProfile();
                            if (await isNetworkAvailable()) {
                            } else {
                              toast(locale.value.yourInternetIsNotWorking);
                            }
                          });
                        }
                      }),
                  24.height,
                ],
              ),
            ).paddingSymmetric(horizontal: 16),
          )),
          Obx(() => const LoaderWidget().visible(editUserProfileController.isLoading.value)),
        ],
      ),
    );
  }

  Widget countryListWid(List<CountryData> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].name,
          titleTextStyle: primaryTextStyle(size: 14),
          onTap: () async {
            hideKeyboard(context);
            editUserProfileController.countryId(list[index].id);
            editUserProfileController.selectedCountry(list[index]);
            editUserProfileController.countryCont.text = list[index].name;
            editUserProfileController.resetState();
            editUserProfileController.resetCity();
            await editUserProfileController.getStates(countryId: list[index].id);
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }

  Widget stateListWid(List<StateData> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].name,
          titleTextStyle: primaryTextStyle(size: 14),
          onTap: () async {
            hideKeyboard(context);
            editUserProfileController.selectedState(list[index]);
            editUserProfileController.stateCont.text = list[index].name;
            editUserProfileController.stateId(list[index].id);
            editUserProfileController.resetCity();
            await editUserProfileController.getCity(stateId: list[index].id);
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }

  Widget cityListWid(List<CityData> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].name,
          titleTextStyle: primaryTextStyle(size: 14),
          onTap: () {
            hideKeyboard(context);
            editUserProfileController.selectedCity(list[index]);
            editUserProfileController.cityId(list[index].id);
            editUserProfileController.cityCont.text = list[index].name;
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}
