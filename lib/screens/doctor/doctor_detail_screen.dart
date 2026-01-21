import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../components/loader_widget.dart';
import '../../generated/assets.dart';
import '../../utils/colors.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/doctor_detail_btm_comp.dart';
import 'components/doctor_info_card.dart';
import 'doctor_detail_controller.dart';

class DoctorDetailScreen extends StatelessWidget {
  DoctorDetailScreen({super.key});

  final DoctorDetailController doctorDetailCont = Get.put(DoctorDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffoldNew(
        appBartitleText: doctorDetailCont.doctorDetails.value.doctorId == loginUserData.value.id ? locale.value.myProfile : locale.value.doctorDetail,
        appBarVerticalSize: Get.height * 0.12,
        body: Obx(
          () => SnapHelperWidget(
            future: doctorDetailCont.doctorDetailFuture.value,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  doctorDetailCont.getDoctorDetail();
                },
              ).paddingSymmetric(horizontal: 16);
            },
            loadingWidget: const LoaderWidget(),
            onSuccess: (res) {
              return AnimatedScrollView(
                children: [
                  Container(
                    color: context.cardColor,
                    child: Column(
                      children: [
                        CachedImageWidget(
                          url: doctorDetailCont.doctorDetails.value.profileImage,
                          fit: BoxFit.cover,
                          width: Get.width,
                          height: Get.height * 0.3,
                          topLeftRadius: (defaultRadius * 2).toInt(),
                          topRightRadius: (defaultRadius * 2).toInt(),
                        ),
                        Column(
                          children: [
                            16.height,
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              doctorDetailCont.doctorDetails.value.fullName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: boldTextStyle(size: 18),
                                            ),
                                            const CachedImageWidget(url: Assets.iconsIcVerified, width: 14, height: 14).paddingLeft(8).visible(doctorDetailCont.doctorDetails.value.emailVerifiedAt.isNotEmpty),
                                          ],
                                        ).flexible(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                          decoration: boxDecorationDefault(
                                            color: isDarkMode.value ? Colors.grey.withValues(alpha: 0.1) : extraLightPrimaryColor,
                                            borderRadius: radius(22),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const CachedImageWidget(
                                                url: Assets.iconsIcStarFilled,
                                                color: upcomingStatusColor,
                                                height: 14,
                                              ),
                                              8.width,
                                              Text(doctorDetailCont.doctorDetails.value.averageRating.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: boldTextStyle(size: 12)),
                                            ],
                                          ),
                                        ).visible(doctorDetailCont.doctorDetails.value.averageRating.toString().isNotEmpty),
                                      ],
                                    ),
                                    8.height,
                                    Row(
                                      children: [
                                        Text(
                                          doctorDetailCont.doctorDetails.value.expert.isNotEmpty ? doctorDetailCont.doctorDetails.value.expert : "Orthocare Expert",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: primaryTextStyle(color: secondaryTextColor),
                                        ).flexible(),
                                      ],
                                    ),
                                  ],
                                ).flexible(),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${locale.value.socialMedia}:",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: secondaryTextStyle(size: 12),
                                ),
                                4.width,
                                SocialMediaElement(
                                  iconPath: Assets.socialMediaIcX,
                                  onPressed: () {
                                    commonLaunchUrl(doctorDetailCont.doctorDetails.value.twitterLink);
                                  },
                                ).paddingLeft(8).visible(doctorDetailCont.doctorDetails.value.twitterLink.isNotEmpty),
                                SocialMediaElement(
                                  iconPath: Assets.socialMediaIcDribble,
                                  onPressed: () {
                                    commonLaunchUrl(doctorDetailCont.doctorDetails.value.dribbbleLink);
                                  },
                                ).paddingLeft(8).visible(doctorDetailCont.doctorDetails.value.dribbbleLink.isNotEmpty),
                                SocialMediaElement(
                                  iconPath: Assets.socialMediaIcFb,
                                  onPressed: () {
                                    commonLaunchUrl(doctorDetailCont.doctorDetails.value.facebookLink);
                                  },
                                ).paddingLeft(8).visible(doctorDetailCont.doctorDetails.value.facebookLink.isNotEmpty),
                                SocialMediaElement(
                                  iconPath: Assets.socialMediaIcInsta,
                                  onPressed: () {
                                    commonLaunchUrl(doctorDetailCont.doctorDetails.value.instagramLink);
                                  },
                                ).paddingLeft(8).visible(doctorDetailCont.doctorDetails.value.instagramLink.isNotEmpty),
                              ],
                            ).paddingTop(16).visible(!showSocial),
                          ],
                        ).paddingSymmetric(horizontal: 24),
                        16.height,
                      ],
                    ),
                  ),
                  // 24.height,
                  ReadMoreText(
                    doctorDetailCont.doctorDetails.value.aboutSelf,
                    trimLines: 3,
                    style: primaryTextStyle(size: 14, color: dividerColor),
                    colorClickableText: appColorPrimary,
                    trimExpandedText: locale.value.readMore,
                  ).paddingAll(24),
                  DoctorDetailBtmComp().paddingSymmetric(horizontal: 24),
                  24.height,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool get showSocial =>
      doctorDetailCont.doctorDetails.value.twitterLink.isEmpty && doctorDetailCont.doctorDetails.value.dribbbleLink.isEmpty && doctorDetailCont.doctorDetails.value.facebookLink.isEmpty && doctorDetailCont.doctorDetails.value.instagramLink.isEmpty;
}
