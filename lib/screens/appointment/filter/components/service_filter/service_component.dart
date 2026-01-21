import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/service/model/service_list_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../../components/cached_image_widget.dart';
import '../../../../../components/loader_widget.dart';
import '../../../../../generated/assets.dart';
import '../../../../../utils/common_base.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/empty_error_state_widget.dart';
import '../../filter_controller.dart';
import '../patient_filter/search_patient_widget.dart';

class FilterServiceComponent extends StatelessWidget {
  final FilterController filterCont;
  const FilterServiceComponent({super.key, required this.filterCont});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        SearchPatientWidget(
          patientListCont: filterCont,
          hintText: locale.value.searchServiceHere,
          filterType: 1,
          onFieldSubmitted: (p0) {
            hideKeyboard(context);
          },
          onClearButton: () {
            filterCont.searchServiceCont.clear();
            filterCont.servicePage(1);
            filterCont.getServicesList();
          },
        ).paddingSymmetric(horizontal: 16),
        12.height,
        Obx(
          () => SnapHelperWidget(
            future: filterCont.serviceListFuture.value,
            errorBuilder: (error) {
              return AnimatedScrollView(
                padding: const EdgeInsets.all(16),
                children: [
                  NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      filterCont.servicePage(1);
                      filterCont.getServicesList();
                    },
                  ),
                ],
              ).paddingSymmetric(horizontal: 32);
            },
            loadingWidget: const LoaderWidget(),
            onSuccess: (p0) {
              if (filterCont.serviceList.isEmpty) {
                return AnimatedScrollView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    NoDataWidget(
                      title: locale.value.noServiceFound,
                      subTitle: locale.value.oppsNoServiceFoundAtMomentTryAgainLater,
                      imageWidget: const EmptyStateWidget(),
                      onRetry: () async {
                        filterCont.servicePage(1);
                        filterCont.getServicesList();
                      },
                    ),
                  ],
                ).paddingSymmetric(horizontal: 32).visible(!filterCont.isServiceLoading.value);
              } else {
                return Obx(
                  () => Stack(
                    children: [
                      AnimatedScrollView(
                        children: List.generate(
                          filterCont.serviceList.length,
                          (index) {
                            final ServiceElement service = filterCont.serviceList[index];
                            return InkWell(
                              onTap: () {
                                filterCont.selectedServiceData(service);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(6),
                                    decoration: boxDecorationDefault(
                                      color: context.cardColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      children: [
                                        CachedImageWidget(
                                          url: service.serviceImage,
                                          height: 75,
                                          width: 75,
                                          fit: BoxFit.cover,
                                          topLeftRadius: 6,
                                          bottomLeftRadius: 6,
                                        ),
                                        8.width,
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            8.height,
                                            Text(
                                              service.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: primaryTextStyle(
                                                size: 12,
                                              ),
                                            ),
                                            6.height,
                                            Row(
                                              children: [
                                                Text(
                                                  service.type.toLowerCase() == ServiceTypes.online ? locale.value.online : locale.value.inClinic,
                                                  style: secondaryTextStyle(),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ).expand(),
                                              ],
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
                                  ).visible(filterCont.selectedServiceData.value.id == service.id),
                                ],
                              ),
                            );
                          },
                        ),
                        onNextPage: () async {
                          if (!filterCont.isServiceLoading.value) {
                            filterCont.servicePage(filterCont.servicePage.value + 1);
                            filterCont.getServicesList();
                          }
                        },
                        onSwipeRefresh: () async {
                          filterCont.servicePage(1);
                          return filterCont.getServicesList(showloader: false);
                        },
                      ),
                      if (filterCont.isServiceLoading.isTrue) const LoaderWidget(),
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
