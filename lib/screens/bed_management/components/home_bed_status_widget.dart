import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/app_logo_widget.dart';
import 'package:kivicare_clinic_admin/utils/view_all_label_component.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_status_controller.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_assign_screen.dart';
import '../../../main.dart';
import '../bed_status_screen.dart';

class HomeBedStatusWidget extends StatelessWidget {
  const HomeBedStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BedStatusController bedStatusController = Get.find();

    return Obx(() {
      if (bedStatusController.isLoading.value && bedStatusController.bedList.isEmpty) {
        return Center(
          child: AppLogoWidget(),
        );
      }

      final List<dynamic> bedsToShow = bedStatusController.bedList.take(3).toList();

      if (bedsToShow.isEmpty) {
        return const Offstage();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          ViewAllLabel(
            label: locale.value.viewAll,
            onTap: () {
              Get.to(() => BedStatusScreen());
            },
          ),
          // 16.height,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: bedsToShow.map((bed) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => BedAssignScreen(isFromBedDetails: false), arguments: {
                      'selectedBed': bed,
                    });
                  },
                  child: BedStatusItemWidget(bed: bed).paddingRight(16),
                );
              }).toList(),
            ).paddingSymmetric(horizontal: 0),
          ),
        ],
      ).paddingSymmetric(horizontal: 16);
    });
  }
}
