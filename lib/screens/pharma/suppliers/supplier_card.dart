import 'package:flutter/material.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import '../../../components/cached_image_widget.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../medicine/model/medicine_resp_model.dart';

class SupplierCard extends StatelessWidget {
  const SupplierCard({
    super.key,
    required this.supplier,
    this.onEditClick,
    this.onDeleteClick,
  });

  final Supplier supplier;
  final VoidCallback? onEditClick;
  final VoidCallback? onDeleteClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: context.cardColor,
        borderRadius: radius(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CachedImageWidget(
                      url: supplier.imageUrl,
                      fit: BoxFit.cover,
                      height: 44,
                      width: 44,
                      circle: true,
                    ),
                    12.width,
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              supplier.fullName,
                              style: boldTextStyle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          4.width,
                          const Icon(Icons.verified, color: Colors.green, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              8.width,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                ),
                child: Text(
                  supplier.supplierType.name,
                  style: primaryTextStyle(),
                ),
              ).visible(supplier.supplierType.name.trim().isNotEmpty),
            ],
          ),

          12.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  launchCall(supplier.contactNumber);
                },
                child: Row(
                  children: [
                    const CachedImageWidget(
                      url: Assets.iconsIcCall,
                      width: 16,
                      height: 16,
                      color: iconColor,
                    ),
                    12.width,
                    Text(
                      supplier.contactNumber,
                      style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorPrimary, color: appColorPrimary),
                    ),
                  ],
                ),
              ).paddingTop(8).visible(supplier.contactNumber.isNotEmpty),
              GestureDetector(
                onTap: () {
                  launchMail(supplier.email);
                },
                child: Row(
                  children: [
                    const CachedImageWidget(
                      url: Assets.iconsIcMail,
                      width: 14,
                      height: 14,
                      color: iconColor,
                    ),
                    12.width,
                    Text(
                      supplier.email,
                      style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorSecondary, color: appColorSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ).paddingTop(8).visible(supplier.email.isNotEmpty),
              10.height,
              Row(
                children: [
                  const CachedImageWidget(
                    url: Assets.iconsIcDollar,
                    width: 14,
                    height: 14,
                    color: iconColor,
                  ),
                  10.width,
                  RichTextWidget(
                    list: [
                      TextSpan(text: "${locale.value.paymentTerms} ", style: secondaryTextStyle()),
                      TextSpan(text: '${supplier.paymentTerms} ${locale.value.days}', style: boldTextStyle(size: 12)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          16.height,
          Divider(
            height: 1,
            thickness: 1,
            color: isDarkMode.value ? borderColor.withValues(alpha: 0.1) : borderColor.withValues(alpha: 0.5),
          ),
          16.height,
          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: onEditClick,
                child: const CachedImageWidget(
                  url: Assets.iconsIcEditReview,
                  height: 18,
                  width: 18,
                  color: iconColor,
                ),
              ),
           /*   12.width,
              InkWell(
                onTap: onDeleteClick,
                child: const CachedImageWidget(
                  url: Assets.iconsIcDelete,
                  height: 18,
                  width: 18,
                  color: iconColor,
                ),
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}
