import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../auth/model/common_model.dart';
import '../model/appointments_res_model.dart';

class PatientInfoCardWidget extends StatelessWidget {
  final AppointmentData appointmentDet;
  const PatientInfoCardWidget({super.key, required this.appointmentDet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedImageWidget(
                url: appointmentDet.userImage,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                circle: true,
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appointmentDet.userName, style: boldTextStyle(size: 16)),
                  8.height,
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
                          16.width
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
                            appointmentDet.userDob.dateInDMMMyyyyFormat,
                            style: secondaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ).visible(appointmentDet.userDob.isNotEmpty),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          launchCall(appointmentDet.userPhone);
                        },
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
                              appointmentDet.userPhone.firstLetter == '+' ? appointmentDet.userPhone : '+${appointmentDet.userPhone}',
                              style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorPrimary, color: appColorPrimary),
                            ),
                          ],
                        ),
                      ).paddingTop(8).visible(appointmentDet.userPhone.isNotEmpty),
                      GestureDetector(
                        onTap: () {
                          launchMail(appointmentDet.userEmail);
                        },
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
                              appointmentDet.userEmail,
                              style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorSecondary, color: appColorSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ).paddingTop(8).visible(appointmentDet.userEmail.isNotEmpty),
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

  CMNModel get gender => genders.firstWhere((element) => element.slug == appointmentDet.userGender.toLowerCase(), orElse: () => CMNModel());
}
