import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/price_widget.dart';
import '../model/service_list_model.dart';

class AllServiceCard extends StatelessWidget {
  final ServiceElement serviceElement;
  final Function()? onClickAssignDoctor;
  final Widget? trailing;
  final bool showActionButton;

  const AllServiceCard(
      {super.key,
      required this.serviceElement,
      this.trailing,
      this.onClickAssignDoctor,
      this.showActionButton = true});

  num _maxPositive(List<num> values, {num fallback = 0}) {
    num maxValue = fallback;
    for (final value in values) {
      if (value > maxValue) maxValue = value;
    }
    return maxValue;
  }

  num _calculateDiscountPercent(
      {required num original, required num finalPrice}) {
    if (original <= 0 || finalPrice >= original) return 0;
    return ((original - finalPrice) / original) * 100;
  }

  _ServicePriceMeta _getServicePriceMeta() {
    if (loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) &&
        serviceElement.assignDoctor.isNotEmpty) {
      try {
        final AssignDoctor doctorAssignment =
            serviceElement.assignDoctor.firstWhere(
          (element) =>
              element.doctorId == loginUserData.value.id &&
              element.clinicId == selectedAppClinic.value.id,
          orElse: () => AssignDoctor(
            charges: serviceElement.charges,
            priceDetail: PriceDetail(
              servicePrice: serviceElement.charges,
              serviceAmount: serviceElement.charges,
            ),
          ),
        );

        final PriceDetail doctorPrice = doctorAssignment.priceDetail;
        final num originalDoctorPrice = _maxPositive(
          <num>[
            doctorAssignment.charges,
            doctorPrice.servicePrice,
            serviceElement.price,
            serviceElement.charges,
          ],
          fallback: serviceElement.charges,
        );

        num discountedDoctorPrice = originalDoctorPrice;
        if (doctorPrice.serviceAmount > 0 &&
            doctorPrice.serviceAmount < originalDoctorPrice) {
          discountedDoctorPrice = doctorPrice.serviceAmount;
        } else if (serviceElement.charges > 0 &&
            serviceElement.charges < originalDoctorPrice) {
          discountedDoctorPrice = serviceElement.charges;
        } else if (serviceElement.payableAmount > 0 &&
            serviceElement.payableAmount < originalDoctorPrice) {
          discountedDoctorPrice = serviceElement.payableAmount;
        }

        final num calculatedDiscount =
            originalDoctorPrice > discountedDoctorPrice
                ? (originalDoctorPrice - discountedDoctorPrice)
                : 0;
        final num discountAmount = doctorPrice.discountAmount > 0
            ? doctorPrice.discountAmount
            : calculatedDiscount;

        final num effectiveDiscountValue = doctorPrice.discountValue > 0
            ? doctorPrice.discountValue
            : _calculateDiscountPercent(
                original: originalDoctorPrice,
                finalPrice: discountedDoctorPrice,
              );
        final String effectiveDiscountType = doctorPrice.discountType.isNotEmpty
            ? doctorPrice.discountType
            : (effectiveDiscountValue > 0
                ? TaxType.PERCENTAGE
                : doctorPrice.discountType);

        final bool hasConfiguredDoctorDiscount =
            _isPercentDiscountType(effectiveDiscountType)
                ? effectiveDiscountValue > 0
                : effectiveDiscountType == TaxType.FIXED &&
                    effectiveDiscountValue > 0;

        return _ServicePriceMeta(
          originalPrice: originalDoctorPrice,
          finalPrice: discountedDoctorPrice,
          discountAmount: discountAmount,
          discountType: effectiveDiscountType,
          discountValue: effectiveDiscountValue,
          hasDiscount: discountAmount > 0 ||
              discountedDoctorPrice < originalDoctorPrice ||
              hasConfiguredDoctorDiscount,
          includesInclusiveTax: doctorPrice.isIncludesInclusiveTaxAvailable ||
              serviceElement.isInclusiveTaxesAvailable,
        );
      } catch (e) {
        return _ServicePriceMeta(
          originalPrice: serviceElement.charges,
          finalPrice: serviceElement.charges,
          discountAmount: 0,
          discountType: serviceElement.discountType,
          discountValue: serviceElement.discountValue,
          hasDiscount: false,
          includesInclusiveTax: serviceElement.isInclusiveTaxesAvailable,
        );
      }
    }

    final num originalPrice = _maxPositive(
      <num>[
        serviceElement.price,
        serviceElement.payableAmount,
        serviceElement.charges,
      ],
      fallback: serviceElement.charges,
    );

    num discountedPrice = originalPrice;
    if (serviceElement.payableAmount > 0 &&
        serviceElement.payableAmount < originalPrice) {
      discountedPrice = serviceElement.payableAmount;
    } else if (serviceElement.charges > 0 &&
        serviceElement.charges < originalPrice) {
      discountedPrice = serviceElement.charges;
    }

    final num calculatedDiscount =
        originalPrice > discountedPrice ? (originalPrice - discountedPrice) : 0;
    final num discountAmount = serviceElement.discountAmount > 0
        ? serviceElement.discountAmount
        : calculatedDiscount;
    final num effectiveDiscountValue = serviceElement.discountValue > 0
        ? serviceElement.discountValue
        : _calculateDiscountPercent(
            original: originalPrice,
            finalPrice: discountedPrice,
          );
    final String effectiveDiscountType = serviceElement.discountType.isNotEmpty
        ? serviceElement.discountType
        : (effectiveDiscountValue > 0
            ? TaxType.PERCENTAGE
            : serviceElement.discountType);

