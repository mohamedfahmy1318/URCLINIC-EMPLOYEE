// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'receptionist_bed_type_controller.dart';
import 'model/bed_type_model.dart';
import 'components/search_bed_type_widget.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/utils/empty_error_state_widget.dart';
import 'package:kivicare_clinic_admin/components/loader_widget.dart';

class ReceptionistBedTypeScreen extends StatelessWidget {
  const ReceptionistBedTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!CoreServiceApis.isBedFeatureAvailable) {
      return AppScaffoldNew(
        appBartitleText: locale.value.manageBedTypes,
        body: Center(
            child: Text(locale.value.noDataFound, style: secondaryTextStyle())),
      );
    }

    ReceptionistBedTypeController receptionistBedTypeController =
        Get.put(ReceptionistBedTypeController());

    return AppScaffoldNew(
      appBartitleText: locale.value.manageBedTypes,
      scaffoldBackgroundColor: context.scaffoldBackgroundColor,
      actions: [
        IconButton(
          icon: const CachedImageWidget(
            url: Assets.iconsIcAdd,
            height: 26,
            width: 26,
            color: white,
          ),
          onPressed: () {
            receptionistBedTypeController.showAddBedType();
          },
        ),
      ],
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideLayout = constraints.maxWidth > 600;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    SearchBedTypeWidget(
                      bedTypeCont: receptionistBedTypeController,
                      hintText: locale.value.searchBedTypeHint,
                      onClearButton: () {
                        receptionistBedTypeController.searchBedTypeCont.clear();
                        receptionistBedTypeController.isSearchText(false);
                        receptionistBedTypeController.filterBedTypes('');
                      },
                    ).expand(),
                  ],
                ),
              ),
              Expanded(
                child: SnapHelperWidget(
                  future: receptionistBedTypeController.bedTypesFuture.value,
                  initialData: receptionistBedTypeController.bedTypes.isNotEmpty
                      ? receptionistBedTypeController.bedTypes
                      : null,
                  errorBuilder: (error) {
                    return NoDataWidget(
                      title: error,
                      retryText: locale.value.reload,
                      imageWidget: const ErrorStateWidget(),
                      onRetry: () {
                        receptionistBedTypeController.page(1);
                        receptionistBedTypeController.getBedTypes();
                      },
                    ).paddingSymmetric(horizontal: 24);
                  },
                  loadingWidget: const LoaderWidget(),
                  onSuccess: (res) {
                    return Obx(
                      () => AnimatedListView(
                        shrinkWrap: true,
                        itemCount: receptionistBedTypeController
                            .filteredBedTypes.length,
                        listAnimationType: ListAnimationType.None,
                        padding: EdgeInsets.symmetric(
                            horizontal: isWideLayout ? 20 : 16, vertical: 8),
                        physics: const AlwaysScrollableScrollPhysics(),
                        emptyWidget: NoDataWidget(
                          title: locale.value.noBedTypesFound,
                          imageWidget: const EmptyStateWidget(),
                          subTitle: locale
                              .value.thereAreCurrentlyNoAppointmentsAvailable,
                        )
                            .paddingSymmetric(horizontal: 24)
                            .paddingBottom(Get.height * 0.15)
                            .visible(
                                !receptionistBedTypeController.isLoading.value),
                        itemBuilder: (context, index) {
                          final bedType = receptionistBedTypeController
                              .filteredBedTypes[index];
                          return _buildBedTypeCard(context, bedType,
                                  isWideLayout, receptionistBedTypeController)
                              .paddingBottom(16);
                        },
                        onNextPage: () async {
                          if (!receptionistBedTypeController.isLastPage.value) {
                            receptionistBedTypeController.onNextPage();
                          }
                        },
                        onSwipeRefresh: () async {
                          return await receptionistBedTypeController
                              .onRefresh();
                        },
                      ),
                    );
                  },
                ).makeRefreshable,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBedTypeCard(BuildContext context, BedTypeElement bedType,
      bool isWideLayout, ReceptionistBedTypeController controller) {
    final isExpanded = false.obs;
    return Container(
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      text: locale.value.bedTypeLabel,
                      style: secondaryTextStyle(
                          size: 12,
                          color: Get.isDarkMode
                              ? UIColors.labelTextDark
                              : UIColors.labelTextLight),
                      children: [
                        TextSpan(
                          text: bedType.type,
                          style: boldTextStyle(
                              size: 12,
                              color: Get.isDarkMode
                                  ? UIColors.valueTextDark
                                  : UIColors.valueTextLight,
                              weight: FontWeight.w700),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Action buttons (edit and delete)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Edit button
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: IconButton(
                        icon: CachedImageWidget(
                          url: Assets.iconsIcEditReview,
                          height: 18,
                          width: 18,
                          color: Get.isDarkMode
                              ? UIColors.iconDark
                              : UIColors.iconLight,
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          // Open edit bed type form using controller function
                          controller.showEditBedTypeDialog(bedType);
                        },
                      ),
                    ),
                    // Delete button
                    IconButton(
                      icon: CachedImageWidget(
                        url: Assets.iconsIcDelete,
                        height: 18,
                        width: 18,
                        color: Get.isDarkMode
                            ? UIColors.iconDark
                            : UIColors.iconLight,
                      ),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showConfirmDialogCustom(
                          context,
                          primaryColor: context.primaryColor,
                          title:
                              locale.value.areYouSureYouWantToDeleteThisBedType,
                          positiveText: locale.value.yes,
                          negativeText: locale.value.cancel,
                          onAccept: (ctx) async {
                            controller.isLoading(true);
                            await controller
                                .deleteBedType(bedType.id)
                                .then((value) {})
                                .catchError((error) {
                              toast(error.toString());
                            }).whenComplete(() => controller.isLoading(false));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            4.height,
            commonDivider,
            9.height,
            // Bed type description
            Obx(() {
              final text = bedType.description.isNotEmpty
                  ? bedType.description
                  : locale.value.noDescriptionAvailable;
              final style = TextStyle(
                fontSize: 11,
                color: Get.isDarkMode
                    ? UIColors.labelTextDark
                    : UIColors.labelTextLight,
                fontWeight: FontWeight.w400,
                height: 1.45,
              );

              final textPainter = TextPainter(
                text: TextSpan(text: text, style: style),
                maxLines: 2,
                textDirection: TextDirection.ltr,
              )..layout(
                  maxWidth: MediaQuery.of(context).size.width -
                      (isWideLayout ? 40 : 32) -
                      32);

              final isTextOverflowing = textPainter.didExceedMaxLines;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: style,
                    maxLines: isExpanded.value ? null : 2,
                    overflow: isExpanded.value ? null : TextOverflow.ellipsis,
                  ),
                  if (isTextOverflowing)
                    GestureDetector(
                      onTap: () {
                        isExpanded.value = !isExpanded.value;
                      },
                      child: Text(
                        isExpanded.value
                            ? locale.value.readLess
                            : locale.value.readMore,
                        style:
                            primaryTextStyle(size: 12, color: appColorPrimary),
                      ).paddingTop(4),
                    )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
