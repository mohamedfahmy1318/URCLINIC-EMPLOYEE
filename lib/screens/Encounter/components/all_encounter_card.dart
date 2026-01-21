import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/constants.dart';
import '../model/encounters_list_model.dart';

class AllEncounterCard extends StatelessWidget {
  final EncounterElement encounterElement;
  final VoidCallback? onEditClick;
  final VoidCallback? onDeleteClick;
  final VoidCallback? onEncounterClick;
  final VoidCallback? onMedicalReportClick;
  final VoidCallback? onBodyChartClick;
  final VoidCallback? onInvoiceClick;

  const AllEncounterCard({
    super.key,
    required this.encounterElement,
    this.onEditClick,
    this.onDeleteClick,
    this.onEncounterClick,
    this.onMedicalReportClick,
    this.onBodyChartClick,
    this.onInvoiceClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: radius(defaultRadius / 2),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          Row(
            children: [
              Text(
                encounterElement.appointmentId == -1 ? locale.value.encounterWithId(encounterElement.id) : '${locale.value.appointment} #${encounterElement.appointmentId}',
                style: boldTextStyle(size: 14, color: appColorPrimary),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: boxDecorationDefault(
                  borderRadius: BorderRadius.circular(20),
                  color: encounterElement.status ? lightGreenColor : lightSecondaryColor,
                ),
                child: Text(
                  encounterElement.status ? locale.value.active : locale.value.closed,
                  style: boldTextStyle(size: 10, color: encounterElement.status ? completedStatusColor : appColorSecondary, weight: FontWeight.w700),
                ),
              ),
            ],
          ).paddingOnly(left: 16, right: 16, bottom: 8),
          if (!loginUserData.value.userRole.contains(EmployeeKeyConst.doctor))
            Row(
              children: [
                Text(
                  encounterElement.doctorName,
                  style: boldTextStyle(size: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ).expand(),
              ],
            ).paddingOnly(left: 16, right: 16, bottom: 8),
          Row(
            children: [
              Text(
                '${locale.value.date}:',
                style: primaryTextStyle(size: 12, color: secondaryTextColor),
              ),
              6.width,
              Text(
                encounterElement.encounterDate.dateInDMMMMyyyyFormat,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle(size: 12),
              ).expand(),
            ],
          ).paddingSymmetric(horizontal: 16),
          8.height,
          Row(
            children: [
              Text(
                '${locale.value.patientName}:',
                style: primaryTextStyle(size: 12, color: secondaryTextColor),
              ),
              6.width,
              Text(
                encounterElement.userName,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle(size: 12),
              ).expand(),
            ],
          ).paddingSymmetric(horizontal: 16),
          6.height,
          Row(
            children: [
              Text(
                '${locale.value.clinicName}:',
                style: primaryTextStyle(size: 12, color: secondaryTextColor),
              ),
              6.width,
              Text(
                encounterElement.clinicName,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle(size: 12),
              ).expand(),
            ],
          ).paddingSymmetric(horizontal: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              commonDivider.paddingSymmetric(horizontal: 16),
              Row(
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onEditClick,
                    icon: const CachedImageWidget(
                      url: Assets.iconsIcEditReview,
                      color: iconColorPrimaryDark,
                      height: 18,
                      width: 18,
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onDeleteClick,
                    icon: const CachedImageWidget(
                      url: Assets.iconsIcDelete,
                      color: iconColorPrimaryDark,
                      height: 18,
                      width: 18,
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onEncounterClick,
                    icon: const CachedImageWidget(
                      url: Assets.iconsIcEncounter,
                      color: iconColorPrimaryDark,
                      height: 18,
                      width: 18,
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onMedicalReportClick,
                    icon: const CachedImageWidget(
                      url: Assets.iconsIcFile,
                      color: iconColorPrimaryDark,
                      height: 18,
                      width: 18,
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onBodyChartClick,
                    icon: const CachedImageWidget(
                      url: Assets.iconsIcPersonBody,
                      color: iconColorPrimaryDark,
                      height: 18,
                      width: 18,
                    ),
                  ).visible(appConfigs.value.isBodyChart),
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onInvoiceClick,
                    icon: const CachedImageWidget(
                      url: Assets.iconsIcInvoice,
                      color: iconColorPrimaryDark,
                      height: 18,
                      width: 18,
                    ),
                  ),
                ],
              ).paddingOnly(left: 8, right: 16),
            ],
          ).visible(encounterElement.status),
          if (encounterElement.status) 8.height else 16.height,
        ],
      ),
    );
  }
}
