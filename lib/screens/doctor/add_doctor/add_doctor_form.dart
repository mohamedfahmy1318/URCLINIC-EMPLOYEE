import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import 'package:kivicare_clinic_admin/screens/doctor/model/commission_list_model.dart';
import 'package:kivicare_clinic_admin/screens/doctor/services/service_list_screen.dart';
import 'package:kivicare_clinic_admin/screens/service/model/service_list_model.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../components/app_primary_widget.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/bottom_selection_widget.dart';
import '../../../components/cached_image_widget.dart';
import '../../../components/decimal_input_formater.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/view_all_label_component.dart';
import '../../auth/sign_in_sign_up/password_rule_item.dart';
import '../../auth/sign_in_sign_up/sign_up_controller.dart';
import '../../clinic/add_clinic_form/model/city_list_response.dart';
import '../../clinic/add_clinic_form/model/country_list_response.dart';
import '../../clinic/add_clinic_form/model/state_list_response.dart';
import 'add_doctor_controller.dart';
import '../clinic_center/clinic_center_screen.dart';
import '../model/qualification_model.dart';

class AddDoctorForm extends StatelessWidget {
  final bool isEdit;
  final bool isFromEditProfile;

  AddDoctorForm({super.key, this.isEdit = false, this.isFromEditProfile = false});

