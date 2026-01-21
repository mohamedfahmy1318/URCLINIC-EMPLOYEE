import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/main.dart';
import '../../../../components/app_scaffold.dart';
import '../../../../components/loader_widget.dart';
import '../../../../utils/empty_error_state_widget.dart';
import 'billing_item_service_card_component.dart';
import 'billing_search_service_widget.dart';
import 'billing_service_list_controller.dart';

class BillingServicesListScreen extends StatelessWidget {
  BillingServicesListScreen({super.key});

  final BillingServicesController serviceListCont = Get.put(BillingServicesController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.services,
      isLoading: serviceListCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        Obx(() {
          return IconButton(
            onPressed: () async {
              Get.back(result: serviceListCont.singleServiceSelect.value);
            },
            icon: const Icon(Icons.check, size: 20, color: Colors.white),
          ).paddingOnly(right: 8, top: 12, bottom: 12).visible(serviceListCont.singleServiceSelect.value.id != -1);
        }),
      ],
      body: SizedBox(
        height: Get.height,
        child: Obx(
          () => Column(
            children: [
              BilligSearchServiceWidget(
                billingServicesController: serviceListCont,
                hintText: locale.value.searchServiceHere,
                onFieldSubmitted: (p0) {
                  hideKeyboard(context);
                },
                onClearButton: () {
                  serviceListCont.searchServiceCont.clear();
                  serviceListCont.getAllServices();
                },
              ).paddingSymmetric(horizontal: 16),
              24.height,
              SnapHelperWidget(
                future: serviceListCont.serviceListFuture.value,
                loadingWidget: serviceListCont.isLoading.value ? const Offstage() : const LoaderWidget(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      serviceListCont.page(1);
                      serviceListCont.getAllServices();
                    },
                  );
                },
                onSuccess: (res) {
                  return Obx(
                    () => AnimatedListView(
                      shrinkWrap: true,
                      itemCount: serviceListCont.serviceList.length,
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      listAnimationType: ListAnimationType.None,
                      emptyWidget: NoDataWidget(
                        title: locale.value.noServicesFound,
                        subTitle: locale.value.oppsNoServicesFoundAtMomentTryAgainLater,
                        imageWidget: const EmptyStateWidget(),
                      ).paddingSymmetric(horizontal: 32).visible(!serviceListCont.isLoading.value),
                      onSwipeRefresh: () async {
                        serviceListCont.page(1);
                        return serviceListCont.getAllServices(showloader: false);
                      },
                      onNextPage: () async {
                        if (!serviceListCont.isLastPage.value) {
                          serviceListCont.page++;
                          serviceListCont.getAllServices();
                        }
                      },
                      itemBuilder: (ctx, index) {
                        return BillingSelectServiceCardComponent(serviceData: serviceListCont.serviceList[index]).paddingBottom(16);
                      },
                    ),
                  ).paddingSymmetric(horizontal: 16);
                },
              ).expand(),
            ],
          ),
        ).paddingTop(16),
      ),
    );
  }
}
