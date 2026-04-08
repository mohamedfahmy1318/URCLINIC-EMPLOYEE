import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/add_edit_bed_screen.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/all_bed_controller.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/model/bed_master_model.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';

import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/screens/appointment/filter/filter_screen.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:kivicare_clinic_admin/utils/empty_error_state_widget.dart';
import 'package:kivicare_clinic_admin/components/loader_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/price_widget.dart';

import 'add_edit_bed_controller.dart';

class AllBedScreen extends StatelessWidget {
  AllBedScreen({super.key});

  final AllBedController allBedController = Get.put(AllBedController());

  @override
  Widget build(BuildContext context) {
    if (!CoreServiceApis.isBedFeatureAvailable) {
      return AppScaffoldNew(
        appBartitleText: locale.value.allBeds,
        body: Center(
          child: NoDataWidget(
            title: locale.value.noDataFound,
            imageWidget: const EmptyStateWidget(),
          ).paddingSymmetric(horizontal: 24),
        ),
      );
    }

    return AppScaffoldNew(
      isLoading: allBedController.isLoading,
      appBartitleText: locale.value.allBeds,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        IconButton(
          icon: const CachedImageWidget(
            url: Assets.iconsIcAdd,
            height: 26,
            width: 26,
            color: white,
          ),
          onPressed: () {
            Get.to(
              () => AddEditBedScreen(
                allBedController: allBedController,
                controller: Get.put(
                  AddEditBedController(),
                ),
              ),
            );
          },
        ).visible(
            loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)),
      ],
      body: Column(
        children: [
          8.height,
          Obx(() {
            return Row(
              spacing: 8,
              children: [
                Expanded(
                  child: AppTextField(
                    textFieldType: TextFieldType.OTHER,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: locale.value.searchHint,
                      prefixIcon: const Icon(Icons.search,
                          color: appColorPrimary, size: 20),
                      filled: true,
                      fillColor: context.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: appColorPrimary, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (text) {
                      allBedController.getBedList(searchBed: text);
                    },
                  ),
                ),
                Container(
                  height: 45,
                  width: 45,
                  alignment: Alignment.center,
                  decoration: boxDecorationDefault(
                    color: appColorPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CachedImageWidget(
                    url: Assets.iconsIcFilter,
                    height: 28,
                    color: white,
                  ).onTap(() {
                    Get.to(() => FilterScreen(), arguments: [
                      allBedController.selectedBedType.value,
                      allBedController.selectedStatus.value,
                    ])?.then((value) {
                      if (value == true) {
                        allBedController.filterBeds();
                      }
                    });
                  }),
                ),
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 8);
          }),
          Expanded(
            child: Obx(
              () => SnapHelperWidget<RxList<BedMasterModel>>(
                future: allBedController.bedsFuture.value,
                initialData: allBedController.bedMasterList.isNotEmpty
                    ? allBedController.bedMasterList
                    : RxList<BedMasterModel>(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error.toString(),
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      allBedController.page(1);
                      allBedController.getBedList();
                    },
                  ).paddingSymmetric(horizontal: 24);
                },
                loadingWidget: const LoaderWidget(),
                onSuccess: (res) {
                  return Obx(
                    () => AnimatedListView(
                      shrinkWrap: true,
                      itemCount: allBedController.filteredBedMasterList.length,
                      listAnimationType: ListAnimationType.None,
                      padding: const EdgeInsets.all(16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      emptyWidget: NoDataWidget(
                        title: locale.value.noBedsFound,
                        imageWidget: const EmptyStateWidget(),
                        subTitle: locale
                            .value.thereAreCurrentlyNoAppointmentsAvailable,
                      )
                          .paddingSymmetric(horizontal: 24)
                          .paddingBottom(Get.height * 0.15)
                          .visible(!allBedController.isLoading.value),
                      itemBuilder: (context, index) {
                        final bed =
                            allBedController.filteredBedMasterList[index];
                        return _buildBedMasterCard(context, bed)
                            .paddingBottom(16);
                      },
                      onNextPage: () async {
                        if (!allBedController.isLastPage.value) {
                          allBedController.onNextPage();
                        }
                      },
                      onSwipeRefresh: () async {
                        return await allBedController.onRefresh();
                      },
                    ),
                  );
                },
              ).makeRefreshable,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBedMasterCard(BuildContext context, BedMasterModel bed) {
    return Container(
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${locale.value.bed}: ',
                            style: secondaryTextStyle(),
                          ),
                          Text(
                            bed.bed.validate(),
                            style: primaryTextStyle(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${locale.value.bedType}: ',
                            style: secondaryTextStyle(),
                          ),
                          Text(
                            bed.bedTypeName.validate(),
                            style: primaryTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                12.height,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${locale.value.charges}: ',
                            style: TextStyle(
                                fontSize: 12,
                                color: Get.isDarkMode
                                    ? UIColors.labelTextDark
                                    : UIColors.labelTextLight),
                          ),
                          PriceWidget(
                            price: bed.charges,
                            size: 14,
                            isBoldText: true,
                            color: Get.isDarkMode
                                ? UIColors.valueTextDark
                                : UIColors.valueTextLight,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${locale.value.capacity}: ',
                            style: TextStyle(
                                fontSize: 12,
                                color: Get.isDarkMode
                                    ? UIColors.labelTextDark
                                    : UIColors.labelTextLight),
                          ),
                          Text(
                            bed.capacity.validate().toString(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Get.isDarkMode
                                    ? UIColors.valueTextDark
                                    : UIColors.valueTextLight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                12.height,
                if (loginUserData.value.userRole
                    .contains(EmployeeKeyConst.vendor)) ...[
                  commonDivider,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: CachedImageWidget(
                          url: Assets.iconsIcEditReview,
                          height: 18,
                          width: 18,
                          color: Get.isDarkMode
                              ? UIColors.iconDark
                              : UIColors.iconLight,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          Get.to(
                            () => AddEditBedScreen(
                              isEdit: true,
                              allBedController: allBedController,
                              controller: Get.put(
                                AddEditBedController(
                                    initialBedData: bed), // Pass bed directly
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: CachedImageWidget(
                          url: Assets.iconsIcDelete,
                          height: 18,
                          width: 18,
                          color: Get.isDarkMode
                              ? UIColors.iconDark
                              : UIColors.iconLight,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          allBedController.showDeleteConfirmation(bed);
                        },
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
          if (bed.isUnderMaintenance.validate(value: false))
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: UIColors.statusBadgeBackground,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                ),
                child: Text(
                  locale.value.underMaintenance.capitalizeEachWord(),
                  style: TextStyle(
                      color: UIColors.statusBadgeText,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