    final bool hasConfiguredDiscount =
        _isPercentDiscountType(effectiveDiscountType)
            ? effectiveDiscountValue > 0
            : effectiveDiscountType == TaxType.FIXED &&
                effectiveDiscountValue > 0;
    final bool hasDiscount = discountAmount > 0 ||
        hasConfiguredDiscount ||
        discountedPrice < originalPrice;

    return _ServicePriceMeta(
      originalPrice: originalPrice,
      finalPrice: discountedPrice,
      discountAmount: discountAmount,
      discountType: effectiveDiscountType,
      discountValue: effectiveDiscountValue,
      hasDiscount: hasDiscount,
      includesInclusiveTax: serviceElement.isInclusiveTaxesAvailable,
    );
  }

  bool _isPercentDiscountType(String type) {
    return type == TaxType.PERCENT || type == TaxType.PERCENTAGE;
  }

  String _formattedPercent(num value) {
    final String raw = value.toStringAsFixed(2);
    if (raw.endsWith('.00')) return raw.replaceAll('.00', '');
    if (raw.endsWith('0')) return raw.substring(0, raw.length - 1);
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final _ServicePriceMeta priceMeta = _getServicePriceMeta();

    return Container(
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        children: [
          16.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: boxDecorationDefault(),
                child: CachedImageWidget(
                  url: serviceElement.serviceImage,
                  fit: BoxFit.cover,
                  radius: 6,
                ),
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: boxDecorationDefault(
                          color: isDarkMode.value
                              ? Colors.grey.withValues(alpha: 0.1)
                              : lightSecondaryColor,
                          borderRadius: radius(8),
                        ),
                        child: Text(
                          serviceElement.categoryName,
                          overflow: TextOverflow.ellipsis,
                          style: boldTextStyle(
                              size: 10,
                              fontFamily: fontFamilyWeight700,
                              color: appColorSecondary),
                        ),
                      ).flexible(),
                      if (trailing != null) trailing!,
                    ],
                  ).paddingOnly(
                    bottom: loginUserData.value.userRole
                                .contains(EmployeeKeyConst.doctor) ||
                            loginUserData.value.userRole
                                .contains(EmployeeKeyConst.vendor)
                        ? 0
                        : 8,
                    top: loginUserData.value.userRole
                                .contains(EmployeeKeyConst.doctor) ||
                            loginUserData.value.userRole
                                .contains(EmployeeKeyConst.vendor)
                        ? 0
                        : 8,
                  ),
                  Text(serviceElement.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: boldTextStyle(size: 16)),
                ],
              ).expand(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("${locale.value.price}:",
                          style: secondaryTextStyle(size: 14)),
                      4.width,
                      if (priceMeta.hasDiscount &&
                          priceMeta.originalPrice > priceMeta.finalPrice)
                        PriceWidget(
                          price: priceMeta.originalPrice,
                          color: dividerColor,
                          size: 12,
                          isLineThroughEnabled: true,
                        ).paddingRight(6),
                      PriceWidget(
                        price: priceMeta.finalPrice,
                        isExtraBoldText: true,
                      ),
                      if (priceMeta.hasDiscount &&
                          _isPercentDiscountType(priceMeta.discountType) &&
                          priceMeta.discountValue > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: boxDecorationDefault(
                            color: Colors.green.withValues(alpha: 0.12),
                            borderRadius: radius(20),
                          ),
                          child: Text(
                            '${_formattedPercent(priceMeta.discountValue)}% ${locale.value.off}',
                            style: boldTextStyle(size: 10, color: Colors.green),
                          ),
                        ),
                    ],
                  ),
                  if (priceMeta.hasDiscount)
                    Row(
                      children: [
                        Text('${locale.value.discount}:',
                            style: secondaryTextStyle(
                                size: 12, color: Colors.green)),
                        4.width,
                        if (_isPercentDiscountType(priceMeta.discountType) &&
                            priceMeta.discountValue > 0)
                          Text(
                            '${_formattedPercent(priceMeta.discountValue)}% ${locale.value.off}',
                            style: boldTextStyle(size: 12, color: Colors.green),
                          )
                        else
                          PriceWidget(
                            price: priceMeta.discountAmount,
                            color: Colors.green,
                            size: 12,
                            isDiscountedPrice: true,
                          ),
                      ],
                    ).paddingTop(4),
                  if (priceMeta.includesInclusiveTax)
                    Text(locale.value.includesInclusiveTax,
                        style: secondaryTextStyle(
                            color: appColorSecondary,
                            size: 10,
                            fontStyle: FontStyle.italic)),
                ],
              ),
              TextButton(
                style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                onPressed: onClickAssignDoctor,
                child: Text(
                  loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)
                      ? locale.value.changePrice
                      : locale.value.assignDoctor,
                  style: boldTextStyle(
                      size: 14,
                      fontFamily: fontFamilyWeight700,
                      color: appColorSecondary),
                ).paddingSymmetric(horizontal: 8),
              ).flexible().visible(showActionButton &&
                  trailing == null &&
                  !loginUserData.value.userRole
                      .contains(EmployeeKeyConst.doctor)),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }
}

class _ServicePriceMeta {
  final num originalPrice;
  final num finalPrice;
  final num discountAmount;
  final String discountType;
  final num discountValue;
  final bool hasDiscount;
  final bool includesInclusiveTax;

  const _ServicePriceMeta({
    required this.originalPrice,
    required this.finalPrice,
    required this.discountAmount,
    required this.discountType,
    required this.discountValue,
    required this.hasDiscount,
    required this.includesInclusiveTax,
  });
}
