import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';

import '../utils/app_common.dart';

class AppTimeDropDownWidget extends StatelessWidget {
  final String value;
  final double? height;
  final String hintText;
  final bool isMandatory;
  final Widget? listWidget;
  final Color? bgColor;
  const AppTimeDropDownWidget({super.key, required this.value, this.height, required this.hintText, this.isMandatory = false, required this.listWidget, this.bgColor});

  List<String> get splitValues => value.split(" ");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(listWidget!);
      },
      child: Container(
        height: height ?? 40.0,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: boxDecorationDefault(color: bgColor ?? white, borderRadius: BorderRadius.circular(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                splitValues.isEmpty ? hintText.validate() : splitValues.first,
                style: secondaryTextStyle(
                  size: 12,
                  color: splitValues.isNotEmpty ? textPrimaryColorGlobal : appBodyColor,
                ),
              ),
            ).expand(),
            VerticalDivider(color: isDarkMode.value ? iconColor.withValues(alpha: 0.5) : iconColor.withValues(alpha: 0.5)),
            8.width,
            Text(
              splitValues.isEmpty ? "-" : splitValues.last,
              style: secondaryTextStyle(
                size: 12,
                color: splitValues.isNotEmpty ? textPrimaryColorGlobal : appBodyColor,
              ),
            ),
            18.width,
          ],
        ),
      ),
    );
  }
}
