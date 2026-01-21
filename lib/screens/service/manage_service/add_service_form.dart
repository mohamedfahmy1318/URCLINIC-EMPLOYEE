import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/category/model/all_category_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_primary_widget.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/bottom_selection_widget.dart';
import '../../../components/cached_image_widget.dart';
import '../../../components/chat_gpt_loder.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import 'add_service_controller.dart';

class AddServiceForm extends StatelessWidget {
  final bool isEdit;

  AddServiceForm({super.key, this.isEdit = false});

  final AddServiceController addServiceController = Get.put(AddServiceController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: isEdit ? locale.value.editService : locale.value.addService,
      isLoading: addServiceController.isLoading,
      body: AnimatedScrollView(
        controller: addServiceController.scrollController,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 16),
        children: [
          Form(
            key: addServiceController.addClinicformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.value.serviceImage, style: boldTextStyle(size: 16)),
                12.height,
                Obx(
                  () => addServiceController.imageFile.value.path.isNotEmpty || addServiceController.serviceImage.value.isNotEmpty
                      ? Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              const SizedBox(
                                width: 110,
                                height: 110,
                                child: Loader(),
                              ).visible(addServiceController.serviceImage.value.isNotEmpty || addServiceController.imageFile.value.path.isNotEmpty),
                              CachedImageWidget(
                                url: addServiceController.imageFile.value.path.isNotEmpty ? addServiceController.imageFile.value.path : addServiceController.serviceImage.value,
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
                                    addServiceController.showBottomSheet(context);
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
                                addServiceController.showBottomSheet(context);
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
                  controller: addServiceController.serviceCont,
                  focus: addServiceController.serviceNameFocus,
                  nextFocus: addServiceController.serviceDurationFocus,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.serviceName,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addServiceController.durationCont,
                  focus: addServiceController.serviceDurationFocus,
                  nextFocus: addServiceController.defaultPriceFocus,
                  textFieldType: TextFieldType.NUMBER,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.serviceDurationMin,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addServiceController.priceCont,
                  textFieldType: TextFieldType.NUMBER,
                  focus: addServiceController.defaultPriceFocus,
                  nextFocus: addServiceController.descriptionFocus,
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.defaultPrice,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                ),
                16.height,
                Obx(
                  () => AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: addServiceController.categoryCont,
                    textFieldType: TextFieldType.NAME,
                    readOnly: true,
                    onTap: () async {
                      addServiceController.getCategory();
                      serviceCommonBottomSheet(
                        context,
                        onSheetClose: (p0) {
                          hideKeyboard(context);
                        },
                        child: Obx(
                          () => BottomSelectionSheet(
                            title: locale.value.chooseCategory,
                            hintText: locale.value.searchForCategory,
                            hasError: addServiceController.hasErrorFetchingCategory.value,
                            isEmpty: addServiceController.isShowFullList ? addServiceController.categoryList.isEmpty : addServiceController.categoryFilterList.isEmpty,
                            errorText: addServiceController.errorMessageCategory.value,
                            isLoading: addServiceController.isLoading,
                            noDataTitle: locale.value.noCategoryFound,
                            onRetry: () {
                              addServiceController.getCategory();
                            },
                            listWidget: Obx(
                              () => categoryListWid(
                                addServiceController.isShowFullList ? addServiceController.categoryList : addServiceController.categoryFilterList,
                              ).expand(),
                            ),
                          ),
                        ),
                      );
                    },
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.category,
                      fillColor: context.cardColor,
                      filled: true,
                      prefixIconConstraints: BoxConstraints.loose(const Size.square(60)),
                      prefixIcon: addServiceController.selectedCategoryType.value.categoryImage.isEmpty && addServiceController.selectedCategoryType.value.id.isNegative
                          ? null
                          : CachedImageWidget(
                              url: addServiceController.selectedCategoryType.value.categoryImage,
                              height: 35,
                              width: 35,
                              firstName: addServiceController.selectedCategoryType.value.name,
                              fit: BoxFit.cover,
                              circle: true,
                            ).paddingOnly(left: 12, top: 8, bottom: 8, right: 12),
                      suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: darkGray.withValues(alpha: 0.5)),
                    ),
                  ),
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addServiceController.descriptionCont,
                  focus: addServiceController.descriptionFocus,
                  minLines: 3,
                  nextFocus: addServiceController.descriptionFocus,
                  textFieldType: TextFieldType.MULTILINE,
                  enableChatGPT: appConfigs.value.enableChatGpt.getBoolInt(),
                  promptFieldInputDecorationChatGPT: inputDecoration(
                    context,
                    hintText: locale.value.writeHere,
                    fillColor: context.scaffoldBackgroundColor,
                    filled: true,
                  ),
                  testWithoutKeyChatGPT: appConfigs.value.testWithoutKey.getBoolInt(),
                  loaderWidgetForChatGPT: const ChatGPTLoadingWidget(),
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.enterDescription,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                ),
                16.height,
                AppButton(
                  width: Get.width,
                  color: appColorPrimary,
                  onTap: () {
                    if (!addServiceController.isLoading.value) {
                      if (addServiceController.imageFile.value.path.isNotEmpty || addServiceController.serviceImage.isNotEmpty) {
                        if (addServiceController.addClinicformKey.currentState!.validate()) {
                          addServiceController.addClinicformKey.currentState!.save();
                        }
                      } else {
                        toast(locale.value.pleaseSelectAServiceImage);

                        /// Open Gallery
                        hideKeyboard(context);
                        addServiceController.showBottomSheet(context);
                      }
                    }
                  },
                  child: Text(
                    addServiceController.isEdit.value ? locale.value.update : locale.value.save,
                    style: primaryTextStyle(color: white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryListWid(List<CategoryElement> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].name,
          titleTextStyle: primaryTextStyle(size: 14),
          leading: CachedImageWidget(url: list[index].categoryImage, height: 35, fit: BoxFit.cover, width: 35, circle: true),
          onTap: () {
            addServiceController.selectedCategoryType(list[index]);
            addServiceController.categoryCont.text = list[index].name;
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}
