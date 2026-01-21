import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/components/loader_widget.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/invoice_details/components/payment_component.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/invoice_details/invoice_details_controller.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/invoice_details/model/billing_details_resp.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../components/app_scaffold.dart';
import '../../../utils/common_base.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../generate_invoice/components/add_billing_item_component.dart';
import '../generate_invoice/components/add_final_discount_component.dart';
import 'components/billing_items_widget.dart';
import 'components/clinic_info_component.dart';
import 'components/invoice_component.dart';
import 'components/patient_detail_component.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  InvoiceDetailsScreen({super.key});

  final InvoiceDetailsController invoiceDetailsCon = Get.put(InvoiceDetailsController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.invoiceDetail,
      isBlurBackgroundinLoader: true,
      isLoading: invoiceDetailsCon.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            return invoiceDetailsCon.getInvoiceDetail(showLoader: true);
          },
          child: SnapHelperWidget(
            future: invoiceDetailsCon.getInvoiceDetailFuture.value,
            initialData: invoiceDetailsCon.invoiceData.value.serviceName.isEmpty ? null : invoiceDetailsCon.invoiceData.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  invoiceDetailsCon.getInvoiceDetail();
                },
              ).paddingSymmetric(horizontal: 24);
            },
            loadingWidget: invoiceDetailsCon.isLoading.value ? const Offstage() : const LoaderWidget(),
            onSuccess: (invoiceDetailData) {
              final BillingDetailModel billingDetails = invoiceDetailData;
              if (invoiceDetailsCon.isLoading.value) {
                return const Offstage();
              } else {
                return AnimatedScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: locale.value.encounterId,
                                style: primaryTextStyle(color: dividerColor, size: 14),
                              ),
                              TextSpan(
                                text: '  #${billingDetails.id}',
                                style: secondaryTextStyle(size: 14, weight: FontWeight.w600, color: appColorSecondary),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => SizedBox(
                            height: 26,
                            child: AppButton(
                              padding: EdgeInsets.zero,
                              textStyle: secondaryTextStyle(color: Colors.white),
                              shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                              onTap: () {
                                invoiceDetailsCon.getClearBillingItem();
                                Get.bottomSheet(AddBillingItemComponent());
                              },
                              child: Text(locale.value.addBillingItem, style: primaryTextStyle(size: 14, color: white)).paddingSymmetric(horizontal: 8),
                            ),
                          ).visible(invoiceDetailsCon.isEditMode.value),
                        ),
                      ],
                    ).paddingAll(16),
                    InvoiceComponent(
                      title: locale.value.clinicInfo,
                      child: ClinicInfoComponent(
                        clinicData: billingDetails,
                      ),
                    ),
                    16.height,
                    InvoiceComponent(
                      title: locale.value.patientDetails,
                      child: PatientDetailComponent(
                        patientData: billingDetails,
                      ),
                    ),
                    16.height,
                    if (invoiceDetailsCon.billingItemList.isNotEmpty)
                      InvoiceComponent(
                        title: locale.value.services,
                        child: BillingItemsWidget(),
                      ),
                    if (invoiceDetailsCon.billingItemList.isNotEmpty)
                      Obx(
                        () => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                if (billingDetails.totalAmount > 0) {
                                  invoiceDetailsCon.invoiceData.value.paymentStatus = 1;
                                  invoiceDetailsCon.invoiceData.refresh();
                                } else {
                                  toast(locale.value.pleaseAddService);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor)),
                                child: Row(
                                  children: [
                                    Text(locale.value.paid, style: primaryTextStyle(size: 12, color: dividerColor)).expand(),
                                    Icon(
                                      invoiceDetailsCon.invoiceData.value.paymentStatus == 1 ? Icons.radio_button_checked_outlined : Icons.radio_button_off_outlined,
                                      size: 20,
                                      color: invoiceDetailsCon.invoiceData.value.paymentStatus == 1 ? appColorPrimary : borderColor,
                                    ),
                                  ],
                                ),
                              ),
                            ).expand(),
                            10.width,
                            InkWell(
                              onTap: () {
                                invoiceDetailsCon.invoiceData.value.paymentStatus = 0;
                                invoiceDetailsCon.invoiceData.refresh();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor)),
                                child: Row(
                                  children: [
                                    Text(locale.value.unpaid, style: primaryTextStyle(size: 12, color: dividerColor)).expand(),
                                    Icon(
                                      invoiceDetailsCon.invoiceData.value.paymentStatus == 0 ? Icons.radio_button_checked_outlined : Icons.radio_button_off_outlined,
                                      size: 20,
                                      color: invoiceDetailsCon.invoiceData.value.paymentStatus == 0 ? appColorPrimary : borderColor,
                                    ),
                                  ],
                                ),
                              ),
                            ).expand(),
                          ],
                        ).paddingSymmetric(horizontal: 16).paddingTop(16).visible(invoiceDetailsCon.isEditMode.value && invoiceDetailsCon.invoiceData.value.paymentStatus == 0),
                      ),
                    8.height,
                    if (billingDetails.bedDetails.charge > 0)
                      Obx(
                            () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(locale.value.bedPrice, style: boldTextStyle()),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Paid Option
                                InkWell(
                                  onTap: () {
                                    if (billingDetails.totalAmount > 0) {
                                      invoiceDetailsCon.bedPaymentStatus(PaymentStatus.paid);
                                    } else {
                                      toast(locale.value.pleaseAddService);
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: boxDecorationDefault(
                                      color: context.cardColor,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(locale.value.paid, style: primaryTextStyle(size: 12, color: dividerColor)).expand(),
                                        Icon(
                                          invoiceDetailsCon.bedPaymentStatus.value == PaymentStatus.paid
                                              ? Icons.radio_button_checked_outlined
                                              : Icons.radio_button_off_outlined,
                                          size: 20,
                                          color: invoiceDetailsCon.bedPaymentStatus.value == PaymentStatus.paid ? appColorPrimary : borderColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ).expand(),

                                10.width,

                                // Unpaid Option
                                InkWell(
                                  onTap: () {
                                    invoiceDetailsCon.bedPaymentStatus(PaymentStatus.unpaid);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: boxDecorationDefault(
                                      color: context.cardColor,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(locale.value.unpaid, style: primaryTextStyle(size: 12, color: dividerColor)).expand(),
                                        Icon(
                                          invoiceDetailsCon.bedPaymentStatus.value == PaymentStatus.unpaid
                                              ? Icons.radio_button_checked_outlined
                                              : Icons.radio_button_off_outlined,
                                          size: 20,
                                          color: invoiceDetailsCon.bedPaymentStatus.value == PaymentStatus.unpaid ? appColorPrimary : borderColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ).expand(),
                              ],
                            ),
                          ],
                        )
                            .paddingSymmetric(horizontal: 16)
                            .paddingTop(16)
                            .visible(
                          billingDetails.bedDetails.charge > 0 &&
                              invoiceDetailsCon.isEditMode.value &&
                              invoiceDetailsCon.bedPaymentStatus.value == PaymentStatus.unpaid,
                        ),
                      ).paddingOnly(bottom: 16),
                    if (invoiceDetailsCon.billingItemList.isNotEmpty)
                      InvoiceComponent(
                        title: locale.value.payment,
                        trailingText: locale.value.addDiscount,
                        showSeeAll: invoiceDetailsCon.isEditMode.value,
                        onSeeAllTap: () {
                          invoiceDetailsCon.setFinalDiscountFormData();
                          Get.bottomSheet(AddFinalDiscountComponent(paymentData: billingDetails));
                        },
                        child: PaymentComponent(
                          paymentData: billingDetails,
                        ),
                      ),
                    Obx(() => invoiceDetailsCon.isEditMode.value ? 52.height : const Offstage()),
                  ],
                );
              }
            },
          ),
        ),
      ),
      widgetsStackedOverBody: [
        Obx(
          () => invoiceDetailsCon.isEditMode.value &&
                  (!invoiceDetailsCon.invoiceData.value.serviceId.isNegative || invoiceDetailsCon.billingItemList.isNotEmpty) &&
                  invoiceDetailsCon.invoiceData.value.paymentStatus == 1 &&
                  invoiceDetailsCon.bedPaymentStatus.value == PaymentStatus.paid &&
                  invoiceDetailsCon.encounter.value.status
              ? Positioned(
                  bottom: 16,
                  height: 50,
                  width: Get.width,
                  child: AppButton(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      width: Get.width,
                      text: locale.value.closeCheckoutEncounter,
                      color: appColorSecondary,
                      textStyle: appButtonTextStyleWhite,
                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                      onTap: () async {
                        invoiceDetailsCon.saveGenerateInvoice(showLoader: true);
                        invoiceDetailsCon.isEditMode.value = false;
                  /*      Get.bottomSheet(
                          SelectPharmaBottomSheet(
                            clinicId: invoiceDetailsCon.invoiceData.value.clinicId,
                          ),
                        ).then((selectedPharma) {
                          if (selectedPharma is Pharma && selectedPharma.id > 0) {
                            invoiceDetailsCon.pharmaId = selectedPharma.id;
                            invoiceDetailsCon.saveGenerateInvoice(showLoader: true);
                            invoiceDetailsCon.isEditMode.value = false;
                          } else {
                            toast("Please select a pharmacy");
                          }
                        });*/
                      }),
                )
              : const Offstage(),
        ),
      ],
    );
  }
}
