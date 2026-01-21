import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../utils/view_all_label_component.dart';

class InvoiceComponent extends StatelessWidget {
  final String title;
  final Widget child;

  final String? trailingText;
  final bool showSeeAll;
  final Function()? onSeeAllTap;

  const InvoiceComponent({super.key, required this.title, required this.child, this.trailingText, this.showSeeAll = false, this.onSeeAllTap});

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
          labelSize: 16,
          onTap: onSeeAllTap,
        ).paddingOnly(left: 16, right: 8),
        child.paddingSymmetric(horizontal: 16),
      ],
    );
  }
}
