import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../../utils/view_all_label_component.dart';
import '../../bed_management/bed_status_screen.dart';

class HomeComponent extends StatelessWidget {
  final String title;

  final bool showSeeAll;

  final Widget child;

  final Function()? onSeeAllTap;
  final String? trailingText;

  const HomeComponent({super.key, this.title = '', this.showSeeAll = false, required this.child, this.onSeeAllTap, this.trailingText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ViewAllLabel(
          label: title,
          trailingText: trailingText ?? locale.value.viewAll,
          isShowAll: showSeeAll,
          onTap: onSeeAllTap ??
              () {
                Get.to(() => BedStatusScreen());
              },
        ).paddingOnly(left: 16, right: 8),
        child.paddingSymmetric(horizontal: 16),
      ],
    ).paddingTop(16);
  }
}
