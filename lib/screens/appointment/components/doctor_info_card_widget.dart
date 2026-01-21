import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../doctor/doctor_detail_screen.dart';
import '../../doctor/model/doctor_list_res.dart';
import '../model/appointments_res_model.dart';

class DoctorInfoCardWidget extends StatelessWidget {
  final AppointmentData doctorInfo;

  const DoctorInfoCardWidget({super.key, required this.doctorInfo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DoctorDetailScreen(), arguments: Doctor(doctorId: doctorInfo.doctorId));
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
                  url: doctorInfo.doctorImage,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  circle: true,
                ),
                16.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctorInfo.doctorName, style: boldTextStyle(size: 16)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            launchCall(doctorInfo.doctorPhone);
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
                                doctorInfo.doctorPhone,
                                style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorPrimary, color: appColorPrimary),
                              ),
                            ],
                          ),
                        ).paddingTop(8).visible(doctorInfo.doctorPhone.isNotEmpty),
                        GestureDetector(
                          onTap: () {
                            launchMail(doctorInfo.doctorEmail);
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
                                doctorInfo.doctorEmail,
                                style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorSecondary, color: appColorSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ).paddingTop(8).visible(doctorInfo.doctorEmail.isNotEmpty),
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
