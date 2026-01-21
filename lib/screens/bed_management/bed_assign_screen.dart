// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_assign_controller.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/bottom_selection_widget.dart';
import '../../components/loader_widget.dart';

// ignore: must_be_immutable
class BedAssignScreen extends StatelessWidget {
  final bool isFromBedDetails;
  const BedAssignScreen({super.key, this.isFromBedDetails = true});

  @override
  Widget build(BuildContext context) {
    final BedAssignController controller = Get.put(BedAssignController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setPersistence(true);
      controller.onScreenVisible();
    });

    InputDecoration commonInputDecoration({String? labelText, Widget? suffixIcon}) {
      return inputDecoration(
        context,
        hintText: labelText,
        fillColor: context.cardColor,
        filled: true,
        suffixIcon: suffixIcon,
      );
    }

    return AppScaffoldNew(
      appBartitleText: controller.isEditMode.value ? locale.value.editBedAssignment : locale.value.bedAssign,
      isLoading: controller.isLoading,
      isBlurBackgroundinLoader: true,
      appBarVerticalSize: Get.height * 0.12,
      body: GetBuilder<BedAssignController>(
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () => controller.refreshData(),
            child: Form(
              key: controller.formKey,
              child: AnimatedScrollView(
                crossAxisAlignment: CrossAxisAlignment.start,
                padding: const EdgeInsets.all(0),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      // color: context.cardColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locale.value.patientInfo,
                              style: boldTextStyle(size: 18),
                            ),
                            if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) ...[
                              16.height,
                              AppTextField(
                                textStyle: primaryTextStyle(size: 12),
                                controller: controller.clinicCont,
                                focus: controller.clinicFocus,
                                readOnly: true,
                                nextFocus: controller.patientFocus,
                                textFieldType: TextFieldType.NAME,
                                onTap: () async {
                                  if(isFromBedDetails){
                                    return;
                                  }
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
                                  suffixIcon: !controller.isClinicSelectionEnabled.value ? null : const Icon(Icons.keyboard_arrow_down_rounded, color: dividerColor, size: 22),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return locale.value.pleaseSelectClinic;
                                  }
                                  return null;
                                },
                              ),
                            ],
                            16.height,
                            Obx(
                              () {
                                final patientName = controller.selectedPatient.value?.fullName;
                                return AppTextField(
                                  key: ValueKey(patientName),
                                  textStyle: primaryTextStyle(size: 12),
                                  controller: controller.patientController,
                                  focus: controller.patientFocus,
                                  nextFocus: controller.encounterFocus,
                                  textFieldType: TextFieldType.NAME,
                                  readOnly: true,
                                  onTap: controller.isEditMode.value
                                      ? null
                                      : () async {
                                          if (controller.isPatientSelectionEnabled.value) {
                                            if (controller.selectedPatientFromEncounter.value != null) {
                                              controller.patientList.value = [controller.selectedPatientFromEncounter.value!];
                                              controller.selectPatient(controller.selectedPatientFromEncounter.value!);
                                            } else {
                                              await controller.fetchPatients();
                                              serviceCommonBottomSheet(
                                                // ignore: use_build_context_synchronously
                                                context,
                                                child: Obx(
                                                  () => BottomSelectionSheet(
                                                    title: locale.value.choosePatient,
                                                    hintText: locale.value.searchForPatient,
                                                    hasError: false,
                                                    isEmpty: controller.patientList.isEmpty,
                                                    errorText: '',
                                                    isLoading: false.obs,
                                                    searchApiCall: (p0) {
                                                      controller.searchPatient(p0);
                                                    },
                                                    onRetry: () {
                                                      controller.patientPage(1);
                                                      controller.fetchPatients();
                                                    },
                                                    listWidget: AnimatedListView(
                                                      shrinkWrap: true,
                                                      itemCount: controller.patientList.length,
                                                      padding: EdgeInsets.zero,
                                                      physics: const AlwaysScrollableScrollPhysics(),
                                                      listAnimationType: ListAnimationType.Slide,
                                                      itemBuilder: (ctx, index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            hideKeyboard(context);
                                                            controller.selectPatient(controller.patientList[index]);
                                                            Get.back();
                                                          },
                                                          child: Container(
                                                            padding: const EdgeInsets.all(8),
                                                            margin: const EdgeInsets.only(bottom: 8),
                                                            decoration: boxDecorationDefault(
                                                              borderRadius: BorderRadius.circular(6),
                                                              color: context.isDarkMode ? appScreenBackgroundDark : appScreenBackground,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                CachedImageWidget(
                                                                  url: controller.patientList[index].profileImage.validate(),
                                                                  height: 35,
                                                                  width: 35,
                                                                  fit: BoxFit.cover,
                                                                  radius: 20,
                                                                ).cornerRadiusWithClipRRect(40),
                                                                10.width,
                                                                Text(
                                                                  controller.patientList[index].fullName.validate(),
                                                                  style: primaryTextStyle(color: context.isDarkMode ? null : darkGrayTextColor),
                                                                ).expand(),
                                                                if (controller.selectedPatient.value?.id == controller.patientList[index].id) Icon(Icons.check_circle, color: appColorPrimary, size: 20),
                                                              ],
                                                            ),
                                                          ),
                                                        ).paddingSymmetric(vertical: 8);
                                                      },
                                                    ).expand(),
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                  decoration: commonInputDecoration(
                                    labelText: locale.value.patient,
                                    suffixIcon: controller.isEditMode.value
                                        ? null
                                        : const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: dividerColor,
                                            size: 22,
                                          ),
                                  ),
                                );
                              },
                            ),
                            16.height,
                            Obx(
                              () {
                                final encounterId = controller.selectedEncounterId.value;
                                return AppTextField(
                                  key: ValueKey(encounterId),
                                  textStyle: primaryTextStyle(size: 12),
                                  controller: controller.encounterController,
                                  focus: controller.encounterFocus,
                                  nextFocus: controller.bedTypeFocus,
                                  textFieldType: TextFieldType.NAME,
                                  readOnly: true,
                                  onTap: (controller.isEditMode.value || !controller.isEncounterSelectionEnabled.value)
                                      ? null
                                      : () async {
                                          if (controller.selectedPatient.value != null) {
                                            await controller.fetchEncounters(controller.selectedPatient.value!.id);
                                            serviceCommonBottomSheet(
                                              // ignore: use_build_context_synchronously
                                              context,
                                              child: GetBuilder<BedAssignController>(
                                                builder: (_) {
                                                  return Obx(
                                                    () => BottomSelectionSheet(
                                                      title: locale.value.chooseEncounter,
                                                      hintText: locale.value.searchForEncounter,
                                                      hasError: false,
                                                      isEmpty: controller.encounterList.isEmpty,
                                                      errorText: '',
                                                      isLoading: false.obs,
                                                      searchApiCall: (p0) {
                                                        controller.searchEncounter(p0);
                                                      },
                                                      onRetry: () {
                                                        controller.fetchEncounters(controller.selectedPatient.value!.id);
                                                      },
                                                      listWidget: AnimatedListView(
                                                        shrinkWrap: true,
                                                        itemCount: controller.encounterList.length,
                                                        padding: EdgeInsets.zero,
                                                        physics: const AlwaysScrollableScrollPhysics(),
                                                        listAnimationType: ListAnimationType.Slide,
                                                        itemBuilder: (ctx, index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              hideKeyboard(context);
                                                              controller.selectEncounter(controller.encounterList[index]);
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
                                                                    locale.value.encounterWithId(controller.encounterList[index].id),
                                                                    style: primaryTextStyle(color: context.isDarkMode ? null : darkGrayTextColor),
                                                                  ).expand(),
                                                                  if (controller.selectedEncounterId.value == controller.encounterList[index].id) Icon(Icons.check_circle, color: appColorPrimary, size: 20),
                                                                ],
                                                              ),
                                                            ),
                                                          ).paddingSymmetric(vertical: 8);
                                                        },
                                                      ).expand(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          } else {
                                            toast(locale.value.pleaseSelectPatient);
                                          }
                                        },
                                  decoration: commonInputDecoration(
                                    labelText: locale.value.encounter,
                                    suffixIcon: (controller.isEditMode.value || !controller.isEncounterSelectionEnabled.value) ? null : const Icon(Icons.keyboard_arrow_down_rounded, color: dividerColor, size: 22),
                                  ),
                                );
                              },
                            ),
                            16.height,
                          ],
                        ),
                        Obx(
                          () {
                            final bedTypeName = controller.selectedBedType.value?.type;
                            return AppTextField(
                              key: ValueKey(bedTypeName),
                              textStyle: primaryTextStyle(size: 12),
                              controller: controller.bedTypeController,
                              focus: controller.bedTypeFocus,
                              nextFocus: controller.roomFocus,
                              textFieldType: TextFieldType.NAME,
                              readOnly: true,
                              onTap: controller.isEditMode.value
                                  ? null
                                  : () async {
                                      controller.fetchBedTypes();
                                      serviceCommonBottomSheet(
                                        context,
                                        child: Obx(
                                          () => BottomSelectionSheet(
                                            title: locale.value.selectBedTypeTitle,
                                            hintText: locale.value.searchBedTypeHintText,
                                            hasError: false,
                                            isEmpty: controller.bedTypeList.isEmpty,
                                            errorText: '',
                                            isLoading: false.obs,
                                            searchApiCall: (p0) {
                                              controller.searchBedTypes(p0);
                                            },
                                            onRetry: () {
                                              controller.fetchBedTypes();
                                            },
                                            listWidget: AnimatedListView(
                                              shrinkWrap: true,
                                              itemCount: controller.bedTypeList.length,
                                              padding: EdgeInsets.zero,
                                              physics: const AlwaysScrollableScrollPhysics(),
                                              listAnimationType: ListAnimationType.Slide,
                                              itemBuilder: (ctx, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    hideKeyboard(context);
                                                    controller.selectBedType(controller.bedTypeList[index]);
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
                                                          controller.bedTypeList[index].type.validate(),
                                                          style: boldTextStyle(size: 16, color: context.isDarkMode ? null : darkGrayTextColor),
                                                        ).expand(),
                                                        if (controller.selectedBedType.value?.type == controller.bedTypeList[index].type) Icon(Icons.check_circle, color: appColorPrimary, size: 20),
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
                              decoration: commonInputDecoration(
                                labelText: locale.value.bedType,
                                suffixIcon: controller.isEditMode.value ? null : const Icon(Icons.keyboard_arrow_down_rounded, color: dividerColor, size: 22),
                              ),
                            );
                          },
                        ),
                        16.height,
                        Obx(
                          () {
                            final bedId = controller.selectedBed.value.id;
                            return AppTextField(
                              key: ValueKey(bedId),
                              textStyle: primaryTextStyle(size: 12),
                              controller: controller.bedController,
                              focus: controller.roomFocus,
                              nextFocus: controller.admissionDateFocus,
                              textFieldType: TextFieldType.NAME,
                              readOnly: true,
                              onTap: controller.isEditMode.value
                                  ? null
                                  : () async {
                                      if (controller.selectedBedType.value == null) {
                                        toast(locale.value.pleaseSelectBedType);
                                        return;
                                      }
                                      await controller.fetchRooms();
                                      serviceCommonBottomSheet(
                                        getContext,
                                        child: Obx(
                                          () => BottomSelectionSheet(
                                            title: locale.value.selectRoom,
                                            hintText: locale.value.search,
                                            hasError: false,
                                            isEmpty: controller.bedList.isEmpty,
                                            errorText: '',
                                            isLoading: false.obs,
                                            searchApiCall: (p0) {
                                              final filteredList = controller.bedList.where((bed) => bed.bed?.toLowerCase().contains(p0.toLowerCase()) ?? false).toList();
                                              controller.bedList.value = filteredList;
                                            },
                                            onRetry: () {
                                              controller.fetchRooms();
                                            },
                                            listWidget: AnimatedListView(
                                              shrinkWrap: true,
                                              itemCount: controller.bedList.length,
                                              padding: EdgeInsets.zero,
                                              physics: const AlwaysScrollableScrollPhysics(),
                                              listAnimationType: ListAnimationType.Slide,
                                              itemBuilder: (ctx, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    hideKeyboard(context);
                                                    controller.selectBed(controller.bedList[index]);
                                                    Get.back();
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: boxDecorationDefault(
                                                      borderRadius: BorderRadius.circular(6),
                                                      color: context.isDarkMode ? appScreenBackgroundDark : appScreenBackground,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                controller.bedList[index].bed.validate(),
                                                                style: boldTextStyle(size: 16, color: context.isDarkMode ? null : darkGrayTextColor),
                                                              ),
                                                              8.width,
                                                              Text(
                                                                locale.value.available,
                                                                style: secondaryTextStyle(
                                                                  size: 14,
                                                                  color: BedColors.available,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        if (controller.selectedBed.value.id == controller.bedList[index].id) Icon(Icons.check_circle, color: appColorPrimary, size: 20),
                                                      ],
                                                    ),
                                                  ),
                                                ).paddingSymmetric(vertical: 8);
                                              },
                                            ).expand(),
                                          ),
                                        ),
                                      );
                                    },
                              decoration: commonInputDecoration(
                                labelText: locale.value.room,
                                suffixIcon: controller.isEditMode.value ? null : const Icon(Icons.keyboard_arrow_down_rounded, color: dividerColor, size: 22),
                              ),
                            );
                          },
                        ),
                        16.height,
                        // Admission Date
                        AppTextField(
                          textStyle: primaryTextStyle(size: 12),
                          controller: controller.admissionDateController,
                          focus: controller.admissionDateFocus,
                          nextFocus: controller.dischargeDateFocus,
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          onTap: controller.isEditMode.value
                              ? null
                              : () async {
                                  controller.pickAssignDate(context);
                                },
                          decoration: commonInputDecoration(
                            labelText: locale.value.admissionDate,
                            suffixIcon: controller.isEditMode.value ? null : commonLeadingWid(imgPath: Assets.iconsIcCalendar, color: secondaryTextColor, size: 10).paddingAll(16),
                          ),
                        ),
                        16.height,
                        // Discharge Date
                        AppTextField(
                          textStyle: primaryTextStyle(size: 12),
                          controller: controller.dischargeDateController,
                          focus: controller.dischargeDateFocus,
                          nextFocus: controller.descriptionFocus,
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          onTap: () async {
                            controller.pickDischargeDate(context);
                          },
                          decoration: commonInputDecoration(
                            labelText: locale.value.dischargeDate,
                            suffixIcon: commonLeadingWid(imgPath: Assets.iconsIcCalendar, color: secondaryTextColor, size: 10).paddingAll(16),
                          ),
                        ),
                        16.height,
                        AppTextField(
                          textStyle: primaryTextStyle(size: 12),
                          controller: controller.descriptionController,
                          focus: controller.descriptionFocus,
                          nextFocus: controller.weightFocus,
                          textFieldType: TextFieldType.MULTILINE,
                          isValidationRequired: false,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            hintText: locale.value.descriptionLabel,
                            filled: true,
                            borderRadius: 10,
                          ),
                          maxLength: 250,
                          maxLines: 5,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Obx(
                            () => Text(
                              '${controller.descriptionCharCount}/250',
                              style: secondaryTextStyle(size: 12),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            24.height,
                            Text(
                              locale.value.patientHealthInformation,
                              style: boldTextStyle(size: 18),
                            ),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(size: 12),
                              controller: controller.weightController,
                              focus: controller.weightFocus,
                              nextFocus: controller.heightFocus,
                              decoration: commonInputDecoration(labelText: locale.value.weightLabel),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final weight = double.tryParse(value);
                                  if (weight == null || weight <= 0) {
                                    return locale.value.pleaseEnterValidWeight;
                                  }
                                }
                                return null;
                              },
                              textFieldType: TextFieldType.NUMBER,
                            ),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(size: 12),
                              controller: controller.heightController,
                              focus: controller.heightFocus,
                              nextFocus: controller.bloodPressureFocus,
                              textFieldType: TextFieldType.NUMBER,
                              decoration: commonInputDecoration(labelText: locale.value.heightLabel),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final height = double.tryParse(value);
                                  if (height == null || height <= 0) {
                                    return locale.value.pleaseEnterValidHeight;
                                  }
                                }
                                return null;
                              },
                            ),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(size: 12),
                              controller: controller.bloodPressureController,
                              focus: controller.bloodPressureFocus,
                              nextFocus: controller.heartRateFocus,
                              keyboardType: TextInputType.phone,
                              decoration: commonInputDecoration(labelText: locale.value.bloodPressureLabel),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final bloodPressureRegex = RegExp(r'^\d{2,3}/\d{2,3}$');
                                  if (!bloodPressureRegex.hasMatch(value)) {
                                    return locale.value.pleaseEnterValidBloodPressure;
                                  }
                                }
                                return null;
                              },
                              textFieldType: TextFieldType.PHONE,
                            ),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(size: 12),
                              controller: controller.heartRateController,
                              focus: controller.heartRateFocus,
                              nextFocus: controller.bloodGroupFocus,
                              decoration: commonInputDecoration(labelText: locale.value.heartRateLabel),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final heartRate = int.tryParse(value);
                                  if (heartRate == null || heartRate <= 0) {
                                    return locale.value.pleaseEnterValidHeartRate;
                                  }
                                }
                                return null;
                              },
                              textFieldType: TextFieldType.NUMBER,
                            ),
                            16.height,
                            AppTextField(
                              key: ValueKey(controller.bloodGroupController.text),
                              textStyle: primaryTextStyle(size: 12),
                              controller: controller.bloodGroupController,
                              focus: controller.bloodGroupFocus,
                              nextFocus: controller.temperatureFocus,
                              readOnly: true,
                              onTap: controller.isEditMode.value
                                  ? null
                                  : () async {
                                      List<String> filteredGroups = List.from(BedManagementStyles.bloodGroups);
                                      serviceCommonBottomSheet(
                                        context,
                                        child: StatefulBuilder(
                                          builder: (context, setState) {
                                            return Obx(
                                              () => BottomSelectionSheet(
                                                title: locale.value.bloodGroupLabel,
                                                hintText: locale.value.search,
                                                hasError: false,
                                                isEmpty: filteredGroups.isEmpty,
                                                errorText: '',
                                                isLoading: false.obs,
                                                searchApiCall: (p0) {
                                                  setState(() {
                                                    filteredGroups = BedManagementStyles.bloodGroups.where((g) => g.toLowerCase().contains(p0.toLowerCase())).toList();
                                                  });
                                                },
                                                onRetry: () {},
                                                listWidget: AnimatedListView(
                                                  shrinkWrap: true,
                                                  itemCount: filteredGroups.length,
                                                  padding: EdgeInsets.zero,
                                                  physics: const AlwaysScrollableScrollPhysics(),
                                                  listAnimationType: ListAnimationType.Slide,
                                                  itemBuilder: (ctx, index) {
                                                    final group = filteredGroups[index];
                                                    return GestureDetector(
                                                      onTap: () {
                                                        hideKeyboard(context);
                                                        controller.bloodGroupController.text = group;
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
                                                              group,
                                                              style: primaryTextStyle(color: context.isDarkMode ? null : darkGrayTextColor),
                                                            ).expand(),
                                                            if (controller.bloodGroupController.text == group) Icon(Icons.check_circle, color: appColorPrimary, size: 20),
                                                          ],
                                                        ),
                                                      ),
                                                    ).paddingSymmetric(vertical: 8);
                                                  },
                                                ).expand(),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                              decoration: commonInputDecoration(
                                labelText: locale.value.bloodGroupLabel,
                                suffixIcon: controller.isEditMode.value ? null : const Icon(Icons.keyboard_arrow_down_rounded, color: dividerColor, size: 22),
                              ),
                              textFieldType: TextFieldType.NAME,
                              isValidationRequired: false,
                            ),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(size: 12),
                              controller: controller.temperatureController,
                              focus: controller.temperatureFocus,
                              nextFocus: controller.symptomsFocus,
                              decoration: commonInputDecoration(labelText: locale.value.temperatureLabel),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final temperature = double.tryParse(value);
                                  if (temperature == null || temperature <= 0) {
                                    return locale.value.pleaseEnterValidTemperature;
                                  }
                                }
                                return null;
                              },
                              textFieldType: TextFieldType.NUMBER,
                            ),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(size: 12),
                              controller: controller.symptomsController,
                              focus: controller.symptomsFocus,
                              nextFocus: controller.notesFocus,
                              maxLines: 3,
                              decoration: commonInputDecoration(labelText: locale.value.symptomsLabel),
                              textFieldType: TextFieldType.MULTILINE,
                              isValidationRequired: false,
                            ),
                            16.height,
                            AppTextField(
                              textStyle: primaryTextStyle(size: 12),
                              controller: controller.notesController,
                              focus: controller.notesFocus,
                              maxLines: 3,
                              decoration: commonInputDecoration(labelText: locale.value.notes),
                              textFieldType: TextFieldType.MULTILINE,
                              isValidationRequired: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  80.height,
                ],
              ),
            ),
          );
        },
      ),
      widgetsStackedOverBody: [
        Positioned(
          bottom: 16,
          height: 50,
          width: Get.width,
          child: AppButton(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            text: controller.isEditMode.value ? locale.value.update : locale.value.save,
            color: appColorSecondary,
            textStyle: appButtonTextStyleWhite,
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
            onTap: () {
              if (controller.formKey.currentState!.validate()) {
                hideKeyboard(context);
                controller.bedAllocation();
              }
            },
          ),
        ),
      ],
    );
  }
}
