import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/empty_error_state_widget.dart';
import 'components/stock_history_card_component.dart';
import 'controller/stock_history_controller.dart';

class StockHistoryScreen extends StatelessWidget {
  const StockHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockHistoryController>(
      init: StockHistoryController(),
      builder: (stockHisController) {
        return AppScaffoldNew(
          appBartitleText: locale.value.stockHistory,
          isLoading: stockHisController.isLoading,
          appBarVerticalSize: Get.height * 0.12,
          hasLeadingWidget: true,
          body: SizedBox(
            height: Get.height,
            child: Obx(
              () => Column(
                children: [
                  SnapHelperWidget(
                    future: stockHisController.getStockHistoryFuture.value,
                    loadingWidget: stockHisController.isLoading.value ? const Offstage() : const LoaderWidget(),
                    errorBuilder: (error) {
                      return NoDataWidget(
                        title: error,
                        retryText: locale.value.reload,
                        imageWidget: const ErrorStateWidget(),
                        onRetry: () {
                          stockHisController.medicinePage(1);
                          stockHisController.getMedicineHistory();
                        },
                      );
                    },
                    onSuccess: (res) {
                      return Obx(
                        () => AnimatedListView(
                          shrinkWrap: true,
                          itemCount: stockHisController.medHistoryList.length,
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 80),
                          physics: const AlwaysScrollableScrollPhysics(),
                          listAnimationType: ListAnimationType.None,
                          emptyWidget: NoDataWidget(
                            title: locale.value.noStockHistoryFound,
                            subTitle: locale.value.noStockHistoryAvailableAtMoment,
                            imageWidget: const EmptyStateWidget(),
                            onRetry: () {
                              stockHisController.medicinePage(1);
                              stockHisController.getMedicineHistory();
                            },
                          ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!stockHisController.isLoading.value),
                          onSwipeRefresh: () async {
                            stockHisController.medicinePage(1);
                            return await stockHisController.getMedicineHistory(showLoader: false);
                          },
                          onNextPage: () async {
                            if (!stockHisController.isMedicineLastPage.value) {
                              stockHisController.medicinePage++;
                              stockHisController.getMedicineHistory();
                            }
                          },
                          itemBuilder: (ctx, index) {
                            return StockHistoryCardWidget(medHistData: stockHisController.medHistoryList[index]).paddingBottom(16);
                          },
                        ),
                      );
                    },
                  ).expand(),
                ],
              ),
            ).paddingTop(16),
          ),
        );
      },
    );
  }
}
