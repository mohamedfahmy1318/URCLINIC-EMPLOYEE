import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/main.dart';
import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/payout_card.dart';
import 'payout_history_controller.dart';

class PayoutHistory extends StatelessWidget {
  final bool isFromBottomBar;
  PayoutHistory({super.key, this.isFromBottomBar = false});

  final PayoutHistoryCont payoutHistoryCont = Get.put(PayoutHistoryCont());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.payoutHistory,
      isLoading: payoutHistoryCont.isLoading,
      hasLeadingWidget: !isFromBottomBar,
      appBarVerticalSize: Get.height * 0.12,
      body: SnapHelperWidget(
        future: payoutHistoryCont.getPayoutFuture.value,
        loadingWidget: payoutHistoryCont.isLoading.value ? const Offstage() : const LoaderWidget(),
        errorBuilder: (error) {
          return NoDataWidget(
            title: error,
            retryText: locale.value.reload,
            imageWidget: const ErrorStateWidget(),
            onRetry: () {
              payoutHistoryCont.page(1);
              payoutHistoryCont.getPayoutList();
            },
          );
        },
        onSuccess: (res) {
          return Obx(
            () => AnimatedListView(
              shrinkWrap: true,
              itemCount: payoutHistoryCont.payoutList.length,
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              emptyWidget: NoDataWidget(
                title: locale.value.noPayout,
                retryText: locale.value.reload,
                subTitle: locale.value.oppsLooksLikeThereIsNoPayoutsAvailable,
                imageWidget: const EmptyStateWidget(),
                onRetry: () {
                  payoutHistoryCont.page(1);
                  payoutHistoryCont.getPayoutList();
                },
              ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!payoutHistoryCont.isLoading.value),
              onSwipeRefresh: () async {
                payoutHistoryCont.page(1);
                return payoutHistoryCont.getPayoutList(showloader: false);
              },
              onNextPage: () async {
                if (!payoutHistoryCont.isLastPage.value) {
                  payoutHistoryCont.page++;
                  payoutHistoryCont.getPayoutList();
                }
              },
              itemBuilder: (ctx, index) {
                return PayoutCardWid(payout: payoutHistoryCont.payoutList[index]).paddingBottom(16);
              },
            ),
          );
        },
      ).paddingSymmetric(vertical: 16),
    );
  }
}
