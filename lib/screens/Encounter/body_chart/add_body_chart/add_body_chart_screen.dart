import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../../components/app_primary_widget.dart';
import '../../../../components/app_scaffold.dart';
import '../../../../components/view_img_widget.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/colors.dart';
import '../body_chart_controller.dart';

class AddBodyChartScreen extends StatelessWidget {
  AddBodyChartScreen({super.key});

  final BodyChartController bodyChartCont = Get.put(BodyChartController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.bodyChart,
      appBarVerticalSize: Get.height * 0.14,
      isLoading: bodyChartCont.isLoading,
      body: SizedBox(
        height: Get.height,
        child: SingleChildScrollView(
          child: Form(
            key: bodyChartCont.addBodyChartFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                24.height,
                Row(
                  children: [
                    Text(locale.value.imageDetails, style: boldTextStyle(size: 14, color: isDarkMode.value ? null : darkGrayTextColor)).expand(),
                    InkWell(
                      onTap: () {
                        bodyChartCont.clearBodyChatData();
                      },
                      child: Text(locale.value.reset, style: boldTextStyle(size: 12, weight: FontWeight.w700, color: appColorSecondary)),
                    ),
                  ],
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: bodyChartCont.imageTitleCont,
                  textFieldType: TextFieldType.NAME,
                  focus: bodyChartCont.imageTitleFocus,
                  onChanged: (p0) {
                    bodyChartCont.isTitleNotEmpty(p0.trim().isNotEmpty);
                  },
                  decoration: inputDecoration(
                    context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: locale.value.imageTitle,
                  ),
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: bodyChartCont.imageDescCont,
                  minLines: 3,
                  focus: bodyChartCont.imageDecrFocus,
                  textFieldType: TextFieldType.MULTILINE,
                  keyboardType: TextInputType.multiline,
                  onChanged: (p0) {
                    bodyChartCont.isImageDescNotEmpty(p0.trim().isNotEmpty);
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.imageDescription,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                ),
                16.height,
                Obx(
                  () => bodyChartCont.editedImg.value.path.isNotEmpty || bodyChartCont.bodyImage.value.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            Get.to(
                              () => DisplyFullScreenImgWidget(
                                imgUrl: bodyChartCont.editedImg.value.path.isNotEmpty ? bodyChartCont.editedImg.value.path : bodyChartCont.bodyImage.value,
                                title: bodyChartCont.imageTitleCont.text.trim().isNotEmpty ? bodyChartCont.imageTitleCont.text : "#Image",
                              ),
                            );
                          },
                          child: Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                CachedImageWidget(
                                  url: bodyChartCont.editedImg.value.path.isNotEmpty ? bodyChartCont.editedImg.value.path : bodyChartCont.bodyImage.value,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(defaultRadius),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          hideKeyboard(context);
                                          if (bodyChartCont.bodyImage.isNotEmpty) {
                                            bodyChartCont.cropNetWorkImage();
                                          } else {
                                            bodyChartCont.editImage();
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: boxDecorationDefault(shape: BoxShape.circle, color: Colors.white),
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: boxDecorationDefault(shape: BoxShape.circle, color: appColorPrimary),
                                            child: const Icon(Icons.edit, size: 16, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          hideKeyboard(context);
                                          bodyChartCont.removeImageDialog();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: boxDecorationDefault(shape: BoxShape.circle, color: Colors.white),
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: boxDecorationDefault(shape: BoxShape.circle, color: redTextColor),
                                            child: const Icon(Icons.delete, size: 16, color: Colors.white),
                                          ),
                                        ),
                                      ).paddingLeft(6).visible(!bodyChartCont.isEdit.value),
                                    ],
                                  ),
                                ),
                              ],
                            ).paddingBottom(16),
                          ),
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
                                bodyChartCont.showBottomSheet(context);
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
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
        ),
      ),
      widgetsStackedOverBody: [
        Positioned(
          bottom: 16,
          height: 50,
          width: Get.width,
          child: Obx(
            () => AppButton(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: Get.width,
              text: locale.value.save,
              color: appColorSecondary,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
              onTap: () {
                hideKeyboard(context);
                if (!bodyChartCont.isLoading.value) {
                  if (bodyChartCont.editedImg.value.path.isNotEmpty || bodyChartCont.bodyImage.isNotEmpty) {
                    if (bodyChartCont.addBodyChartFormKey.currentState!.validate()) {
                      bodyChartCont.addBodyChartFormKey.currentState!.save();
                      bodyChartCont.saveBodyChart();
                    } else {
                      toast(locale.value.pleaseUploadTheImage);
                    }
                  }
                }
              },
            ).visible((bodyChartCont.editedImg.value.path.isNotEmpty || bodyChartCont.bodyImage.isNotEmpty) && bodyChartCont.isTitleNotEmpty.value && bodyChartCont.isImageDescNotEmpty.value),
          ),
        ),
      ],
    );
  }
}
