import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/loader_widget.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/add_pharma_screen.dart';
import 'package:kivicare_clinic_admin/screens/pharma/pharma_card.dart';
import 'package:kivicare_clinic_admin/screens/pharma/suppliers/component/search_pharma_component.dart';
import 'package:kivicare_clinic_admin/screens/pharma/suppliers/controller/pharma_controller.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:kivicare_clinic_admin/utils/empty_error_state_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_scaffold.dart';

class PharmaScreen extends StatefulWidget {
  const PharmaScreen({super.key});

  @override
  State<PharmaScreen> createState() => _PharmaScreenState();
}

class _PharmaScreenState extends State<PharmaScreen> {
  PharmaController allPharmaCont = Get.put(PharmaController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.allPharma,
      isLoading: allPharmaCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        IconButton(
          onPressed: () async {
            Get.to(() => AddPharmaScreen())?.then((value) {
              if (value == true) {
                allPharmaCont.getPharmas(showLoader: true);
              }
            });
          },
          icon: const Icon(Icons.add_circle_outline_rounded, size: 28, color: Colors.white),
        ).paddingOnly(right: 8).visible(loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)),
      ],
      body: SizedBox(
        height: Get.height,
        child: Column(
          children: [
            SearchPharmaComponent(
                allPharmaCont: allPharmaCont,
                onFieldSubmitted: (p0) {
                  hideKeyboard(context);
                },
                onClearButton: () {
                  allPharmaCont.searchPharmaCont.clear();
                  allPharmaCont.getPharmas();
                }).paddingSymmetric(horizontal: 16),
            16.height,
            Obx(
              () => SnapHelperWidget(
                future: allPharmaCont.pharmaListFuture.value,
                loadingWidget: allPharmaCont.isLoading.value ? const Offstage() : const LoaderWidget(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      allPharmaCont.page(1);
                      allPharmaCont.getPharmas();
                    },
                  );
                },
                onSuccess: (res) {
                  return Obx(
                    () => AnimatedListView(
                      shrinkWrap: true,
                      itemCount: allPharmaCont.pharmaList.length,
                      padding: const EdgeInsets.only(bottom: 80),
                      physics: const AlwaysScrollableScrollPhysics(),
                      listAnimationType: ListAnimationType.Slide,
                      emptyWidget: NoDataWidget(
                        title: locale.value.noPharmaFound,
                        imageWidget: const EmptyStateWidget(),
                      ).paddingSymmetric(horizontal: 32).visible(!allPharmaCont.isLoading.value),
                      onSwipeRefresh: () async {
                        allPharmaCont.page.value = 1;
                        allPharmaCont.isLastPage.value = false;
                        allPharmaCont.pharmaListFuture(allPharmaCont.getPharmas(showLoader: true));
                      },
                      onNextPage: () async {
                        if (!allPharmaCont.isLastPage.value) {
                          allPharmaCont.page++;
                          allPharmaCont.getPharmas();
                        }
                      },
                      itemBuilder: (ctx, index) {
                        return PharmaCard(
                          pharma: allPharmaCont.pharmaList[index],
                          onEditClick: () {
                            Get.to(
                              () => AddPharmaScreen(
                                isEdit: true,
                              ),
                              arguments: allPharmaCont.pharmaList[index],
                            )?.then((value) {
                              if (value == true) {
                                allPharmaCont.getPharmas(showLoader: true);
                              }
                            });
                          },
                          onDeleteClick: () {
                            allPharmaCont.deletePharma(context: context, pharmalist: allPharmaCont.pharmaList, index: index);
                          },
                        ).paddingBottom(16);
                      },
                    ).paddingSymmetric(horizontal: 16),
                  );
                },
              ).expand(),
            ),
          ],
        ),
      ).paddingTop(16),
    );
  }
}
