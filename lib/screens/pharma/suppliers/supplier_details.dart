import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';

class SupplierDetails extends StatelessWidget {
  final Supplier supplier;

  const SupplierDetails({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      hasLeadingWidget: true,
      appBartitleText: locale.value.supplierDetails,
      appBarVerticalSize: Get.height * 0.12,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(supplier.imageUrl.validate()),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 50),
                ),
                16.height,
                Text(
                  "${supplier.firstName.validate()} ${supplier.lastName.validate()}",
                  style: boldTextStyle(size: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            24.height,

            // Supplier Info Card
            Container(
              width: Get.width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(icon: Assets.iconsIcMail, title: locale.value.email, value: supplier.email.validate()),
                  16.height,
                  _infoRow(icon: Assets.iconsIcCall, title: locale.value.contactNumber, value: supplier.contactNumber.validate()),
                  16.height,
                  _infoRow(icon: Assets.iconsIcCart, title: locale.value.supplierType, value: supplier.supplierType.name.validate()),
                  16.height,
                  _infoRow(icon: Assets.iconsIcImgCard, title: locale.value.paymentTerms, value: supplier.paymentTerms.validate()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({required String icon, required String title, required String value}) {
    return Row(
      children: [
        CachedImageWidget(
          url: icon,
          width: 20,
          color: iconColor,
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: secondaryTextStyle(size: 12)),
              4.height,
              Text(value, style: primaryTextStyle(size: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
