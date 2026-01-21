import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';

class SwitchDialogComponent extends StatelessWidget {
  final Function()? onTap;

  const SwitchDialogComponent({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      decoration: boxDecorationDefault(color: white, borderRadius: BorderRadius.all(radiusCircular(6))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CachedImageWidget(
            url: Assets.imagesConfirm,
            height: 140,
            width: 140,
            fit: BoxFit.contain,
          ),
          40.height,
          Text(
            locale.value.areYouSureYouWantTonupdateTheService,
            textAlign: TextAlign.center,
            style: boldTextStyle(
              size: 18,
              height: 1.4,
              color: isDarkMode.value ? null : darkGrayTextColor,
            ),
          ),
          40.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: AppButton(
                  height: 50,
                  disabledColor: isDarkMode.value ? appScreenBackgroundDark : appScreenBackground,
                  margin: const EdgeInsets.only(left: 10.0),
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: radius(6),
                  ),
                  color: appColorSecondary,
                  child: Text(
                    locale.value.cancel,
                    style: boldTextStyle(size: 14, color: appBodyColor),
                  ),
                ),
              ).expand(),
              16.width,
              InkWell(
                onTap: onTap ?? () {},
                child: AppButton(
                  height: 50,
                  disabledColor: appColorSecondary,
                  margin: const EdgeInsets.only(right: 10.0),
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: radius(6),
                  ),
                  color: appColorSecondary,
                  child: Text(
                    locale.value.save,
                    style: boldTextStyle(size: 14, color: white),
                  ),
                ),
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}
