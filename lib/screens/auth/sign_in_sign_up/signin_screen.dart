import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import '../../../components/app_logo_widget.dart';
import '../../../components/app_scaffold.dart';
import '../../../configs.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';
import '../model/login_roles_model.dart';
import 'sign_in_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../password/forget_password_screen.dart';
import 'signup_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: signInController.isLoading,
      hasLeadingWidget: false,
      clipBehaviorSplitRegion: Clip.none,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedScrollView(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                locale.value.chooseYourRole,
                style: boldTextStyle(size: 22),
              ),
              8.height,
              Text(
                '${locale.value.welcomeBackToThe} $APP_NAME',
                style: secondaryTextStyle(size: 14),
              ),
              SizedBox(height: Get.height * 0.05),
              Form(
                key: signInController.signInformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppTextField(
                      title: locale.value.email,
                      textStyle: primaryTextStyle(size: 12),
                      controller: signInController.emailCont,
                      focus: signInController.emailFocus,
                      nextFocus: signInController.passwordFocus,
                      textFieldType: TextFieldType.EMAIL_ENHANCED,
                      decoration: inputDecoration(
                        isShowLabel: false,
                        context,
                        fillColor: context.cardColor,
                        filled: true,
                        hintText: locale.value.email,
                      ),
                      suffix: commonLeadingWid(
                              imgPath: Assets.iconsIcMail,
                              color: secondaryTextColor,
                              size: 12)
                          .paddingAll(16),
                    ),
                    16.height,
                    Text(locale.value.password, style: primaryTextStyle()),
                    8.height,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: signInController.passwordCont,
                      focus: signInController.passwordFocus,
                      // Optional
                      textFieldType: TextFieldType.PASSWORD,
                      obscureText: true,
                      decoration: inputDecoration(
                        isShowLabel: false,
                        context,
                        fillColor: context.cardColor,
                        filled: true,
                        hintText: locale.value.password,
                      ),
                      suffixPasswordVisibleWidget: commonLeadingWid(
                              imgPath: Assets.iconsIcEye,
                              color: appColorPrimary,
                              size: 12)
                          .paddingAll(14),
                      suffixPasswordInvisibleWidget: commonLeadingWid(
                              imgPath: Assets.iconsIcEyeSlash,
                              color: appColorPrimary,
                              size: 12)
                          .paddingAll(14),
                    ),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => CheckboxListTile(
                            checkColor: whiteColor,
                            value: signInController.isRememberMe.value,
                            activeColor: appColorPrimary,
                            visualDensity: VisualDensity.compact,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) async {
                              signInController.toggleSwitch();
                            },
                            checkboxShape:
                                RoundedRectangleBorder(borderRadius: radius(0)),
                            side: const BorderSide(
                                color: secondaryTextColor, width: 1.5),
                            title: Text(
                              locale.value.rememberMe,
                              style: secondaryTextStyle(color: darkGrayGeneral),
                            ),
                          ),
                        ).expand(),
                        TextButton(
                          onPressed: () {
                            Get.to(() => ForgetPassword());
                          },
                          child: Text(
                            locale.value.forgotPassword,
                            style: primaryTextStyle(
                              size: 12,
                              color: appColorPrimary,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                              decorationColor: appColorPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).paddingSymmetric(horizontal: 16),
              SizedBox(height: Get.height * 0.03),
              if (shouldShowDemoCredentials)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    chooseEmployeeType(
                      context,
                      isLoading: signInController.isLoading,
                      onChange: (p0) {
                        if (shouldShowDemoCredentials) {
                          signInController.emailCont.text = p0.email;
                          signInController.passwordCont.text = p0.password;

                          hideKeyboard(context);
                        } else {
                          signInController.emailCont.text = '';
                          signInController.passwordCont.text = '';
                          signInController.isRememberMe.value = false;
                        }
                        signInController.selectedLoginRole(p0);
                      },
                    );
                  },
                  child: Text(
                    locale.value.demoAccounts,
                    style: primaryTextStyle(
                      size: 14,
                      color: appColorPrimary,
                      decoration: TextDecoration.underline,
                      decorationColor: appColorPrimary,
                    ),
                  ).paddingSymmetric(horizontal: 8),
                ).paddingBottom(16).visible(shouldShowDemoCredentials),
              Column(
                children: [
                  Row(
                    children: [
                      AppButton(
                        height: 54,
                        text: locale.value.signIn,
                        color: appColorSecondary,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: radius(defaultAppButtonRadius / 2)),
                        textStyle: appButtonTextStyleWhite,
                        onTap: () {
                          if (signInController.signInformKey.currentState!
                              .validate()) {
                            signInController.signInformKey.currentState!.save();
                            signInController.saveForm();
                          }
                        },
                      ).expand(),
                    ],
                  ),
                  8.height,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(locale.value.notAMember,
                          style: secondaryTextStyle()),
                      4.width,
                      InkWell(
                        onTap: () {
                          Get.to(() => SignUpScreen());
                          signInController.signInformKey.currentState?.reset();
                        },
                        child: Text(
                          locale.value.signUp,
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
              ).paddingSymmetric(horizontal: 16),
              SizedBox(height: Get.height * 0.01),
              Wrap(
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                alignment: WrapAlignment.center,
                children: loginRoles
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          signInController.selectedLoginRole(e);
                        },
                        child: Obx(
                          () => RoleComponent(
                            loginUserRole: e,
                            isSelected:
                                signInController.selectedLoginRole.value.id ==
                                    e.id,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: Get.height * 0.03),
            ],
          ).paddingOnly(top: Get.height * 0.11),
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

class RoleComponent extends StatelessWidget {
  final LoginRoleData loginUserRole;
  final bool isSelected;

  const RoleComponent(
      {super.key, required this.loginUserRole, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: boxDecorationDefault(
          color: isSelected ? appColorPrimary : context.cardColor,
          shape: BoxShape.rectangle,
          borderRadius: radius(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedImageWidget(
            url: loginUserRole.icon,
            height: 15,
            fit: BoxFit.fitHeight,
            color: isSelected ? white : textSecondaryColorGlobal,
          ),
          8.width,
          Text(
            loginUserRole.roleName,
            style: boldTextStyle(
                size: 14, color: isSelected ? white : textSecondaryColorGlobal),
          ),
        ],
      ),
    );
  }
}

void chooseEmployeeType(BuildContext context,
    {RxBool? isLoading,
    required Function(LoginRoleData) onChange,
    bool isFromDemoAccountTap = false}) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      ),
      child: ListView.separated(
        itemCount: loginRoles.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SettingItemWidget(
            title: loginRoles[index].roleName,
            titleTextStyle: primaryTextStyle(size: 14),
            leading: CachedImageWidget(
                url: loginRoles[index].icon,
                color: appColorPrimary,
                height: 22,
                fit: BoxFit.fitHeight,
                width: 22),
            onTap: () {
              onChange(loginRoles[index]);
              Get.back();
            },
          );
        },
        separatorBuilder: (context, index) =>
            commonDivider.paddingSymmetric(vertical: 6),
      ),
    ),
  );
}
