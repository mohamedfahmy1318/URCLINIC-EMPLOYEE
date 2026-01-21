import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/auth/sign_in_sign_up/password_rule_item.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kivicare_clinic_admin/components/app_logo_widget.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import '../../../components/cached_image_widget.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../components/app_scaffold.dart';
import '../../../configs.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import '../../clinic/model/clinics_res_model.dart';
import '../../doctor/clinic_center/clinic_center_screen.dart';
import '../model/clinic_center_argument_model.dart';
import 'sign_up_controller.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: signUpController.isLoading,
      hasLeadingWidget: false,
      clipBehaviorSplitRegion: Clip.none,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SafeArea(
            child: AnimatedScrollView(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  locale.value.createYourAccount,
                  style: primaryTextStyle(size: 24),
                ),
                8.height,
                Text(
                  locale.value.registerYourAccountForBetterExperience,
                  style: secondaryTextStyle(size: 14),
                ),
                SizedBox(height: Get.height * 0.04),
                Form(
                  key: signUpController.signUpformKey,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height * 0.005),
                      AppTextField(
                        textStyle: primaryTextStyle(size: 12),
                        controller: signUpController.fisrtNameCont,
                        focus: signUpController.fisrtNameFocus,
                        nextFocus: signUpController.lastNameFocus,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(
                          context,
                          fillColor: context.cardColor,
                          filled: true,
                          hintText: locale.value.firstName,
                        ),
                        suffix: commonLeadingWid(
                          imgPath: Assets.navigationIcUserOutlined,
                          color: secondaryTextColor,
                          size: 12,
                        ).paddingAll(16),
                      ).paddingTop(16),
                      AppTextField(
                        textStyle: primaryTextStyle(size: 12),
                        controller: signUpController.lastNameCont,
                        focus: signUpController.lastNameFocus,
                        nextFocus: signUpController.emailFocus,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(
                          context,
                          fillColor: context.cardColor,
                          filled: true,
                          hintText: locale.value.lastName,
                        ),
                        suffix: commonLeadingWid(
                          imgPath: Assets.navigationIcUserOutlined,
                          color: secondaryTextColor,
                          size: 12,
                        ).paddingAll(16),
                      ).paddingTop(16),
                      Obx(
                        () => AppTextField(
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.emailCont,
                          focus: signUpController.emailFocus,
                          nextFocus: signUpController.passwordFocus,
                          textFieldType: TextFieldType.EMAIL_ENHANCED,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: locale.value.email,
                            errorText: signUpController.emailError.value.isNotEmpty ? signUpController.emailError.value : null,
                          ),
                          suffix: commonLeadingWid(
                            imgPath: Assets.iconsIcMail,
                            color: secondaryTextColor,
                            size: 12,
                          ).paddingAll(16),
                        ).paddingTop(16),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(
                            () => AppTextField(
                              textStyle: primaryTextStyle(size: 12),
                              textFieldType: TextFieldType.OTHER,
                              controller: TextEditingController(
                                text: "  +${signUpController.pickedPhoneCode.value.phoneCode}",
                              ),
                              focus: signUpController.mobileFocus,
                              nextFocus: signUpController.mobileFocus,
                              errorThisFieldRequired: locale.value.thisFieldIsRequired,
                              readOnly: true,
                              onTap: () {
                                pickCountry(
                                  context,
                                  onSelect: (Country country) {
                                    signUpController.pickedPhoneCode(country);
                                    signUpController.phoneCodeCont.text = signUpController.pickedPhoneCode.value.phoneCode;
                                  },
                                );
                              },
                              textAlign: TextAlign.center,
                              decoration: inputDecoration(
                                isShowLabel: false,
                                context,
                                hintText: signUpController.pickedPhoneCode.value.phoneCode.isNotEmpty ? "+${signUpController.pickedPhoneCode.value.phoneCode}" : "+91",
                                prefixIcon: Text(
                                  signUpController.pickedPhoneCode.value.flagEmoji,
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
                            controller: signUpController.mobileCont,
                            focus: signUpController.mobileFocus,
                            errorThisFieldRequired: locale.value.thisFieldIsRequired,
                            decoration: inputDecoration(
                              context,
                              hintText: locale.value.contactNumber,
                              fillColor: context.cardColor,
                              filled: true,
                            ),
                          ).expand(flex: 8),
                        ],
                      ).paddingTop(16),
                      16.height,
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
                                  signUpController.selectedGender(genders[index]);
                                  loginUserData.value.gender = signUpController.selectedGender.value.slug;
                                },
                                borderRadius: radius(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: boxDecorationDefault(
                                    color: signUpController.selectedGender.value.id == genders[index].id ? appColorPrimary : context.cardColor,
                                  ),
                                  child: Text(
                                    genders[index].name,
                                    style: secondaryTextStyle(
                                      color: signUpController.selectedGender.value.id == genders[index].id ? white : null,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      16.height,
                      Focus(
                        onFocusChange: (value) {
                          signUpController.passContHasFocus(value);
                        },
                        child: AppTextField(
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.passwordCont,
                          focus: signUpController.passwordFocus,
                          textFieldType: TextFieldType.PASSWORD,
                          obscureText: true,
                          onChanged: (val) => signUpController.checkPasswordRules(val),
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: locale.value.password,
                          ),
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
                          suffixPasswordVisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEye, size: 14).paddingAll(12),
                          suffixPasswordInvisibleWidget: commonLeadingWid(
                            imgPath: Assets.iconsIcEyeSlash,
                            size: 14,
                          ).paddingAll(12),
                        ),
                      ),
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
                        ).visible(signUpController.passContHasFocus.value),
                      ),
                      // User Role selection
                      Obx(
                        () => AppTextField(
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.userTypeCont,
                          focus: signUpController.userTypeFocus,
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          onTap: () async {
                            chooseEmployeeType(
                              context,
                              isLoading: signUpController.isLoading,
                              onChange: (p0) {
                                signUpController.selectedLoginRole(p0);
                                signUpController.userTypeCont.text = p0.roleName;
                              },
                            );
                          },
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            prefixIconConstraints: BoxConstraints.loose(const Size.square(60)),
                            prefixIcon: signUpController.selectedLoginRole.value.icon.isEmpty && signUpController.selectedLoginRole.value.id.isNegative
                                ? null
                                : CachedImageWidget(
                                    url: signUpController.selectedLoginRole.value.icon,
                                    color: appColorPrimary,
                                    height: 22,
                                    fit: BoxFit.cover,
                                    width: 22,
                                  ).paddingOnly(left: 12, top: 8, bottom: 8, right: 12),
                            hintText: locale.value.selectUserRole,
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 24,
                              color: darkGray.withValues(alpha: 0.5),
                            ),
                          ),
                        ).paddingTop(16),
                      ),
                      Obx(
                        () => AppTextField(
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.clinicCenterCont,
                          focus: signUpController.clinicCenterFocus,
                          nextFocus: signUpController.emailFocus,
                          textFieldType: TextFieldType.MULTILINE,
                          minLines: 1,
                          readOnly: true,
                          onTap: () {
                            if (signUpController.selectedLoginRole.value.id.isNegative) {
                              toast(locale.value.pleaseSelectRoleToRegister);
                            } else {
                              Get.to(
                                () => ClinicCenterScreen(),
                                arguments: ClinicCenterArgumentModel(
                                  isReceptionistRegister: signUpController.selectedLoginRole.value.userType.contains(EmployeeKeyConst.receptionist),
                                  isDoctorRegister: (signUpController.selectedLoginRole.value.userType.contains(EmployeeKeyConst.doctor) || signUpController.selectedLoginRole.value.userType.contains(EmployeeKeyConst.pharma)),
                                  selectedClinc: signUpController.selectedClinic.value,
                                ),
                              )?.then((value) {
                                if (value is ClinicData) {
                                  signUpController.selectClinics(clinic: value);
                                  signUpController.signUpformKey.currentState!.validate();
                                }
                              });
                            }
                          },
                          decoration: inputDecoration(
                            context,
                            hintText: locale.value.selectClinic,
                            fillColor: context.cardColor,
                            filled: true,
                            prefixIconConstraints: BoxConstraints.loose(const Size.square(60)),
                            prefixIcon: (signUpController.selectedClinic.value.clinicImage.isEmpty && signUpController.selectedClinic.value.id.isNegative)
                                ? null
                                : CachedImageWidget(
                                    url: signUpController.selectedClinic.value.clinicImage,
                                    height: 35,
                                    width: 35,
                                    firstName: signUpController.selectedClinic.value.name,
                                    fit: BoxFit.cover,
                                    circle: true,
                                  ).paddingOnly(left: 12, top: 8, bottom: 8, right: 12),
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 24,
                              color: darkGray.withValues(alpha: 0.5),
                            ),
                          ),
                        ).paddingTop(16).visible(!signUpController.selectedLoginRole.value.userType.contains(EmployeeKeyConst.vendor)),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Obx(
                                () => CheckboxListTile(
                                  checkColor: whiteColor,
                                  value: signUpController.isAcceptedTc.value,
                                  activeColor: appColorPrimary,
                                  visualDensity: VisualDensity.compact,
                                  dense: true,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  onChanged: (val) {
                                    signUpController.isAcceptedTc.value = !signUpController.isAcceptedTc.value;
                                  },
                                  checkboxShape: RoundedRectangleBorder(borderRadius: radius(0)),
                                  side: const BorderSide(
                                    color: secondaryTextColor,
                                    width: 1.5,
                                  ),
                                  title: RichTextWidget(
                                    list: [
                                      TextSpan(
                                        text: "${locale.value.iAgreeToThe} ",
                                        style: secondaryTextStyle(),
                                      ),
                                      TextSpan(
                                        text: locale.value.termsConditions,
                                        style: primaryTextStyle(
                                          color: appColorPrimary,
                                          size: 12,
                                          decoration: TextDecoration.underline,
                                          decorationColor: appColorPrimary,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            commonLaunchUrl(
                                              TERMS_CONDITION_URL,
                                              launchMode: LaunchMode.externalApplication,
                                            );
                                          },
                                      ),
                                      TextSpan(
                                        text: " ${locale.value.and} ",
                                        style: secondaryTextStyle(),
                                      ),
                                      TextSpan(
                                        text: locale.value.privacyPolicy,
                                        style: primaryTextStyle(
                                          color: appColorPrimary,
                                          size: 12,
                                          decoration: TextDecoration.underline,
                                          decorationColor: appColorPrimary,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            commonLaunchUrl(
                                              PRIVACY_POLICY_URL,
                                              launchMode: LaunchMode.externalApplication,
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ).expand(),
                            ],
                          ),
                        ],
                      ).paddingTop(16),
                      AppButton(
                        width: Get.width,
                        text: locale.value.signUp,
                        color: appColorSecondary,
                        textStyle: appButtonTextStyleWhite,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: radius(defaultAppButtonRadius / 2),
                        ),
                        onTap: () {
                          if (signUpController.signUpformKey.currentState!.validate()) {
                            signUpController.signUpformKey.currentState!.save();
                            signUpController.saveForm();
                          }
                        },
                      ).paddingTop(8),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 16),
                8.height,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(locale.value.alreadyHaveAnAccount, style: secondaryTextStyle()),
                    4.width,
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        locale.value.signIn,
                        style: boldTextStyle(
                          size: 12,
                          color: appColorSecondary,
                          decorationColor: appColorSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                16.height,
              ],
            ).paddingOnly(top: Get.height * 0.11),
          ),
          Positioned(
            width: Get.width,
            top: -Constants.appLogoSize / 2,
            child: const AppLogoWidget(),
          ),
        ],
      ),
    );
  }
}
