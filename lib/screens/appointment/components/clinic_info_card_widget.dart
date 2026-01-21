import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/clinic_detail_screen.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../model/appointments_res_model.dart';

class ClinicInfoCardWidget extends StatelessWidget {
  final AppointmentData clinicInfo;
  const ClinicInfoCardWidget({super.key, required this.clinicInfo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ClinicDetailScreen(), arguments: ClinicData(id: clinicInfo.clinicId, clinicImage: clinicInfo.clinicImage, name: clinicInfo.clinicName));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: boxDecorationDefault(color: context.cardColor),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedImageWidget(
                  url: clinicInfo.clinicImage,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  circle: true,
                ),
                16.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(clinicInfo.clinicName, style: boldTextStyle(size: 16)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            launchCall(clinicInfo.clinicPhone);
                          },
                          child: Row(
                            children: [
                              const CachedImageWidget(
                                url: Assets.iconsIcCall,
                                width: 14,
                                height: 14,
                                color: iconColor,
                              ),
                              12.width,
                              Text(
                                clinicInfo.clinicPhone,
                                style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorSecondary, color: appColorSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ).paddingTop(8).visible(clinicInfo.clinicPhone.isNotEmpty),
                        GestureDetector(
                          onTap: () {
                            launchMap(clinicInfo.clinicAddress);
                          },
                          child: Row(
                            children: [
                              const CachedImageWidget(
                                url: Assets.imagesLocationPin,
                                width: 16,
                                height: 16,
                                color: iconColor,
                              ),
                              12.width,
                              Text(
                                clinicInfo.clinicAddress,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorPrimary, color: appColorPrimary),
                              ).flexible(),
                            ],
                          ),
                        ).paddingTop(8).visible(clinicInfo.clinicAddress.isNotEmpty),
                      ],
                    ),
                  ],
                ).expand(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
