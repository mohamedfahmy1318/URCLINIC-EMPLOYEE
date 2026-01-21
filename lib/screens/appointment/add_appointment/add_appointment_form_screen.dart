import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/service/model/service_list_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../components/app_files_widget.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/bottom_selection_widget.dart';
import '../../../components/cached_image_widget.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../../utils/price_widget.dart';
import '../../../utils/view_all_label_component.dart';
import '../../Encounter/generate_invoice/components/billing_item_service_list_screen.dart';
import 'package:kivicare_clinic_admin/screens/appointment/components/applied_tax_list_bottom_sheet.dart';
import '../../auth/model/login_response.dart';
import 'add_appointment_controller.dart';
import 'patient_list_widget_add_appointment.dart';

class AddAppointmentFormScreen extends StatelessWidget {
  AddAppointmentFormScreen({super.key});

  final AddAppointmentController addAppointmentCont = Get.put(AddAppointmentController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.addAppointment,
      isLoading: addAppointmentCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: AnimatedScrollView(
        controller: addAppointmentCont.scrollController,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 16),
        children: [
          Form(
            key: addAppointmentCont.addAppointmentformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: addAppointmentCont.patientCont,
                    focus: addAppointmentCont.patientFocus,
                    textFieldType: TextFieldType.NAME,
                    readOnly: true,
                    onTap: () async {
                      serviceCommonBottomSheet(
                        context,
                        child: Obx(
                          () => BottomSelectionSheet(
                            title: locale.value.choosePatient,
                            hintText: locale.value.searchForPatient,
                            hasError: addAppointmentCont.hasErrorFetchingPatient.value,
                            isEmpty: !addAppointmentCont.isLoading.value && addAppointmentCont.patientList.isEmpty,
                            errorText: addAppointmentCont.errorMessagePatient.value,
                            isLoading: addAppointmentCont.isLoading,
                            searchApiCall: (p0) {
                              log("Search  ==> $p0");
                              addAppointmentCont.searchPatient(p0);
                              addAppointmentCont.getPatientList();
                            },
                            onRetry: () {
                              addAppointmentCont.getPatientList();
                            },
                            listWidget: PatientListWidgetAddAppointment(patientList: addAppointmentCont.patientList).expand(),
                          ),
                        ),
                      );
                    },
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.patient,
                      fillColor: context.cardColor,
                      filled: true,
                      prefixIconConstraints: BoxConstraints.loose(const Size.square(60)),
                      prefixIcon: (addAppointmentCont.selectPatient.value.profileImage.isEmpty && addAppointmentCont.selectPatient.value.id.isNegative).obs.value
                          ? null
                          : CachedImageWidget(
                              url: addAppointmentCont.selectPatient.value.profileImage,
                              height: 35,
                              width: 35,
                              firstName: addAppointmentCont.selectPatient.value.firstName,
                              lastName: addAppointmentCont.selectPatient.value.lastName,
                              fit: BoxFit.cover,
                              circle: true,
                            ).paddingOnly(left: 12, top: 8, bottom: 8, right: 12),
                      suffixIcon: commonLeadingWid(imgPath: Assets.iconsIcPatients, color: iconColor, size: 10).paddingSymmetric(vertical: 16),
                    ),
                  ).paddingTop(16),
                ),
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addAppointmentCont.servicesCont,
                  focus: addAppointmentCont.servicesFocus,
                  textFieldType: TextFieldType.MULTILINE,
                  minLines: 1,
                  readOnly: true,
                  onTap: () {
                    Get.to(() => BillingServicesListScreen(), arguments: [addAppointmentCont.selectedService.value, 'is_enable_advance_payment=0'])?.then((value) {
                      log('VALUE: ${value.runtimeType}');
                      if (value is ServiceElement) {
                        addAppointmentCont.selectedService(value);
                        addAppointmentCont.servicesCont.text = addAppointmentCont.selectedService.value.name;
                        addAppointmentCont.getTimeSlot();
                      }
                    });
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectService,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: darkGray.withValues(alpha: 0.5)),
                  ),
                ).paddingTop(16),
                16.height,
                AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  textFieldType: TextFieldType.MULTILINE,
                  isValidationRequired: false,
                  minLines: 5,
                  maxLength: 250,

                  controller: addAppointmentCont.medicalReportCont,
                  decoration: inputDecoration(
                    context,
                    labelText: locale.value.addMedicalHistory,
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                ),
                16.height,
                AddFilesWidget(
                  width: Get.width * 0.9,
                  fileList: addAppointmentCont.medicalReportFiles,
                  onFilePick: addAppointmentCont.handleFilesPickerClick,
                  onFilePathRemove: (index) {
                    addAppointmentCont.medicalReportFiles.remove(addAppointmentCont.medicalReportFiles[index]);
                  },
                ),
                Obx(
                  () => Column(
                    children: [
                      ViewAllLabel(label: locale.value.chooseDate, isShowAll: false).paddingOnly(right: 8),
                      Container(
                        decoration: boxDecorationDefault(color: context.cardColor),
                        child: DatePicker(
                          dateTextStyle: boldTextStyle(size: 18),
                          dayTextStyle: secondaryTextStyle(size: 14),
                          monthTextStyle: secondaryTextStyle(size: 14),
                          DateTime.now(),
                          initialSelectedDate: DateTime.now(),
                          selectionColor: lightPrimaryColor,
                          selectedTextColor: appColorPrimary,
                          height: 100,
                          onDateChange: (date) {
                            addAppointmentCont.selectedDate(date.formatDateYYYYmmdd());
                            addAppointmentCont.selectedSlot("");
                            addAppointmentCont.getTimeSlot();
                            addAppointmentCont.onDateTimeChange();
                          },
                        ),
                      ),
                    ],
                  ).paddingTop(8).visible(!addAppointmentCont.selectedService.value.id.isNegative),
                ),
                Obx(
                  () => SnapHelperWidget(
                    future: addAppointmentCont.slotsFuture.value,
                    errorBuilder: (error) {
                      return NoDataWidget(
                        title: error,
                        retryText: locale.value.reload,
                        imageWidget: const ErrorStateWidget(),
                        onRetry: () {
                          addAppointmentCont.getTimeSlot();
                        },
                      ).paddingSymmetric(horizontal: 32);
                    },
                    loadingWidget: addAppointmentCont.isLoading.value ? const Offstage() : const LoaderWidget(),
                    onSuccess: (p0) {
                      if (addAppointmentCont.slots.isEmpty) {
                        return NoDataWidget(title: locale.value.noTimeSlotsAvailable).paddingBottom(12);
                      }

                      return Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ViewAllLabel(label: locale.value.chooseTime, isShowAll: false).paddingOnly(right: 8),
                            Container(
                              padding: const EdgeInsets.all(16),
                              width: Get.width,
                              alignment: Alignment.center,
                              decoration: boxDecorationDefault(color: context.cardColor),
                              child: AnimatedWrap(
                                spacing: 12,
                                runSpacing: 12,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: List.generate(
                                  addAppointmentCont.slots.length,
                                  (i) {
                                    final String slot = addAppointmentCont.slots[i];
                                    return Obx(
                                      () => GestureDetector(
                                        onTap: () {
                                          addAppointmentCont.selectedSlot(slot);
                                          addAppointmentCont.onDateTimeChange();
                                        },
                                        child: Container(
                                          width: Get.width / 3 - 32,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: boxDecorationWithRoundedCorners(
                                            backgroundColor: addAppointmentCont.selectedSlot.value == slot ? appColorPrimary : context.scaffoldBackgroundColor,
                                            borderRadius: BorderRadius.circular(defaultRadius / 2),
                                          ),
                                          child: Text(
                                            slot,
                                            textAlign: TextAlign.center,
                                            style: primaryTextStyle(
                                              size: 12,
                                              color: (addAppointmentCont.selectedSlot.value == slot) ? Colors.white : appColorPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).paddingTop(8).visible(addAppointmentCont.selectedDate.value.trim().isNotEmpty && (!addAppointmentCont.selectedService.value.id.isNegative)),
                ),
                Obx(
                  () {
                    return addAppointmentCont.otherPatientList.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              16.height,
                              ViewAllLabel(
                                label: locale.value.bookedFor,
                                isShowAll: false,
                              ),
                              SnapHelperWidget(
                                future: addAppointmentCont.otherPatientListFuture.value,
                                loadingWidget: const LoaderWidget().center(),
                                errorBuilder: (error) {
                                  return NoDataWidget(
                                    title: error,
                                    retryText: locale.value.reload,
                                    imageWidget: const ErrorStateWidget(),
                                    onRetry: () async {
                                      await addAppointmentCont.onRefresh(patientId: addAppointmentCont.selectPatient.value.id.toString());
                                    },
                                  ).paddingSymmetric(horizontal: 32);
                                },
                                onSuccess: (data) {
                                  if (data.isEmpty) return const Offstage();
                                  return AnimatedWrap(
                                    listAnimationType: ListAnimationType.None,
                                    spacing: 16,
                                    runSpacing: 16,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: data.map((userData) {
                                      return Obx(() {
                                        return GestureDetector(
                                          onTap: () {
                                            if (addAppointmentCont.selectedMember.value.id == userData.id) {
                                              addAppointmentCont.selectedMember(UserData());
                                            } else {
                                              addAppointmentCont.selectedMember(userData);
                                            }
                                          },
                                          child: AnimatedOpacity(
                                            opacity: 1,
                                            duration: const Duration(milliseconds: 500),
                                            child: Container(
                                              width: Get.width / 3 - 24,
                                              decoration: boxDecorationDefault(
                                                color: addAppointmentCont.selectedMember.value.id == userData.id ? appColorPrimary : context.cardColor,
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                              child: Row(
                                                spacing: 12,
                                                children: [
                                                  CachedImageWidget(
                                                    url: userData.profileImage,
                                                    circle: true,
                                                    height: 28,
                                                    width: 28,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Text(
                                                    userData.firstName,
                                                    style: boldTextStyle(
                                                      size: 14,
                                                      color: addAppointmentCont.selectedMember.value.id == userData.id
                                                          ? Colors.white
                                                          : isDarkMode.value
                                                              ? Colors.white
                                                              : Colors.black,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ).expand(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          )
                        : const Offstage();
                  },
                ),
                Obx(
                  () {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ViewAllLabel(label: locale.value.paymentDetails, isShowAll: false).paddingOnly(right: 8),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(16),
                          decoration: boxDecorationDefault(color: context.cardColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Service price
                              if (addAppointmentCont.finalAssignDoctor.priceDetail.isIncludesInclusiveTaxAvailable)
                                detailWidgetPrice(
                                  title: locale.value.price,
                                  paddingBottom: addAppointmentCont.selectedService.value.assignDoctor.isNotEmpty ? 0 : 10,
                                  value: addAppointmentCont.selectedService.value.assignDoctor.isNotEmpty ? addAppointmentCont.finalAssignDoctor.priceDetail.serviceAmount : addAppointmentCont.selectedService.value.charges,
                                )
                              else
                                detailWidgetPrice(
                                  title: locale.value.price,
                                  paddingBottom: addAppointmentCont.selectedService.value.assignDoctor.isNotEmpty ? 0 : 10,
                                  value: addAppointmentCont.selectedService.value.assignDoctor.isNotEmpty ? addAppointmentCont.finalAssignDoctor.priceDetail.servicePrice : addAppointmentCont.selectedService.value.charges,
                                ),

                              ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (addAppointmentCont.selectedService.value.assignDoctor.isNotEmpty)
                                      Text(
                                        locale.value.asPerDoctorCharges,
                                        style: secondaryTextStyle(
                                          color: appColorSecondary,
                                          size: 11,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    if (addAppointmentCont.finalAssignDoctor.priceDetail.isIncludesInclusiveTaxAvailable)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          locale.value.includesInclusiveTax,
                                          style: secondaryTextStyle(
                                            color: appColorSecondary,
                                            size: 10,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                10.height,
                              ],

                              /// Discount price
                              if (!addAppointmentCont.finalAssignDoctor.priceDetail.isIncludesInclusiveTaxAvailable) ...[
                                if (addAppointmentCont.selectedService.value.assignDoctor.isNotEmpty && addAppointmentCont.finalAssignDoctor.priceDetail.discountAmount > 0) ...[
                                  detailWidgetPrice(
                                    leadingWidget: Row(
                                      children: [
                                        Text(locale.value.discount, style: secondaryTextStyle()),
                                        if (addAppointmentCont.finalAssignDoctor.priceDetail.discountType == TaxType.PERCENTAGE)
                                          Text(
                                            ' (${addAppointmentCont.finalAssignDoctor.priceDetail.discountValue}% ${locale.value.off})',
                                            style: boldTextStyle(color: Colors.green, size: 12),
                                          )
                                        else if (addAppointmentCont.finalAssignDoctor.priceDetail.discountType == TaxType.FIXED)
                                          PriceWidget(
                                            price: addAppointmentCont.finalAssignDoctor.priceDetail.discountValue,
                                            color: Colors.green,
                                            size: 12,
                                            isDiscountedPrice: true,
                                          ),
                                      ],
                                    ),
                                    value: addAppointmentCont.finalAssignDoctor.priceDetail.discountAmount,
                                    textColor: Colors.green,
                                  ),
                                ] else if (addAppointmentCont.selectedService.value.assignDoctor.isEmpty && addAppointmentCont.selectedService.value.discount)
                                  detailWidgetPrice(
                                    leadingWidget: Row(
                                      children: [
                                        Text(locale.value.discount, style: secondaryTextStyle()),
                                        if (addAppointmentCont.selectedService.value.discountType == TaxType.PERCENTAGE)
                                          Text(
                                            ' (${addAppointmentCont.selectedService.value.discountValue}% ${locale.value.off})',
                                            style: boldTextStyle(color: Colors.green, size: 12),
                                          )
                                        else if (addAppointmentCont.selectedService.value.discountType == TaxType.FIXED)
                                          PriceWidget(
                                            price: addAppointmentCont.selectedService.value.discountValue,
                                            color: Colors.green,
                                            size: 12,
                                            isDiscountedPrice: true,
                                          ),
                                      ],
                                    ),
                                    value: addAppointmentCont.selectedService.value.discountAmount,
                                    textColor: Colors.green,
                                  ),

                                /// Subtotal
                                if (addAppointmentCont.selectedService.value.assignDoctor.isNotEmpty && addAppointmentCont.finalAssignDoctor.priceDetail.serviceAmount != addAppointmentCont.selectedService.value.payableAmount)
                                  detailWidgetPrice(
                                    title: locale.value.subtotal,
                                    value: addAppointmentCont.finalAssignDoctor.priceDetail.serviceAmount,
                                    paddingBottom: addAppointmentCont.finalAssignDoctor.priceDetail.isIncludesInclusiveTaxAvailable ? 0 : null,
                                  )
                                else if (addAppointmentCont.selectedService.value.assignDoctor.isEmpty && addAppointmentCont.selectedService.value.discount)
                                  detailWidgetPrice(
                                    title: locale.value.subtotal,
                                    value: addAppointmentCont.selectedService.value.payableAmount,
                                    paddingBottom: addAppointmentCont.finalAssignDoctor.priceDetail.isIncludesInclusiveTaxAvailable ? 0 : null,
                                  ),
                              ],

                              /// Tax
                              if (appConfigs.value.isExclusiveTaxesAvailable)
                                detailWidgetPrice(
                                  paddingBottom: 0,
                                  leadingWidget: Row(
                                    children: [
                                      Text(locale.value.exclusiveTax, style: secondaryTextStyle()).expand(),
                                      const Icon(Icons.info_outline_rounded, size: 20, color: appColorPrimary).onTap(
                                        () {
                                          showModalBottomSheet(
                                            context: context,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: radiusCircular(16),
                                                topRight: radiusCircular(16),
                                              ),
                                            ),
                                            builder: (_) {
                                              return AppliedTaxListBottomSheet(
                                                taxes: appConfigs.value.exclusiveTaxList,
                                                subTotal: addAppointmentCont.selectedService.value.assignDoctor.isNotEmpty ? addAppointmentCont.finalAssignDoctor.priceDetail.serviceAmount : addAppointmentCont.selectedService.value.charges,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      8.width,
                                    ],
                                  ).expand(),
                                  value: addAppointmentCont.finalAssignDoctor.priceDetail.totalExclusiveTax,
                                  isSemiBoldText: true,
                                  textColor: appColorSecondary,
                                ),
                              commonDivider.paddingSymmetric(vertical: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(locale.value.total, style: boldTextStyle(size: 14)),
                                  PriceWidget(
                                    price: addAppointmentCont.totalAmount,
                                    color: appColorPrimary,
                                  ),
                                ],
                              ),

                              /// Advance Payment
                              if (addAppointmentCont.selectedService.value.isEnableAdvancePayment) ...[
                                8.height,
                                detailWidgetPrice(
                                  leadingWidget: Row(
                                    children: [
                                      Text(locale.value.advancePayableAmount, overflow: TextOverflow.ellipsis, maxLines: 2, style: secondaryTextStyle()),
                                      Text(
                                        ' (${addAppointmentCont.selectedService.value.advancePaymentAmount}%)',
                                        style: boldTextStyle(color: Colors.green, size: 12),
                                      ),
                                    ],
                                  ).flexible(),
                                  value: addAppointmentCont.advancePayableAmount,
                                  paddingBottom: 0,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ).visible(
                      addAppointmentCont.saveBtnVisible.value &&
                          (!addAppointmentCont.selectedService.value.id.isNegative) &&
                          (!addAppointmentCont.selectPatient.value.id.isNegative) &&
                          (!addAppointmentCont.getClinicId.isNegative) &&
                          (!addAppointmentCont.doctorData.value.doctorId.isNegative),
                    );
                  },
                ),
                16.height,
                Obx(
                  () => AppButton(
                    width: Get.width,
                    color: appColorPrimary,
                    onTap: () {
                      hideKeyboard(context);
                      if (!addAppointmentCont.isLoading.value) {
                        if (addAppointmentCont.addAppointmentformKey.currentState!.validate()) {
                          addAppointmentCont.addAppointmentformKey.currentState!.save();
                          addAppointmentCont.saveBooking();
                        }
                      }
                    },
                    child: Text(locale.value.save, style: primaryTextStyle(color: white)),
                  ).visible(
                    addAppointmentCont.saveBtnVisible.value &&
                        (!addAppointmentCont.selectedService.value.id.isNegative) &&
                        (!addAppointmentCont.selectPatient.value.id.isNegative) &&
                        (!addAppointmentCont.getClinicId.isNegative) &&
                        (!addAppointmentCont.doctorData.value.doctorId.isNegative),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detailWidgetPrice({Widget? leadingWidget, Widget? trailingWidget, String? title, num? value, Color? textColor, bool isSemiBoldText = false, double? paddingBottom}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leadingWidget ?? Text(title.validate(), overflow: TextOverflow.ellipsis, maxLines: 2, style: secondaryTextStyle()).flexible(),
        trailingWidget ??
            PriceWidget(
              price: value.validate(),
              color: textColor ?? appColorPrimary,
              size: 14,
              isSemiBoldText: isSemiBoldText,
            ),
      ],
    ).paddingBottom(paddingBottom ?? 10);
  }
}
