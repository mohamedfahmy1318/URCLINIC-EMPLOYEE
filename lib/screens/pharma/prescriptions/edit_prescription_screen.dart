import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/add_medicine_to_prescription_screen.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/controller/add_medicine_to_prescription_controller.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/medicine_list_screen.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../components/cached_image_widget.dart';
import '../../../components/loader_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../../utils/price_widget.dart';
import '../../../utils/view_all_label_component.dart';
import '../../appointment/components/appointment_detail_applied_tax_list_bottom_sheet.dart';
import '../../home/home_controller.dart';
import 'controller/all_prescription_controller.dart';
import 'controller/edit_prescription_controller.dart';

class EditPrescriptionScreen extends StatelessWidget {
  EditPrescriptionScreen({super.key});

  final EditPrescriptionController editPrescriptionCont = Get.put(EditPrescriptionController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: editPrescriptionCont.isLoading,
      appBartitleText: "${locale.value.editPrescription} #${editPrescriptionCont.prescriptionId}",
      appBarVerticalSize: Get.height * 0.12,
      body: RefreshIndicator(
        onRefresh: () {
          return editPrescriptionCont.init(showLoader: false);
        },
        child: Obx(
          () => SnapHelperWidget(
            future: editPrescriptionCont.getPrescriptionDetails.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  editPrescriptionCont.init();
                },
              ).paddingSymmetric(horizontal: 16);
            },
            loadingWidget: editPrescriptionCont.isLoading.value ? const Offstage() : const LoaderWidget(),
            onSuccess: (resData) {
              return Column(
                children: [
                  // Add Extra Medicine Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: boxDecorationDefault(
                      borderRadius: radius(0),
                      color: lightGreen2Color,
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: CachedImageWidget(
                            url: Assets.navigationIcMedicineOutlined,
                            height: 18,
                            width: 18,
                            color: white,
                          ),
                        ),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  locale.value.addExtraMedicine,
                                  style: boldTextStyle(size: 14, color: Colors.black),
                                ).expand(),
                                TextButton(
                                  style: const ButtonStyle().copyWith(
                                    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    Get.to(
                                      () => MedicinesListScreen(
                                        isSelectMedicineScreen: true,
                                        isAddMedicineScreen: true,
                                      ),
                                      arguments: editPrescriptionCont.prescriptionDetail.value.medicineInfo.map((p0)=>p0.medicineId).toSet().toList(),
                                    )?.then((value) {
                                      if (value is List<Medicine>) {
                                        if (Get.isRegistered<AddMedToPrescController>()) {
                                          Get.delete<AddMedToPrescController>(); // Clean old instance if needed
                                        }
                                        final controller = Get.put(AddMedToPrescController());
                                        controller.setMedicineForms(value);
                                        controller.prescriptionId = editPrescriptionCont.prescriptionId;

                                        Get.to(() => AddMedToPresScreen());
                                      }
                                    });
                                    /*         Get.to(() => AddMedToPresScreen(), arguments: {
                                      'prescriptionId': editPrescriptionCont.prescriptionId,
                                    })?.then((value) {
                                      if (value == true) {
                                        if (Get.isRegistered<AllPrescriptionsController>()) {
                                          Get.find<AllPrescriptionsController>().getPrescriptions();
                                        }
                                        if (Get.isRegistered<HomeController>()) {
                                          Get.find<HomeController>().getDashboardDetail();
                                        }
                                        editPrescriptionCont.init(showLoader: true);
                                      }
                                    });*/
                                  },
                                  child: Text(locale.value.addMedicine, style: boldTextStyle(size: 14, fontFamily: fontFamilyWeight700, color: appColorSecondary)).paddingSymmetric(horizontal: 8),
                                ),
                              ],
                            ),
                            Text(
                              locale.value.addExtraMedicineForPatient,
                              style: secondaryTextStyle(size: 12, color: Colors.black),
                            ),
                          ],
                        ).expand(),
                      ],
                    ),
                  ),
                  Obx(
                    () => AnimatedScrollView(
                      listAnimationType: ListAnimationType.FadeIn,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 64),
                      children: [
                        16.height,
                        Text(locale.value.medicineInfo, style: boldTextStyle(size: Constants.labelTextSize)),
                        8.height,
                        Obx(
                          () => AnimatedListView(
                            shrinkWrap: true,
                            listAnimationType: ListAnimationType.None,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: editPrescriptionCont.prescriptionDetail.value.medicineInfo.obs.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                margin: EdgeInsets.only(top: index == 0 ? 0 : 12),
                                decoration: boxDecorationDefault(
                                  color: context.cardColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          editPrescriptionCont.prescriptionDetail.value.medicineInfo[index].name,
                                          overflow: TextOverflow.ellipsis,
                                          style: boldTextStyle(size: 14, color: isDarkMode.value ? null : darkGrayTextColor),
                                        ).expand(),
                                        PriceWidget(
                                          price: editPrescriptionCont.prescriptionDetail.value.medicineInfo[index].totalAmount.toDouble(),
                                          size: 14,
                                          isBoldText: true,
                                        ),
                                      ],
                                    ),
                                    8.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${locale.value.category}:",
                                          style: secondaryTextStyle(color: isDarkMode.value ? null : darkGrayTextColor),
                                        ),
                                        Text(
                                          " ${editPrescriptionCont.prescriptionDetail.value.medicineInfo[index].category.name}",
                                          style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                        ),
                                      ],
                                    ),
                                    8.height,
                                    Divider(color: isDarkMode.value ? borderColor.withValues(alpha: 0.2) : context.dividerColor.withValues(alpha: 0.2), height: 1),
                                    16.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: locale.value.dosage,
                                                style: primaryTextStyle(color: dividerColor, size: 12),
                                              ),
                                              TextSpan(
                                                text: editPrescriptionCont.prescriptionDetail.value.medicineInfo[index].dosage,
                                                style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                              ),
                                            ],
                                          ),
                                        ).expand(),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: locale.value.form,
                                                style: primaryTextStyle(color: dividerColor, size: 12),
                                              ),
                                              TextSpan(
                                                text: editPrescriptionCont.prescriptionDetail.value.medicineInfo[index].form,
                                                style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                              ),
                                            ],
                                          ),
                                        ).expand()
                                      ],
                                    ),
                                    8.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${locale.value.quantity}: ',
                                                style: primaryTextStyle(color: dividerColor, size: 12),
                                              ),
                                              TextSpan(
                                                text: editPrescriptionCont.prescriptionDetail.value.medicineInfo[index].quantity.toString(),
                                                style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                              ),
                                            ],
                                          ),
                                        ).expand(),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${locale.value.days}: ',
                                                style: primaryTextStyle(color: dividerColor, size: 12),
                                              ),
                                              TextSpan(
                                                text: editPrescriptionCont.prescriptionDetail.value.medicineInfo[index].days,
                                                style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                              ),
                                            ],
                                          ),
                                        ).expand()
                                      ],
                                    ),
                                    8.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${locale.value.frequency}: ',
                                                style: primaryTextStyle(color: dividerColor, size: 12),
                                              ),
                                              TextSpan(
                                                text: editPrescriptionCont.prescriptionDetail.value.medicineInfo[index].frequency,
                                                style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                              ),
                                            ],
                                          ),
                                        ).expand(),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: locale.value.expiring,
                                                style: primaryTextStyle(color: dividerColor, size: 12),
                                              ),
                                              TextSpan(
                                                text: editPrescriptionCont.prescriptionDetail.value.medicineInfo[index].expiryDate.dateInDMMMyyyyFormat,
                                                style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                              ),
                                            ],
                                          ),
                                        ).expand(),
                                      ],
                                    ),
                                    16.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (Get.isRegistered<AddMedToPrescController>()) {
                                              Get.delete<AddMedToPrescController>(); // Clean old instance if needed
                                            }
                                            Get.to(() => AddMedToPresScreen(), arguments: {
                                              'prescriptionId': editPrescriptionCont.prescriptionId,
                                              'medicineInfo': editPrescriptionCont.prescriptionDetail.value.medicineInfo[index],
                                              'encounter_id': editPrescriptionCont.prescriptionDetail.value.bookingInfo.encounterId,
                                            })?.then((value) {
                                              if (value == true) {
                                                if (Get.isRegistered<AllPrescriptionsController>()) {
                                                  Get.find<AllPrescriptionsController>().getPrescriptions();
                                                }
                                                if (Get.isRegistered<HomeController>()) {
                                                  Get.find<HomeController>().getDashboardDetail();
                                                }
                                                editPrescriptionCont.init(showLoader: true);
                                              }
                                            });
                                          },
                                          child: const CachedImageWidget(
                                            url: Assets.iconsIcEditReview,
                                            height: 18,
                                            width: 18,
                                            color: iconColor,
                                          ),
                                        ),
                                        12.width,
                                        InkWell(
                                          onTap: () {
                                            editPrescriptionCont.handlePrescriptionMedicineDeleteClick(context: context, medicineList: editPrescriptionCont.prescriptionDetail.value.medicineInfo, index: index);
                                          },
                                          child: const CachedImageWidget(
                                            url: Assets.iconsIcDelete,
                                            height: 18,
                                            width: 18,
                                            color: iconColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        paymentDetails(context),
                        16.height,
                      ],
                    ).paddingSymmetric(horizontal: 16),
                  ).expand(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget paymentDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(label: locale.value.paymentDetails, isShowAll: false),
        Container(
          width: Get.width,
          padding: const EdgeInsets.all(16),
          decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(locale.value.medicineTotal, style: secondaryTextStyle()).expand(),
                  PriceWidget(
                    price: num.parse(editPrescriptionCont.prescriptionDetail.value.paymentInfo.medicineTotal.toString()).toStringAsFixed(Constants.DECIMAL_POINT).toDouble(),
                    color: isDarkMode.value ? null : darkGrayTextColor,
                    size: 12,
                    isBoldText: true,
                  ),
                ],
              ),
              8.height,

              /// Tax

              if (editPrescriptionCont.prescriptionDetail.value.paymentInfo.exclusiveTaxAmount > 0)
                detailWidgetPrice(
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
                              return AppointmentDetailAppliedTaxListBottomSheet(
                                taxes: editPrescriptionCont.prescriptionDetail.value.paymentInfo.exclusiveTax,
                                title: locale.value.appliedExclusiveTaxes,
                              );
                            },
                          );
                        },
                      ),
                      8.width,
                    ],
                  ).expand(),
                  value: editPrescriptionCont.prescriptionDetail.value.paymentInfo.exclusiveTaxAmount,
                  isSemiBoldText: true,
                  textColor: appColorSecondary,
                ),
              commonDivider.paddingSymmetric(vertical: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(locale.value.total, style: boldTextStyle(size: 14)),
                  PriceWidget(
                    price: editPrescriptionCont.prescriptionDetail.value.paymentInfo.totalAmount,
                    color: appColorPrimary,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget detailWidgetPrice({Widget? leadingWidget, Widget? trailingWidget, String? title, num? value, Color? textColor, bool isSemiBoldText = false, double? paddingBottom}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leadingWidget ?? Text(title.validate(), style: secondaryTextStyle()),
        trailingWidget ??
            PriceWidget(
              price: value.validate(),
              color: textColor ?? appColorPrimary,
              size: 14,
              isSemiBoldText: isSemiBoldText,
            )
      ],
    ).paddingBottom(paddingBottom ?? 10);
  }
}
