import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'controller/prescription_detail_controller.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  PrescriptionDetailScreen({super.key});

  final PrescriptionDetailController prescriptionDetailCont = Get.put(PrescriptionDetailController());

  bool get isOnlineService => prescriptionDetailCont.prescriptionDetail.value.bookingInfo.appointmentType.toLowerCase() == ServiceTypes.online;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: prescriptionDetailCont.isLoading,
      appBartitleText: "${locale.value.prescription} #${prescriptionDetailCont.prescriptionId}",
      appBarVerticalSize: Get.height * 0.12,
      body: RefreshIndicator(
        onRefresh: () {
          return prescriptionDetailCont.init(showLoader: false);
        },
        child: Obx(
          () => SnapHelperWidget(
            future: prescriptionDetailCont.getPrescriptionDetails.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  prescriptionDetailCont.init();
                },
              ).paddingSymmetric(horizontal: 16);
            },
            loadingWidget: prescriptionDetailCont.isLoading.value ? const Offstage() : const LoaderWidget(),
            onSuccess: (resData) {
              return Obx(
                () => AnimatedScrollView(
                  listAnimationType: ListAnimationType.FadeIn,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 64),
                  children: [
                    16.height,
                    Text(locale.value.patientInfo, style: boldTextStyle(size: Constants.labelTextSize)),
                    8.height,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: boxDecorationDefault(color: context.cardColor),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedImageWidget(
                                url: prescriptionDetailCont.prescriptionDetail.value.patientInfo.image,
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                                circle: true,
                              ),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(prescriptionDetailCont.prescriptionDetail.value.patientInfo.name, style: boldTextStyle(size: 16)),
                                  8.height,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          launchCall(prescriptionDetailCont.prescriptionDetail.value.patientInfo.phone);
                                        },
                                        child: Row(
                                          children: [
                                            const CachedImageWidget(
                                              url: Assets.iconsIcCall,
                                              width: 16,
                                              height: 16,
                                              color: iconColor,
                                            ),
                                            12.width,
                                            Text(
                                              prescriptionDetailCont.prescriptionDetail.value.patientInfo.phone,
                                              style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorPrimary, color: appColorPrimary),
                                            ),
                                          ],
                                        ),
                                      ).paddingTop(8).visible(prescriptionDetailCont.prescriptionDetail.value.patientInfo.phone.isNotEmpty),
                                      GestureDetector(
                                        onTap: () {
                                          launchMail(prescriptionDetailCont.prescriptionDetail.value.patientInfo.email);
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
                                              prescriptionDetailCont.prescriptionDetail.value.patientInfo.email,
                                              style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorSecondary, color: appColorSecondary),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ).paddingTop(8).visible(prescriptionDetailCont.prescriptionDetail.value.patientInfo.email.isNotEmpty),
                                    ],
                                  )
                                ],
                              ).expand(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    Text(locale.value.doctorInfo, style: boldTextStyle(size: Constants.labelTextSize)),
                    8.height,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: boxDecorationDefault(color: context.cardColor),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedImageWidget(
                                url: prescriptionDetailCont.prescriptionDetail.value.doctorInfo.image,
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                                circle: true,
                              ),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(prescriptionDetailCont.prescriptionDetail.value.doctorInfo.name, style: boldTextStyle(size: 16)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          launchCall(prescriptionDetailCont.prescriptionDetail.value.doctorInfo.phone);
                                        },
                                        child: Row(
                                          children: [
                                            const CachedImageWidget(
                                              url: Assets.iconsIcCall,
                                              width: 16,
                                              height: 16,
                                              color: iconColor,
                                            ),
                                            12.width,
                                            Text(
                                              prescriptionDetailCont.prescriptionDetail.value.doctorInfo.phone,
                                              style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorPrimary, color: appColorPrimary),
                                            ),
                                          ],
                                        ),
                                      ).paddingTop(8).visible(prescriptionDetailCont.prescriptionDetail.value.doctorInfo.phone.isNotEmpty),
                                      GestureDetector(
                                        onTap: () {
                                          launchMail(prescriptionDetailCont.prescriptionDetail.value.doctorInfo.email);
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
                                              prescriptionDetailCont.prescriptionDetail.value.doctorInfo.email,
                                              style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorSecondary, color: appColorSecondary),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ).paddingTop(8).visible(prescriptionDetailCont.prescriptionDetail.value.doctorInfo.email.isNotEmpty),
                                    ],
                                  )
                                ],
                              ).expand(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    Text(locale.value.bookingInfo, style: boldTextStyle(size: Constants.labelTextSize)),
                    8.height,
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(16),
                      decoration: boxDecorationDefault(color: context.cardColor),
                      child: Column(
                        children: [
                          detailWidget(
                            title: locale.value.appointmentDateAndTime,
                            value: prescriptionDetailCont.prescriptionDetail.value.bookingInfo.appointmentDateTime,
                          ),
                          detailWidget(
                            title: locale.value.serviceName,
                            value: prescriptionDetailCont.prescriptionDetail.value.bookingInfo.serviceName,
                          ),
                          detailWidget(
                            title: locale.value.prescriptionDateAndTime,
                            value: prescriptionDetailCont.prescriptionDetail.value.bookingInfo.prescriptionDate,
                          ).visible(prescriptionDetailCont.prescriptionDetail.value.bookingInfo.prescriptionDate.isNotEmpty),
                          detailWidget(
                            title: locale.value.appointmentType,
                            value: isOnlineService ? locale.value.online : locale.value.inClinic,
                          ),
                          detailWidget(
                            title: locale.value.prescriptionStatus,
                            value: getPrescriptionStatus(status: prescriptionDetailCont.prescriptionDetail.value.prescriptionStatus),
                            textColor: getPrescriptionStatusColor(status: prescriptionDetailCont.prescriptionDetail.value.prescriptionStatus),
                          ),
                          detailWidget(
                            title: locale.value.prescriptionPaymentStatus,
                            value: getPrescriptionPaymentStatus(status: prescriptionDetailCont.prescriptionDetail.value.prescriptionPaymentStatus.trim()),
                            textColor: getPrescriptionPaymentStatusColor(paymentStatus: prescriptionDetailCont.prescriptionDetail.value.prescriptionPaymentStatus.trim()),
                          ),
                          detailWidget(
                            title: locale.value.clinicName,
                            value: prescriptionDetailCont.prescriptionDetail.value.bookingInfo.clinicName,
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    Text(locale.value.medicineInfo, style: boldTextStyle(size: Constants.labelTextSize)),
                    8.height,
                    Obx(
                      () => AnimatedListView(
                        shrinkWrap: true,
                        listAnimationType: ListAnimationType.None,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: prescriptionDetailCont.prescriptionDetail.value.medicineInfo.length,
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
                                      prescriptionDetailCont.prescriptionDetail.value.medicineInfo[index].name,
                                      style: boldTextStyle(size: 14, color: isDarkMode.value ? null : darkGrayTextColor),
                                    ).expand(),
                                    PriceWidget(
                                      price: prescriptionDetailCont.prescriptionDetail.value.medicineInfo[index].totalAmount.toDouble(),
                                      size: 16,
                                      isBoldText: true,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${locale.value.category}:",
                                      style: secondaryTextStyle(color: isDarkMode.value ? null : darkGrayTextColor),
                                    ),
                                    Text(
                                      " ${prescriptionDetailCont.prescriptionDetail.value.medicineInfo[index].category.name}",
                                      style: primaryTextStyle(color: isDarkMode.value ? null : darkGrayTextColor),
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
                                            text: prescriptionDetailCont.prescriptionDetail.value.medicineInfo[index].dosage,
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
                                            text: prescriptionDetailCont.prescriptionDetail.value.medicineInfo[index].form,
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
                                            text: prescriptionDetailCont.prescriptionDetail.value.medicineInfo[index].quantity.toString(),
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
                                            text: prescriptionDetailCont.prescriptionDetail.value.medicineInfo[index].days,
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
                                            text: prescriptionDetailCont.prescriptionDetail.value.medicineInfo[index].frequency,
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
                                            text: prescriptionDetailCont.prescriptionDetail.value.medicineInfo[index].expiryDate.dateInDMMMyyyyFormat,
                                            style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                                          ),
                                        ],
                                      ),
                                    ).expand(),
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
              );
            },
          ),
        ),
      ),
    );
  }

  num calculateMedicinePrice(num amount, num tax) {
    return amount + tax;
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
                  Text(locale.value.medicineTotalInc, style: secondaryTextStyle()).expand(),
                  PriceWidget(
                    price: prescriptionDetailCont.prescriptionDetail.value.paymentInfo.medicineTotal.toStringAsFixed(Constants.DECIMAL_POINT).toDouble(),
                    color: isDarkMode.value ? null : darkGrayTextColor,
                    size: 12,
                    isBoldText: true,
                  ),
                ],
              ),
              8.height,

              /// Tax
              if (prescriptionDetailCont.prescriptionDetail.value.paymentInfo.exclusiveTaxAmount > 0)
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
                                taxes: prescriptionDetailCont.prescriptionDetail.value.paymentInfo.exclusiveTax,
                                title: locale.value.appliedExclusiveTaxes,
                              );
                            },
                          );
                        },
                      ),
                      8.width,
                    ],
                  ).expand(),
                  value: prescriptionDetailCont.prescriptionDetail.value.paymentInfo.exclusiveTaxAmount,
                  isSemiBoldText: true,
                  textColor: appColorSecondary,
                ),
              commonDivider.paddingSymmetric(vertical: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(locale.value.total, style: boldTextStyle(size: 14)),
                  PriceWidget(
                    price: prescriptionDetailCont.prescriptionDetail.value.paymentInfo.totalAmount,
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
