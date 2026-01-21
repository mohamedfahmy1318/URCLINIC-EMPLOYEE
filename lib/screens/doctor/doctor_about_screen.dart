import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../generated/assets.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import 'model/doctor_list_res.dart';

class DoctorAboutScreen extends StatelessWidget {
  final Doctor doctorData;
  const DoctorAboutScreen({super.key, required this.doctorData});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.aboutMyself,
      appBarVerticalSize: Get.height * 0.12,
      body: AnimatedScrollView(
        padding: const EdgeInsets.all(24),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              locale.value.contactInfo,
              style: boldTextStyle(size: 16),
            ),
          ),
          8.height,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    launchCall(doctorData.mobile);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      const CachedImageWidget(url: Assets.iconsIcCall, color: iconColor, width: 14, height: 14),
                      12.width,
                      Text(
                        doctorData.mobile,
                        style: primaryTextStyle(color: secondaryTextColor),
                      ),
                    ],
                  ),
                ),
                16.height,
                GestureDetector(
                  onTap: () {
                    launchMail(doctorData.email);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      const CachedImageWidget(url: Assets.iconsIcMail, color: iconColor, width: 14, height: 14),
                      12.width,
                      Text(
                        doctorData.email,
                        style: primaryTextStyle(color: secondaryTextColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          16.height,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              locale.value.specialization,
              style: boldTextStyle(size: 16),
            ),
          ),
          8.height,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Row(
              children: [
                const CachedImageWidget(url: Assets.iconsIcSpecialization, color: iconColor, width: 14, height: 14),
                12.width,
                Text(
                  doctorData.expert,
                  style: primaryTextStyle(color: secondaryTextColor),
                ),
              ],
            ),
          ),
          16.height,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              locale.value.experience,
              style: boldTextStyle(size: 16),
            ),
          ),
          8.height,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Row(
              children: [
                const CachedImageWidget(url: Assets.iconsIcExperience, color: iconColor, width: 14, height: 14),
                12.width,
                Text(
                  doctorData.experience,
                  style: primaryTextStyle(color: secondaryTextColor),
                ),
              ],
            ),
          ),
          16.height,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              locale.value.about,
              style: boldTextStyle(size: 16),
            ),
          ),
          8.height,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: ReadMoreText(
              parseHtmlString(doctorData.aboutSelf),
              trimLines: 4,
              style: secondaryTextStyle(size: 14, color: secondaryTextColor),
              colorClickableText: appColorPrimary,
              trimMode: TrimMode.Line,
              textAlign: TextAlign.justify,
              trimCollapsedText: " ...${locale.value.readMore}",
              trimExpandedText: locale.value.readLess,
              locale: Localizations.localeOf(context),
            ),
          ),
        ],
      ),
    );
  }
}
