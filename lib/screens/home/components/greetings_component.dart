import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../components/notification_bell_badge.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../auth/other/notification_screen.dart';

class GreetingsComponent extends StatelessWidget {
  const GreetingsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('👋 ${locale.value.welcomeBack}', style: appButtonTextStyleWhite),
              4.height,
              Obx(
                () => Text(
                  '${locale.value.hey}, ${loginUserData.value.userName.isNotEmpty ? loginUserData.value.userName.capitalizeEachWord().validate() : locale.value.guest.validate()}',
                  style: primaryTextStyle(color: white, size: 20),
                ),
              ),
            ],
          ).expand(),
          16.width,
          NotificationBellBadge(
            onTap: () {
              Get.to(() => NotificationScreen());
            },
          ),
        ],
      ).paddingSymmetric(horizontal: 24),
    );
  }
}
