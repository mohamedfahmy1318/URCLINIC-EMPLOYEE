import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/screens/doctor/model/doctor_list_res.dart';
import '../../../../generated/assets.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(
        color: transparentColor,
      ),
      child: Stack(
        children: [
          CachedImageWidget(
            url: doctor.profileImage,
            height: Get.height * 0.25,
            fit: BoxFit.cover,
            width: Get.width / 2 - 24,
          ).cornerRadiusWithClipRRect(defaultRadius),
          Positioned(
            top: 12,
            left: 12,
            child: CachedImageWidget(
              url: Assets.iconsIcOnline,
              height: 16,
              width: 16,
              color: doctor.status.getBoolInt() ? null : redColor,
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            left: 16,
            child: Container(
              decoration: boxDecorationDefault(
                  color: context.cardColor,
                  borderRadius: radius(defaultRadius - 4)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  Text(doctor.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: primaryTextStyle()),
                  Text(doctor.expert,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: secondaryTextStyle())
                      .paddingTop(6)
                      .visible(doctor.expert.isNotEmpty),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
