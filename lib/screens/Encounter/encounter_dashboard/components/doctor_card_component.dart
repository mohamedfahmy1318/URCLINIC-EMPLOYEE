import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';

import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../model/encounters_list_model.dart';

class DoctorCardComponent extends StatelessWidget {
  final EncounterElement encounterData;

  const DoctorCardComponent({super.key, required this.encounterData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: boxDecorationDefault(
        borderRadius: BorderRadius.circular(6),
        color: context.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${locale.value.doctorName}: ',
                      style: primaryTextStyle(color: dividerColor, size: 12),
                    ),
                    TextSpan(
                      text: encounterData.doctorName,
                      style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                    ),
                  ],
                ),
              ).expand(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: boxDecorationDefault(
                  borderRadius: BorderRadius.circular(20),
                  color: encounterData.status ? lightGreenColor : lightSecondaryColor,
                ),
                child: Text(encounterData.status ? locale.value.active : locale.value.closed, style: boldTextStyle(size: 10, color: encounterData.status ? completedStatusColor : appColorSecondary, weight: FontWeight.w700)),
              ),
            ],
          ),
          8.height,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${locale.value.clinicName}: ',
                  style: primaryTextStyle(color: dividerColor, size: 12),
                ),
                TextSpan(
                  text: encounterData.clinicName,
                  style: boldTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                ),
              ],
            ),
          ),
          if (encounterData.description.isNotEmpty) ...[
            4.height,
            Divider(color: isDarkMode.value ? borderColor.withValues(alpha: 0.2) : context.dividerColor.withValues(alpha: 0.2)),
            4.height,
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${locale.value.description}: ',
                    style: primaryTextStyle(color: dividerColor, size: 12),
                  ),
                  TextSpan(
                    text: encounterData.description,
                    style: boldTextStyle(size: 12, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
