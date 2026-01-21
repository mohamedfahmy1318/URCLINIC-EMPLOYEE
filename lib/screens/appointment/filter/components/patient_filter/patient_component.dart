import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/add_encounter/model/patient_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';

import '../../../../../components/cached_image_widget.dart';
import '../../../../../components/loader_widget.dart';
import '../../../../../generated/assets.dart';
import '../../../../../utils/common_base.dart';
import '../../../../../utils/empty_error_state_widget.dart';
import '../../filter_controller.dart';
import 'search_patient_widget.dart';

class PatientComponent extends StatelessWidget {
  final FilterController filterCont;

  const PatientComponent({super.key, required this.filterCont});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        SearchPatientWidget(
          patientListCont: filterCont,
          hintText: locale.value.searchDoctorHere,
          filterType: 0,
          onFieldSubmitted: (p0) {
            hideKeyboard(context);
          },
          onClearButton: () {
            filterCont.patientSearchCont.clear();
            filterCont.getPatientList();
          },
        ).paddingSymmetric(horizontal: 16),
        12.height,
        Obx(
          () => SnapHelperWidget(
            future: filterCont.gePatientFuture.value,
            errorBuilder: (error) {
              return AnimatedScrollView(
                padding: const EdgeInsets.all(16),
                children: [
                  NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      filterCont.patientPage(1);
                      filterCont.getPatientList();
                    },
                  ),
                ],
              ).paddingSymmetric(horizontal: 32);
            },
            loadingWidget: const LoaderWidget(),
            onSuccess: (p0) {
              if (filterCont.patientList.isEmpty) {
                return AnimatedScrollView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    NoDataWidget(
                      title: locale.value.noPatientFound,
                      subTitle: locale.value.oppsNoPatientFoundAtMomentTryAgainLater,
                      imageWidget: const EmptyStateWidget(),
                      onRetry: () async {
                        filterCont.patientPage(1);
                        filterCont.getPatientList();
                      },
                    ),
                  ],
                ).paddingSymmetric(horizontal: 32).visible(!filterCont.isLoading.value);
              } else {
                return Obx(
                  () => Stack(
                    children: [
                      AnimatedScrollView(
                        children: List.generate(
                          filterCont.patientList.length,
                          (index) {
                            final PatientModel patient = filterCont.patientList[index];
                            return InkWell(
                              onTap: () {
                                filterCont.selectedPatient(patient);
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
                                          url: patient.profileImage,
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
                                              patient.fullName,
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
                                                  patient.email,
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
                                  ).visible(filterCont.selectedPatient.value.id == patient.id),
                                ],
                              ),
                            );
                          },
                        ),
                        onNextPage: () async {
                          if (!filterCont.isLastPage.value) {
                            filterCont.patientPage(filterCont.patientPage.value + 1);
                            filterCont.getPatientList();
                          }
                        },
                        onSwipeRefresh: () async {
                          filterCont.patientPage(1);
                          return filterCont.getPatientList(showloader: false);
                        },
                      ),
                      if (filterCont.isLoading.isTrue) const LoaderWidget(),
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
