import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/appointment/appointments_controller.dart';
import 'package:kivicare_clinic_admin/screens/appointment/model/appointment_details_resp.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/appointment/components/clinic_info_card_widget.dart';
import '../../../components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../components/cached_image_widget.dart';
import '../../components/cancellations_booking_charge_dialog.dart';
import '../../components/loader_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/empty_error_state_widget.dart';
import '../../utils/price_widget.dart';
import '../../utils/view_all_label_component.dart';
import '../Encounter/encounter_dashboard/encounter_dashboard.dart';
import '../Encounter/medical_Report/components/common_file_placeholders.dart';
import '../Encounter/model/encounters_list_model.dart';
import 'appointment_detail_controller.dart';
import 'components/appointment_detail_applied_tax_list_bottom_sheet.dart';
import 'components/doctor_info_card_widget.dart';
import 'components/apppointment_info_card_widget.dart';
import 'components/patient_info_card_widget.dart';
import 'components/service_info_card_widget.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/components/bed_component.dart';

class AppointmentDetail extends StatelessWidget {
  AppointmentDetail({super.key});

  final AppointmentDetailController appointmentDetailCont =
      Get.put(AppointmentDetailController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: appointmentDetailCont.isUpdateLoading,
      appBartitleText:
          "${locale.value.appointment} #${appointmentDetailCont.appintmentData.value.id}",
      appBarVerticalSize: Get.height * 0.12,
      body: RefreshIndicator(
        onRefresh: () {
          return appointmentDetailCont.init(showLoader: false);
        },
        child: Obx(
          () => SnapHelperWidget(
            future: appointmentDetailCont.getAppointmentDetails.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  appointmentDetailCont.init();
                },
              ).paddingSymmetric(horizontal: 16);
            },
            loadingWidget: appointmentDetailCont.isUpdateLoading.value
                ? const Offstage()
                : const LoaderWidget(),
            onSuccess: (appointmentDetailRes) {
              return Obx(
                () => AnimatedScrollView(
                  listAnimationType: ListAnimationType.FadeIn,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.only(bottom: showBtns.obs.value ? 64 : 16),
                  children: [
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(locale.value.sessionSummary,
                            style:
                                boldTextStyle(size: Constants.labelTextSize)),

                        ///Invoice Download
                        SizedBox(
                          height: 23,
                          child: AppButton(
                            padding: EdgeInsets.zero,
                            textStyle: secondaryTextStyle(color: Colors.white),
                            shapeBorder:
                                RoundedRectangleBorder(borderRadius: radius(4)),
                            onTap: () {
                              appointmentDetailCont.getAppointmentInvoice();
                            },
                            child: Row(
                              children: [
                                const CachedImageWidget(
                                  url: Assets.iconsIcDownload,
                                  height: 14,
                                  width: 14,
                                  color: white,
                                ),
                                6.width,
                                Text(locale.value.invoice,
                                    style: primaryTextStyle(
                                        size: 12, color: white)),
                              ],
                            ),
                          ),
                        ).visible(appointmentDetailCont
                                    .appintmentData.value.status ==
                                StatusConst.checkout ||
                            appointmentDetailCont.appintmentData.value.status ==
                                StatusConst.completed),
                      ],
                    ),
                    8.height,
                    ApppointmentInfoCardWidget(
                      appointmentDet:
                          appointmentDetailCont.appintmentData.value,
                    ),
                    if (appointmentDetailCont
                        .appintmentData.value.medicalReport.isNotEmpty) ...[
                      8.height,
                      medicalReportWidget(),
                    ],
                    if (appointmentDetailCont
                        .appintmentData.value.appointmentExtraInfo.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          8.height,
                          ViewAllLabel(
                              label: locale.value.medicalHistory,
                              isShowAll: false),
                          Container(
                            width: Get.width,
                            padding: const EdgeInsets.all(16),
                            decoration:
                                boxDecorationDefault(color: context.cardColor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ReadMoreText(
                                  appointmentDetailCont.appintmentData.value
                                      .appointmentExtraInfo,
                                  trimLines: 3,
                                  trimMode: TrimMode.Line,
                                  style: secondaryTextStyle(size: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (appointmentDetailCont
                            .appintmentData.value.medicalReport.isEmpty &&
                        appointmentDetailCont
                            .appintmentData.value.appointmentExtraInfo.isEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          8.height,
                          ViewAllLabel(
                              label: locale.value.medicalHistory,
                              isShowAll: false),
                          Container(
                            width: Get.width,
                            padding: const EdgeInsets.all(16),
                            decoration:
                                boxDecorationDefault(color: context.cardColor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: dividerColor,
                                      size: 16,
                                    ),
                                    8.width,
                                    Text(
                                      locale.value.noMedicalReportsFound,
                                      style: secondaryTextStyle(
                                          size: 14, color: dividerColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).visible(appointmentDetailCont.appintmentData.value
                          .appointmentExtraInfo.isNotEmpty),
                    if (loginUserData.value.userRole
                            .contains(EmployeeKeyConst.vendor) ||
                        loginUserData.value.userRole
                            .contains(EmployeeKeyConst.receptionist)) ...[
                      if (loginUserData.value.userRole
                          .contains(EmployeeKeyConst.vendor)) ...[
                        16.height,
                        Text(locale.value.clinicInfo,
                            style:
                                boldTextStyle(size: Constants.labelTextSize)),
                        8.height,
                        ClinicInfoCardWidget(
                          clinicInfo:
                              appointmentDetailCont.appintmentData.value,
                        ),
                      ],
                      16.height,
                      Text(locale.value.doctorInfo,
                          style: boldTextStyle(size: Constants.labelTextSize)),
                      8.height,
                      DoctorInfoCardWidget(
                        doctorInfo: appointmentDetailCont.appintmentData.value,
                      ),
                    ],
                    16.height,
                    Text(locale.value.patientInfo,
                        style: boldTextStyle(size: Constants.labelTextSize)),
                    8.height,
                    PatientInfoCardWidget(
                      appointmentDet:
                          appointmentDetailCont.appintmentData.value,
                    ),
                    16.height,
                    Text(locale.value.aboutService,
                        style: boldTextStyle(size: Constants.labelTextSize)),
                    8.height,
                    ServiceInfoCardWidget(
                        appointmentDet:
                            appointmentDetailCont.appintmentData.value),
                    if (appointmentDetailCont.appintmentData.value.encounterId >
                            0 &&
                        (appointmentDetailCont.appintmentData.value.status ==
                                StatusConst.check_in ||
                            appointmentDetailCont.appintmentData.value.status ==
                                StatusConst.checkout))
                      Column(
                        children: [
                          16.height,
                          ViewAllLabel(
                            label: locale.value.encounterDetails,
                            trailingText: locale.value.viewAll,
                            onTap: () {
                              final encounterDetail = EncounterElement(
                                id: appointmentDetailCont
                                    .appintmentData.value.encounterId,
                                appointmentId: appointmentDetailCont
                                    .appintmentData.value.id,
                                clinicId: appointmentDetailCont
                                    .appintmentData.value.clinicId,
                                clinicName: appointmentDetailCont
                                    .appintmentData.value.clinicName,
                                description: appointmentDetailCont
                                    .appintmentData.value.encounterDescription,
                                doctorId: appointmentDetailCont
                                    .appintmentData.value.doctorId,
                                doctorName: appointmentDetailCont
                                    .appintmentData.value.doctorName,
                                encounterDate: appointmentDetailCont
                                    .appintmentData.value.appointmentDate,
                                userId: appointmentDetailCont
                                    .appintmentData.value.userId,
                                userName: appointmentDetailCont
                                    .appintmentData.value.userName,
                                userImage: appointmentDetailCont
                                    .appintmentData.value.userImage,
                                serviceId: appointmentDetailCont
                                    .appintmentData.value.serviceId,
                                address: appointmentDetailCont
                                    .appintmentData.value.address,
                                userEmail: appointmentDetailCont
                                    .appintmentData.value.userEmail,
                                status: appointmentDetailCont
                                    .appintmentData.value.encounterStatus,
                              );

                              Get.to(
                                () => EncountersDashboardScreen(
                                    encounterDetail: encounterDetail),
                                arguments: appointmentDetailCont
                                    .appintmentData.value.encounterId,
                              )?.then((value) {
                                if (value == true) {
                                  appointmentDetailCont.init();
                                }
                              });
                            },
                          ),
                          Container(
                            width: Get.width,
                            padding: const EdgeInsets.all(16),
                            decoration:
                                boxDecorationDefault(color: context.cardColor),
                            child: Column(
                              children: [
                                detailWidget(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  leadingWidget: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${locale.value.doctorName}: ',
                                          style: secondaryTextStyle()),
                                      Marquee(
                                        child: Text(
                                          appointmentDetailCont
                                              .appintmentData.value.doctorName,
                                          style: boldTextStyle(size: 12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ).expand(),
                                    ],
                                  ).expand(flex: 3),
                                  trailingWidget: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: boxDecorationDefault(
                                      color: appointmentDetailCont
                                              .appintmentData
                                              .value
                                              .encounterStatus
                                          ? lightGreenColor
                                          : lightSecondaryColor,
                                      borderRadius: radius(22),
                                    ),
                                    child: Text(
                                      appointmentDetailCont.appintmentData.value
                                              .encounterStatus
                                          ? locale.value.active
                                          : locale.value.closed,
                                      style: boldTextStyle(
                                        size: 12,
                                        color: appointmentDetailCont
                                                .appintmentData
                                                .value
                                                .encounterStatus
                                            ? completedStatusColor
                                            : pendingStatusColor,
                                      ),
                                    ),
                                  ).paddingLeft(16),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${locale.value.clinicName}: ',
                                        style: secondaryTextStyle()),
                                    Text(
                                      appointmentDetailCont
                                          .appintmentData.value.clinicName,
                                      style: boldTextStyle(size: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ).expand(),
                                  ],
                                ),
                                if (appointmentDetailCont.appintmentData.value
                                    .encounterDescription.isNotEmpty) ...[
                                  commonDivider.paddingSymmetric(vertical: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${locale.value.description}: ',
                                          style: secondaryTextStyle()),
                                      Text(
                                        appointmentDetailCont.appintmentData
                                            .value.encounterDescription,
                                        style: boldTextStyle(size: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ).expand(),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (appointmentDetailCont.appintmentData.value
                              .bedAllocation.isNotEmpty) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                16.height,
                                Text(
                                  locale.value.bedDetails,
                                  style: boldTextStyle(
                                      size: Constants.labelTextSize),
                                ),
                                8.height,
                                Column(
                                  children: [
                                    ListView.builder(
                                      itemCount: appointmentDetailCont
                                          .appintmentData
                                          .value
                                          .bedAllocation
                                          .length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final bed = appointmentDetailCont
                                            .appintmentData
                                            .value
                                            .bedAllocation[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: BedComponent(
                                            bedData: bed,
                                            isEncounterOpen:
                                                appointmentDetailCont
                                                    .appintmentData
                                                    .value
                                                    .encounterStatus,
                                            patientId: appointmentDetailCont
                                                .appintmentData.value.userId,
                                            patientName: appointmentDetailCont
                                                .appintmentData.value.userName,
                                            encounterId: appointmentDetailCont
                                                .appintmentData
                                                .value
                                                .encounterId,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ]
                        ],
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
      widgetsStackedOverBody: [
        Positioned(
          bottom: 16,
          width: Get.width,
          child: Obx(
            () {
              if (!showBtns) return const Offstage();
              if (appointmentDetailCont.appintmentData.value.status ==
                  RequestStatus.pending) {
                return Row(
                  children: [
                    AppButton(
                      width: Get.width,
                      height: 48,
                      padding: EdgeInsets.zero,
                      color: appColorPrimary,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: radius(defaultAppButtonRadius / 2)),
                      text: locale.value.confirm,
                      textStyle:
                          appButtonPrimaryColorText.copyWith(color: white),
                      onTap: () {
                        final encounterDetail = EncounterElement(
                          id: appointmentDetailCont
                              .appintmentData.value.encounterId,
                          appointmentId:
                              appointmentDetailCont.appintmentData.value.id,
                          clinicId: appointmentDetailCont
                              .appintmentData.value.clinicId,
                          clinicName: appointmentDetailCont
                              .appintmentData.value.clinicName,
                          description: appointmentDetailCont
                              .appintmentData.value.encounterDescription,
                          doctorId: appointmentDetailCont
                              .appintmentData.value.doctorId,
                          doctorName: appointmentDetailCont
                              .appintmentData.value.doctorName,
                          encounterDate: appointmentDetailCont
                              .appintmentData.value.appointmentDate,
                          userId:
                              appointmentDetailCont.appintmentData.value.userId,
                          userName: appointmentDetailCont
                              .appintmentData.value.userName,
                          userImage: appointmentDetailCont
                              .appintmentData.value.userImage,
                          address: appointmentDetailCont
                              .appintmentData.value.address,
                          userEmail: appointmentDetailCont
                              .appintmentData.value.userEmail,
                          status: appointmentDetailCont
                              .appintmentData.value.encounterStatus,
                        );

                        appointmentDetailCont.updateStatus(
                          id: appointmentDetailCont.appintmentData.value.id,
                          status: getUpdateStatusText(
                              status: appointmentDetailCont
                                  .appintmentData.value.status),
                          context: context,
                          isClockOut: false,
                          encountDetails: encounterDetail,
                        );
                      },
                    ).expand(),
                    SizedBox(width: 12),
                    AppButton(
                      width: Get.width,
                      height: 48,
                      padding: EdgeInsets.zero,
                      color: Colors.red,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: radius(defaultAppButtonRadius / 2)),
                      text: locale.value.cancel,
                      textStyle:
                          appButtonPrimaryColorText.copyWith(color: white),
                      onTap: () {
                        Get.bottomSheet(
                          isScrollControlled: true,
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: CancellationsBookingChargeDialog(
                              appointmentData:
                                  appointmentDetailCont.appintmentData.value,
                              isDurationMode: checkTimeDifference(
                                  inputDateTime: DateTime.parse(
                                      appointmentDetailCont
                                          .appintmentData.value.appointmentDate
                                          .validate())),
                              loaderOnOFF: (p0) {
                                appointmentDetailCont.isLoading(p0);
                              },
                              onBookingCancelled: () {
                                appointmentDetailCont.init();
                                Get.find<AppointmentsController>()
                                    .getAppointmentList();
                              },
                            ),
                          ),
                        );
                      },
                    ).expand(),
                  ],
                ).paddingSymmetric(horizontal: 16);
              } else {
                return Row(
                  children: [
                    AppButton(
                      width: Get.width,
                      height: 48,
                      padding: EdgeInsets.zero,
                      color: appColorPrimary,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: radius(defaultAppButtonRadius / 2)),
                      text: getUpdateStatusText(
                          status: appointmentDetailCont
                              .appintmentData.value.status),
                      textStyle:
                          appButtonPrimaryColorText.copyWith(color: white),
                      onTap: () {
                        final encounterDetail = EncounterElement(
                          id: appointmentDetailCont
                              .appintmentData.value.encounterId,
                          appointmentId:
                              appointmentDetailCont.appintmentData.value.id,
                          clinicId: appointmentDetailCont
                              .appintmentData.value.clinicId,
                          clinicName: appointmentDetailCont
                              .appintmentData.value.clinicName,
                          description: appointmentDetailCont
                              .appintmentData.value.encounterDescription,
                          doctorId: appointmentDetailCont
                              .appintmentData.value.doctorId,
                          doctorName: appointmentDetailCont
                              .appintmentData.value.doctorName,
                          encounterDate: appointmentDetailCont
                              .appintmentData.value.appointmentDate,
                          userId:
                              appointmentDetailCont.appintmentData.value.userId,
                          userName: appointmentDetailCont
                              .appintmentData.value.userName,
                          userImage: appointmentDetailCont
                              .appintmentData.value.userImage,
                          address: appointmentDetailCont
                              .appintmentData.value.address,
                          userEmail: appointmentDetailCont
                              .appintmentData.value.userEmail,
                          status: appointmentDetailCont
                              .appintmentData.value.encounterStatus,
                        );

                        if (appointmentDetailCont.appintmentData.value.status ==
                            StatusConst.check_in) {
                          Get.to(
                            () => EncountersDashboardScreen(
                                encounterDetail: encounterDetail),
                            arguments: appointmentDetailCont
                                .appintmentData.value.encounterId,
                          );
                        } else {
                          appointmentDetailCont.updateStatus(
                            id: appointmentDetailCont.appintmentData.value.id,
                            status: getUpdateStatusText(
                                status: appointmentDetailCont
                                    .appintmentData.value.status),
                            context: context,
                            isClockOut: false,
                            encountDetails: encounterDetail,
                          );
                        }
                      },
                    ).expand(),
                  ],
                ).paddingSymmetric(horizontal: 16);
              }
            },
          ),
        ),
      ],
    );
  }

  bool get isDoctor =>
      loginUserData.value.userRole.contains(EmployeeKeyConst.doctor);

  bool get showBtns {
    // Doctor can only access Encounter screen (when status is check_in), no Confirm/Cancel/Check-In
    if (isDoctor) {
      return appointmentDetailCont.appintmentData.value.status ==
          StatusConst.check_in;
    }
    return (appointmentDetailCont.appintmentData.value.status !=
                StatusConst.checkout &&
            appointmentDetailCont.appintmentData.value.status !=
                StatusConst.cancelled) ||
        (appointmentDetailCont.appintmentData.value.isEnableAdvancePayment &&
            appointmentDetailCont.appintmentData.value.paymentStatus ==
                PaymentStatus.ADVANCE_PAID);
  }

  Widget paymentDetails(BuildContext context) {
    bool isPaidShow = appointmentDetailCont.appintmentData.value.status ==
            StatusConst.checkout &&
        appointmentDetailCont.appintmentData.value.paymentStatus ==
            PaymentStatus.PAID;

    // 👉 FIX: Calculate bed total up front
    num bedTotal =
        appointmentDetailCont.appintmentData.value.bedAllocation.fold(
      0,
      (sum, item) => sum + item.charge.validate(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(label: locale.value.paymentDetails, isShowAll: false),
        Container(
          width: Get.width,
          padding: const EdgeInsets.all(16),
          decoration: boxDecorationDefault(
              color: context.cardColor, borderRadius: BorderRadius.circular(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(locale.value.serviceTotal, style: secondaryTextStyle())
                      .expand(),
                  PriceWidget(
                    price: num.parse(appointmentDetailCont
                            .appintmentData.value.serviceTotal
                            .toString())
                        .toStringAsFixed(Constants.DECIMAL_POINT)
                        .toDouble(),
                    color: isDarkMode.value ? null : darkGrayTextColor,
                    size: 12,
                    isBoldText: true,
                  ),
                ],
              ),
              8.height,

              if (appointmentDetailCont
                  .appintmentData.value.enableFinalBillingDiscount) ...[
                8.height,
                detailWidgetPrice(
                  leadingWidget: Row(
                    children: [
                      Text(locale.value.discount, style: secondaryTextStyle()),
                      if (appointmentDetailCont
                              .appintmentData.value.billingFinalDiscountType ==
                          TaxType.PERCENTAGE)
                        Text(
                          ' (${appointmentDetailCont.appintmentData.value.billingFinalDiscountValue}% ${locale.value.off})',
                          style: boldTextStyle(color: Colors.green, size: 12),
                        )
                      else if (appointmentDetailCont
                              .appintmentData.value.billingFinalDiscountType ==
                          TaxType.FIXED)
                        PriceWidget(
                          price: appointmentDetailCont
                              .appintmentData.value.billingFinalDiscountValue,
                          color: Colors.green,
                          size: 12,
                          isDiscountedPrice: true,
                        )
                    ],
                  ),
                  value: appointmentDetailCont
                      .appintmentData.value.billingFinalDiscountAmount,
                  textColor: Colors.green,
                ),
                detailWidgetPrice(
                  title: locale.value.subtotal,
                  value: appointmentDetailCont.appintmentData.value.subtotal,
                ),
              ],

              /// TAX
              if (appointmentDetailCont
                  .appintmentData.value.isExclusiveTaxesAvailable)
                detailWidgetPrice(
                  leadingWidget: Row(
                    children: [
                      Text(locale.value.exclusiveTax,
                              style: secondaryTextStyle())
                          .expand(),
                      const Icon(Icons.info_outline_rounded,
                              size: 20, color: appColorPrimary)
                          .onTap(
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
                                taxes: appointmentDetailCont
                                    .appintmentData.value.exclusiveTaxList,
                                title: locale.value.appliedExclusiveTaxes,
                              );
                            },
                          );
                        },
                      ),
                      8.width,
                    ],
                  ).expand(),
                  value: appointmentDetailCont
                      .appintmentData.value.totalExclusiveTax,
                  isSemiBoldText: true,
                  textColor: appColorSecondary,
                ),
              if (bedTotal > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(locale.value.bedPrice, style: secondaryTextStyle()),
                    PriceWidget(
                      price: bedTotal,
                      color: isDarkMode.value ? null : darkGrayTextColor,
                      size: 12,
                      isBoldText: true,
                    ),
                  ],
                ),
                8.height,
              ],
              commonDivider.paddingSymmetric(vertical: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(locale.value.total, style: boldTextStyle(size: 14)),
                  PriceWidget(
                    price: (appointmentDetailCont
                        .appintmentData.value.totalAmount),
                    color: appColorPrimary,
                  ),
                ],
              ),
              8.height,
              if (appointmentDetailCont.appintmentData.value.paymentStatus ==
                      PaymentStatus.PAID &&
                  appointmentDetailCont
                      .appintmentData.value.isEnableAdvancePayment &&
                  !appointmentDetailCont.appintmentData.value.status
                      .toLowerCase()
                      .contains(StatusConst.cancel.toLowerCase()) &&
                  appointmentDetailCont.appintmentData.value.advancePaidAmount >
                      0)
                detailWidgetPrice(
                  leadingWidget: Text(locale.value.advancePaidAmount,
                      style: boldTextStyle(size: 14)),
                  value: appointmentDetailCont
                      .appintmentData.value.advancePaidAmount,
                  textColor: completedStatusColor,
                ),
              if (appointmentDetailCont.appintmentData.value.paymentStatus ==
                      PaymentStatus.PAID &&
                  appointmentDetailCont
                      .appintmentData.value.isEnableAdvancePayment &&
                  !appointmentDetailCont.appintmentData.value.status
                      .toLowerCase()
                      .contains(StatusConst.cancel.toLowerCase()) &&
                  appointmentDetailCont
                          .appintmentData.value.remainingPayableAmount >
                      0)
                detailWidgetPrice(
                  leadingWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(locale.value.remainingAmount,
                          style: boldTextStyle(size: 14)),
                      8.width,
                      Text(
                        '(${locale.value.paid})',
                        style: secondaryTextStyle(color: completedStatusColor),
                      ).visible(isPaidShow)
                    ],
                  ),
                  value: appointmentDetailCont
                      .appintmentData.value.remainingPayableAmount,
                ),

              /// Advance Paid (ADVANCE_PAID mode)
              if (appointmentDetailCont.appintmentData.value.paymentStatus ==
                      PaymentStatus.ADVANCE_PAID &&
                  appointmentDetailCont
                      .appintmentData.value.isEnableAdvancePayment &&
                  appointmentDetailCont.appintmentData.value.advancePaidAmount >
                      0) ...[
                8.height,
                detailWidgetPrice(
                  leadingWidget: Row(
                    children: [
                      Text(locale.value.advancePaidAmount,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: secondaryTextStyle()),
                      Text(
                        ' (${appointmentDetailCont.appintmentData.value.advancePaymentAmount}%)',
                        style: boldTextStyle(
                            color: completedStatusColor, size: 12),
                      ),
                    ],
                  ).flexible(),
                  textColor: completedStatusColor,
                  value: appointmentDetailCont
                      .appintmentData.value.advancePaidAmount,
                ),
              ],

              if ((!appointmentDetailCont.appintmentData.value.status
                      .toLowerCase()
                      .contains(StatusConst.cancel.toLowerCase())) &&
                  appointmentDetailCont
                          .appintmentData.value.remainingPayableAmount >
                      0) ...[
                10.height,
                detailWidgetPrice(
                  title: locale.value.remainingPayableAmount,
                  isSemiBoldText: true,
                  textColor: pendingStatusColor,
                  value: appointmentDetailCont
                      .appintmentData.value.remainingPayableAmount,
                ),
              ],
            ],
          ),
        ),

        /// Refundable Section — Canceled
        if (appointmentDetailCont.appintmentData.value.status
            .toLowerCase()
            .contains(StatusConst.cancel.toLowerCase()))
          Container(
            width: Get.width,
            padding: const EdgeInsets.all(16),
            decoration: boxDecorationDefault(color: completedStatusColor),
            child: detailWidgetPrice(
              leadingWidget: Text(locale.value.refundableAmount,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: primaryTextStyle(color: Colors.white)),
              textColor: Colors.white,
              value: appointmentDetailCont
                          .appintmentData.value.advancePaidAmount >
                      0
                  ? appointmentDetailCont.appintmentData.value.advancePaidAmount
                  : appointmentDetailCont.appintmentData.value.totalAmount,
              paddingBottom: 0,
            ),
          ).paddingOnly(top: 16),
      ],
    );
  }

  Widget medicalReportWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(label: locale.value.medicalReports, isShowAll: false),
        AnimatedWrap(
          listAnimationType: ListAnimationType.None,
          spacing: 16,
          runSpacing: 16,
          itemCount:
              appointmentDetailCont.appintmentData.value.medicalReport.length,
          itemBuilder: (ctx, index) {
            final AppointmentMedicalReport medicalReportData =
                appointmentDetailCont.appintmentData.value.medicalReport[index];
            return GestureDetector(
              onTap: () {
                viewFiles(medicalReportData.url);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 80,
                height: 80,
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: Get.context!.cardColor,
                  border: Border.all(color: borderColor),
                ),
                child: medicalReportData.url.isImage
                    ? CachedImageWidget(
                        url: medicalReportData.url,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        radius: defaultRadius,
                      )
                    : CommonPdfPlaceHolder(
                        text: medicalReportData.url.split("/").last,
                        fileLink: medicalReportData.url,
                        height: 80,
                        width: 80,
                      ),
              ),
            );
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  void showMedicalReportsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: radiusCircular(16),
          topRight: radiusCircular(16),
        ),
      ),
      builder: (context) {
        return Container(
          height: Get.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.value.medicalReports,
                    style: boldTextStyle(size: 18),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              16.height,
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: appointmentDetailCont
                      .appintmentData.value.medicalReport.length,
                  itemBuilder: (context, index) {
                    final AppointmentMedicalReport medicalReportData =
                        appointmentDetailCont
                            .appintmentData.value.medicalReport[index];
                    return GestureDetector(
                      onTap: () {
                        viewFiles(medicalReportData.url);
                      },
                      child: Container(
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: context.cardColor,
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor: transparentColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(defaultRadius),
                                    topRight: Radius.circular(defaultRadius),
                                  ),
                                ),
                                child: medicalReportData.url.isImage
                                    ? CachedImageWidget(
                                        url: medicalReportData.url,
                                        fit: BoxFit.cover,
                                        radius: defaultRadius,
                                      )
                                    : CommonPdfPlaceHolder(
                                        text: medicalReportData.url
                                            .split("/")
                                            .last,
                                        fileExt: medicalReportData.url
                                            .split("/")
                                            .last,
                                      ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              child: Text(
                                medicalReportData.url.split("/").last,
                                style: secondaryTextStyle(size: 10),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget detailWidgetPrice(
      {Widget? leadingWidget,
      Widget? trailingWidget,
      String? title,
      num? value,
      Color? textColor,
      bool isSemiBoldText = false,
      double? paddingBottom}) {
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
            ),
      ],
    ).paddingBottom(paddingBottom ?? 10);
  }
}
