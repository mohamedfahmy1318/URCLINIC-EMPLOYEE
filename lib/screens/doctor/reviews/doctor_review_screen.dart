import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/main.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/loader_widget.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../components/doctor_review_card.dart';
import 'doctor_review_controller.dart';

class DoctorReviewsScreen extends StatelessWidget {
  DoctorReviewsScreen({super.key});

  final DoctorReviewController doctorsReviewsCont = Get.put(DoctorReviewController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.reviews,
      appBarVerticalSize: Get.height * 0.12,
      isLoading: doctorsReviewsCont.isLoading,
      body: Obx(
        () => SnapHelperWidget(
          future: doctorsReviewsCont.doctorsFuture.value,
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                doctorsReviewsCont.page(1);
                doctorsReviewsCont.getReviews();
              },
            ).paddingSymmetric(horizontal: 32);
          },
          loadingWidget: doctorsReviewsCont.isLoading.value ? const Offstage() : const LoaderWidget(),
          onSuccess: (p0) {
            if (doctorsReviewsCont.reviewList.isEmpty) {
              return NoDataWidget(
                title: locale.value.noReviewsTillNow,
                subTitle: locale.value.oppsNoReviewFoundAtMomentTryAgainLater,
                // retryText: "Add Reviews",
                imageWidget: const EmptyStateWidget(),
                onRetry: () async {
                  doctorsReviewsCont.page(1);
                  doctorsReviewsCont.getReviews();
                },
              ).paddingSymmetric(horizontal: 16).visible(!doctorsReviewsCont.isLoading.value);
            } else {
              return AnimatedListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: doctorsReviewsCont.reviewList.length,
                physics: const NeverScrollableScrollPhysics(),
                emptyWidget: NoDataWidget(
                  title: locale.value.noReviewsFoundAtAMoment,
                  subTitle: locale.value.looksLikeThereIsNoReviewsWellKeepYouPostedWhe,
                  titleTextStyle: primaryTextStyle(),
                  imageWidget: const EmptyStateWidget(),
                ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.1),
                itemBuilder: (context, index) {
                  return DoctorReviewCard(doctorReviewData: doctorsReviewsCont.reviewList[index]).paddingTop(index == 0 ? 0 : 16);
                },
              ).paddingTop(24).paddingBottom(8);
            }
          },
        ),
      ),
    );
  }
}
