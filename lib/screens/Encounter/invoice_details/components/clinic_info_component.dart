import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/app_common.dart';
import '../model/billing_details_resp.dart';

class ClinicInfoComponent extends StatelessWidget {
  final BillingDetailModel clinicData;

  const ClinicInfoComponent({super.key, required this.clinicData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(clinicData.clinicName, style: boldTextStyle(size: 14, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor)).expand(),
              Text(clinicData.date.dateInDMMMMyyyyFormat, style: secondaryTextStyle(size: 12, color: appBodyColor)),
            ],
          ),
          8.height,
          Row(
            children: [
              const CachedImageWidget(
                url: Assets.iconsIcMail,
                height: 12,
                width: 12,
                color: iconColor,
              ),
              14.width,
              InkWell(
                onTap: () {
                  launchMail(clinicData.clinicEmail);
                },
                child: Text(
                  clinicData.clinicEmail,
                  style: secondaryTextStyle(
                    size: 12,
                    color: appColorSecondary,
                    decoration: TextDecoration.underline,
                    decorationColor: appColorSecondary,
                  ),
                ),
              ),
            ],
          ),
          8.height,
          Row(
            children: [
              const CachedImageWidget(
                url: Assets.iconsIcLocation,
                height: 14,
                width: 14,
                color: iconColor,
              ),
              12.width,
              Text(
                clinicData.clinicAddress,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: secondaryTextStyle(
                  size: 12,
                  color: dividerColor,
                ),
              ).flexible(),
            ],
          ),
        ],
      ),
    );
  }
}
