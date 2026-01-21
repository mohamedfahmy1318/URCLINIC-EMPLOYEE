import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/pharma_detail_screen.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';

class PharmaCard extends StatelessWidget {
  final Pharma pharma;
  final VoidCallback? onEditClick;
  final VoidCallback? onDeleteClick;
  const PharmaCard({super.key, required this.pharma, this.onEditClick, this.onDeleteClick});

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
                      url: pharma.imageUrl,
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
                              pharma.fullName,
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

            ],
          ),

          12.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  launchCall(pharma.contactNumber);
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
                      pharma.contactNumber,
                      style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorPrimary, color: appColorPrimary),
                    ),
                  ],
                ),
              ).paddingTop(8).visible(pharma.contactNumber.isNotEmpty),
              GestureDetector(
                onTap: () {
                  launchMail(pharma.email);
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
                      pharma.email,
                      style: secondaryTextStyle(decoration: TextDecoration.underline, decorationColor: appColorSecondary, color: appColorSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ).paddingTop(8).visible(pharma.email.isNotEmpty),

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
              //view pharma
              12.width,
              InkWell(
                onTap: (){
                  PharmaDetailScreen(pharma: pharma).launch(context);
                },
                child: const CachedImageWidget(
                  url: Assets.iconsIcNotepad,
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
    ).onTap((){

      Get.to(() =>
      PharmaDetailScreen(pharma: pharma),arguments: {'clinicId': pharma.clinicId});

    });
  }
}
