import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../model/review_model.dart';

class DoctorReviewCard extends StatelessWidget {
  final ReviewModel doctorReviewData;

  const DoctorReviewCard({super.key, required this.doctorReviewData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Get.width,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: boxDecorationDefault(color: extraLightPrimaryColor, borderRadius: radius(22)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CachedImageWidget(
                        url: Assets.iconsIcStarFilled,
                        color: upcomingStatusColor,
                        height: 12,
                      ),
                      5.width,
                      Text(
                        doctorReviewData.rating.toStringAsFixed(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: boldTextStyle(size: 12, color: appColorPrimary, weight: FontWeight.w700),
                      ).paddingTop(2),
                    ],
                  ),
                ),
                Text(
                  doctorReviewData.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: boldTextStyle(size: 14),
                ).paddingLeft(8).expand(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: boxDecorationDefault(color: lightSecondaryColor, borderRadius: radius(22)),
                  alignment: Alignment.center,
                  child: Text(
                    doctorReviewData.serviceName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: boldTextStyle(size: 12, color: appColorSecondary),
                  ),
                ).paddingLeft(16).expand().visible(doctorReviewData.serviceName.isNotEmpty),
              ],
            ),
          ),
          Row(
            children: [
              CachedImageWidget(
                url: doctorReviewData.profileImage,
                firstName: doctorReviewData.username,
                height: 35,
                width: 35,
                fit: BoxFit.cover,
                circle: true,
              ),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${locale.value.by} ${doctorReviewData.username}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: primaryTextStyle(),
                      ),
                      const CachedImageWidget(url: Assets.iconsIcVerified, width: 14, height: 14).paddingLeft(8),
                    ],
                  ),
                  4.height,
                  Text(
                    doctorReviewData.createdAt.dateInyyyyMMddHHmmFormat.timeAgoWithLocalization,
                    style: secondaryTextStyle(color: secondaryTextColor),
                  ),
                ],
              ),
            ],
          ).paddingTop(16).visible(doctorReviewData.username.isNotEmpty),
          Text(doctorReviewData.reviewMsg, style: secondaryTextStyle()).paddingTop(16).visible(doctorReviewData.reviewMsg.isNotEmpty),
        ],
      ),
    );
  }
}
