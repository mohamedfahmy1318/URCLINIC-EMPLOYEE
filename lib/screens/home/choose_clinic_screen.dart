import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../components/app_scaffold.dart';
import '../../components/cached_image_widget.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/empty_error_state_widget.dart';
import '../clinic/model/clinics_res_model.dart';
import 'choose_clinic_controller.dart';

class ChooseClinicScreen extends StatelessWidget {
  ChooseClinicScreen({super.key});

  final ChooseClinicController clinicListController = Get.put(ChooseClinicController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.chooseClinic,
      appBarVerticalSize: Get.height * 0.12,
      isLoading: clinicListController.isLoading,
      actions: [
        Obx(
          () => IconButton(
            onPressed: () async {
              if (clinicListController.isSingleSelect.value) {
                if (clinicListController.singleClinicSelect.value.id.isNegative) {
                  toast(locale.value.pleaseChooseClinic);
                } else {
                  Get.back(result: clinicListController.singleClinicSelect.value);
                }
              } else {
                Get.back(result: clinicListController.selectedClinics);
              }
            },
            icon: const Icon(Icons.check, size: 20, color: Colors.white),
          ).paddingOnly(right: 8, top: 12, bottom: 12).visible(clinicListController.singleClinicSelect.value.id != -1),
        ),
      ],
      body: SizedBox(
        height: Get.height,
        child: Obx(
          () => Column(
            children: [
              SnapHelperWidget(
                future: clinicListController.getClinics.value,
                loadingWidget: clinicListController.isLoading.value ? const Offstage() : const LoaderWidget(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      clinicListController.page(1);
                      clinicListController.getClinicList();
                    },
                  );
                },
                onSuccess: (res) {
                  return Obx(
                    () => AnimatedListView(
                      shrinkWrap: true,
                      itemCount: clinicListController.clinicList.length,
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      listAnimationType: ListAnimationType.None,
                      emptyWidget: NoDataWidget(
                        title: locale.value.noClinicsFound,
                        subTitle: locale.value.oppsNoClinicsFoundAtMomentTryAgainLater,
                        imageWidget: const EmptyStateWidget(),
                        onRetry: () async {
                          clinicListController.page(1);
                          clinicListController.getClinicList();
                        },
                      ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!clinicListController.isLoading.value),
                      onSwipeRefresh: () async {
                        clinicListController.page(1);
                        return clinicListController.getClinicList(showloader: false);
                      },
                      onNextPage: () async {
                        if (!clinicListController.isLastPage.value) {
                          clinicListController.page++;
                          clinicListController.getClinicList();
                        }
                      },
                      itemBuilder: (ctx, index) {
                        return ChooseClinicCard(
                          clinicData: clinicListController.clinicList[index],
                          clinicListController: clinicListController,
                        ).paddingBottom(16);
                      },
                    ),
                  );
                },
              ).expand(),
            ],
          ),
        ).paddingTop(16),
      ),
    );
  }
}

class ChooseClinicCard extends StatelessWidget {
  final ClinicData clinicData;
  final ChooseClinicController clinicListController;

  const ChooseClinicCard({
    super.key,
    required this.clinicData,
    required this.clinicListController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clinicListController.singleClinicSelect(clinicData);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: boxDecorationDefault(
          borderRadius: BorderRadius.circular(6),
          color: context.cardColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.width,
            CachedImageWidget(
              url: clinicData.clinicImage,
              width: 52,
              radius: 6,
              fit: BoxFit.cover,
              height: 52,
            ),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clinicData.name, style: boldTextStyle(size: 14, color: isDarkMode.value ? null : darkGrayTextColor)),
                2.height,
                Text(clinicData.description, style: primaryTextStyle(size: 12, color: dividerColor)),
              ],
            ).expand(),
            12.width,
            Obx(
              () => RadioGroup<int>(
                groupValue: clinicListController.singleClinicSelect.value.id,
                onChanged: (int? newId) {
                  final selected = clinicListController.clinicList.firstWhere((c) => c.id == newId);
                  clinicListController.singleClinicSelect(selected);
                },
                child: Radio<int>(value: clinicData.id),
              ),
            ),
            4.width,
          ],
        ),
      ),
    );
  }
}
