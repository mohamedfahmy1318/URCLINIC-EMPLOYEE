import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/doctor_qualification_card.dart';
import 'model/doctor_list_res.dart';

class QualificationScreen extends StatelessWidget {
  final Doctor doctorData;
  const QualificationScreen({super.key, required this.doctorData});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.qualification,
      appBarVerticalSize: Get.height * 0.12,
      body: AnimatedListView(
        shrinkWrap: true,
        itemCount: doctorData.qualifications.length,
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        emptyWidget: NoDataWidget(
          title: locale.value.noQualificationsFound,
          subTitle: locale.value.looksLikeThereAreNoQualificationsAddedByThisD,
          titleTextStyle: primaryTextStyle(),
          imageWidget: const EmptyStateWidget(),
        ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.1),
        itemBuilder: (BuildContext context, int index) {
          return QualificationCard(
            doctorData: doctorData,
            index: index,
          ).paddingBottom(16);
        },
      ).paddingTop(24).paddingBottom(8),
    );
  }
}
