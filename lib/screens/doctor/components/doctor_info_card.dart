import 'package:flutter/material.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../doctor_detail_controller.dart';

class DoctorInfoCard extends StatelessWidget {
  const DoctorInfoCard({
    super.key,
    required this.sizeOfInfoCard,
    required this.doctorDetailCont,
  });

  final double sizeOfInfoCard;
  final DoctorDetailController doctorDetailCont;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeOfInfoCard,
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: radius(defaultRadius / 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                          const CachedImageWidget(url: Assets.iconsIcVerified, width: 14, height: 14).paddingLeft(8),
                        ],
                      ).flexible(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: boxDecorationDefault(
                          color: extraLightPrimaryColor,
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
                      ),
                    ],
                  ),
                  8.height,
                  Row(
                    children: [
                      Text(doctorDetailCont.doctorDetails.value.expert.isNotEmpty ? doctorDetailCont.doctorDetails.value.expert : "Orthocare Expert", maxLines: 1, overflow: TextOverflow.ellipsis, style: primaryTextStyle(color: secondaryTextColor))
                          .flexible(),
                    ],
                  ),
                ],
              ).flexible(),
            ],
          ),
          16.height,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${locale.value.socialMedia}:",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: secondaryTextStyle(size: 12),
              ),
              12.width,
              SocialMediaElement(
                iconPath: Assets.socialMediaIcX,
                onPressed: () {
                  commonLaunchUrl(doctorDetailCont.doctorDetails.value.twitterLink, launchMode: LaunchMode.externalApplication);
                },
              ),
              SocialMediaElement(
                iconPath: Assets.socialMediaIcDribble,
                onPressed: () {
                  commonLaunchUrl(doctorDetailCont.doctorDetails.value.dribbbleLink, launchMode: LaunchMode.externalApplication);
                },
              ),
              SocialMediaElement(
                iconPath: Assets.socialMediaIcFb,
                onPressed: () {
                  commonLaunchUrl(doctorDetailCont.doctorDetails.value.facebookLink, launchMode: LaunchMode.externalApplication);
                },
              ),
              SocialMediaElement(
                iconPath: Assets.socialMediaIcInsta,
                onPressed: () {
                  commonLaunchUrl(doctorDetailCont.doctorDetails.value.instagramLink, launchMode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),
          16.height,
        ],
      ),
    );
  }
}

class SocialMediaElement extends StatelessWidget {
  final void Function() onPressed;
  final String iconPath;
  const SocialMediaElement({
    super.key,
    required this.onPressed,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(1),
      constraints: const BoxConstraints(),
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: boxDecorationDefault(color: lightPrimaryColor, shape: BoxShape.circle),
        child: CachedImageWidget(
          url: iconPath,
          height: 16,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
