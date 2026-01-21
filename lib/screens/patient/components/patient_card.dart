import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../Encounter/add_encounter/model/patient_model.dart';
import '../../auth/model/common_model.dart';

class PatientCardWid extends StatelessWidget {
  final PatientModel patient;

  const PatientCardWid({super.key, required this.patient});

  CMNModel get gender => genders.firstWhere((element) => element.slug == patient.gender.toLowerCase(), orElse: () => CMNModel());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedImageWidget(
                url: patient.profileImage,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                circle: true,
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(patient.fullName, style: boldTextStyle(size: 16)),
                  8.height.visible(patient.dateOfBirth.isNotEmpty || patient.gender.isNotEmpty),
                  Row(
                    children: [
                      Row(
                        children: [
                          const CachedImageWidget(
                            url: Assets.iconsIcUser,
                            width: 14,
                            height: 14,
                            color: iconColor,
                          ),
                          8.width,
                          Text(
                            gender.name,
                            style: secondaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          24.width,
                        ],
                      ).visible(gender.name.isNotEmpty),
                      Row(
                        children: [
                          const CachedImageWidget(
                            url: Assets.iconsIcBirthday,
                            width: 14,
                            height: 14,
                            color: iconColor,
                          ),
                          8.width,
                          Text(
                            patient.dateOfBirth.dateInDMMMyyyyFormat,
                            style: secondaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ).visible(patient.dateOfBirth.isNotEmpty),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          launchCall(patient.mobile);
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Row(
                          children: [
                            const CachedImageWidget(
                              url: Assets.iconsIcCall,
                              width: 16,
                              height: 16,
                              color: iconColor,
                            ),
                            12.width,
                            Text(
                              patient.mobile,
                              style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorPrimary, color: appColorPrimary),
                            ),
                          ],
                        ),
                      ).paddingTop(8).visible(patient.mobile.isNotEmpty),
                      GestureDetector(
                        onTap: () {
                          launchMail(patient.email);
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Row(
                          children: [
                            const CachedImageWidget(
                              url: Assets.iconsIcMail,
                              width: 14,
                              height: 14,
                              color: iconColor,
                            ),
                            12.width,
                            Text(
                              patient.email,
                              style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorSecondary, color: appColorSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ).paddingTop(8).visible(patient.email.isNotEmpty),
                    ],
                  ),
                ],
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}
