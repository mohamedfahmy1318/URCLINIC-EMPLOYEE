import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../components/cached_image_widget.dart';
import '../../../../../components/loader_widget.dart';
import '../../../../../generated/assets.dart';
import '../../../../../main.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/common_base.dart';
import '../../../../../utils/empty_error_state_widget.dart';
import '../../../../clinic/model/clinics_res_model.dart';
import '../../filter_controller.dart';
import 'filter_search_clinic_component.dart';

class FilterClinicComponent extends StatelessWidget {
  final FilterController filterCont;

  const FilterClinicComponent({super.key, required this.filterCont});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        FilterSearchClinicComponent(
          filterClinicController: filterCont,
          hintText: locale.value.searchClinicHere,
          onFieldSubmitted: (p0) {
            hideKeyboard(context);
          },
        ).paddingSymmetric(horizontal: 16),
        12.height,
        Obx(
          () => SnapHelperWidget(
            future: filterCont.clinicListFuture.value,
            errorBuilder: (error) {
              return AnimatedScrollView(
                padding: const EdgeInsets.all(16),
                children: [
                  NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      filterCont.clinicPage(1);
                      filterCont.getClinicsList();
                    },
                  ),
                ],
              ).paddingSymmetric(horizontal: 32);
            },
            loadingWidget: const LoaderWidget(),
            onSuccess: (data) {
              if (filterCont.clinicList.isEmpty) {
                return AnimatedScrollView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    NoDataWidget(
                      title: locale.value.noClinicsFoundAtAMoment,
                      subTitle: locale.value.looksLikeThereIsNoClinicsWellKeepYouPostedWhe,
                      retryText: locale.value.reload,
                      imageWidget: const EmptyStateWidget(),
                      onRetry: () async {
                        filterCont.clinicPage(1);
                        filterCont.getClinicsList();
                      },
                    ),
                  ],
                ).paddingSymmetric(horizontal: 32).visible(!filterCont.isClinicLoading.value);
              } else {
                return Obx(
                  () => Stack(
                    children: [
                      AnimatedScrollView(
                        children: [
                          AnimatedWrap(
                            children: List.generate(filterCont.clinicList.length, (index) {
                              final ClinicData clinic = filterCont.clinicList[index];
                              return InkWell(
                                onTap: () {
                                  filterCont.selectedClinic(clinic);
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(6),
                                      height: 85,
                                      decoration: boxDecorationDefault(
                                        color: context.cardColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CachedImageWidget(
                                            url: clinic.clinicImage,
                                            height: 85,
                                            width: 85,
                                            fit: BoxFit.cover,
                                            topLeftRadius: 6,
                                            bottomLeftRadius: 6,
                                          ),
                                          8.width,
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              8.height,
                                              Text(
                                                clinic.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: primaryTextStyle(
                                                  size: 12,
                                                ),
                                              ),
                                              6.height,
                                              Row(
                                                children: [
                                                  const CachedImageWidget(url: Assets.iconsIcLocation, color: iconColor, width: 12, height: 12),
                                                  8.width,
                                                  Text(
                                                    clinic.address,
                                                    style: secondaryTextStyle(),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ).expand(),
                                                ],
                                              ),
                                              6.height,
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                decoration: boxDecorationDefault(
                                                  color: getClinicStatusLightColor(clinicStatus: clinic.clinicStatus.toLowerCase()),
                                                  borderRadius: radius(22),
                                                ),
                                                child: Text(
                                                  getClinicStatus(status: clinic.clinicStatus.toLowerCase()),
                                                  style: boldTextStyle(size: 10, color: Colors.green.shade600),
                                                ),
                                              ),
                                              6.height,
                                            ],
                                          ).expand(),
                                          8.width,
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: commonLeadingWid(
                                        imgPath: Assets.imagesConfirm,
                                        color: whiteTextColor,
                                        size: 8,
                                      ).circularLightPrimaryBg(color: appColorPrimary, padding: 6),
                                    ).visible(filterCont.selectedClinic.value.id == clinic.id),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                        onNextPage: () async {
                          if (!filterCont.isClinicLoading.value) {
                            filterCont.clinicPage(filterCont.clinicPage.value + 1);
                            filterCont.getClinicsList();
                          }
                        },
                        onSwipeRefresh: () async {
                          filterCont.clinicPage(1);
                          return filterCont.getClinicsList();
                        },
                      ),
                      if (filterCont.isClinicLoading.isTrue) const LoaderWidget(),
                    ],
                  ),
                );
              }
            },
          ),
        ).paddingOnly(bottom: 16, left: 8, right: 8).expand(),
      ],
    );
  }
}
