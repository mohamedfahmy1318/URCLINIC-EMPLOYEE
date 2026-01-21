import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/service/all_service_list_screen.dart';

import '../../../components/cached_image_widget.dart';
import '../model/all_category_model.dart';

class AllCategoryCard extends StatelessWidget {
  final CategoryElement category;
  final Widget? child;
  final bool showSubTexts;

  const AllCategoryCard({
    super.key,
    required this.category,
    this.showSubTexts = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AllServicesScreen(), arguments: category);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: boxDecorationDefault(color: white),
        child: Row(
          children: [
            CachedImageWidget(
              url: category.categoryImage,
              fit: BoxFit.cover,
              height: 60,
              width: 60,
              circle: true,
              // color: const Color(0xFF6E8192),
            ).paddingSymmetric(vertical: 12),
            16.width,
            Text(
              category.name,
              overflow: TextOverflow.ellipsis,
              style: boldTextStyle(size: 14),
            ).flexible(),
          ],
        ),
      ),
    );
  }
}
