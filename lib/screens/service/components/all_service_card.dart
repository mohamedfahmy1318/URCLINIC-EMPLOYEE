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

  const AllServiceCard({super.key, required this.serviceElement, this.trailing, this.onClickAssignDoctor});

  num _getDisplayPrice() {
    if (loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) && serviceElement.assignDoctor.isNotEmpty) {
      try {
        final doctorAssignment = serviceElement.assignDoctor.firstWhere(
          (element) => element.doctorId == loginUserData.value.id && element.clinicId == selectedAppClinic.value.id,
          orElse: () => AssignDoctor(priceDetail: PriceDetail(serviceAmount: serviceElement.charges)),
        );

        num taxAmount = 0;
        if (doctorAssignment.priceDetail.inclusiveTaxList.isNotEmpty) {
          for (var tax in doctorAssignment.priceDetail.inclusiveTaxList) {
            if (tax.type == "percent") {
              taxAmount += (doctorAssignment.charges * tax.value / 100);
            } else if (tax.type == "fixed") {
              taxAmount += tax.amount;
            }
          }
        } else {
          taxAmount = doctorAssignment.priceDetail.totalInclusiveTax;
        }

        final finalPrice = doctorAssignment.charges + taxAmount;
        return finalPrice > 0 ? finalPrice : serviceElement.charges;
      } catch (e) {
        return serviceElement.charges;
      }
    }
    return serviceElement.charges;
  }

  @override
  Widget build(BuildContext context) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: boxDecorationDefault(
                          color: isDarkMode.value ? Colors.grey.withValues(alpha: 0.1) : lightSecondaryColor,
                          borderRadius: radius(8),
                        ),
                        child: Text(
                          serviceElement.categoryName,
                          overflow: TextOverflow.ellipsis,
                          style: boldTextStyle(size: 10, fontFamily: fontFamilyWeight700, color: appColorSecondary),
                        ),
                      ).flexible(),
                      if (trailing != null) trailing!,
                    ],
                  ).paddingOnly(
                    bottom: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) || loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) ? 0 : 8,
                    top: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) || loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) ? 0 : 8,
                  ),
                  Text(serviceElement.name, overflow: TextOverflow.ellipsis, maxLines: 2, style: boldTextStyle(size: 16)),
                ],
              ).expand(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 4,
                children: [
                  Text("${locale.value.price}:", style: secondaryTextStyle(size: 14)),
                  PriceWidget(
                    price: _getDisplayPrice(),
                    isExtraBoldText: true,
                  ),
                  if (serviceElement.isInclusiveTaxesAvailable) ...[
                    Text(locale.value.includesInclusiveTax, style: secondaryTextStyle(color: appColorSecondary, size: 10, fontStyle: FontStyle.italic)),
                  ],
                ],
              ),
              TextButton(
                style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                onPressed: onClickAssignDoctor,
                child: Text(
                  loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? locale.value.changePrice : locale.value.assignDoctor,
                  style: boldTextStyle(size: 14, fontFamily: fontFamilyWeight700, color: appColorSecondary),
                ).paddingSymmetric(horizontal: 8),
              ).flexible().visible(trailing == null),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }
}
