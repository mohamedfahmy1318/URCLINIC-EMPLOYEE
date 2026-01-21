import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/empty_error_state_widget.dart';
import 'components/expired_medicine_card.dart';
import 'controller/expired_medicine_controller.dart';

class ExpiredMedicine extends StatelessWidget {
  const ExpiredMedicine({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpiredMedicineController>(
      init: ExpiredMedicineController(),
      builder: (controller) {
        return AppScaffoldNew(
          appBartitleText: '${locale.value.expired} ${locale.value.medicines}',
          isLoading: controller.isLoading,
          appBarVerticalSize: Get.height * 0.12,
          body: SizedBox(
            height: Get.height,
            child: Obx(
              () => SnapHelperWidget(
                future: controller.getMedicines.value,
                loadingWidget: controller.isLoading.value ? const Offstage() : const LoaderWidget(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      controller.medicinePage(1);
                      controller.getMedicineList();
                    },
                  );
                },
                onSuccess: (res) {
                  return AnimatedListView(
                    shrinkWrap: true,
                    itemCount: controller.expiredMedicineList.length,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: 80,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(),
                    listAnimationType: ListAnimationType.None,
                    emptyWidget: NoDataWidget(
                      title: controller.emptyMessageText.value,
                      subTitle: controller.emptySubMessageText.value,
                      imageWidget: const EmptyStateWidget(),
                      onRetry: () {
                        controller.medicinePage(1);
                        controller.getMedicineList();
                      },
                    ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!controller.isLoading.value),
                    onSwipeRefresh: () async {
                      controller.medicinePage(1);
                      return await controller.getMedicineList(showLoader: false);
                    },
                    onNextPage: () async {
                      if (!controller.isMedicineLastPage.value) {
                        controller.medicinePage++;
                        controller.getMedicineList();
                      }
                    },
                    itemBuilder: (ctx, index) {
                      final item = controller.expiredMedicineList[index];

                      if (controller.medsAlreadyInPresc.contains(item.id)) {
                        return const Offstage();
                      }

                      return ExpiredMedicineCard(
                        expiredMedicineController: controller,
                        medicineData: item,
                      );
                    },
                  );
                },
              ).paddingTop(16),
            ),
          ),
        );
      },
    );
  }
}
