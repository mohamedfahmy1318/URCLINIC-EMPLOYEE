import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/pharma_apis.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/home/home_controller.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/add_medicine_to_prescription_screen.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/controller/add_medicine_to_prescription_controller.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/medicine_list_screen.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/prescriptions/controller/all_prescription_controller.dart';
import 'package:kivicare_clinic_admin/screens/pharma/prescriptions/edit_prescription_screen.dart';
import 'package:kivicare_clinic_admin/screens/pharma/prescriptions/model/prescriptions_res_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/prescriptions/prescription_detail_screen.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:kivicare_clinic_admin/utils/price_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';

class PrescriptionCardWidget extends StatelessWidget {
  final PrescriptionData prescriptionData;

  const PrescriptionCardWidget({super.key, required this.prescriptionData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => PrescriptionDetailScreen(), arguments: prescriptionData.id)?.then((value) {
          if (value == true) {
            if (Get.isRegistered<AllPrescriptionsController>()) {
              Get.find<AllPrescriptionsController>().getPrescriptions();
            }
            if (Get.isRegistered<HomeController>()) {
              Get.find<HomeController>().getDashboardDetail();
            }
          }
        });
      },
      child: Container(
        decoration: boxDecorationDefault(
          borderRadius: BorderRadius.circular(12),
          color: context.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          locale.value.encounterId,
                          style: primaryTextStyle(size: 14, color: secondaryTextColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        8.width,
                        Text(
                          "#${prescriptionData.id}",
                          style: boldTextStyle(size: 14, color: isDarkMode.value ? context.primaryColor : primaryTextColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    PriceWidget(
                      price: prescriptionData.totalAmount.toDouble(),
                      size: 16,
                      isBoldText: true,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      locale.value.dateAndTime,
                      style: primaryTextStyle(size: 14, color: secondaryTextColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    8.width,
                    Text(
                      prescriptionData.prescriptionDate,
                      style: boldTextStyle(size: 14, color: isDarkMode.value ? context.primaryColor : primaryTextColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                16.height,
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDarkMode.value ? borderColor.withValues(alpha: 0.1) : borderColor.withValues(alpha: 0.5),
                ),
                16.height,
                Text(
                  locale.value.prescriptionInfo,
                  style: primaryTextStyle(size: 14, color: secondaryTextColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode.value ? context.cardColor : context.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CachedImageWidget(
                                url: Assets.iconsIcCalendar,
                                height: 18,
                                width: 18,
                                color: isDarkMode.value ? context.primaryColor : primaryTextColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                locale.value.prescriptionStatus,
                                style: primaryTextStyle(size: 14),
                              ),
                            ],
                          ),
                          Text(
                            getPrescriptionStatus(status: prescriptionData.prescriptionStatus),
                            overflow: TextOverflow.ellipsis,
                            style: boldTextStyle(size: 14, color: getPrescriptionStatusColor(status: prescriptionData.prescriptionStatus)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CachedImageWidget(
                                  url: Assets.iconsIcCircleDollar,
                                  height: 18,
                                  width: 18,
                                  color: isDarkMode.value ? context.primaryColor : primaryTextColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    locale.value.prescriptionPaymentStatus,
                                    style: primaryTextStyle(size: 14),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            getPrescriptionPaymentStatus(status: prescriptionData.prescriptionPaymentStatus),
                            overflow: TextOverflow.ellipsis,
                            style: boldTextStyle(size: 14, color: getPrescriptionPaymentStatusColor(paymentStatus: prescriptionData.prescriptionPaymentStatus)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  locale.value.patientInfo,
                  style: primaryTextStyle(size: 14, color: secondaryTextColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: boxDecorationDefault(color: context.cardColor),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (prescriptionData.userImage != "")
                            CachedImageWidget(
                              url: prescriptionData.userImage,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                              circle: true,
                            )
                          else
                            PlaceHolderWidget(
                                height: 60,
                                width: 60,
                                color: isDarkMode.value ? context.primaryColor : cardLightColor,
                                shape: BoxShape.circle,
                                alignment: Alignment.center,
                                child: CachedImageWidget(
                                  url: Assets.iconsIcUser,
                                  height: 40,
                                )),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(prescriptionData.userName, style: boldTextStyle(size: 16)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      launchMail(prescriptionData.userEmail);
                                    },
                                    child: Row(
                                      children: [
                                        const CachedImageWidget(
                                          url: Assets.iconsIcMail,
                                          width: 14,
                                          height: 14,
                                          color: iconColor,
                                        ),
                                        12.width,
                                        Text(
                                          prescriptionData.userEmail,
                                          style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorSecondary, color: appColorSecondary),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ).paddingTop(8).visible(prescriptionData.userEmail.isNotEmpty),
                                ],
                              )
                            ],
                          ).expand(),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ).paddingAll(16),
            Column(
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDarkMode.value ? borderColor.withValues(alpha: 0.1) : borderColor.withValues(alpha: 0.5),
                ).paddingSymmetric(horizontal: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: const ButtonStyle().copyWith(
                        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        debugPrint('PRESCRIPTIONDATA.MEDICINEIDS: ${prescriptionData.medicineIds}');

                        Get.to(
                          () => MedicinesListScreen(
                            isSelectMedicineScreen: true,
                            isAddMedicineScreen: true,
                          ),
                          arguments: prescriptionData.medicineIds,
                        )?.then((value) {
                          if (value is List<Medicine>) {
                            if (Get.isRegistered<AddMedToPrescController>()) {
                              Get.delete<AddMedToPrescController>(); // Clean old instance if needed
                            }
                            final controller = Get.put(AddMedToPrescController());
                            controller.setMedicineForms(value);
                            controller.prescriptionId = prescriptionData.id;

                            Get.to(() => AddMedToPresScreen());
                          }
                        });
                      },
                      child: Text(locale.value.addMedicine, style: boldTextStyle(size: 14, fontFamily: fontFamilyWeight700, color: appColorSecondary)).paddingSymmetric(horizontal: 8),
                    ),
                    Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            Get.to(() => EditPrescriptionScreen(), arguments: prescriptionData.id)?.then((value) {
                              if (value == true) {
                                if (Get.isRegistered<AllPrescriptionsController>()) {
                                  Get.find<AllPrescriptionsController>().getPrescriptions();
                                }
                                if (Get.isRegistered<HomeController>()) {
                                  Get.find<HomeController>().getDashboardDetail();
                                }
                              }
                            });
                          },
                          icon: const CachedImageWidget(
                            url: Assets.iconsIcEditReview,
                            color: iconColorPrimaryDark,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ).paddingSymmetric(horizontal: 8),
                if (prescriptionData.prescriptionStatus.toLowerCase() != StatusConst.completed)

                  /// create button for prescription complete
                  Row(
                    children: [
                      AppButton(
                        text: locale.value.complete,
                        textStyle: boldTextStyle(color: Colors.white),
                        color: appColorSecondary,
                        width: Get.width,
                        onTap: () {
                          Get.put(AllPrescriptionsController());
                          Map<String, dynamic> request = {"encounter_id": prescriptionData.id, "status": 1};
                          PharmaApis.changePrescriptionStatus(request: request).then((value) {
                            toast(value.message);
                            Get.find<AllPrescriptionsController>().getPrescriptions();
                          });
                        },
                      ).paddingSymmetric(horizontal: 8, vertical: 16).expand(),
                      /*  AppButton(
                        text: locale.value.cancel,
                        textStyle: boldTextStyle(color: Colors.white),
                        color: appColorSecondary,
                        width: Get.width,
                        onTap: () {
                          Map<String, dynamic> request = {"encounter_id": prescriptionData.id, "status": 0};
                          PharmaApis.changePrescriptionStatus(request: request).then((value) {
                            toast(value.message);
                          });
                        },
                      ).paddingSymmetric(horizontal: 8, vertical: 16).expand(),*/
                    ],
                  ),
              ],
            ).visible(prescriptionData.prescriptionStatus.toLowerCase() != StatusConst.completed),
            if (prescriptionData.prescriptionStatus.toLowerCase() == StatusConst.completed && prescriptionData.prescriptionPaymentStatus.toLowerCase() != "paid" && prescriptionData.prescriptionPaymentStatus.toLowerCase() != "completed")
              AppButton(
                text: locale.value.payNow,
                textStyle: boldTextStyle(color: Colors.white),
                color: appColorSecondary,
                width: Get.width,
                onTap: () {
                  Map<String, dynamic> request = {"encounter_id": prescriptionData.id, "status": 1};
                  PharmaApis.changePrescriptionPaymentStatus(request: request).then((value) {
                    toast(value.message);
                    Get.find<AllPrescriptionsController>().getPrescriptions();
                  });
                },
              ).paddingSymmetric(horizontal: 8, vertical: 16),
          ],
        ),
      ),
    );
  }
}
