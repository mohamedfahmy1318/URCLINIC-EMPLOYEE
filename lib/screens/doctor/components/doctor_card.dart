import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/screens/doctor/model/doctor_list_res.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../generated/assets.dart';
import '../../../utils/app_common.dart';
import '../../../utils/constants.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final void Function()? onEditClick;
  final void Function()? onDeleteClick;

  const DoctorCard({super.key, this.onEditClick, this.onDeleteClick, required this.doctor});

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
            top: 12,
            right: 12,
            child: Container(
              decoration: boxDecorationDefault(color: appColorPrimary, borderRadius: radius(6)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onEditClick,
                    icon: const CachedImageWidget(
                      url: Assets.iconsIcEditReview,
                      height: 18,
                      width: 18,
                      color: white,
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onDeleteClick,
                    icon: const CachedImageWidget(
                      url: Assets.iconsIcDelete,
                      height: 18,
                      width: 18,
                      color: white,
                    ),
                  ).visible(loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            left: 16,
            child: Container(
              decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(defaultRadius - 4)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  Text(doctor.fullName, maxLines: 1, overflow: TextOverflow.ellipsis, style: primaryTextStyle()),
                  Text(doctor.expert, maxLines: 1, overflow: TextOverflow.ellipsis, style: secondaryTextStyle()).paddingTop(6).visible(doctor.expert.isNotEmpty),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
