import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/requests/model/request_type_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../model/service_request_model.dart';

class RequestCardComponent extends StatelessWidget {
  final RequestElement request;
  const RequestCardComponent({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: boxDecorationDefault(
                  color: isDarkMode.value ? Colors.grey.withValues(alpha: 0.1) : lightSecondaryColor,
                  borderRadius: radius(8),
                ),
                child: Text(
                  requestTypeList.firstWhere((element) => element.type == request.type, orElse: () => RequestType.fromJson(request.toJson())).name,
                  style: boldTextStyle(size: 10, fontFamily: fontFamilyWeight700, color: appColorSecondary),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${locale.value.status}:", style: secondaryTextStyle()),
                  4.width,
                  Text(
                    getRequestStatus(status: request.isStatus),
                    style: primaryTextStyle(size: 12, color: getRequestStatusColor(requestStatus: request.isStatus)),
                  ),
                ],
              ).visible(getRequestStatus(status: request.isStatus).isNotEmpty),
            ],
          ),
          16.height,
          Text(request.name, style: boldTextStyle(size: 16)),
          16.height,
          Divider(
            color: context.dividerColor.withValues(alpha: 0.2),
            height: 1,
          ),
          16.height,
          Text(request.description, style: secondaryTextStyle(size: 12)),
        ],
      ),
    );
  }
}
