import 'package:flutter/material.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/model/bed_master_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';

class BedStatusItemWidget extends StatelessWidget {
  final BedMasterModel bed;

  const BedStatusItemWidget({super.key, required this.bed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 3 - 22,
      height: Get.width / 3 - 25,
      alignment: Alignment.center,
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.iconsIcBed,
            color: BedColors.available,
            height: 24,
            width: 24,
          ),
          4.height,
          Text(
            bed.bed.validate(),
            style: primaryTextStyle(color: textPrimaryColorGlobal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
