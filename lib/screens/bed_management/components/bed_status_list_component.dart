import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'bed_status_item_widget.dart';
import '../bed_status_controller.dart';

class BedStatusListComponent extends StatelessWidget {
  BedStatusListComponent({super.key});

  final BedStatusController bedStatusController = Get.find<BedStatusController>(); 
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: bedStatusController.bedList.map((bed) {
            return BedStatusItemWidget(bed: bed).paddingRight(16);
          }).toList(),
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }
}
