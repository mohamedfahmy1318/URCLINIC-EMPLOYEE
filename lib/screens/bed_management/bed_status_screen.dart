// ignore_for_file: constant_pattern_never_matches_value_type

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_assign_screen.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_status_controller.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'model/bed_master_model.dart';
import 'package:kivicare_clinic_admin/utils/empty_error_state_widget.dart';

class BedStatusScreen extends StatelessWidget {
  const BedStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!CoreServiceApis.isBedFeatureAvailable) {
      return AppScaffoldNew(
        appBartitleText: locale.value.bedStatus,
        body: Center(
          child: NoDataWidget(
            title: locale.value.noDataFound,
            imageWidget: const EmptyStateWidget(),
          ).paddingSymmetric(horizontal: 24),
        ),
      );
    }

    final BedStatusController bedStatusController =
        Get.put(BedStatusController());

    return AppScaffoldNew(
      appBartitleText: locale.value.bedStatus,
      isLoading: bedStatusController.isLoading,
      actions: [
        IconButton(
          icon: const CachedImageWidget(
            url: Assets.iconsIcAdd,
            height: 26,
            width: 26,
            color: white,
          ),
          onPressed: () async {
            final result = await Get.to(() => BedAssignScreen(),
                arguments: {'isFromBedStatus': true});
            if (result == true) {
              bedStatusController.forceRefreshAllData();
            }
          },
        ).paddingRight(8),
      ],
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () => bedStatusController.refreshAllData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.value.bedStatus, style: boldTextStyle())
                    .paddingOnly(left: 16, right: 16, top: 16, bottom: 12),
                _buildBedStatusSummary(context, bedStatusController)
                    .paddingSymmetric(horizontal: 16),
                24.height,
                _buildAllBedSection(context, bedStatusController),
                50.height,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBedStatusSummary(
      BuildContext context, BedStatusController bedStatusController) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Obx(
        () {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              _buildStatusRow(context, [
                _statusBox(
                    context,
                    bedStatusController.totalBeds.value.toString(),
                    locale.value.totalBeds,
                    Colors.grey.shade200,
                    textColor: Colors.grey.shade800),
                _statusBox(
                    context,
                    bedStatusController.availableBeds.value.toString(),
                    locale.value.available,
                    BedColors.availableLight,
                    textColor: BedColors.availableTextLight),
              ]),
              16.height,
              _buildStatusRow(context, [
                _statusBox(
                    context,
                    bedStatusController.occupiedBeds.value.toString(),
                    locale.value.occupied,
                    BedColors.occupiedLight,
                    textColor: BedColors.occupiedTextLight),
                _statusBox(
                    context,
                    bedStatusController.maintenanceBeds.value.toString(),
                    locale.value.underMaintenance,
                    BedColors.maintenanceLight,
                    textColor: BedColors.maintenanceTextLight),
              ]),
              16.height,
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context, List<Widget> children) {
    return Row(
      children: children
          .expand(
              (widget) => [Expanded(child: widget), const SizedBox(width: 16)])
          .toList()
        ..removeLast(),
    );
  }

  Widget _statusBox(
      BuildContext context, String count, String label, Color? bgColor,
      {Color? textColor}) {
    Color boxBgColor = bgColor ?? context.cardColor;
    Color boxTextColor = textColor ?? textPrimaryColorGlobal;

    return Container(
      height: 70,
      alignment: Alignment.center,
      decoration: boxDecorationDefault(
        color: boxBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: Get.isDarkMode ? Colors.white12 : Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(count, style: boldTextStyle(size: 20, color: boxTextColor)),
          Text(label, style: secondaryTextStyle(size: 12, color: boxTextColor)),
        ],
      ),
    );
  }

  Widget _buildAllBedSection(
      BuildContext context, BedStatusController bedStatusController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(locale.value.allBeds, style: boldTextStyle(size: 16)),
          16.height,
          _buildWardTypeFilters(context, bedStatusController),
          12.height,
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: boxDecorationDefault(
              color: context.cardColor,
            ),
            clipBehavior: Clip.antiAlias,
            child: _buildBedGrid(bedStatusController),
          ),
        ],
      ),
    );
  }

  Widget _buildWardTypeFilters(
      BuildContext context, BedStatusController bedStatusController) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: bedStatusController.bedTypeList.map((type) {
            bool isSelected =
                bedStatusController.selectedBedType.value?.id == type.id;

            return GestureDetector(
              onTap: () {
                bedStatusController.selectBedType(type);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: boxDecorationDefault(
                  color: isSelected ? appColorPrimary : context.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: Get.isDarkMode
                              ? Colors.white12
                              : Colors.grey.shade300),
                ),
                child: Text(
                  type.type.validate(),
                  style: primaryTextStyle(
                    color: isSelected ? white : textSecondaryColorGlobal,
                    size: 14,
                  ),
                ),
              ).paddingRight(8),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBedGrid(BedStatusController bedStatusController) {
    return Obx(
      () => bedStatusController.filteredBedList.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NoDataWidget(
                  title: locale.value.noDataFound,
                  imageWidget: const EmptyStateWidget(),
                ).center(),
              ],
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0,
              ),
              padding: EdgeInsets.zero,
              itemCount: bedStatusController.filteredBedList.length,
              itemBuilder: (context, index) {
                final bed = bedStatusController.filteredBedList[index];
                return Obx(
                  () => GestureDetector(
                    onTap: () async {
                      bedStatusController.selectBed(bed); // <-- Highlight first

                      if (bed.bedStatus == BedStatus.AVAILABLE &&
                          !bed.isUnderMaintenance) {
                        await Future.delayed(const Duration(
                            microseconds:
                                100)); // Optional: slight delay to show selection // Optional: slight delay to show selection
                        Get.to(() => BedAssignScreen(isFromBedDetails: false),
                            arguments: {
                              'selectedBed': bed,
                              'isFromBedStatus': true,
                            });
                      }
                    },
                    child: BedStatusItemWidget(
                      bed: bed,
                      isSelected:
                          bedStatusController.selectedIndex.value == index,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class BedStatusItemWidget extends StatelessWidget {
  final BedMasterModel bed;
  final bool isSelected;

  const BedStatusItemWidget({
    super.key,
    required this.bed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    // Default colors
    Color borderColor = Colors.grey.shade300;
    Color backgroundColor = context.cardColor;
    Color iconColor = Colors.grey;

    // Status-based colors
    Color statusColor;

    if (bed.isUnderMaintenance || bed.bedStatus == 'maintenance') {
      statusColor = BedColors.maintenance;
    } else if (bed.bedStatus == 'available') {
      statusColor = BedColors.available;
    } else {
      statusColor = BedColors.occupied;
    }

    // When selected, fill with status color
    if (isSelected) {
      backgroundColor = statusColor;
      iconColor = Colors.white;
      borderColor = statusColor; // Optional: same as background
    } else {
      iconColor = statusColor;
      // borderColor remains grey
    }

    return Stack(
      children: [
        Container(
          width: 115,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: boxDecorationDefault(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.iconsIcBed,
                color: iconColor,
                height: 30,
                width: 30,
              ),
              8.height,
              Text(
                bed.bed.validate(),
                style: primaryTextStyle(
                  size: 12,
                  color: bed.bedStatus == 'occupied'
                      ? (isSelected
                          ? Colors.white
                          : BedColors.occupiedTextLight)
                      : isSelected
                          ? Colors.white
                          : (isDarkMode.value ? Colors.white : Colors.black),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        if (bed.isUnderMaintenance)
          Positioned(
            top: 2,
            right: 5,
            child: Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                ),
                color: context.cardColor,
              ),
              child: Icon(Icons.settings, size: 20, color: iconColor),
            ),
          ),
      ],
    );
  }
}
