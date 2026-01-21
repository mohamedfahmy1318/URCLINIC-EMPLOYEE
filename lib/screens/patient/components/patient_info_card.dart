import 'package:flutter/material.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../patient_detail_controller.dart';

class PatientInfoCard extends StatelessWidget {
  const PatientInfoCard({
    super.key,
    required this.sizeOfInfoCard,
    required this.patientDetailCont,
  });

  final double sizeOfInfoCard;
  final PatientDetailController patientDetailCont;

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
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(patientDetailCont.patientModel.value.firstName, style: boldTextStyle(size: 16)),
              8.height,
              Row(
                children: [
                  Text("${locale.value.gender}:", style: secondaryTextStyle(size: 12)),
                  4.width,
                  Text(patientDetailCont.patientModel.value.gender.capitalize(), style: boldTextStyle(size: 12)),
                ],
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  launchCall(patientDetailCont.patientModel.value.mobile);
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: boxDecorationDefault(
                    color: extraLightPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: commonLeadingWid(imgPath: Assets.iconsIcCall, color: appColorPrimary, size: 15),
                ),
              ),
              16.width,
              GestureDetector(
                onTap: () {
                  launchMail(patientDetailCont.patientModel.value.email);
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: boxDecorationDefault(
                    color: extraLightPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: commonLeadingWid(imgPath: Assets.iconsIcMail, color: appColorPrimary, size: 15),
                ),
              ),
            ],
          ),
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
      constraints: BoxConstraints.tight(const Size.fromRadius(18)),
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: boxDecorationDefault(color: lightPrimaryColor, shape: BoxShape.circle),
        child: CachedImageWidget(
          url: iconPath,
          height: 14,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
