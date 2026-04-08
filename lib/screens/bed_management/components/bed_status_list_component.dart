import 'package:flutter/material.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'bed_status_item_widget.dart';
import '../bed_status_controller.dart';

class BedStatusListComponent extends StatelessWidget {
  BedStatusListComponent({super.key});

  final BedStatusController? bedStatusController =
      Get.isRegistered<BedStatusController>()
          ? Get.find<BedStatusController>()
          : null;

  @override
  Widget build(BuildContext context) {
    if (!CoreServiceApis.isBedFeatureAvailable || bedStatusController == null) {
      return const Offstage();
    }

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: bedStatusController!.bedList.map((bed) {
            return BedStatusItemWidget(bed: bed).paddingRight(16);
          }).toList(),
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }
}
