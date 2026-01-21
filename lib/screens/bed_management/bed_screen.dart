import 'package:flutter/material.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/components/loader_widget.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_controller.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/components/search_bed_component.dart';

import 'package:kivicare_clinic_admin/utils/empty_error_state_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';

class BedScreen extends StatelessWidget {
  BedScreen({super.key});

  final BedController bedController = Get.put(BedController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.allBeds,
      isLoading: bedController.isLoading,
      body: SnapHelperWidget(
        future: bedController.bedListFuture.value,
        errorBuilder: (error) {
          return NoDataWidget(
            title: error,
            retryText: locale.value.reload,
            imageWidget: const ErrorStateWidget(),
            onRetry: () {
              bedController.page(1);
              bedController.getBedList();
            },
          ).paddingSymmetric(horizontal: 24);
        },
        loadingWidget: const LoaderWidget(),
        onSuccess: (data) {
          return AnimatedScrollView(
            onNextPage: bedController.onNextPage,
            onSwipeRefresh: bedController.onRefresh,
            children: [
              SearchBedComponent(bedController: bedController),
              16.height,
              AnimatedWrap(
                runSpacing: 16,
                spacing: 16,
                itemCount: bedController.bedList.length,
              )
            ],
          );
        },
      ),
    );
  }
}
