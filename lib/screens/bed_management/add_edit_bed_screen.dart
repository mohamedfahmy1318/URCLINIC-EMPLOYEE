// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:kivicare_clinic_admin/components/bottom_selection_widget.dart';
import 'package:kivicare_clinic_admin/components/loader_widget.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/add_edit_bed_controller.dart';
import 'package:kivicare_clinic_admin/main.dart';

import '../../utils/app_common.dart';
import '../../utils/constants.dart';
import 'all_bed_controller.dart';

class AddEditBedScreen extends StatelessWidget {
  final AddEditBedController controller;
  final AllBedController allBedController;
  final bool isEdit;

  const AddEditBedScreen({super.key, required this.controller, this.isEdit = false, required this.allBedController});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBarVerticalSize: Get.height * 0.12,
      appBartitleText: (isEdit) ? locale.value.editBed : locale.value.addBed,
      isLoading: allBedController.isLoading,
      body: Obx(
        () => Stack(
          children: [
            controller.isLoading.value
                ? const LoaderWidget()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) ...[
                            AppTextField(
                              textStyle: primaryTextStyle(size: 12),
                              controller: controller.clinicCont,
                              focus: controller.clinicFocus,
                              readOnly: true,
                              nextFocus: controller.bedNameFocus,
                              textFieldType: TextFieldType.NAME,
                              onTap: () async {
                                hideKeyboard(context);
                                await showModalBottomSheet(
                                  context: getContext,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  isScrollControlled: true,
                                  builder: (context) {
                                    controller.getClinicList();
                                    return SizedBox(
                                      height: Get.height * 0.7,
                                      child: Obx(() {
                                        if (controller.isClinicLoading.value) {
                                          return const LoaderWidget();
                                        }
                                        return BottomSelectionSheet(
                                          searchTextCont: controller.clinicSearchCont,
                                          title: locale.value.selectClinic,
                                          hintText: locale.value.searchClinicHere,
                                          hasError: false,
                                          isEmpty: controller.clinicList.isEmpty,
                                          errorText: '',
                                          isLoading: controller.isLoading,
                                          searchApiCall: (p0) {},
                                          onRetry: controller.getClinicList,
                                          listWidget: AnimatedListView(
                                            shrinkWrap: true,
                                            itemCount: controller.clinicList.length,
                                            padding: EdgeInsets.zero,
                                            physics: const AlwaysScrollableScrollPhysics(),
                                            listAnimationType: ListAnimationType.Slide,
                                            itemBuilder: (ctx, index) {
                                              final clinic = controller.clinicList[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  controller.selectedClinic(clinic.id);
                                                  controller.clinicCont.text = clinic.name.validate();
                                                  Get.back();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(12),
                                                  margin: const EdgeInsets.only(bottom: 12),
                                                  decoration: boxDecorationDefault(
                                                    borderRadius: BorderRadius.circular(6),
                                                    color: context.isDarkMode ? appScreenBackgroundDark : appScreenBackground,
                                                  ),
                                                  child: Text(
                                                    clinic.name,
                                                    style: primaryTextStyle(
                                                      color: context.isDarkMode ? null : darkGrayTextColor,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                              decoration: inputDecoration(
                                context,
                                hintText: '${locale.value.clinic}*',
                                fillColor: context.cardColor,
                                filled: true,
                                borderRadius: 10,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return locale.value.pleaseSelectClinic;
                                }
                                return null;
                              },
                            ),
                            16.height,
                          ],
                          AppTextField(
                            textStyle: primaryTextStyle(size: 12),
                            controller: controller.bedNameCont,
                            focus: controller.bedNameFocus,
                            nextFocus: controller.bedTypeFocus,
                            textFieldType: TextFieldType.NAME,
                            decoration: inputDecoration(
                              context,
                              hintText: locale.value.bedNameLabel,
                              fillColor: context.cardColor,
                              filled: true,
                              borderRadius: 10,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return locale.value.pleaseEnterBedName;
                              }
                              return null;
                            },
                          ),
                          16.height,
                          AppTextField(
                            textStyle: primaryTextStyle(size: 12),
                            controller: controller.bedTypeCont,
                            focus: controller.bedTypeFocus,
                            nextFocus: controller.chargesFocus,
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            onTap: () async {
                              if (controller.bedTypes.isEmpty) {
                                toast(locale.value.noBedTypesAvailable);
                                return;
                              }

                              await showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: Get.height * 0.7,
                                    child: Obx(
                                      () => BottomSelectionSheet(
                                        title: locale.value.selectBedTypeTitle,
                                        hintText: locale.value.searchBedTypeHintText,
                                        hasError: false,
                                        isEmpty: controller.bedTypes.isEmpty,
                                        errorText: '',
                                        isLoading: controller.isLoading,
                                        searchApiCall: (p0) {},
                                        onRetry: () {
                                          controller.fetchBedTypes();
                                        },
                                        listWidget: AnimatedListView(
                                          shrinkWrap: true,
                                          itemCount: controller.bedTypes.length,
                                          padding: EdgeInsets.zero,
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          listAnimationType: ListAnimationType.Slide,
                                          itemBuilder: (ctx, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                hideKeyboard(context);
                                                controller.selectedBedType = controller.bedTypes[index];
                                                controller.bedTypeCont.text = controller.bedTypes[index].type.validate();
                                                Get.back();
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(12),
                                                margin: const EdgeInsets.only(bottom: 12),
                                                decoration: boxDecorationDefault(
                                                  borderRadius: BorderRadius.circular(6),
                                                  color: context.isDarkMode ? appScreenBackgroundDark : appScreenBackground,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      controller.bedTypes[index].type.validate(),
                                                      style: primaryTextStyle(color: context.isDarkMode ? null : darkGrayTextColor),
                                                    ).expand(),
                                                    if (controller.selectedBedType?.type == controller.bedTypes[index].type) Icon(Icons.check_circle, color: appColorPrimary, size: 20),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ).expand(),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            decoration: inputDecoration(
                              context,
                              fillColor: context.cardColor,
                              hintText: locale.value.bedTypeLabel,
                              filled: true,
                              suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: dividerColor, size: 22),
                              borderRadius: 10,
                            ),
                            validator: (value) {
                              if (controller.selectedBedType == null) {
                                return locale.value.pleaseSelectBedType;
                              }
                              return null;
                            },
                          ),
                          16.height,
                          AppTextField(
                            textStyle: primaryTextStyle(size: 12),
                            controller: controller.chargesCont,
                            focus: controller.chargesFocus,
                            nextFocus: controller.capacityFocus,
                            textFieldType: TextFieldType.NUMBER,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: inputDecoration(
                              context,
                              hintText: locale.value.chargesLabel,
                              fillColor: context.cardColor,
                              filled: true,
                              borderRadius: 10,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return locale.value.pleaseEnterBedCharges;
                              if (double.tryParse(value) == null) return locale.value.pleaseEnterValidAmount;
                              return null;
                            },
                          ),
                          16.height,
                          AppTextField(
                            textStyle: primaryTextStyle(size: 12),
                            controller: controller.capacityCont,
                            focus: controller.capacityFocus,
                            nextFocus: controller.descriptionFocus,
                            textFieldType: TextFieldType.NUMBER,
                            keyboardType: TextInputType.number,
                            decoration: inputDecoration(
                              context,
                              hintText: locale.value.bedCapacityLabel,
                              fillColor: context.cardColor,
                              filled: true,
                              borderRadius: 10,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return locale.value.pleaseEnterCapacity;
                              if (int.tryParse(value) == null) return locale.value.pleaseEnterValidNumber;
                              return null;
                            },
                          ),
                          16.height,
                          Container(
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(locale.value.underMaintenanceLabel, style: secondaryTextStyle()),
                                Obx(
                                  () => Transform.scale(
                                    scale: 0.7,
                                    alignment: Alignment.centerRight,
                                    child: Switch(
                                      value: controller.underMaintenance,
                                      onChanged: (val) => controller.underMaintenance = val,
                                      activeTrackColor: appColorSecondary,
                                      activeColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          16.height,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextField(
                                textStyle: primaryTextStyle(size: 12),
                                controller: controller.descriptionCont,
                                focus: controller.descriptionFocus,
                                maxLines: 5,
                                maxLength: 250,
                                onChanged: controller.onDescriptionChanged,
                                decoration: inputDecoration(
                                  context,
                                  hintText: locale.value.descriptionLabel,
                                  fillColor: context.cardColor,
                                  filled: true,
                                  borderRadius: 10,
                                ),
                                textFieldType: TextFieldType.MULTILINE,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Obx(
                                  () => Text(
                                    '${controller.descriptionCharCount}/250',
                                    style: secondaryTextStyle(
                                      size: 12,
                                      color: controller.descriptionCharCount > 240 ? Colors.orange : null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          32.height,
                        ],
                      ),
                    ),
                  ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Obx(
                () => AppButton(
                  color: appColorSecondary,
                  text: locale.value.save,
                  width: Get.width,
                  onTap: controller.isSaving
                      ? null
                      : () => controller.saveBed(isEdit: isEdit).then(
                            (value) {
                              allBedController.getBedList(showloader: true);
                            },
                          ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
