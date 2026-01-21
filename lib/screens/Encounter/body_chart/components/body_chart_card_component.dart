import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/view_img_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/body_chart/add_body_chart/add_body_chart_screen.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/common_base.dart';
import '../body_chart_controller.dart';
import '../model/body_chart_resp.dart';

class BodyChartCardComponent extends StatelessWidget {
  final BodyChartModel chartDetails;
  final int index;
  final VoidCallback? onDeleteClick;
  BodyChartCardComponent({
    super.key,
    required this.chartDetails,
    this.onDeleteClick,
    required this.index,
  });

  final BodyChartController bodyChartCont = Get.put(BodyChartController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(6), color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("#${chartDetails.id}", style: primaryTextStyle(size: 12, color: appColorSecondary)).expand(),
              IconButton(
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  bodyChartCont.setChartDetails(chartDet: chartDetails);
                  Get.to(() => AddBodyChartScreen());
                },
                icon: const CachedImageWidget(
                  url: Assets.iconsIcEditReview,
                  color: iconColorPrimaryDark,
                  height: 18,
                  width: 18,
                ),
              ).visible(bodyChartCont.encounter.value.status),
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
              ).visible(bodyChartCont.encounter.value.status),
            ],
          ),
          2.height,
          Text(chartDetails.name, style: boldTextStyle(size: 16, color: isDarkMode.value ? null : darkGrayTextColor)),
          8.height,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${locale.value.patientName}: ',
                          style: primaryTextStyle(color: dividerColor, size: 12),
                        ),
                        TextSpan(
                          text: chartDetails.patientName,
                          style: primaryTextStyle(size: 12, weight: FontWeight.w500, color: isDarkMode.value ? null : darkGrayTextColor),
                        ),
                      ],
                    ),
                  ),
                  8.height,
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${locale.value.doctorName}: ',
                          style: primaryTextStyle(color: dividerColor, size: 12),
                        ),
                        TextSpan(
                          text: chartDetails.doctorName,
                          style: boldTextStyle(size: 12, weight: FontWeight.w700, color: isDarkMode.value ? null : darkGrayTextColor),
                        ),
                      ],
                    ),
                  ),
                  8.height,
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${locale.value.lastUpdate}: ',
                          style: primaryTextStyle(color: dividerColor, size: 12),
                        ),
                        TextSpan(
                          text: chartDetails.updatedAt.dateInDMMMMyyyyFormat,
                          style: primaryTextStyle(size: 12, weight: FontWeight.w500, color: isDarkMode.value ? null : darkGrayTextColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.to(() => DisplyFullScreenImgWidget(imgUrl: chartDetails.fileUrl, title: chartDetails.name));
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: boxDecorationDefault(),
                  child: CachedImageWidget(
                    url: chartDetails.fileUrl,
                    fit: BoxFit.cover,
                    radius: 6,
                  ),
                ),
              ),
            ],
          ),
          8.height,
          commonDivider.paddingSymmetric(vertical: 8),
          Text(chartDetails.description, style: primaryTextStyle(size: 12, color: dividerColor)),
        ],
      ),
    );
  }
}
