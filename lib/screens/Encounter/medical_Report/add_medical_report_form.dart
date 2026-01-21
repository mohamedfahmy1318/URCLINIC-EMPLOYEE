import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../components/app_primary_widget.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import 'add_medical_report_controller.dart';
import 'components/common_file_placeholders.dart';

class AddMedicalReportForm extends StatelessWidget {
  final bool isEdit;

  AddMedicalReportForm({super.key, this.isEdit = false});

  final AddMedicalReportController addMedReportCont = Get.put(AddMedicalReportController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: isEdit ? locale.value.editMedicalReport : locale.value.addMedicalReport,
      isLoading: addMedReportCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: AnimatedScrollView(
        controller: addMedReportCont.scrollController,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 16),
        children: [
          Row(
            children: [
              Text(locale.value.reportDetails, style: boldTextStyle(size: 14, color: isDarkMode.value ? null : darkGrayTextColor)).expand(),
              InkWell(
                onTap: () {
                  addMedReportCont.clearMedReportData();
                },
                child: Text(locale.value.reset, style: boldTextStyle(size: 12, weight: FontWeight.w700, color: appColorSecondary)),
              ),
            ],
          ),
          8.height,
          Form(
            key: addMedReportCont.medicalReportsFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return addMedReportCont.imageFile.value.path.isNotEmpty || addMedReportCont.medicalReportImage.value.isNotEmpty
                      ? Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              if (file.contains(RegExp(r'\.jpeg|\.jpg|\.gif|\.png|\.bmp')))
                                CachedImageWidget(
                                  url: addMedReportCont.imageFile.value.path.isNotEmpty ? addMedReportCont.imageFile.value.path : addMedReportCont.medicalReportImage.value,
                                  height: 110,
                                  width: 110,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(defaultRadius)
                              else
                                Container(
                                  decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor),
                                  child: CommonPdfPlaceHolder(
                                    height: 110,
                                    width: 110,
                                    text: file.getFileName,
                                    fileExt: file.getFileExtension,
                                  ),
                                ),
                              Positioned(
                                top: 110 * 3 / 4 + 4,
                                left: 110 * 3 / 4 + 4,
                                child: GestureDetector(
                                  onTap: () {
                                    hideKeyboard(context);
                                    addMedReportCont.showBottomSheet(context);
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: boxDecorationDefault(shape: BoxShape.circle, color: Colors.white),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: boxDecorationDefault(shape: BoxShape.circle, color: appColorPrimary),
                                      child: const Icon(Icons.file_upload_outlined, size: 16, color: Colors.white),
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
                                addMedReportCont.showBottomSheet(context);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CachedImageWidget(
                                    url: Assets.iconsIcImageUpload,
                                    height: 28,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  16.height,
                                  Text(
                                    locale.value.uploadMedicalReport,
                                    style: secondaryTextStyle(color: secondaryTextColor, size: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                }),
                4.height,
                Text(
                  locale.value.supportedFormat,
                  style: secondaryTextStyle(size: 12, color: appColorSecondary, fontStyle: FontStyle.italic),
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addMedReportCont.nameCont,
                  textFieldType: TextFieldType.NAME,
                  onChanged: (p0) {
                    addMedReportCont.isNameNotEmpty(p0.trim().isNotEmpty);
                  },
                  decoration: inputDecoration(
                    context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: locale.value.name,
                  ),
                  suffix: commonLeadingWid(imgPath: Assets.iconsIcUser, color: iconColor, size: 10).paddingAll(16),
                ),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addMedReportCont.dateCont,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: addMedReportCont.medicalReport.value.date.dateInyyyyMMddHHmmFormat.isAfter(DateTime.now()) ? addMedReportCont.medicalReport.value.date.dateInyyyyMMddHHmmFormat : DateTime.now(),
                      firstDate: DateTime(1970),
                      lastDate: DateTime.now(),
                    );

                    if (selectedDate != null) {
                      addMedReportCont.dateCont.text = selectedDate.formatDateYYYYmmdd();
                      addMedReportCont.isDateNotEmpty(addMedReportCont.dateCont.text.trim().isNotEmpty);
                    } else {
                      log("Date is not selected");
                    }
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.date,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: commonLeadingWid(imgPath: Assets.iconsIcCalendar, color: iconColor, size: 10).paddingAll(16),
                  ),
                ),
              ],
            ),
          ),
        ],
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
              text: addMedReportCont.isEdit.value ? locale.value.update : locale.value.save,
              color: appColorSecondary,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
              onTap: () {
                hideKeyboard(context);
                if (!addMedReportCont.isLoading.value) {
                  if (addMedReportCont.imageFile.value.path.isNotEmpty || addMedReportCont.medicalReportImage.isNotEmpty) {
                    if (addMedReportCont.medicalReportsFormKey.currentState!.validate()) {
                      addMedReportCont.medicalReportsFormKey.currentState!.save();
                      addMedReportCont.addEditMedicalReport();
                    }
                  } else {
                    toast(locale.value.pleaseUploadAMedicalReport);

                    /// Open Gallery
                    addMedReportCont.showBottomSheet(context);
                  }
                }
              },
            ).visible((addMedReportCont.imageFile.value.path.isNotEmpty || addMedReportCont.medicalReportImage.isNotEmpty) && addMedReportCont.isNameNotEmpty.value && addMedReportCont.isDateNotEmpty.value),
          ),
        ),
      ],
    );
  }

  String get file => addMedReportCont.imageFile.value.path.isNotEmpty ? addMedReportCont.imageFile.value.path : addMedReportCont.medicalReportImage.value;
}
