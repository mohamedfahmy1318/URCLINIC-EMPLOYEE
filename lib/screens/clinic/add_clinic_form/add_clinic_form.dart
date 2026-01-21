import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/clinic/add_clinic_form/add_clinic_controller.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../components/app_primary_widget.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/bottom_selection_widget.dart';
import '../../../components/cached_image_widget.dart';
import '../../../components/chat_gpt_loder.dart';
import '../../../components/decimal_input_formater.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import 'model/city_list_response.dart';
import 'model/country_list_response.dart';
import 'model/specialization_resp.dart';
import 'model/state_list_response.dart';

class AddClinicForm extends StatelessWidget {
  final bool isEdit;

  AddClinicForm({super.key, this.isEdit = false});

  final AddClinicController addClinicCont = Get.put(AddClinicController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: isEdit ? locale.value.editClinic : locale.value.addClinic,
      isLoading: addClinicCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: AnimatedScrollView(
        controller: addClinicCont.scrollController,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 16),
        children: [
          Form(
            key: addClinicCont.addClinicformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.value.clinicImage, style: boldTextStyle(size: 16)),
                12.height,
                Obx(
                  () => addClinicCont.imageFile.value.path.isNotEmpty || addClinicCont.clinicImage.value.isNotEmpty
                      ? Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              CachedImageWidget(
                                url: addClinicCont.imageFile.value.path.isNotEmpty ? addClinicCont.imageFile.value.path : addClinicCont.clinicImage.value,
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
                                    addClinicCont.showBottomSheet(context);
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
                                addClinicCont.showBottomSheet(context);
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
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addClinicCont.clinicNameCont,
                  focus: addClinicCont.clinicNameFocus,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.clinicName,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcNursingHome, color: iconColor, size: 12).paddingAll(16),
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addClinicCont.emailCont,
                  focus: addClinicCont.emailFocus,
                  textFieldType: TextFieldType.EMAIL,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.email,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcMail, color: iconColor, size: 12).paddingAll(16),
                ),
                16.height,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => AppTextField(
                        textStyle: primaryTextStyle(size: 12),
                        textFieldType: TextFieldType.OTHER,
                        controller: TextEditingController(text: "  +${addClinicCont.pickedPhoneCode.value.phoneCode}"),
                        focus: addClinicCont.clinicPhoneCodeFocus,
                        nextFocus: addClinicCont.clinicPhoneFocus,
                        errorThisFieldRequired: locale.value.thisFieldIsRequired,
                        readOnly: true,
                        onTap: () {
                          pickCountry(
                            context,
                            onSelect: (Country country) {
                              addClinicCont.pickedPhoneCode(country);
                              addClinicCont.clinicPhoneCodeCont.text = addClinicCont.pickedPhoneCode.value.phoneCode;
                            },
                          );
                        },
                        textAlign: TextAlign.center,
                        decoration: inputDecoration(
                          context,
                          hintText: "",
                          prefixIcon: Text(
                            addClinicCont.pickedPhoneCode.value.flagEmoji,
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
                      controller: addClinicCont.clinicPhoneCont,
                      focus: addClinicCont.clinicPhoneFocus,
                      errorThisFieldRequired: locale.value.thisFieldIsRequired,
                      // maxLength: 10,
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.contactNumber,
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                    ).expand(flex: 8),
                  ],
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addClinicCont.specializationCont,
                  focus: addClinicCont.specializationFocus,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return locale.value.thisFieldIsRequired;
                    }
                    return null;
                  },
                  onTap: () async {
                    addClinicCont.getSpecializationList();
                    serviceCommonBottomSheet(
                      context,
                      child: Obx(
                        () => BottomSelectionSheet(
                          title: locale.value.chooseSpecialization,
                          hintText: locale.value.searchForSpecialization,
                          hasError: addClinicCont.hasErrorFetchingSpecialization.value,
                          isEmpty: !addClinicCont.isLoading.value && addClinicCont.specializationList.isEmpty,
                          errorText: addClinicCont.errorMessageSpecialization.value,
                          isLoading: addClinicCont.isLoading,
                          searchApiCall: (p0) {
                            addClinicCont.getSpecializationList(searchTxt: p0);
                          },
                          onRetry: () {
                            addClinicCont.getSpecializationList();
                          },
                          listWidget: Obx(
                            () => specializationListWid(addClinicCont.specializationList).expand(),
                          ),
                        ),
                      ),
                    );
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.specialization,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: dividerColor,
                      size: 22,
                    ),
                  ),
                ),
                16.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(locale.value.timeSlot, style: primaryTextStyle()),
                    8.height,
                    Obx(
                      () => HorizontalList(
                        itemCount: addClinicCont.timeSloteList.length,
                        spacing: 16,
                        runSpacing: 16,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Obx(
                            () => InkWell(
                              onTap: () {
                                addClinicCont.selectTimeSlot(addClinicCont.timeSloteList[index]);
                              },
                              borderRadius: radius(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: boxDecorationDefault(
                                  color: addClinicCont.selectTimeSlot.value.id == addClinicCont.timeSloteList[index].id ? appColorPrimary : context.cardColor,
                                ),
                                child: Text(
                                  addClinicCont.timeSloteList[index].name,
                                  style: secondaryTextStyle(
                                    color: addClinicCont.selectTimeSlot.value.id == addClinicCont.timeSloteList[index].id ? white : null,
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
                  textFieldType: TextFieldType.NAME,
                  controller: addClinicCont.addressCont,
                  nextFocus: addClinicCont.descriptionFocus,
                  focus: addClinicCont.addressFocus,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.address,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                ),
                16.height,
                Row(
                  children: [
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addClinicCont.countryCont,
                      focus: addClinicCont.countryFocus,
                      textFieldType: TextFieldType.NAME,
                      readOnly: true,
                      onTap: () async {
                        serviceCommonBottomSheet(
                          context,
                          child: Obx(
                            () => BottomSelectionSheet(
                              title: locale.value.chooseCountry,
                              hintText: locale.value.searchForCountry,
                              hasError: addClinicCont.hasErrorFetchingCountry.value,
                              isEmpty: !addClinicCont.isLoading.value && addClinicCont.countryList.isEmpty,
                              errorText: addClinicCont.errorMessageCountry.value,
                              isLoading: addClinicCont.isLoading,
                              searchApiCall: (p0) {
                                addClinicCont.getCountry(searchTxt: p0);
                              },
                              onRetry: () {
                                addClinicCont.getCountry();
                              },
                              listWidget: Obx(
                                () => countryListWid(addClinicCont.countryList).expand(),
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
                      controller: addClinicCont.stateCont,
                      focus: addClinicCont.stateFocus,
                      textFieldType: TextFieldType.NAME,
                      readOnly: true,
                      onTap: () async {
                        serviceCommonBottomSheet(
                          context,
                          child: Obx(
                            () => BottomSelectionSheet(
                              title: locale.value.chooseState,
                              hintText: locale.value.searchForState,
                              hasError: addClinicCont.hasErrorFetchingState.value,
                              isEmpty: !addClinicCont.isLoading.value && addClinicCont.stateList.isEmpty,
                              errorText: addClinicCont.errorMessageState.value,
                              isLoading: addClinicCont.isLoading,
                              searchApiCall: (p0) {
                                addClinicCont.getStates(countryId: addClinicCont.selectedCountry.value.id, searchTxt: p0);
                              },
                              onRetry: () {
                                addClinicCont.getStates(countryId: addClinicCont.selectedCountry.value.id);
                              },
                              listWidget: Obx(
                                () => stateListWid(addClinicCont.stateList).expand(),
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
                16.height,
                Row(
                  children: [
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addClinicCont.cityCont,
                      focus: addClinicCont.cityFocus,
                      textFieldType: TextFieldType.NAME,
                      readOnly: true,
                      onTap: () async {
                        serviceCommonBottomSheet(
                          context,
                          child: Obx(
                            () => BottomSelectionSheet(
                              title: locale.value.chooseCity,
                              hintText: locale.value.searchForCity,
                              hasError: addClinicCont.hasErrorFetchingCity.value,
                              isEmpty: !addClinicCont.isLoading.value && addClinicCont.cityList.isEmpty,
                              errorText: addClinicCont.errorMessageCity.value,
                              isLoading: addClinicCont.isLoading,
                              searchApiCall: (p0) {
                                addClinicCont.getCity(stateId: addClinicCont.selectedState.value.id, searchTxt: p0);
                              },
                              onRetry: () {
                                addClinicCont.getCity(stateId: addClinicCont.selectedState.value.id);
                              },
                              listWidget: Obx(
                                () => cityListWid(addClinicCont.cityList).expand(),
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
                      controller: addClinicCont.postalCont,
                      focus: addClinicCont.postalFocus,
                      nextFocus: addClinicCont.addressFocus,
                      isValidationRequired: false,
                      decoration: inputDecoration(
                        context,
                        hintText: locale.value.postalCode,
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                    ).expand(),
                  ],
                ),
                16.height,
                Row(
                  children: [
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addClinicCont.latCont,
                      focus: addClinicCont.latFocus,
                      nextFocus: addClinicCont.lonFocus,
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
                    ).expand(),
                    16.width,
                    AppTextField(
                      textStyle: primaryTextStyle(size: 12),
                      controller: addClinicCont.lonCont,
                      focus: addClinicCont.lonFocus,
                      nextFocus: addClinicCont.descriptionFocus,
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
                    ).expand(),
                  ],
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addClinicCont.descriptionCont,
                  focus: addClinicCont.descriptionFocus,
                  minLines: 3,
                  nextFocus: addClinicCont.descriptionFocus,
                  textFieldType: TextFieldType.MULTILINE,
                  enableChatGPT: appConfigs.value.enableChatGpt.getBoolInt(),
                  promptFieldInputDecorationChatGPT: inputDecoration(context, hintText: locale.value.writeHere, fillColor: context.scaffoldBackgroundColor, filled: true),
                  testWithoutKeyChatGPT: appConfigs.value.testWithoutKey.getBoolInt(),
                  loaderWidgetForChatGPT: const ChatGPTLoadingWidget(),
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.description,
                    fillColor: context.cardColor,
                    filled: true,
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
                          value: addClinicCont.status.value,
                          activeThumbColor: switchActiveColor,
                          inactiveTrackColor: switchColor.withValues(alpha: 0.2),
                          onChanged: (bool value) {
                            addClinicCont.status(value);
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
                    /// Open Gallery
                    hideKeyboard(context);
                    if (!addClinicCont.isLoading.value) {
                      if (addClinicCont.imageFile.value.path.isNotEmpty || addClinicCont.clinicImage.isNotEmpty) {
                        if (addClinicCont.addClinicformKey.currentState!.validate()) {
                          addClinicCont.addClinicformKey.currentState!.save();
                          addClinicCont.addClinic();
                        }
                      } else {
                        toast(locale.value.pleaseSelectAClinicImage);

                        addClinicCont.showBottomSheet(context);
                      }
                    }
                  },
                  child: Text(addClinicCont.isEdit.value ? locale.value.update : locale.value.save, style: primaryTextStyle(color: white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* Widget timeSlotListWid(List<TimeSlotMinResponse> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].name,
          titleTextStyle: primaryTextStyle(size: 14),
          onTap: () async {
            hideKeyboard(context);
            addClinicCont.selectTimeSlot(list[index]);
            addClinicCont.timeSlotCont.text = list[index].name;
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  } */

  Widget specializationListWid(List<SpecializationModel> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].name,
          titleTextStyle: primaryTextStyle(size: 14),
          onTap: () async {
            hideKeyboard(context);
            addClinicCont.selectSpecialization(list[index]);
            addClinicCont.specializationCont.text = list[index].name;
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
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
            addClinicCont.countryId(list[index].id);
            addClinicCont.selectedCountry(list[index]);
            addClinicCont.countryCont.text = list[index].name;
            addClinicCont.resetState();
            addClinicCont.resetCity();
            await addClinicCont.getStates(countryId: list[index].id);
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
            addClinicCont.selectedState(list[index]);
            addClinicCont.stateCont.text = list[index].name;
            addClinicCont.stateId(list[index].id);
            addClinicCont.resetCity();
            await addClinicCont.getCity(stateId: list[index].id);
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
            addClinicCont.selectedCity(list[index]);
            addClinicCont.cityId(list[index].id);
            addClinicCont.cityCont.text = list[index].name;
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}
