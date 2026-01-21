import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../components/cached_image_widget.dart';
import '../../bed_management/bed_type/receptionist_bed_type_screen.dart';
import '../model/receptionist_res_model.dart';

class ReceptionistCardComponent extends StatelessWidget {
  final ReceptionistData receptionist;
  final void Function()? onEditClick;
  final void Function()? onDeleteClick;

  const ReceptionistCardComponent({super.key, required this.receptionist, this.onEditClick, this.onDeleteClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Row(
        children: [
          CachedImageWidget(
            url: receptionist.profileImage,
            fit: BoxFit.cover,
            height: 60,
            width: 60,
            circle: true,
            // color: const Color(0xFF6E8192),
          ).paddingSymmetric(vertical: 12),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                receptionist.fullName,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle(size: 14),
              ),
              8.height,
              Row(
                children: [
                  const CachedImageWidget(
                    url: Assets.iconsIcHospital,
                    fit: BoxFit.cover,
                    height: 15,
                    width: 15,
                    circle: true,
                    color: iconColor,
                  ),
                  8.width,
                  Text(
                    receptionist.clinicName,
                    overflow: TextOverflow.ellipsis,
                    style: secondaryTextStyle(size: 12),
                  ),
                ],
              ),
            ],
          ).flexible(),
          Column(
            children: [
              IconButton(
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Get.to(() => const ReceptionistBedTypeScreen());
                },
                icon: const Icon(
                  Icons.hotel,
                  size: 18,
                  color: appColorPrimary,
                ),
              ),
              IconButton(
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: onDeleteClick,
                icon: const CachedImageWidget(
                  url: Assets.iconsIcDelete,
                  height: 18,
                  width: 18,
                  color: redColor,
                ),
              ),
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
                  color: appColorPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
