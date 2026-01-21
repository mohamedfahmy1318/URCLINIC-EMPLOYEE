import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../model/medical_reports_res_model.dart';
import '../medical_reports_controller.dart';

class MedicalReportCard extends StatelessWidget {
  final MedicalReport medicalReport;
  final void Function()? onEditClick;
  final void Function()? onDeleteClick;
  MedicalReportCard({
    super.key,
    this.onEditClick,
    this.onDeleteClick,
    required this.medicalReport,
  });

  final MedicalReportsController medicalReportsCont = Get.put(MedicalReportsController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        viewFiles(medicalReport.fileUrl);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: boxDecorationDefault(
          borderRadius: BorderRadius.circular(6),
          color: context.cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(medicalReport.name, style: secondaryTextStyle(size: 16, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor)).expand(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
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
                        height: 18,
                        width: 18,
                      ),
                    ),
                  ],
                ).visible(medicalReportsCont.encounterData.value.status),
              ],
            ).paddingBottom(6),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${locale.value.date}: ',
                    style: primaryTextStyle(color: dividerColor, size: 12),
                  ),
                  TextSpan(
                    text: medicalReport.updatedAt.dateInMMMMDyyyyFormat,
                    style: secondaryTextStyle(size: 12, weight: FontWeight.w500, color: isDarkMode.value ? null : darkGrayTextColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
