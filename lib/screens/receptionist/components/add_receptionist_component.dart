import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/screens/receptionist/components/add_receptionist_controller.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../auth/model/clinic_center_argument_model.dart';
import '../../auth/sign_in_sign_up/password_rule_item.dart';
import '../../clinic/model/clinics_res_model.dart';
import '../../doctor/clinic_center/clinic_center_screen.dart';

class AddReceptionistComponent extends StatelessWidget {
  final bool isEdit;
  final bool isFromEditProfile;

  AddReceptionistComponent({super.key, this.isEdit = false, this.isFromEditProfile = false});

  final AddReceptionistController addReceptionistCont = Get.put(AddReceptionistController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: isEdit
          ? locale.value.editReceptionist
          : isFromEditProfile
              ? locale.value.editProfile
              : locale.value.addReceptionist,
      isLoading: addReceptionistCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: AnimatedScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 16),
        children: [
          Obx(
            () => Form(
              key: addReceptionistCont.addReqFormKey,
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    2.height,
                    Row(
                      children: [
                        Text(
                          isEdit ? locale.value.editReceptionist : locale.value.addReceptionist,
                          style: secondaryTextStyle(size: 16, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                        ).expand(),
                      ],
                    ),
                    16.height,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addReceptionistCont.firstNameCont,
                      focus: addReceptionistCont.firstNameFocus,
                      nextFocus: addReceptionistCont.lastNameFocus,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.firstName,
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                      suffix: commonLeadingWid(imgPath: Assets.navigationIcUserOutlined, color: secondaryTextColor, size: 12).paddingAll(16),
                    ),
                    16.height,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addReceptionistCont.lastNameCont,
                      focus: addReceptionistCont.lastNameFocus,
                      nextFocus: addReceptionistCont.emailFocus,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.lastName,
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                      suffix: commonLeadingWid(imgPath: Assets.navigationIcUserOutlined, color: secondaryTextColor, size: 12).paddingAll(16),
                    ),
                    16.height,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addReceptionistCont.clinicCenterCont,
                      focus: addReceptionistCont.clinicCenterFocus,
                      nextFocus: addReceptionistCont.emailFocus,
                      textFieldType: TextFieldType.MULTILINE,
                      minLines: 1,
                      readOnly: true,
                      onTap: () {
                        Get.to(
                          () => ClinicCenterScreen(),
                          arguments: ClinicCenterArgumentModel(
                            isReceptionistRegister: true,

                            selectedClinc: addReceptionistCont.selectedClinic.value,
                          ),
                        )?.then((value) {
                          if (value is ClinicData) {
                            addReceptionistCont.selectClinics(clinic: value);
                          }
                        });
                      },
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.selectClinicCenters,
                        fillColor: context.cardColor,
                        filled: true,
                        prefixIconConstraints: BoxConstraints.loose(const Size.square(60)),
                        prefixIcon: (addReceptionistCont.selectedClinic.value.clinicImage.isEmpty && addReceptionistCont.selectedClinic.value.id.isNegative).obs.value
                            ? null
                            : CachedImageWidget(
                                url: addReceptionistCont.selectedClinic.value.clinicImage,
                                height: 35,
                                width: 35,
                                firstName: addReceptionistCont.selectedClinic.value.name,
                                fit: BoxFit.cover,
                                circle: true,
                              ).paddingOnly(left: 12, top: 8, bottom: 8, right: 12),
                        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: darkGray.withValues(alpha: 0.5)),
                      ),
                    ),
                    16.height,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addReceptionistCont.emailCont,
                      focus: addReceptionistCont.emailFocus,
                      nextFocus: addReceptionistCont.addressFocus,
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
                                    addReceptionistCont.selectedGender(genders[index]);
                                  },
                                  borderRadius: radius(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    decoration: boxDecorationDefault(
                                      color: addReceptionistCont.selectedGender.value.id == genders[index].id ? appColorPrimary : context.cardColor,
                                    ),
                                    child: Text(
                                      genders[index].name,
                                      style: secondaryTextStyle(
                                        color: addReceptionistCont.selectedGender.value.id == genders[index].id ? white : null,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addReceptionistCont.addressCont,
                      focus: addReceptionistCont.addressFocus,
                      nextFocus: addReceptionistCont.phoneFocus,
                      textFieldType: TextFieldType.MULTILINE,
                      minLines: 1,
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.address,
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                      suffix: commonLeadingWid(imgPath: Assets.iconsIcLocation, size: 12).paddingAll(16),
                    ),
                    16.height,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => AppTextField(
                            textStyle: primaryTextStyle(size: 12),
                            textFieldType: TextFieldType.OTHER,
                            controller: TextEditingController(text: "  +${addReceptionistCont.pickedPhoneCode.value.phoneCode}"),
                            focus: addReceptionistCont.phoneCodeFocus,
                            nextFocus: addReceptionistCont.phoneFocus,
                            errorThisFieldRequired: locale.value.thisFieldIsRequired,
                            readOnly: true,
                            onTap: () {
                              pickCountry(
                                context,
                                onSelect: (Country country) {
                                  addReceptionistCont.pickedPhoneCode(country);
                                  addReceptionistCont.phoneCodeCont.text = addReceptionistCont.pickedPhoneCode.value.phoneCode;
                                },
                              );
                            },
                            textAlign: TextAlign.center,
                            decoration: inputDecoration(
                              context,
                              hintText: "",
                              prefixIcon: Text(
                                addReceptionistCont.pickedPhoneCode.value.flagEmoji,
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
                          controller: addReceptionistCont.phoneCont,
                          focus: addReceptionistCont.phoneFocus,
                          nextFocus: addReceptionistCont.passwordFocus,
                          // maxLength: 10,
                          errorThisFieldRequired: locale.value.thisFieldIsRequired,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    16.height,
                    if (!isEdit) ...[
                      Focus(
                        onFocusChange: (value) {
                          addReceptionistCont.passContHasFocus(value);
                        },
                        child: AppTextField(
                          textStyle: primaryTextStyle(size: 12),
                          controller: addReceptionistCont.passwordCont,
                          focus: addReceptionistCont.passwordFocus,
                          onChanged: (val) => addReceptionistCont.checkPasswordRules(val),
                          nextFocus: addReceptionistCont.confirmPasswordFocus,
                          textFieldType: TextFieldType.PASSWORD,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return locale.value.passwordIsRequired;
                            } else if (value.length < 8) {
                              return locale.value.passwordTooShort;
                            } else if (!addReceptionistCont.hasSpecial.value ||
                                !addReceptionistCont.hasNumber.value ||
                                !addReceptionistCont.hasUppercase.value ||
                                !addReceptionistCont.hasLetter.value) {
                              return locale.value.passwordDoesNotMeetRequirements;
                            }
                            return null;
                          },
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: locale.value.password,
                          ),
                          suffixPasswordVisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEye, color: appColorPrimary, size: 12).paddingAll(14),
                          suffixPasswordInvisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, color: appColorPrimary, size: 12).paddingAll(14),
                        ),
                      ),
                      Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              6.height,
                              PasswordRuleItem(
                                isValid: addReceptionistCont.hasUppercase.value,
                                text: locale.value.passwordMustIncludeAtLeastOneCapitalCharacter,
                              ),
                              PasswordRuleItem(
                                isValid: addReceptionistCont.hasLetter.value,
                                text: locale.value.passwordMustIncludeAtLeastOneLowercaseCharacter,
                              ),
                              PasswordRuleItem(
                                isValid: addReceptionistCont.hasNumber.value,
                                text: locale.value.passwordMustIncludeAtLeastOneNumber,
                              ),
                              PasswordRuleItem(
                                isValid: addReceptionistCont.hasSpecial.value,
                                text: locale.value.passwordMustIncludeSpacialCharacter,
                              ),
                            ],
                          ).visible(addReceptionistCont.passContHasFocus.value &&
                              (!addReceptionistCont.hasUppercase.value || !addReceptionistCont.hasLetter.value || !addReceptionistCont.hasNumber.value || !addReceptionistCont.hasSpecial.value))),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(size: 12),
                        controller: addReceptionistCont.confirmPasswordCont,
                        // Optional
                        focus: addReceptionistCont.confirmPasswordFocus,
                        textFieldType: TextFieldType.PASSWORD,
                        obscureText: true,
                        decoration: inputDecoration(
                          context,
                          fillColor: context.cardColor,
                          filled: true,
                          hintText: locale.value.confirmNewPassword,
                        ),
                        suffixPasswordVisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEye, color: appColorPrimary, size: 12).paddingAll(14),
                        suffixPasswordInvisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, color: appColorPrimary, size: 12).paddingAll(14),
                      ),
                    ],
                    32.height,
                    AppButton(
                      width: Get.width,
                      text: locale.value.save,
                      color: appColorSecondary,
                      textStyle: appButtonTextStyleWhite,
                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                      onTap: () {
                        if (addReceptionistCont.addReqFormKey.currentState!.validate()) {
                          hideKeyboard(context);
                          addReceptionistCont.saveReceptionist();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
