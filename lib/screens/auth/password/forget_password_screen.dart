import 'package:get/get.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import 'forget_pass_controller.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final ForgetPasswordController forgetPassController = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: forgetPassController.isLoading,
      appBartitleText: locale.value.forgotPassword,
      appBarVerticalSize: Get.height * 0.12,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80, top: 46),
              child: Form(
                key: forgetPassController.forgotPassFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Get.width * 0.8,
                      child: Text(
                        locale.value.resetYourPassword,
                        textAlign: TextAlign.center,
                        style: primaryTextStyle(size: 18),
                      ),
                    ),
                    16.height,
                    SizedBox(
                      width: Get.width * 0.8,
                      child: Text(
                        locale.value.enterYourEmailAddressToResetYourNewPassword,
                        textAlign: TextAlign.center,
                        style: secondaryTextStyle(),
                      ),
                    ),
                    32.height,
                    CachedImageWidget(
                      url: Assets.imagesForgotPassBg,
                      height: Get.height * 0.25,
                      width: Get.height * 0.25,
                      fit: BoxFit.contain,
                    ),
                    32.height,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: forgetPassController.emailCont,
                      textFieldType: TextFieldType.EMAIL_ENHANCED,
                      errorThisFieldRequired: locale.value.emailRequired,
                      decoration: inputDecoration(
                        context,
                        fillColor: context.cardColor,
                        filled: true,
                        hintText: locale.value.email,
                      ),
                      suffix: commonLeadingWid(imgPath: Assets.iconsIcMail, color: secondaryTextColor, size: 12).paddingAll(16),
                    ),
                    64.height,
                    AppButton(
                      width: Get.width,
                      text: locale.value.sendCode,
                      color: appColorSecondary,
                      textStyle: appButtonTextStyleWhite,
                      onTap: () {
                        if (forgetPassController.forgotPassFormKey.currentState!.validate()) {
                          forgetPassController.forgotPassFormKey.currentState!.save();
                          forgetPassController.saveForm();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
