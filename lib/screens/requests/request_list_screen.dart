import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/main.dart';
import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/add_request_component.dart';
import 'components/request_card_component.dart';
import 'request_list_screen_controller.dart';

class RequestListScreen extends StatelessWidget {
  RequestListScreen({super.key});
  final RequestListController reqListCont = Get.put(RequestListController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.requestList,
      isLoading: reqListCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        IconButton(
          onPressed: () async {
            Get.bottomSheet(AddRequestComponent());
          },
          icon: const Icon(Icons.add_circle_outline_rounded, size: 28, color: Colors.white),
        ).paddingOnly(right: 8),
      ],
      body: Obx(
        () => SnapHelperWidget(
          future: reqListCont.getRequestList.value,
          loadingWidget: reqListCont.isLoading.value ? const Offstage() : const LoaderWidget(),
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                reqListCont.page(1);
                reqListCont.getRequests();
              },
            ).visible(!reqListCont.isLoading.value);
          },
          onSuccess: (res) {
            return Obx(
              () => AnimatedListView(
                shrinkWrap: true,
                itemCount: reqListCont.requestList.length,
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                listAnimationType: ListAnimationType.None,
                emptyWidget: NoDataWidget(
                  title: locale.value.noRequestsFound,
                  subTitle: locale.value.oppsNoRequestsFoundAtMomentTryAgainLater,
                  retryText: locale.value.addRequest,
                  imageWidget: const EmptyStateWidget(),
                  onRetry: () async {
                    Get.bottomSheet(AddRequestComponent());
                  },
                ).paddingSymmetric(horizontal: 32).visible(!reqListCont.isLoading.value),
                onSwipeRefresh: () async {
                  reqListCont.page(1);
                  return reqListCont.getRequests(showloader: false);
                },
                onNextPage: () async {
                  if (!reqListCont.isLastPage.value) {
                    reqListCont.page++;
                    reqListCont.isLoading(true);
                    reqListCont.getRequests();
                  }
                },
                itemBuilder: (ctx, index) {
                  return RequestCardComponent(request: reqListCont.requestList[index]).paddingBottom(16);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
