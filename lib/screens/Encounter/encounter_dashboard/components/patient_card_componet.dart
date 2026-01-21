import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../utils/app_common.dart';
import '../../model/encounters_list_model.dart';

class PatientCardComponent extends StatelessWidget {
  final EncounterElement encounterData;
  const PatientCardComponent({super.key, required this.encounterData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: boxDecorationDefault(
        borderRadius: BorderRadius.circular(6),
        color: context.cardColor,
      ),
      child: Row(
        children: [
          CachedImageWidget(
            url: encounterData.userImage,
            height: 80,
            width: 80,
            circle: true,
            fit: BoxFit.cover,
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              3.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(encounterData.userName, style: boldTextStyle(size: 14, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor)).expand(),
                  Text(encounterData.encounterDate.dateInDMMMMyyyyFormat, style: primaryTextStyle(size: 12, color: dividerColor)),
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
                  8.width,
                  InkWell(
                    onTap: () {
                      launchMail(encounterData.userEmail);
                    },
                    child: Text(
                      encounterData.userEmail,
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
              if (encounterData.address.isNotEmpty)
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
                      encounterData.address,
                      style: secondaryTextStyle(
                        size: 12,
                        color: dividerColor,
                      ),
                    ).expand(),
                  ],
                ).paddingTop(8),
            ],
          ).expand(),
        ],
      ),
    );
  }
}
