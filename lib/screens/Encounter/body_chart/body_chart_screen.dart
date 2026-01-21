import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/body_chart/body_chart_controller.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/empty_error_state_widget.dart';
import 'add_body_chart/add_body_chart_screen.dart';
import 'components/body_chart_card_component.dart';

class BodyChartScreen extends StatelessWidget {
  BodyChartScreen({super.key});

  final BodyChartController bodyChartCont = Get.put(BodyChartController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.bodyChart,
      isLoading: bodyChartCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        Obx(
          () => IconButton(
            onPressed: () async {
              bodyChartCont.clearBodyChatData();
              Get.to(() => AddBodyChartScreen());
            },
            icon: const Icon(Icons.add_circle_outline_rounded, size: 28, color: Colors.white),
          ).paddingOnly(right: 8).visible(bodyChartCont.encounter.value.status.obs.value),
        ),
      ],
      body: SizedBox(
        height: Get.height,
        child: Column(
          children: [
            24.height,
            Obx(
              () => SnapHelperWidget(
                future: bodyChartCont.bodyChartListFuture.value,
                loadingWidget: bodyChartCont.isLoading.value ? const Offstage() : const LoaderWidget(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      bodyChartCont.page(1);
                      bodyChartCont.getAllBodyChart();
                    },
                  );
                },
                onSuccess: (res) {
                  return Obx(
                    () => AnimatedListView(
                      shrinkWrap: true,
                      itemCount: bodyChartCont.bodyChartList.length,
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      emptyWidget: NoDataWidget(
                        title: locale.value.noBodyChartsFound,
                        subTitle: locale.value.oppsNoBodyChartsFoundAtMomentTryAgainLater,
                        imageWidget: const EmptyStateWidget(),
                      ).paddingSymmetric(horizontal: 16).paddingBottom(Get.height * 0.15).visible(!bodyChartCont.isLoading.value),
                      onSwipeRefresh: () async {
                        bodyChartCont.page(1);
                        return bodyChartCont.getAllBodyChart(showloader: false);
                      },
                      onNextPage: () async {
                        if (!bodyChartCont.isLastPage.value) {
                          bodyChartCont.page++;
                          bodyChartCont.getAllBodyChart();
                        }
                      },
                      itemBuilder: (ctx, index) {
                        return BodyChartCardComponent(
                          chartDetails: bodyChartCont.bodyChartList[index],
                          index: index,
                          onDeleteClick: () {
                            showConfirmDialogCustom(
                              context,
                              primaryColor: appColorPrimary,
                              title: locale.value.areYouSureYouWantToDeleteThisBodyChart,
                              positiveText: locale.value.delete,
                              negativeText: locale.value.cancel,
                              onAccept: (ctx) async {
                                bodyChartCont.deleteBodyChart(id: bodyChartCont.bodyChartList[index].id, index: index);
                              },
                            );
                          },
                        ).paddingBottom(16);
                      },
                    ),
                  );
                },
              ),
            ).expand(),
            24.height,
          ],
        ),
      ),
    );
  }
}
