import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/configs.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';

import '../../../generated/assets.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../clinic_detail_screen.dart';
import '../model/clinics_res_model.dart';

class ClinicComponent extends StatelessWidget {
  final ClinicData clinicData;
  final void Function()? onEditClick;
  final void Function()? onDeleteClick;

  const ClinicComponent({super.key, this.onEditClick, this.onDeleteClick, required this.clinicData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ClinicDetailScreen(), arguments: clinicData);
      },
      child: Container(
        height: Get.height * 0.42,
        decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedImageWidget(
                  url: clinicData.clinicImage,
                  width: Get.width,
                  topLeftRadius: 8,
                  topRightRadius: 8,
                  fit: clinicData.clinicImage == '$DOMAIN_URL/img/default.webp'
                      ? BoxFit.contain
                      : BoxFit.cover,
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Container(
                        decoration: boxDecorationDefault(color: context.cardColor, shape: BoxShape.circle),
                        child: IconButton(
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(),
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: onEditClick,
                          icon: const CachedImageWidget(
                            url: Assets.iconsIcEditReview,
                            color: iconColor,
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ).visible(loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) || loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)),
                      Container(
                        decoration: boxDecorationDefault(color: context.cardColor, shape: BoxShape.circle),
                        child: IconButton(
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(),
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: onDeleteClick,
                          icon: const CachedImageWidget(
                            url: Assets.iconsIcDelete,
                            color: iconColor,
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ).paddingLeft(12).visible(loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)),
                    ],
                  ),
                ),
              ],
            ).flexible(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                8.height,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "${locale.value.pinCode}: ", style: primaryTextStyle()),
                      TextSpan(text: clinicData.pincode, style: primaryTextStyle(color: appColorSecondary)),
                    ],
                  ),
                ).paddingTop(8).visible(clinicData.pincode.isNotEmpty),
                8.height,
                Row(
                  children: [
                    Text(clinicData.name, style: boldTextStyle()).expand(),
                  ],
                ),
                12.height,
                GestureDetector(
                  onTap: () {
                    launchMap(clinicData.address);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      const CachedImageWidget(url: Assets.iconsIcLocation, color: iconColor, width: 16, height: 16),
                      12.width,
                      Text(
                        clinicData.address,
                        style: secondaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                8.height,
                GestureDetector(
                  onTap: () {
                    launchCall(clinicData.contactNumber);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Row(
                    children: [
                      const CachedImageWidget(url: Assets.iconsIcCall, color: iconColor, width: 14, height: 14),
                      12.width,
                      Text(
                        clinicData.contactNumber,
                        style: primaryTextStyle(color: appColorPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
            16.height,
          ],
        ),
      ),
    );
  }
}
