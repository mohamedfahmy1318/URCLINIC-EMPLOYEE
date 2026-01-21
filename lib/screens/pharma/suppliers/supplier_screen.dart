import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/empty_error_state_widget.dart';
import 'add_supplier_screen.dart';
import 'component/search_supplier_component.dart';
import 'controller/add_supplier_controller.dart';
import 'supplier_card.dart';
import 'controller/supplier_controller.dart';

class SupplierScreen extends StatelessWidget {
  SupplierScreen({super.key});

  final SupplierController allSuppliersCont = Get.put(SupplierController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.allSuppliers,
      isLoading: allSuppliersCont.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      actions: [
        IconButton(
          onPressed: () async {
            Get.to(() => AddSupplierScreen())?.then((value) async {
              if (value == true) {
                allSuppliersCont.getSuppliers(showLoader: true);
                AddSupplierController addSupplierController = Get.find();
                await addSupplierController.fetchPharmaList();
              }
            });
          },
          icon: const Icon(Icons.add_circle_outline_rounded, size: 28, color: Colors.white),
        ).paddingOnly(right: 8),
      ],
      body: SizedBox(
        height: Get.height,
        child: Column(
          children: [
            SearchSupplierComponent(
                allSuppliersCont: allSuppliersCont,
                onFieldSubmitted: (p0) {
                  hideKeyboard(context);
                },
                onClearButton: () {
                  allSuppliersCont.searchSupplierCont.clear();
                  allSuppliersCont.getSuppliers();
                }).paddingSymmetric(horizontal: 16),
            16.height,
            Obx(
              () => SnapHelperWidget(
                future: allSuppliersCont.supplierListFuture.value,
                loadingWidget: allSuppliersCont.isLoading.value ? const Offstage() : const LoaderWidget(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      allSuppliersCont.page(1);
                      allSuppliersCont.getSuppliers();
                    },
                  );
                },
                onSuccess: (res) {
                  return Obx(
                    () => AnimatedListView(
                      shrinkWrap: true,
                      itemCount: allSuppliersCont.supplierList.length,
                      padding: const EdgeInsets.only(bottom: 80),
                      physics: const AlwaysScrollableScrollPhysics(),
                      listAnimationType: ListAnimationType.Slide,
                      emptyWidget: NoDataWidget(
                        title: locale.value.noSuppliersFound,
                        imageWidget: const EmptyStateWidget(),
                      ).paddingSymmetric(horizontal: 32).visible(!allSuppliersCont.isLoading.value),
                      onSwipeRefresh: () async {
                        allSuppliersCont.page(1);
                        return await allSuppliersCont.getSuppliers(showLoader: false);
                      },
                      onNextPage: () async {
                        if (!allSuppliersCont.isLastPage.value) {
                          allSuppliersCont.page++;
                          allSuppliersCont.getSuppliers();
                        }
                      },
                      itemBuilder: (ctx, index) {
                        return SupplierCard(
                          supplier: allSuppliersCont.supplierList[index],
                          onEditClick: () {
                            Get.to(
                                    () => AddSupplierScreen(
                                          isEdit: true,
                                        ),
                                    arguments: allSuppliersCont.supplierList[index])
                                ?.then((value) {
                              if (value == true) {
                                allSuppliersCont.getSuppliers(showLoader: true);
                              }
                            });
                          },
                          onDeleteClick: () {
                            allSuppliersCont.deleteSupplier(context: context, supplierList: allSuppliersCont.supplierList, index: index);
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
