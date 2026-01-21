import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/app_primary_widget.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/components/bottom_selection_widget.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/doctor/model/commission_list_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/add_pharma_controller.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';
import '../auth/model/clinic_center_argument_model.dart';
import '../auth/sign_in_sign_up/password_rule_item.dart';
import '../clinic/model/clinics_res_model.dart';
import '../doctor/clinic_center/clinic_center_screen.dart';

class AddPharmaScreen extends StatelessWidget {
  final bool isEdit;
  final AddPharmaController controller = Get.put(AddPharmaController());

  AddPharmaScreen({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: isEdit ? locale.value.editPharma : locale.value.addNewPharma,
      isLoading: controller.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: AnimatedScrollView(
        controller: controller.scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
        children: [
          Form(
            key: controller.addPharmaForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImagePicker(context),
                _sectionTitle("Personal Details"),
                _buildPersonalDetails(context),
                _sectionTitle("Contact Detail"),
                _buildContactDetails(context),
                if (!isEdit) _buildPasswordFields(context),
                _sectionTitle("Pharma Details"),
                _buildPharmaDetails(context),
                _buildStatusSwitch(),
                16.height,
                _buildSaveButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🔹 Helper Widgets
  // ---------------------------------------------------------------------------

  Widget _buildImagePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.pharmaImage, style: boldTextStyle(size: 16)),
        12.height,
        Obx(() {
          final path = controller.imageFile.value.path;
          final networkImage = controller.selectedPharma.value.imageUrl;

          if (path.isEmpty && networkImage.isEmpty) {
            return AppPrimaryWidget(
              width: Get.width,
              constraints: BoxConstraints(minHeight: Get.height * 0.18),
              backgroundColor: context.cardColor,
              border: Border.all(color: borderColor, width: 0.8),
              borderRadius: defaultRadius,
              onTap: () => controller.showImagePicker(context),
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
            );
          } else {
            final imageUrl = path.isNotEmpty ? path : networkImage;
            return Center(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  CachedImageWidget(
                    url: imageUrl,
                    height: 110,
                    width: 110,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(defaultRadius),
                  Positioned(
                    top: 82,
                    left: 82,
                    child: GestureDetector(
                      onTap: () => controller.showImagePicker(context),
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
            );
          }
        }),
      ],
    );
  }

  Widget _buildPersonalDetails(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: controller.firstNameCont,
          focus: controller.firstNameFocus,
          nextFocus: controller.lastNameFocus,
          textFieldType: TextFieldType.NAME,
          isValidationRequired: true,
          errorThisFieldRequired: locale.value.thisFieldIsRequired,
          decoration: inputDecoration(context, hintText: locale.value.firstName, fillColor: context.cardColor, filled: true),
          suffix: commonLeadingWid(imgPath: Assets.navigationIcUserOutlined, color: secondaryTextColor, size: 12).paddingAll(16),
        ).paddingTop(16),
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: controller.lastNameCont,
          focus: controller.lastNameFocus,
          nextFocus: controller.emailFocus,
          textFieldType: TextFieldType.NAME,
          isValidationRequired: true,
          errorThisFieldRequired: locale.value.thisFieldIsRequired,
          decoration: inputDecoration(context, hintText: locale.value.lastName, fillColor: context.cardColor, filled: true),
          suffix: commonLeadingWid(imgPath: Assets.navigationIcUserOutlined, color: secondaryTextColor, size: 12).paddingAll(16),
        ).paddingTop(16),
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: controller.dobCont,
          focus: controller.dobFocus,
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) controller.dobCont.text = picked.formatDateDDMMYY();
          },
          textFieldType: TextFieldType.OTHER,
          decoration: inputDecoration(
            context,
            hintText: locale.value.dateOfBirth,
            fillColor: context.cardColor,
            filled: true,
            suffixIcon: const Icon(Icons.date_range, color: secondaryTextColor),
          ),
        ).paddingTop(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.value.gender, style: boldTextStyle()),
            8.height,
            Obx(
              () => Align(
                alignment: Alignment.centerLeft,
                child: HorizontalList(
                  itemCount: genders.length,
                  spacing: 16,
                  runSpacing: 16,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Obx(
                      () => InkWell(
                        onTap: () {
                          controller.selectedGender(genders[index]);
                        },
                        borderRadius: radius(),
                        child: Container(
                          decoration: boxDecorationDefault(
                            color: controller.selectedGender.value.id == genders[index].id ? appColorPrimary : context.cardColor,
                          ),
                          child: Text(
                            genders[index].name,
                            style: secondaryTextStyle(
                              color: controller.selectedGender.value.id == genders[index].id ? white : null,
                            ),
                          ).paddingSymmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ).paddingTop(16),
      ],
    );
  }

  Widget _buildContactDetails(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 2,
              child: Obx(() {
                return AppTextField(
                  textFieldType: TextFieldType.NUMBER,
                  textStyle: primaryTextStyle(size: 12),
                  controller: TextEditingController(text: " +${controller.pickedPhoneCode.value.phoneCode}"),
                  readOnly: true,
                  onTap: () => pickCountry(context, onSelect: (c) => controller.pickedPhoneCode(c)),
                  textAlign: TextAlign.center,
                  decoration: inputDecoration(
                    context,
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(controller.pickedPhoneCode.value.flagEmoji),
                        6.width,
                        Text(" +${controller.pickedPhoneCode.value.phoneCode}", style: primaryTextStyle(size: 12)),
                      ],
                    ).paddingOnly(left: 6, right: 6),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: dividerColor, size: 22),
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                );
              }).paddingTop(16),
            ),
            16.width,
            Expanded(
              flex: 5,
              child: AppTextField(
                textFieldType: TextFieldType.NUMBER,
                textStyle: primaryTextStyle(size: 12),
                controller: controller.phoneCont,
                focus: controller.phoneFocus,
                nextFocus: controller.addressFocus,
                isValidationRequired: true,
                errorThisFieldRequired: locale.value.thisFieldIsRequired,
                decoration: inputDecoration(context, hintText: locale.value.contactNumber, fillColor: context.cardColor, filled: true),
                suffix: commonLeadingWid(imgPath: Assets.iconsIcCall, color: secondaryTextColor, size: 12).paddingAll(16),
              ).paddingTop(16),
            ),
          ],
        ),

        // Phone number field

        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: controller.emailCont,
          focus: controller.emailFocus,
          nextFocus: controller.phoneFocus,
          textFieldType: TextFieldType.EMAIL_ENHANCED,
          isValidationRequired: true,
          errorThisFieldRequired: locale.value.thisFieldIsRequired,
          decoration: inputDecoration(context, hintText: locale.value.email, fillColor: context.cardColor, filled: true),
          suffix: commonLeadingWid(imgPath: Assets.iconsIcMail, color: secondaryTextColor, size: 12).paddingAll(16),
        ).paddingTop(16),
        AppTextField(
          textStyle: primaryTextStyle(size: 12),
          controller: controller.addressCont,
          focus: controller.addressFocus,
          textFieldType: TextFieldType.MULTILINE,
          maxLines: 3,
          decoration: inputDecoration(context, hintText: locale.value.address, fillColor: context.cardColor, filled: true),
        ).paddingTop(16),
      ],
    );
  }

  Widget _buildPasswordFields(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return Focus(
            onFocusChange: (value) {
              controller.passContHasFocus(value);
            },
            child: AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: controller.passwordCont,
              focus: controller.passWordFocus,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale.value.passwordIsRequired;
                } else if (value.length < 8) {
                  return locale.value.passwordTooShort;
                } else if (!controller.hasSpecial.value || !controller.hasNumber.value || !controller.hasUppercase.value || !controller.hasLetter.value) {
                  return locale.value.passwordDoesNotMeetRequirements;
                }
                return null;
              },
              onChanged: (val) => controller.checkPasswordRules(val),
              nextFocus: controller.confirmPasswordFocus,
              textFieldType: TextFieldType.PASSWORD,
              isValidationRequired: true,
              suffixIconColor: iconColor,
              errorThisFieldRequired: locale.value.thisFieldIsRequired,
              decoration: inputDecoration(context, hintText: locale.value.password, fillColor: context.cardColor, filled: true),
            ).paddingTop(16),
          );
        }),
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              6.height,
              PasswordRuleItem(
                isValid: controller.hasUppercase.value,
                text: locale.value.passwordMustIncludeAtLeastOneCapitalCharacter,
              ),
              PasswordRuleItem(
                isValid: controller.hasLetter.value,
                text: locale.value.passwordMustIncludeAtLeastOneLowercaseCharacter,
              ),
              PasswordRuleItem(
                isValid: controller.hasNumber.value,
                text: locale.value.passwordMustIncludeAtLeastOneNumber,
              ),
              PasswordRuleItem(
                isValid: controller.hasSpecial.value,
                text: locale.value.passwordMustIncludeSpacialCharacter,
              ),
            ],
          ).visible(controller.passContHasFocus.value),
        ),
        Obx(() {
          return AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: controller.confirmPasswordCont,
            focus: controller.confirmPasswordFocus,
            textFieldType: TextFieldType.PASSWORD,
            isValidationRequired: true,
            errorThisFieldRequired: locale.value.thisFieldIsRequired,
            decoration: inputDecoration(context, hintText: "${locale.value.confirm} ${locale.value.password}", fillColor: context.cardColor, filled: true),
            suffixIconColor: iconColor,
          ).paddingTop(16);
        })
      ],
    );
  }

  Widget _buildPharmaDetails(BuildContext context) {
    return Column(
      children: [
        Obx(
          () {
            final selected = controller.selectedClinic.value;

            return AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: controller.clinicCenterCont,
              focus: controller.clinicCenterFocus,
              textFieldType: TextFieldType.MULTILINE,
              minLines: 1,
              readOnly: true,
              onTap: () {
                Get.to(
                  () => ClinicCenterScreen(),
                  arguments: ClinicCenterArgumentModel(
                    isReceptionistRegister: false,
                    isDoctorRegister: false,
                    selectedClinc: selected ?? ClinicData(),
                  ),
                )?.then((value) {
                  if (value is ClinicData) {
                    controller.selectedClinic.value = value;
                    controller.clinicCenterCont.text = value.name;
                  }
                });
              },
              decoration: inputDecoration(
                context,
                hintText: locale.value.selectClinic,
                fillColor: context.cardColor,
                filled: true,
                prefixIconConstraints: BoxConstraints.loose(const Size.square(60)),

                prefixIcon: (selected == null || selected.clinicImage.isEmpty || selected.id.isNegative)
                    ? null
                    : CachedImageWidget(
                        url: selected.clinicImage,
                        height: 35,
                        width: 35,
                        firstName: selected.name,
                        fit: BoxFit.cover,
                        circle: true,
                      ).paddingOnly(left: 12, top: 8, bottom: 8, right: 12),

                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 24,
                  color: Colors.grey,
                ),
              ),
            ).paddingTop(16);
          },
        ),

        ///add commission selection here
        Obx(() {
          return AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: controller.commissionCont,
            focus: controller.commissionFocus,
            textFieldType: TextFieldType.NAME,
            readOnly: true,
            onTap: () async {
              //  controller.getCommission();
              serviceCommonBottomSheet(
                context,
                onSheetClose: (p0) {
                  hideKeyboard(context);
                },
                child: Obx(
                  () => BottomSelectionSheet(
                    title: locale.value.chooseCommission,
                    hintText: locale.value.searchForCommission,
                    hasError: controller.hasErrorFetchingCommission.value,
                    isEmpty: controller.isShowFullList ? controller.commissionList.isEmpty : controller.commissionFilterList.isEmpty,
                    errorText: controller.errorMessageCommission.value,
                    isLoading: controller.isLoading,
                    noDataTitle: locale.value.noCommissionFound,
                    onRetry: () {
                      controller.getCommission();
                    },
                    listWidget: Obx(
                      () => commissionListWid(
                        controller.isShowFullList ? controller.commissionList : controller.commissionFilterList,
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
          ).paddingTop(16);
        }),
      ],
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
              controller.setCommissionContValue(commissionList: list);
              finish(context);
            },
          ),
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }

  Widget _buildStatusSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(locale.value.status, style: secondaryTextStyle(size: 14)),
        Obx(() => Transform.scale(
              scale: 0.75,
              child: Switch(
                value: controller.status.value,
                onChanged: controller.status.call,
                activeTrackColor: switchActiveTrackColor,
                activeThumbColor: switchActiveColor,
                inactiveTrackColor: switchColor.withAlpha(50),
              ),
            )),
      ],
    ).paddingTop(16);
  }

  Widget _buildSaveButton(BuildContext context) {
    return AppButton(
      width: Get.width,
      color: appColorPrimary,
      onTap: () {
        hideKeyboard(context);
        controller.savePharma(isEdit: isEdit);
      },
      child: Text(isEdit ? locale.value.update : locale.value.save, style: primaryTextStyle(color: white)),
    );
  }

  Widget _sectionTitle(String title) => Text(title, style: boldTextStyle(size: 16)).paddingTop(16);
}
