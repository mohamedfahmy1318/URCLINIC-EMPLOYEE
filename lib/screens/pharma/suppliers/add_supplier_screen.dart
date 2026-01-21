import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../components/app_primary_widget.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/bottom_selection_widget.dart';
import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import 'controller/add_supplier_controller.dart';

class AddSupplierScreen extends StatelessWidget {
  final bool isEdit;

  AddSupplierScreen({super.key, this.isEdit = false});

  final AddSupplierController addSupplierCont = Get.put(AddSupplierController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: isEdit ? locale.value.editSupplier : locale.value.addNewSupplier,
      isLoading: addSupplierCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: AnimatedScrollView(
        controller: addSupplierCont.scrollController,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 16),
        children: [
          Form(
            key: addSupplierCont.addSupplierFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.value.supplierImage, style: boldTextStyle(size: 16)),
                12.height,
                Obx(
                  () => addSupplierCont.imageFile.value.path.isNotEmpty || addSupplierCont.doctorImage.value.isNotEmpty
                      ? Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              CachedImageWidget(
                                url: addSupplierCont.imageFile.value.path.isNotEmpty ? addSupplierCont.imageFile.value.path : addSupplierCont.doctorImage.value,
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
                                    addSupplierCont.showImagePicker(context);
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
                                addSupplierCont.showImagePicker(context);
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
                Text(locale.value.personalDetails, style: boldTextStyle(size: 16)).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addSupplierCont.firstNameCont,
                  focus: addSupplierCont.firstNameFocus,
                  nextFocus: addSupplierCont.lastNameFocus,
                  textFieldType: TextFieldType.NAME,
                  errorThisFieldRequired: locale.value.thisFieldIsRequired,
                  isValidationRequired: true,
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
                  controller: addSupplierCont.lastNameCont,
                  focus: addSupplierCont.lastNameFocus,
                  nextFocus: addSupplierCont.emailFocus,
                  textFieldType: TextFieldType.NAME,
                  errorThisFieldRequired: locale.value.thisFieldIsRequired,
                  isValidationRequired: true,
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
                  controller: addSupplierCont.emailCont,
                  focus: addSupplierCont.emailFocus,
                  nextFocus: addSupplierCont.phoneFocus,
                  textFieldType: TextFieldType.EMAIL_ENHANCED,
                  errorThisFieldRequired: locale.value.thisFieldIsRequired,
                  isValidationRequired: true,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.email,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcMail, color: secondaryTextColor, size: 12).paddingAll(16),
                ).paddingTop(16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => AppTextField(
                        textStyle: primaryTextStyle(size: 12),
                        textFieldType: TextFieldType.OTHER,
                        controller: TextEditingController(text: "  +${addSupplierCont.pickedPhoneCode.value.phoneCode}"),
                        focus: addSupplierCont.phoneCodeFocus,
                        nextFocus: addSupplierCont.phoneFocus,
                        errorThisFieldRequired: locale.value.thisFieldIsRequired,
                        readOnly: true,
                        onTap: () {
                          pickCountry(context, onSelect: (Country country) {
                            addSupplierCont.pickedPhoneCode(country);
                            addSupplierCont.phoneCodeCont.text = country.phoneCode;
                          });
                        },
                        textAlign: TextAlign.center,
                        decoration: inputDecoration(
                          context,
                          hintText: "",
                          prefixIcon: Row(
                            children: [
                              Text(
                                addSupplierCont.pickedPhoneCode.value.flagEmoji,
                              ),
                              6.width,
                              Text(
                                " +${addSupplierCont.pickedPhoneCode.value.phoneCode}",
                                style: primaryTextStyle(size: 12),
                              ),
                            ],
                          ).paddingOnly(left: 6, right: 6),
                          // prefixIconConstraints: BoxConstraints.tight(const Size(24, 24)),
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: dividerColor,
                            size: 22,
                          ).paddingOnly(right: 32),
                          suffixIconConstraints: BoxConstraints.tight(const Size(24, 24)),
                          fillColor: context.cardColor,
                          filled: true,
                        ),
                      ),
                    ).expand(flex: 3),
                    8.width,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      textFieldType: TextFieldType.PHONE,
                      controller: addSupplierCont.phoneCont,
                      focus: addSupplierCont.phoneFocus,
                      nextFocus: addSupplierCont.supplierTypeFocus,
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
                ).paddingTop(16),
                // Medicine Form Selection
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addSupplierCont.supplierTypeCont,
                  focus: addSupplierCont.supplierTypeFocus,
                  nextFocus: addSupplierCont.paymentTermsFocus,
                  textFieldType: TextFieldType.NAME,
                  errorThisFieldRequired: locale.value.thisFieldIsRequired,
                  isValidationRequired: true,
                  readOnly: true,
                  onTap: () async {
                    serviceCommonBottomSheet(
                      context,
                      child: Obx(
                        () => BottomSelectionSheet(
                          title: locale.value.chooseSupplierType,
                          hintText: locale.value.searchForSupplierType,
                          hasError: addSupplierCont.hasErrorFetchingSupplierType.value,
                          isEmpty: !addSupplierCont.isSupplierTypesLoading.value && addSupplierCont.supplierTypes.isEmpty,
                          errorText: addSupplierCont.errorMessageSupplierType.value,
                          isLoading: addSupplierCont.isSupplierTypesLoading,
                          searchApiCall: (p0) {
                            addSupplierCont.getSupplierTypeList(searchTxt: p0);
                          },
                          onRetry: () {
                            addSupplierCont.getSupplierTypeList();
                          },
                          listWidget: Obx(() => supplierTypeListWid(addSupplierCont.supplierTypes).expand()),
                        ),
                      ),
                    );
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectSupplierType,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: commonLeadingWid(imgPath: Assets.iconsIcDropdown, color: iconColor.withValues(alpha: 0.6), size: 10).scale(scale: 0.8, alignment: Alignment.centerRight).paddingSymmetric(horizontal: 16),
                  ),
                ).paddingTop(16),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addSupplierCont.paymentTermsCont,
                  focus: addSupplierCont.paymentTermsFocus,
                  errorThisFieldRequired: locale.value.thisFieldIsRequired,
                  isValidationRequired: true,
                  textFieldType: TextFieldType.NUMBER,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.paymentTermsInDays,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcTotalPayout, color: iconColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
                ).paddingTop(16),
                8.height,

                ///Add field to select pharmacy from list of pharmacy if user is super admin
                if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor))
                  Obx(
                    () => AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      readOnly: true,
                      focus: addSupplierCont.selectedPharmacyNameFocus,
                      controller: addSupplierCont.selectedPharmacyNameCont,
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.selectPharma,
                        fillColor: context.cardColor,
                        filled: true,
                      ).copyWith(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        suffixIcon: commonLeadingWid(
                          imgPath: Assets.iconsIcDropdown,
                          color: iconColor.withValues(alpha: 0.6),
                          size: 8,
                        ).paddingAll(17),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(borderRadius: radius()),
                          builder: (_) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: addSupplierCont.pharmaList.map((pharma) {
                                  return ListTile(
                                    title: Text(pharma.fullName.validate(), style: primaryTextStyle(size: 14)),
                                    onTap: () {
                                      try {
                                        if (addSupplierCont.selectedPharmacyId != null) {
                                          addSupplierCont.selectedPharmacyId?.value = pharma.id.toString();
                                        }
                                      } catch (_) {}
                                      addSupplierCont.selectedPharmacyNameCont.text = pharma.fullName.validate();
                                      Get.back();
                                    },
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locale.value.thisFieldIsRequired;
                        }
                        return null;
                      },
                      textFieldType: TextFieldType.OTHER,
                    ).paddingTop(16),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.value.status,
                      style: secondaryTextStyle(size: 14),
                    ),

                    ///switch always show off
                    Obx(() {
                      return Transform.scale(
                        scale: 0.75,
                        child: Switch(
                          activeTrackColor: switchActiveTrackColor,
                          value: addSupplierCont.status.value,
                          activeThumbColor: switchActiveColor,
                          inactiveTrackColor: switchColor.withAlpha(50),
                          onChanged: (bool value) {
                            addSupplierCont.status(value);
                          },
                        ),
                      );
                    })
                  ],
                ),
                16.height,
                AppButton(
                  width: Get.width,
                  color: appColorPrimary,
                  onTap: () {
                    hideKeyboard(context);
                    if (!addSupplierCont.isLoading.value) {
                      if (addSupplierCont.imageFile.value.path.isNotEmpty || addSupplierCont.doctorImage.isNotEmpty) {
                        if (addSupplierCont.addSupplierFormKey.currentState!.validate()) {
                          addSupplierCont.addSupplierFormKey.currentState!.save();
                          addSupplierCont.saveSupplier();
                        }
                      } else {
                        toast(locale.value.pleaseSelectAnSupplierImage);
                        addSupplierCont.showImagePicker(context);
                      }
                    }
                  },
                  child: Text(addSupplierCont.isEdit.value ? locale.value.update : locale.value.save, style: primaryTextStyle(color: white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget to display the list of medicine forms
  Widget supplierTypeListWid(List<SupplierType> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].name,
          titleTextStyle: primaryTextStyle(size: 14),
          onTap: () async {
            hideKeyboard(context);
            addSupplierCont.selectedSupplierType(list[index]);
            addSupplierCont.supplierTypeCont.text = list[index].name;
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}
