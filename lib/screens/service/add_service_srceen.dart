import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/empty_error_state_widget.dart';
import '../home/home_controller.dart';
import 'add_service_conrtoller.dart';
import 'all_service_list_controller.dart';
import 'components/all_service_card.dart';
import 'model/service_list_model.dart';

class AddServiceSrceen extends StatelessWidget {
  final AllServicesController controller;

  AddServiceSrceen({super.key, required this.controller});

  final AddServiceController serviceListCont = Get.put(AddServiceController());
  final HomeController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffoldNew(
        appBartitleText: locale.value.selectService,
        isLoading: serviceListCont.isLoading,
        appBarVerticalSize: Get.height * 0.12,
        actions: [
          IconButton(
            onPressed: () {
              serviceListCont.assignServices().then((_) {
                Get.back();
                controller.getAllServices();
                homeScreenController.getDashboardDetail();
              });
            },
            icon: const Icon(
              Icons.check,
              color: white,
            ),
          ).paddingOnly(right: 16).visible(serviceListCont.selectedServiceId.isNotEmpty),
        ],
        body: SizedBox(
          height: Get.height,
          child: Obx(
            () => Column(
              children: [
                AppTextField(
                  controller: serviceListCont.searchServiceCont,
                  textFieldType: TextFieldType.OTHER,
                  textInputAction: TextInputAction.done,
                  textStyle: primaryTextStyle(),
                  onChanged: (p0) {
                    serviceListCont.isSearchServiceText(serviceListCont.searchServiceCont.text.trim().isNotEmpty);
                    serviceListCont.searchServiceStream.add(p0);
                  },
                  suffix: Obx(
                    () => appCloseIconButton(
                      context,
                      onPressed: () {
                        hideKeyboard(context);
                        serviceListCont.searchServiceCont.clear();
                        serviceListCont.isSearchServiceText(serviceListCont.searchServiceCont.text.trim().isNotEmpty);
                        serviceListCont.page(1);
                        serviceListCont.getAllServices();
                      },
                      size: 11,
                    ).visible(serviceListCont.isSearchServiceText.value),
                  ),
                  decoration: inputDecorationWithOutBorder(
                    context,
                    hintText: locale.value.searchHere,
                    filled: true,
                    fillColor: context.cardColor,
                    prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 18).paddingAll(14),
                  ),
                ).paddingSymmetric(horizontal: 16),
                20.height,
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
                        ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!serviceListCont.isLoading.value),
                        onSwipeRefresh: () async {
                          serviceListCont.page++;
                          return serviceListCont.getAllServices(showloader: false);
                        },
                        onNextPage: () async {
                          if (!serviceListCont.isLastPage.value) {
                            serviceListCont.page++;
                            serviceListCont.getAllServices();
                          }
                        },
                        itemBuilder: (ctx, index) {
                          final ServiceElement service = serviceListCont.serviceList[index];
                          return AllServiceCard(
                            serviceElement: service,
                            trailing: Obx(() {
                              final bool isSelected = serviceListCont.selectedServiceId.contains(service.id);
                              return Checkbox(
                                activeColor: appColorPrimary,
                                value: isSelected,
                                onChanged: (bool? value) {
                                  serviceListCont.toggleService(service, value ?? false);
                                },
                              );
                            }),
                          ).paddingBottom(16);
                        },
                      ),
                    ).paddingSymmetric(horizontal: 16);
                  },
                ).expand(),
              ],
            ),
          ).paddingTop(16),
        ),
      ),
    );
  }
}
