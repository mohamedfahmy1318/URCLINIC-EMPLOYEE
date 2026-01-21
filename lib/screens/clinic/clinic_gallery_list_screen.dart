import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';

import '../../components/app_primary_widget.dart';
import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../components/loader_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/empty_error_state_widget.dart';
import 'clinic_gallery_list_controller.dart';
import 'model/clinic_gallery_model.dart';

class ClinicGalleryListScreen extends StatelessWidget {
  ClinicGalleryListScreen({super.key});

  final ClinicGalleryListController galleryListCont = Get.put(ClinicGalleryListController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.gallery,
      scaffoldBackgroundColor: context.scaffoldBackgroundColor,
      appBarVerticalSize: Get.height * 0.12,
      isLoading: galleryListCont.isLoading,
      isBlurBackgroundinLoader: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          AppPrimaryWidget(
            width: Get.width,
            constraints: BoxConstraints(minHeight: Get.height * 0.18),
            backgroundColor: context.cardColor,
            border: Border.all(color: borderColor, width: 0.8),
            borderRadius: defaultRadius,
            onTap: () {
              hideKeyboard(context);
              galleryListCont.showBottomSheet(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CachedImageWidget(
                  url: Assets.iconsIcImageUpload,
                  height: 32,
                  fit: BoxFit.fitHeight,
                ),
                16.height,
                Text(
                  locale.value.chooseImageToUpload,
                  style: secondaryTextStyle(color: secondaryTextColor, size: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).paddingSymmetric(horizontal: 16),
          16.height,
          Obx(
            () => SnapHelperWidget(
              future: galleryListCont.galleryListFuture.value,
              errorBuilder: (error) {
                return NoDataWidget(
                  title: error,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    galleryListCont.page(1);
                    galleryListCont.getGalleryList();
                  },
                ).paddingSymmetric(horizontal: 32);
              },
              loadingWidget: galleryListCont.isLoading.value ? const Offstage() : const LoaderWidget(),
              onSuccess: (data) {
                if (galleryListCont.galleryList.isEmpty) {
                  return NoDataWidget(
                    title: locale.value.noGalleryFoundAtAMoment,
                    subTitle: locale.value.looksLikeThereIsNoGalleryForThisClinicWellKee,
                    titleTextStyle: primaryTextStyle(),
                    imageWidget: const EmptyStateWidget(),
                    retryText: locale.value.reload,
                    onRetry: () {
                      galleryListCont.page(1);
                      galleryListCont.getGalleryList();
                    },
                  ).paddingSymmetric(horizontal: 32);
                }

                return AnimatedScrollView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    AnimatedWrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(
                        galleryListCont.galleryList.length,
                        (index) {
                          final GalleryData galleryData = galleryListCont.galleryList[index];
                          return Stack(
                            children: [
                              CachedImageWidget(
                                url: galleryData.fullUrl,
                                height: 100,
                                fit: BoxFit.cover,
                                width: Get.width / 3 - 22,
                                radius: 4,
                              ),
                              Obx(
                                () => Positioned(
                                  right: 6,
                                  top: 6,
                                  child: InkWell(
                                    onTap: () {
                                      if (galleryListCont.deletedGalleryList.contains(galleryData)) {
                                        galleryListCont.deletedId.remove(galleryData.id);
                                        galleryListCont.deletedGalleryList.remove(galleryData);
                                      } else {
                                        galleryListCont.deletedId.add(galleryData.id);
                                        galleryListCont.deletedGalleryList.add(galleryData);
                                      }
                                    },
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(2), color: galleryListCont.deletedGalleryList.contains(galleryData) ? appColorPrimary : white),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.check, size: 14, color: white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ).cornerRadiusWithClipRRect(defaultRadius);
                        },
                      ),
                    ),
                  ],
                  onNextPage: () async {
                    if (!galleryListCont.isLastPage.value) {
                      galleryListCont.page(galleryListCont.page.value + 1);
                      galleryListCont.getGalleryList();
                    }
                  },
                  onSwipeRefresh: () async {
                    galleryListCont.page(1);
                    return galleryListCont.getGalleryList(showLoader: false);
                  },
                );
              },
            ),
          ),
        ],
      ),
      widgetsStackedOverBody: [
        Obx(
          () => Positioned(
            bottom: 16,
            height: 50,
            width: Get.width,
            child: AppButton(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: Get.width,
              text: locale.value.delete,
              color: appColorSecondary,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
              onTap: () {
                if (galleryListCont.deletedId.isNotEmpty) {
                  galleryListCont.deleteGalleryList();
                } else {
                  toast(locale.value.pleaseSelectImages);
                }
              },
            ),
          ).visible(galleryListCont.deletedId.isNotEmpty),
        ),
      ],
    );
  }
}
