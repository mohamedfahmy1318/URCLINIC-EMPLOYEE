import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/pharma/inventory/add_stock_screen.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/cached_image_widget.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/empty_error_state_widget.dart';
import 'components/medicine_card_component.dart';
import 'medicine_filter.dart';
import 'controller/medicine_list_controller.dart';
import 'components/search_medicine_widget.dart';

class MedicinesListScreen extends StatelessWidget {
  //if the screen is select medicine screen or List medicine screen
  final bool isSelectMedicineScreen;
  final bool hasLeadingWidget;
  final bool isAddMedicineScreen;

  const MedicinesListScreen({super.key, this.hasLeadingWidget = true, this.isSelectMedicineScreen = false, this.isAddMedicineScreen = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MedicinesListController>(
      init: MedicinesListController(),
      builder: (medicinesListCont) {
        return AppScaffoldNew(
          appBartitleText: isAddMedicineScreen ? locale.value.addMedicine : medicinesListCont.appBarTitle.value,
          isLoading: medicinesListCont.isLoading,
          appBarVerticalSize: Get.height * 0.12,
          hasLeadingWidget: hasLeadingWidget,
          actions: isSelectMedicineScreen
              ? [
                  IconButton(
                    onPressed: () async {
                      Get.back(result: medicinesListCont.selectedMedicines);
                    },
                    icon: const Icon(Icons.check, size: 20, color: Colors.white),
                  ).paddingOnly(right: 8, top: 12, bottom: 12),
                ]
              : [
                  IconButton(
                    onPressed: () async {
                      Get.to(() => AddStockScreen())?.then((value) {
                        if (value == true) {
                          medicinesListCont.medicinePage(1);
                          medicinesListCont.getMedicineList();
                        }
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 28, color: Colors.white),
                  ).paddingOnly(right: 8).visible(loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) || loginUserData.value.userRole.contains(EmployeeKeyConst.pharma)),
                ],
          body: SizedBox(
            height: Get.height,
            child: Obx(
              () => Column(
                children: [
                  Row(
                    children: [
                      SearchMedicineWidget(
                          medicinesListCont: medicinesListCont,
                          onFieldSubmitted: (p0) {
                            hideKeyboard(context);
                          },
                          onClearButton: () {
                            medicinesListCont.searchMedicinesCont.clear();
                            medicinesListCont.getMedicineList();
                          }).expand(),
                      if (medicinesListCont.screenType == MedicineScreenType.all) ...[
                        12.width,
                        InkWell(
                          onTap: () {
                            medicinesListCont.selectedTabIndex.value = 0;
                            showFilterBottomSheet(context: context, medicinesListCont: medicinesListCont);
                          },
                          child: Container(
                            height: 46,
                            width: 46,
                            alignment: Alignment.center,
                            decoration: boxDecorationDefault(color: appColorPrimary, borderRadius: BorderRadius.circular(12)),
                            child: const CachedImageWidget(
                              url: Assets.iconsIcFilter,
                              height: 28,
                              color: white,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ).paddingSymmetric(horizontal: 16),
                  16.height,
                  SnapHelperWidget(
                    future: medicinesListCont.getMedicines.value,
                    loadingWidget: medicinesListCont.isLoading.value ? const Offstage() : const LoaderWidget(),
                    errorBuilder: (error) {
                      return NoDataWidget(
                        title: error,
                        retryText: locale.value.reload,
                        imageWidget: const ErrorStateWidget(),
                        onRetry: () {
                          medicinesListCont.medicinePage(1);
                          medicinesListCont.getMedicineList();
                        },
                      );
                    },
                    onSuccess: (res) {
                      return Obx(
                        () => AnimatedListView(
                          shrinkWrap: true,
                          itemCount: medicinesListCont.medicineList.length,
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 80),
                          physics: const AlwaysScrollableScrollPhysics(),
                          listAnimationType: ListAnimationType.None,
                          emptyWidget: NoDataWidget(
                            title: medicinesListCont.emptyMessageText.value,
                            subTitle: medicinesListCont.emptySubMessageText.value,
                            imageWidget: const EmptyStateWidget(),
                            onRetry: () {
                              medicinesListCont.medicinePage(1);
                              medicinesListCont.getMedicineList();
                            },
                          ).paddingSymmetric(horizontal: 32).paddingBottom(Get.height * 0.15).visible(!medicinesListCont.isLoading.value),
                          onSwipeRefresh: () async {
                            medicinesListCont.medicinePage(1);
                            return await medicinesListCont.getMedicineList(showLoader: false);
                          },
                          onNextPage: () async {
                            if (!medicinesListCont.isMedicineLastPage.value) {
                              medicinesListCont.medicinePage++;
                              medicinesListCont.getMedicineList();
                            }
                          },
                          itemBuilder: (ctx, index) {
                            if (medicinesListCont.medsAlreadyInPresc.contains(medicinesListCont.medicineList[index].id)) return Offstage();
                            return MedicineCardWidget(
                              isSelectMedicineScreen: isSelectMedicineScreen,
                              medicinesListCont: medicinesListCont,
                              medicineData: medicinesListCont.medicineList[index],
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
      },
    );
  }
}
