import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/add_clinic_form/model/clinic_session_response.dart';
import 'package:kivicare_clinic_admin/screens/clinic/clinic_session/clinic_session_controller.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import '../../../../components/app_scaffold.dart';
import 'package:get/get.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/empty_error_state_widget.dart';
import 'components/week_time_comnponents.dart';

class ClinicSessionScreen extends StatelessWidget {
  ClinicSessionScreen({super.key});

  final ClinicSessionController clinicSessionController = Get.put(ClinicSessionController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.clinicSessions,
      scaffoldBackgroundColor: context.scaffoldBackgroundColor,
      appBarVerticalSize: Get.height * 0.12,
      isLoading: clinicSessionController.isLoading,
      body: SnapHelperWidget(
        future: clinicSessionController.getClinicsFuture.value,
        loadingWidget: clinicSessionController.isLoading.value ? const Offstage() : const LoaderWidget(),
        errorBuilder: (error) {
          return NoDataWidget(
            title: error,
            retryText: locale.value.reload,
            imageWidget: const ErrorStateWidget(),
            onRetry: () {
              clinicSessionController.getClinicSessionList();
            },
          );
        },
        onSuccess: (res) {
          return Obx(
            () => SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: AnimatedListView(
                shrinkWrap: true,
                itemCount: clinicSessionController.clinicSessionList.length,
                physics: const NeverScrollableScrollPhysics(),
                emptyWidget: clinicSessionController.isLoading.isTrue
                    ? const Offstage()
                    : NoDataWidget(
                        title: locale.value.noSessionsFound,
                        subTitle: locale.value.oppsNoSessionsFoundAtMomentTryAgainLater,
                        imageWidget: const EmptyStateWidget(),
                        onRetry: () async {
                          clinicSessionController.getClinicSessionList();
                        },
                      ).paddingSymmetric(horizontal: 16),
                itemBuilder: (ctx, index) {
                  final ClinicSessionModel weekReport = clinicSessionController.clinicSessionList[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)
                                  ? null
                                  : () {
                                      if (weekReport.isHoliday == 1) {
                                        weekReport.isHoliday = 0;
                                      } else {
                                        weekReport.isHoliday = 1;
                                      }
                                      clinicSessionController.clinicSessionList.refresh();
                                    },
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: weekReport.isHoliday == 1 ? dividerColor : appColorPrimary,
                                  border: Border.all(
                                    color: weekReport.isHoliday == 1
                                        ? isDarkMode.value
                                            ? context.cardColor
                                            : borderColor
                                        : appColorPrimary,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.check,
                                  size: 12,
                                  color: weekReport.isHoliday == 1 ? transparentColor : white,
                                ),
                              ),
                            ),
                            12.width,
                            Text(
                              weekReport.day.capitalizeFirst!,
                              style: primaryTextStyle(
                                size: 12,
                                weight: FontWeight.w500,
                                color: weekReport.isHoliday == 1 ? dividerColor : null,
                              ),
                            ).expand(),
                            if (weekReport.isHoliday == 1)
                              Text(
                                locale.value.unavailable,
                                style: primaryTextStyle(
                                  size: 12,
                                  weight: FontWeight.w500,
                                  color: dividerColor,
                                ),
                              ),
                          ],
                        ),
                        if (weekReport.isHoliday == 0) WeekTimeComponent(weekData: weekReport),
                      ],
                    ),
                  );
                },
              ),
            ),
          ).paddingOnly(left: 16, right: 16, bottom: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? 0 : 80);
        },
      ),
      widgetsStackedOverBody: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)
          ? []
          : [
              Positioned(
                bottom: 16,
                height: 50,
                width: Get.width,
                child: AppButton(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: Get.width,
                  text: locale.value.save,
                  color: appColorSecondary,
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                  onTap: () {
                    clinicSessionController.saveClinicSession();
                  },
                ),
              ),
            ],
    );
  }
}
