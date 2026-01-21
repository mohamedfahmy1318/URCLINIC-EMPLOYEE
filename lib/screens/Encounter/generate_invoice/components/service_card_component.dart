import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/colors.dart';
import '../../../service/all_service_list_controller.dart';
import '../../../service/model/service_list_model.dart';

class SelectServiceCardComponent extends StatelessWidget {
  final ServiceElement serviceData;
  SelectServiceCardComponent({super.key, required this.serviceData});

  final AllServicesController serviceListCont = Get.put(AllServicesController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: boxDecorationDefault(
          borderRadius: BorderRadius.circular(6),
          color: context.cardColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageWidget(
              url: serviceData.serviceImage,
              width: 52,
              radius: 6,
              fit: BoxFit.cover,
              height: 52,
            ),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(serviceData.name, style: boldTextStyle(size: 14, color: isDarkMode.value ? null : darkGrayTextColor)),
                2.height,
                Text(serviceData.description, style: primaryTextStyle(size: 12, color: dividerColor)),
              ],
            ).expand(),
            12.width,
            Obx(
              () => Checkbox(
                checkColor: whiteColor,
                value: (serviceListCont.singleServiceSelect.value.id == serviceData.id).obs.value,
                activeColor: appColorPrimary,
                visualDensity: VisualDensity.compact,
                onChanged: (val) async {
                  serviceListCont.singleServiceSelect(serviceData);
                },
                side: const BorderSide(color: secondaryTextColor, width: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