  final AddDoctorController addDoctorCont = Get.put(AddDoctorController());
  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: isEdit
          ? locale.value.editDoctor
          : isFromEditProfile
              ? locale.value.editProfile
              : locale.value.addDoctor,
      isLoading: addDoctorCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: AnimatedScrollView(
        controller: addDoctorCont.scrollController,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 16),
        children: [
          Form(
            key: addDoctorCont.addDoctorformKey,
            autovalidateMode: AutovalidateMode.onUnfocus,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.value.doctorImage, style: boldTextStyle(size: 16)),
                12.height,
                Obx(
                  () => addDoctorCont.imageFile.value.path.isNotEmpty || addDoctorCont.doctorImage.value.isNotEmpty
                      ? Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              CachedImageWidget(
                                url: addDoctorCont.imageFile.value.path.isNotEmpty ? addDoctorCont.imageFile.value.path : addDoctorCont.doctorImage.value,
                                height: 110,
                                width: 110,
                                fit: BoxFit.cover,
                              ).cornerRadiusWithClipRRect(defaultRadius),
                              Positioned(
                                top: 110 * 3 / 4 + 4,
                                left: 110 * 3 / 4 + 4,
                                child: GestureDetector(
                                  onTap: () {
                                    hideKeyboard(context);
                                    addDoctorCont.showImagePicker(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: boxDecorationDefault(shape: BoxShape.circle, color: Colors.white),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: boxDecorationDefault(shape: BoxShape.circle, color: appColorPrimary),
                                      child: const Icon(Icons.camera_alt_outlined, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ).paddingBottom(16),
                        )
                      : Column(
                          children: [
                            AppPrimaryWidget(
                              width: Get.width,
                              constraints: BoxConstraints(minHeight: Get.height * 0.18),
                              backgroundColor: context.cardColor,
                              border: Border.all(color: borderColor, width: 0.8),
                              borderRadius: defaultRadius,
                              onTap: () {
                                hideKeyboard(context);
                                addDoctorCont.showImagePicker(context);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CachedImageWidget(
                                    url: Assets.iconsIcImageUpload,
                                    height: 32,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  16.height,
                                  Text(
                                    locale.value.chooseImageToUpload,
                                    style: secondaryTextStyle(color: secondaryTextColor, size: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
                Text("Personal Details", style: boldTextStyle(size: 16)).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.firstNameCont,
                  focus: addDoctorCont.firstNameFocus,
                  nextFocus: addDoctorCont.lastNameFocus,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.firstName,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.navigationIcUserOutlined, color: secondaryTextColor, size: 12).paddingAll(16),
                ).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.lastNameCont,
                  focus: addDoctorCont.lastNameFocus,
                  nextFocus: addDoctorCont.emailFocus,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.lastName,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.navigationIcUserOutlined, color: secondaryTextColor, size: 12).paddingAll(16),
                ).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.emailCont,
                  focus: addDoctorCont.emailFocus,
                  nextFocus: addDoctorCont.phoneFocus,
                  textFieldType: TextFieldType.EMAIL_ENHANCED,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.email,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcMail, color: secondaryTextColor, size: 12).paddingAll(16),
                ).paddingTop(16),
                16.height,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => AppTextField(
                        textStyle: primaryTextStyle(size: 12),
                        textFieldType: TextFieldType.OTHER,
                        controller: TextEditingController(text: "  +${addDoctorCont.pickedPhoneCode.value.phoneCode}"),
                        focus: addDoctorCont.phoneCodeFocus,
                        nextFocus: addDoctorCont.phoneFocus,
                        errorThisFieldRequired: locale.value.thisFieldIsRequired,
                        readOnly: true,
                        onTap: () {
                          pickCountry(
                            context,
                            onSelect: (Country country) {
                              addDoctorCont.pickedPhoneCode(country);
                              addDoctorCont.phoneCodeCont.text = addDoctorCont.pickedPhoneCode.value.phoneCode;
                            },
                          );
                        },
                        textAlign: TextAlign.center,
                        decoration: inputDecoration(
                          context,
                          hintText: "",
                          prefixIcon: Text(
                            addDoctorCont.pickedPhoneCode.value.flagEmoji,
                          ).paddingOnly(top: 2, left: 8),
                          prefixIconConstraints: BoxConstraints.tight(const Size(24, 24)),
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: dividerColor,
                            size: 22,
                          ).paddingOnly(right: 32),
                          suffixIconConstraints: BoxConstraints.tight(const Size(32, 24)),
                          fillColor: context.cardColor,
                          filled: true,
                        ),
                      ),
                    ).expand(flex: 3),
                    16.width,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      textFieldType: TextFieldType.PHONE,
                      controller: addDoctorCont.phoneCont,
                      focus: addDoctorCont.phoneFocus,
                      nextFocus: addDoctorCont.passwordFocus,
                      // maxLength: 10,
                      errorThisFieldRequired: locale.value.thisFieldIsRequired,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                addDoctorCont.selectedGender(genders[index]);
                              },
                              borderRadius: radius(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: boxDecorationDefault(
                                  color: addDoctorCont.selectedGender.value.id == genders[index].id ? appColorPrimary : context.cardColor,
                                ),
                                child: Text(
                                  genders[index].name,
                                  style: secondaryTextStyle(
                                    color: addDoctorCont.selectedGender.value.id == genders[index].id ? white : null,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ).paddingTop(16),
                16.height,
                Row(
                  children: [
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addDoctorCont.countryCont,
                      focus: addDoctorCont.countryFocus,
                      textFieldType: TextFieldType.NAME,
                      readOnly: true,
                      onTap: () async {
                        serviceCommonBottomSheet(
                          context,
                          child: Obx(
                            () => BottomSelectionSheet(
                              title: locale.value.chooseCountry,
                              hintText: locale.value.searchForCountry,
                              hasError: addDoctorCont.hasErrorFetchingCountry.value,
                              isEmpty: !addDoctorCont.isLoading.value && addDoctorCont.countryList.isEmpty,
                              errorText: addDoctorCont.errorMessageCountry.value,
                              isLoading: addDoctorCont.isLoading,
                              searchApiCall: (p0) {
                                addDoctorCont.getCountry(searchTxt: p0);
                              },
                              onRetry: () {
                                addDoctorCont.getCountry();
                              },
                              listWidget: Obx(
                                () => countryListWid(addDoctorCont.countryList).expand(),
                              ),
                            ),
                          ),
                        );
                      },
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.country,
                        fillColor: context.cardColor,
                        filled: true,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: dividerColor,
                          size: 22,
                        ),
                      ),
                    ).expand(),
                    16.width,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addDoctorCont.stateCont,
                      focus: addDoctorCont.stateFocus,
                      textFieldType: TextFieldType.NAME,
                      readOnly: true,
                      onTap: () async {
                        serviceCommonBottomSheet(
                          context,
                          child: Obx(
                            () => BottomSelectionSheet(
                              title: locale.value.chooseState,
                              hintText: locale.value.searchForState,
                              hasError: addDoctorCont.hasErrorFetchingState.value,
                              isEmpty: !addDoctorCont.isLoading.value && addDoctorCont.stateList.isEmpty,
                              errorText: addDoctorCont.errorMessageState.value,
                              isLoading: addDoctorCont.isLoading,
                              searchApiCall: (p0) {
                                addDoctorCont.getStates(countryId: addDoctorCont.selectedCountry.value.id, searchTxt: p0);
                              },
                              onRetry: () {
                                addDoctorCont.getStates(countryId: addDoctorCont.selectedCountry.value.id);
                              },
                              listWidget: Obx(
                                () => stateListWid(addDoctorCont.stateList).expand(),
                              ),
                            ),
                          ),
                        );
                      },
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.state,
                        fillColor: context.cardColor,
                        filled: true,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: dividerColor,
                          size: 22,
                        ),
                      ),
                    ).expand(),
                  ],
                ),
                Row(
                  children: [
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addDoctorCont.cityCont,
                      focus: addDoctorCont.cityFocus,
                      textFieldType: TextFieldType.NAME,
                      readOnly: true,
                      onTap: () async {
                        serviceCommonBottomSheet(
                          context,
                          child: Obx(
                            () => BottomSelectionSheet(
                              title: locale.value.chooseCity,
                              hintText: locale.value.searchForCity,
                              hasError: addDoctorCont.hasErrorFetchingCity.value,
                              isEmpty: !addDoctorCont.isLoading.value && addDoctorCont.cityList.isEmpty,
                              errorText: addDoctorCont.errorMessageCity.value,
                              isLoading: addDoctorCont.isLoading,
                              searchApiCall: (p0) {
                                addDoctorCont.getCity(stateId: addDoctorCont.selectedState.value.id, searchTxt: p0);
                              },
                              onRetry: () {
                                addDoctorCont.getCity(stateId: addDoctorCont.selectedState.value.id);
                              },
                              listWidget: Obx(
                                () => cityListWid(addDoctorCont.cityList).expand(),
                              ),
                            ),
                          ),
                        );
                      },
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.city,
                        fillColor: context.cardColor,
                        filled: true,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: dividerColor,
                          size: 22,
                        ),
                      ),
                    ).expand(),
                    16.width,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      textFieldType: TextFieldType.NAME,
                      controller: addDoctorCont.postalCont,
                      focus: addDoctorCont.postalFocus,
                      nextFocus: addDoctorCont.fbFocus,
                      isValidationRequired: false,
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.postalCode,
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                    ).expand(),
                  ],
                ).paddingTop(16),
                Focus(
                  onFocusChange: (value) {
                    signUpController.passContHasFocus(value);
                  },
                  child: AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: addDoctorCont.passwordCont,
                    // Optional
                    focus: addDoctorCont.passwordFocus,
                    nextFocus: addDoctorCont.confirmPasswordFocus,
                    textFieldType: TextFieldType.PASSWORD,
                    obscureText: true,
                    decoration: inputDecoration(
                      context,
                      fillColor: context.cardColor,
                      filled: true,
                      hintText: locale.value.newPassword,
                    ),
                    onChanged: (val) => signUpController.checkPasswordRules(val),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return locale.value.passwordIsRequired;
                      } else if (value.length < 8) {
                        return locale.value.passwordTooShort;
                      } else if (!signUpController.hasSpecial.value || !signUpController.hasNumber.value || !signUpController.hasUppercase.value || !signUpController.hasLetter.value) {
                        return locale.value.passwordDoesNotMeetRequirements;
                      }
                      return null;
                    },
                    suffixPasswordVisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEye, color: appColorPrimary, size: 12).paddingAll(14),
                    suffixPasswordInvisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, color: appColorPrimary, size: 12).paddingAll(14),
                  ),
                ).paddingTop(16).visible(!(isEdit || isFromEditProfile)),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      6.height,
                      PasswordRuleItem(
                        isValid: signUpController.hasUppercase.value,
                        text: locale.value.passwordMustIncludeAtLeastOneCapitalCharacter,
                      ),
                      PasswordRuleItem(
                        isValid: signUpController.hasLetter.value,
                        text: locale.value.passwordMustIncludeAtLeastOneLowercaseCharacter,
                      ),
                      PasswordRuleItem(
                        isValid: signUpController.hasNumber.value,
                        text: locale.value.passwordMustIncludeAtLeastOneNumber,
                      ),
                      PasswordRuleItem(
                        isValid: signUpController.hasSpecial.value,
                        text: locale.value.passwordMustIncludeSpacialCharacter,
                      ),
                    ],
                  ).visible(signUpController.passContHasFocus.value &&
                      (!signUpController.hasUppercase.value || !signUpController.hasLetter.value || !signUpController.hasNumber.value || !signUpController.hasSpecial.value)),
                ),

                   AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: addDoctorCont.confirmPasswordCont,
                    // Optional
                    focus: addDoctorCont.confirmPasswordFocus,
                    nextFocus: addDoctorCont.aboutSelfFocus,
                    textFieldType: TextFieldType.PASSWORD,
                    obscureText: true,
                    decoration: inputDecoration(
                      context,
                      fillColor: context.cardColor,
                      filled: true,
                      hintText: locale.value.confirmNewPassword,
                    ),
                    onChanged: (val) => signUpController.checkPasswordRules(val),
                    validator: (value) {
                      if (addDoctorCont.passwordCont.text != value) {
                        return locale.value.theConfirmPasswordAndPasswordMustMatch;
                      }
                      return null;
                    },
                    suffixPasswordVisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEye, color: appColorPrimary, size: 12).paddingAll(14),
                    suffixPasswordInvisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, color: appColorPrimary, size: 12).paddingAll(14),
                  ).paddingTop(16).visible(!(isEdit || isFromEditProfile)),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.addressCont,
                  focus: addDoctorCont.addressFocus,
                  nextFocus: addDoctorCont.signatureFocus,
                  textFieldType: TextFieldType.MULTILINE,
                  minLines: 1,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.address,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcLocation, size: 12).paddingAll(16),
                ).paddingTop(16),
                Obx(
                      () => addDoctorCont.signatureUint8List.value.isEmpty
                      ? AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: addDoctorCont.signatureCont.value,
                    focus: addDoctorCont.signatureFocus,
                    nextFocus: addDoctorCont.latFocus,
                    textFieldType: TextFieldType.OTHER,
                    readOnly: true,
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.signature,
                      fillColor: context.cardColor,
                      filled: true,
                    ),
                    onTap: () {
                      addDoctorCont.signatureBottomSheet(context);
                    },
                    suffix: commonLeadingWid(imgPath: Assets.iconsIcSignature, size: 12).paddingAll(16),
                  )
                      : InkWell(
                    onTap: () {
                      addDoctorCont.signatureBottomSheet(context);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 80,
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: boxDecorationDefault(
                            borderRadius: BorderRadius.circular(6),
                            color: context.cardColor,
                            border: Border.all(color: borderColor.withValues(alpha: 0.8), width: 0.6),
                          ),
                          child: Image.memory(
                            addDoctorCont.signatureUint8List.value,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -7,
                          left: 12,
                          child: Text(
                            locale.value.signature,
                            style: primaryTextStyle(size: 10,color: secondaryTextColor.withValues(alpha: .9)),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () {
                              addDoctorCont.signaturePadCont.clear();
                              addDoctorCont.signatureCont.value.text = "";
                              addDoctorCont.signatureUint8List(Uint8List(0));
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: boxDecorationDefault(
                                shape: BoxShape.circle,
                                color: iconColor,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.clear, size: 10, color: white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).paddingTop(16),
                16.height,
                Row(
                  children: [
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addDoctorCont.latCont,
                      focus: addDoctorCont.latFocus,
                      nextFocus: addDoctorCont.lonFocus,
                      textFieldType: TextFieldType.NUMBER,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                        DecimalTextInputFormatter(decimalRange: 6),
                      ],
                      isValidationRequired: false,
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.latitude,
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                      suffix: commonLeadingWid(imgPath: Assets.iconsIcGlobe, size: 12).paddingAll(16),
                    ).expand(),
                    16.width,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addDoctorCont.lonCont,
                      focus: addDoctorCont.lonFocus,
                      textFieldType: TextFieldType.NUMBER,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                        DecimalTextInputFormatter(decimalRange: 6),
                      ],
                      isValidationRequired: false,
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.longitude,
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                      suffix: commonLeadingWid(imgPath: Assets.iconsIcGlobe, size: 12).paddingAll(16),
                    ).expand(),
                  ],
                ),
                Text("Other Details", style: boldTextStyle(size: 16)).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.aboutSelfCont,
                  focus: addDoctorCont.aboutSelfFocus,
                  nextFocus: addDoctorCont.expertFocus,
                  textFieldType: TextFieldType.MULTILINE,
                  minLines: 1,
                  decoration: inputDecoration(
                    context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: locale.value.aboutSelf,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcEditReview, color: secondaryTextColor, size: 12).paddingAll(16),
                ).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.expertCont,
                  focus: addDoctorCont.expertFocus,
                  nextFocus: addDoctorCont.commissionFocus,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(
                    context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: locale.value.expert,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcExperience, color: secondaryTextColor, size: 12).paddingAll(16),
                ).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.commissionCont,
                  focus: addDoctorCont.commissionFocus,
                  nextFocus: addDoctorCont.clinicCenterFocus,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    addDoctorCont.getCommission();
                    serviceCommonBottomSheet(
                      context,
                      onSheetClose: (p0) {
                        hideKeyboard(context);
                      },
                      child: Obx(
                        () => BottomSelectionSheet(
                          title: locale.value.chooseCommission,
                          hintText: locale.value.searchForCommission,
                          hasError: addDoctorCont.hasErrorFetchingCommission.value,
                          isEmpty: addDoctorCont.isShowFullList ? addDoctorCont.commissionList.isEmpty : addDoctorCont.commissionFilterList.isEmpty,
                          errorText: addDoctorCont.errorMessageCommission.value,
                          isLoading: addDoctorCont.isLoading,
                          noDataTitle: locale.value.noCommissionFound,
                          onRetry: () {
                            addDoctorCont.getCommission();
                          },
                          listWidget: Obx(
                            () => commissionListWid(
                              addDoctorCont.isShowFullList ? addDoctorCont.commissionList : addDoctorCont.commissionFilterList,
                            ).expand(),
                          ),
                        ),
                      ),
                    );
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.commission,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: darkGray.withValues(alpha: 0.5)),
                  ),
                ).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.clinicCenterCont,
                  focus: addDoctorCont.clinicCenterFocus,
                  nextFocus: addDoctorCont.fbFocus,
                  textFieldType: TextFieldType.MULTILINE,
                  minLines: 1,
                  readOnly: true,
                  onTap: () {
                    Get.to(() => ClinicCenterScreen(), arguments: addDoctorCont.selectedClinicList)?.then((value) {
                      if (value is List<ClinicData>) {
                        addDoctorCont.selectClinics(clinicList: value);
                      }
                    });
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectClinicCenters,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: darkGray.withValues(alpha: 0.5)),
                  ),
                ).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.servicesCont,
                  focus: addDoctorCont.servicesFocus,
                  nextFocus: addDoctorCont.fbFocus,
                  textFieldType: TextFieldType.MULTILINE,
                  minLines: 1,
                  readOnly: true,
                  onTap: () {
                    Get.to(() => ServicesListScreen(), arguments: addDoctorCont.selectedServiceList.toList())?.then((value) {
                      if (value is List<ServiceElement>) {
                        addDoctorCont.selectServices(serviceList: value);
                      }
                    });
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectServices,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: darkGray.withValues(alpha: 0.5)),
                  ),
                ).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.experienceCont,
                  focus: addDoctorCont.experienceFocus,
                  nextFocus: addDoctorCont.fbFocus,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(
                    context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: locale.value.experience,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcExperience, color: secondaryTextColor, size: 12).paddingAll(16),
                ).paddingTop(16),
                Text("Social Media", style: boldTextStyle(size: 16)).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.fbCont,
                  focus: addDoctorCont.fbFocus,
                  nextFocus: addDoctorCont.instaFocus,
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.facebookLink,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.socialMediaIcFb, size: 12).paddingAll(16),
                ).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.instaCont,
                  focus: addDoctorCont.instaFocus,
                  nextFocus: addDoctorCont.twitterFocus,
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.instagramLink,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.socialMediaIcInsta, size: 12).paddingAll(16),
                ).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.twitterCont,
                  focus: addDoctorCont.twitterFocus,
                  nextFocus: addDoctorCont.dribbleFocus,
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.twitterLink,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.socialMediaIcX, size: 12).paddingAll(16),
                ).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addDoctorCont.dribbleCont,
                  focus: addDoctorCont.dribbleFocus,
                  nextFocus: addDoctorCont.addressFocus,
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.dribbleLink,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.socialMediaIcDribble, size: 12).paddingAll(16),
                ).paddingTop(16),
                ViewAllLabel(
                  label: locale.value.qualification,
                  trailingText: locale.value.addNew,
                  onTap: () {
                    addDoctorCont.qualifications.add(
                      QualificationModel(
                        index: addDoctorCont.qualifications.length,
                        degreeCont: TextEditingController(),
                        universityCont: TextEditingController(),
                        yearCont: TextEditingController(),
                        degreeFocus: FocusNode(),
                        universityFocus: FocusNode(),
                        yearFocus: FocusNode(),
                      ),
                    );
                  },
                ).paddingTop(16),
                Obx(
                  () => AnimatedListView(
                    listAnimationType: ListAnimationType.None,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: addDoctorCont.qualifications.length,
                    itemBuilder: (context, index) {
                      return QulificationComponent(
                        qualification: addDoctorCont.qualifications[index],
                        onRemoveTap: () {
                          addDoctorCont.qualifications.removeAt(index);
                        },
                      );
                    },
                  ),
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.value.status,
                      style: secondaryTextStyle(size: 14),
                    ),
                    Obx(
                      () => Transform.scale(
                        scale: 0.75,
                        child: Switch(
                          activeTrackColor: switchActiveTrackColor,
                          value: addDoctorCont.status.value,
                          activeThumbColor: switchActiveColor,
                          inactiveTrackColor: switchColor.withValues(alpha: 0.2),
                          onChanged: (bool value) {
                            log('VALUE: $value');
                            addDoctorCont.status(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                16.height,
                AppButton(
                  width: Get.width,
                  color: appColorPrimary,
                  onTap: () {
                    hideKeyboard(context);
                    if (!addDoctorCont.isLoading.value) {
                      if (addDoctorCont.imageFile.value.path.isNotEmpty || addDoctorCont.doctorImage.isNotEmpty) {
                        if (addDoctorCont.addDoctorformKey.currentState!.validate()) {
                          addDoctorCont.addDoctorformKey.currentState!.save();
                          addDoctorCont.addDoctor();
                        }
                      } else {
                        toast(locale.value.pleaseSelectADoctorImage);

                        /// Open Gallery
                        addDoctorCont.showImagePicker(context);
                      }
                    }
                  },
                  child: Text(addDoctorCont.isEdit.value ? locale.value.update : locale.value.save, style: primaryTextStyle(color: white)),
                ),
              ],
            ),
          ),
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
            addDoctorCont.countryId(list[index].id);
            addDoctorCont.selectedCountry(list[index]);
            addDoctorCont.countryCont.text = list[index].name;
            addDoctorCont.resetState();
            addDoctorCont.resetCity();
            await addDoctorCont.getStates(countryId: list[index].id);
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
            addDoctorCont.selectedState(list[index]);
            addDoctorCont.stateCont.text = list[index].name;
            addDoctorCont.stateId(list[index].id);
            addDoctorCont.resetCity();
            await addDoctorCont.getCity(stateId: list[index].id);
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
            addDoctorCont.selectedCity(list[index]);
            addDoctorCont.cityId(list[index].id);
            addDoctorCont.cityCont.text = list[index].name;
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }

  Widget commissionListWid(List<CommissionElement> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Obx(
          () => SettingItemWidget(
            title: "${list[index].title}  (${list[index].commissionValue} ${list[index].commissionType.toLowerCase().trim().contains(TaxType.PERCENT) ? "%" : appCurrency.value.currencyName})",
            titleTextStyle: primaryTextStyle(size: 14),
            leading: list[index].isSelected.value
                ? const Icon(
                    Icons.check_rounded,
                    color: appColorPrimary,
                  )
                : null,
            subTitleTextStyle: secondaryTextStyle(),
            onTap: () {
              list[index].isSelected(!list[index].isSelected.value);
              addDoctorCont.setCommissionContValue(commissionList: list);
            },
          ),
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}

class QulificationComponent extends StatelessWidget {
  final QualificationModel qualification;
  final void Function()? onRemoveTap;

  const QulificationComponent({super.key, required this.qualification, required this.onRemoveTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: "#${qualification.index + 1}",
          trailingText: locale.value.remove,
          onTap: onRemoveTap,
          labelTextColor: secondaryTextColor,
          labelSize: 12,
          trailingTextColor: appColorPrimary,
        ),
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: qualification.degreeCont,
          focus: qualification.degreeFocus,
          nextFocus: qualification.universityFocus,
          textFieldType: TextFieldType.OTHER,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return locale.value.pleaseEnterDegree;
            }
            return null;
          },
          decoration: inputDecoration(
            context,
            hintText: locale.value.degreecertification,
            fillColor: context.cardColor,
            filled: true,
          ),
          suffix: commonLeadingWid(imgPath: Assets.iconsIcGraduation, size: 12).paddingAll(16),
        ),
        16.height,
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: qualification.universityCont,
          focus: qualification.universityFocus,
          nextFocus: qualification.yearFocus,
          textFieldType: TextFieldType.OTHER,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return locale.value.pleaseEnterUniversity;
            }
            return null;
          },
          decoration: inputDecoration(
            context,
            hintText: locale.value.university,
            fillColor: context.cardColor,
            filled: true,
          ),
          suffix: commonLeadingWid(imgPath: Assets.iconsIcUniversity, size: 12).paddingAll(16),
        ),
        16.height,
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: qualification.yearCont,
          focus: qualification.yearFocus,
          readOnly: true,
          textFieldType: TextFieldType.NUMBER,
          keyboardType: TextInputType.number,
          maxLength: 4,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(locale.value.selectYear, style: boldTextStyle()),
                  content: SizedBox(
                    // Need to use container to add size constraint.
                    width: Get.width * 0.8,
                    height: Get.height * 0.5,
                    child: YearPicker(
                      firstDate: DateTime.now().subtract(const Duration(days: 36500)),
                      lastDate: DateTime.now().subtract(const Duration(days: 1)),
                      selectedDate: qualification.yearCont.text.dateInyyyyMMddFormat,
                      onChanged: (DateTime dateTime) {
                        Get.back();
                        debugPrint('DATETIME.YEAR: ${dateTime.year}');
                        qualification.yearCont.text = dateTime.year.toString();
                      },
                    ),
                  ),
                );
              },
            );
          },
          decoration: inputDecoration(
            context,
            hintText: locale.value.year,
            fillColor: context.cardColor,
            filled: true,
            suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: darkGray.withValues(alpha: 0.5)),
          ),
        ),
      ],
    );
  }
}
