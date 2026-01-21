import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../components/loader_widget.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/empty_error_state_widget.dart';
import 'clinic_detail_controller.dart';
import 'components/clinic_detail_btm_comp.dart';

class ClinicDetailScreen extends StatelessWidget {
  ClinicDetailScreen({super.key});

  final ClinicDetailController clinicDetailCont = Get.put(ClinicDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffoldNew(
      appBartitleText: locale.value.clinicDetail,
      appBarVerticalSize: Get.height * 0.12,
      isLoading: clinicDetailCont.isLoading,
      body: SnapHelperWidget(
          future: clinicDetailCont.getClinicDetailFuture.value,
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                clinicDetailCont.getClinicDetail();
              },
            ).paddingSymmetric(horizontal: 16);
          },
          loadingWidget: clinicDetailCont.isLoading.value ? const Offstage() : const LoaderWidget(),
          onSuccess: (res) {
            return AnimatedScrollView(
              children: [
                Container(
                  color: context.cardColor,
                  child: Column(
                    children: [
                      CachedImageWidget(
                        url: clinicDetailCont.clinicData.value.clinicImage,
                        fit: BoxFit.cover,
                        width: Get.width,
                        height: Get.height * 0.3,
                        topLeftRadius: (defaultRadius * 2).toInt(),
                        topRightRadius: (defaultRadius * 2).toInt(),
                      ),
                      Column(
                        children: [
                          16.height,
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        clinicDetailCont.clinicData.value.name,
                                        style: boldTextStyle(size: 18),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                        decoration: boxDecorationDefault(
                                          color: isDarkMode.value ? Colors.grey.withValues(alpha: 0.1) : lightPrimaryColor,
                                          borderRadius: radius(22),
                                        ),
                                        child: Text(
                                          clinicDetailCont.clinicData.value.clinicStatus,
                                          style: boldTextStyle(size: 12, color: appColorPrimary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ).flexible(),
                            ],
                          ),
                          16.height,
                          GestureDetector(
                            onTap: () {
                              launchCall(clinicDetailCont.clinicData.value.contactNumber);
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Row(
                              children: [
                                const CachedImageWidget(url: Assets.iconsIcCall, color: iconColor, width: 14, height: 14),
                                12.width,
                                Text(
                                  clinicDetailCont.clinicData.value.contactNumber,
                                  style: primaryTextStyle(color: appColorPrimary),
                                ),
                              ],
                            ),
                          ),
                          8.height,
                          GestureDetector(
                            onTap: () {
                              launchMap(clinicDetailCont.clinicData.value.address);
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Row(
                              children: [
                                const CachedImageWidget(url: Assets.iconsIcLocation, color: iconColor, width: 16, height: 16),
                                12.width,
                                Text(
                                  clinicDetailCont.clinicData.value.address,
                                  style: secondaryTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          16.height,
                        ],
                      ).paddingSymmetric(horizontal: 24),
                    ],
                  ),
                ),
                Column(
                  children: [
                    16.height,
                    ReadMoreText(
                      parseHtmlString(clinicDetailCont.clinicData.value.description),
                      trimLines: 4,
                      style: secondaryTextStyle(size: 14, color: secondaryTextColor),
                      colorClickableText: appColorPrimary,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: " ...${locale.value.readMore}",
                      trimExpandedText: locale.value.readLess,
                      locale: Localizations.localeOf(context),
                    ),
                    16.height,
                    Obx(() => ClinicDetailBtmComp(clinicData: clinicDetailCont.clinicData.value)),
                    24.height,
                  ],
                ).paddingSymmetric(horizontal: 24),
              ],
              onSwipeRefresh: () {
                return clinicDetailCont.getClinicDetail(showLoader: false);
              },
            ).makeRefreshable;
          },
        ),
      ),
    );
  }
}
