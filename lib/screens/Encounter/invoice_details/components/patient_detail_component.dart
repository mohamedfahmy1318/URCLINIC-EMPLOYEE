import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/invoice_details/model/billing_details_resp.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../../generated/assets.dart';

class PatientDetailComponent extends StatelessWidget {
  final BillingDetailModel patientData;
  const PatientDetailComponent({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CachedImageWidget(
                url: Assets.iconsIcUser,
                height: 14,
                width: 14,
                color: iconColor,
              ),
              14.width,
              Text(
                patientData.userName,
                style: secondaryTextStyle(
                  size: 12,
                  color: dividerColor,
                ),
              ),
            ],
          ),
          8.height.visible(patientData.userGender.isNotEmpty),
          Row(
            children: [
              const CachedImageWidget(
                url: Assets.iconsIcLocation,
                height: 14,
                width: 14,
                color: iconColor,
              ).visible(patientData.userGender.isNotEmpty),
              14.width,
              Text(
                patientData.userAddress,
                style: secondaryTextStyle(
                  size: 12,
                  color: dividerColor,
                ),
              ),
            ],
          ).visible(patientData.userAddress.isNotEmpty),
          8.height.visible(patientData.userAddress.isNotEmpty),
          Row(
            children: [
              const CachedImageWidget(
                url: Assets.iconsIcCalendar,
                height: 14,
                width: 14,
                color: iconColor,
              ),
              12.width,
              Text(
                patientData.userDob.dateInDMMMMyyyyFormat,
                style: secondaryTextStyle(
                  size: 12,
                  color: dividerColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
