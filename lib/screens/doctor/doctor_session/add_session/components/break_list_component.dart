import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../../../main.dart';
import '../../../../clinic/add_clinic_form/model/clinic_session_response.dart';
import '../add_session_controller.dart';
import 'add_break_component.dart';

class BreakListComponent extends StatelessWidget {
  final ClinicSessionModel weeksReport;

  BreakListComponent({super.key, required this.weeksReport});

  final AddSessionController addSessionCont = Get.put(AddSessionController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(locale.value.breaks, style: primaryTextStyle(size: 14, color: textSecondaryColor, weight: FontWeight.w500)),
        8.height,
        AnimatedListView(
          shrinkWrap: true,
          itemCount: weeksReport.breaks.length,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          listAnimationType: ListAnimationType.None,
          itemBuilder: (ctx, index) {
            final BreakListModel breakReport = weeksReport.breaks[index];
            if (breakReport.breakStartTime == "" || breakReport.breakEndTime == "") {
              return const Offstage();
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${timeFormate(time: breakReport.breakStartTime)} - ${timeFormate(time: breakReport.breakEndTime)}",
                  style: primaryTextStyle(size: 12, color: textSecondaryColor),
                ).expand(),
                InkWell(
                  onTap: () {
                    addSessionCont.breStartTime(breakReport.breakStartTime);
                    addSessionCont.breEndTime(breakReport.breakEndTime);
                    Get.bottomSheet(
                      AddBreakComponent(
                        index: index,
                        isAdd: false,
                        weekListModel: weeksReport,
                      ),
                    );
                  },
                  child: Text(
                    locale.value.editBreak,
                    style: boldTextStyle(size: 12, color: appColorSecondary),
                  ),
                ),
              ],
            ).paddingBottom(8.0);
          },
        ),
      ],
    );
  }
}
