import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/empty_error_state_widget.dart';
import 'all_category_controller.dart';
import 'components/all_category_card.dart';

class AllCategoryScreen extends StatelessWidget {
  AllCategoryScreen({super.key});

  // final HomeController homeController = Get.find();
  final AllCategoriesCont allCategoriesCont = Get.put(AllCategoriesCont());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.allCategory,
      appBarVerticalSize: Get.height * 0.12,
      isLoading: allCategoriesCont.isLoading,
      body: Obx(
        () => SnapHelperWidget(
          future: allCategoriesCont.categoryListFuture.value,
          initialData: allCategoriesCont.categoryList.isNotEmpty ? allCategoriesCont.categoryList : null,
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                allCategoriesCont.page(1);
                allCategoriesCont.getCategoryList();
              },
            ).paddingSymmetric(horizontal: 24);
          },
          loadingWidget: allCategoriesCont.isLoading.value ? const Offstage() : const LoaderWidget(),
          onSuccess: (response) {
            return Obx(
              () => AnimatedListView(
                shrinkWrap: true,
                itemCount: allCategoriesCont.categoryList.length,
                listAnimationType: ListAnimationType.None,
                padding: const EdgeInsets.only(top: 24, bottom: 64),
                physics: const AlwaysScrollableScrollPhysics(),
                emptyWidget: NoDataWidget(
                  title: locale.value.noCategoryFound,
                  retryText: locale.value.reload,
                  onRetry: () {
                    allCategoriesCont.page(1);
                    allCategoriesCont.getCategoryList();
                  },
                ).paddingSymmetric(horizontal: 24),
                itemBuilder: (context, index) {
                  return AllCategoryCard(
                    category: allCategoriesCont.categoryList[index],
                  ).paddingBottom(24);
                },
                onNextPage: () {
                  if (!allCategoriesCont.isLastPage.value) {
                    allCategoriesCont.page(allCategoriesCont.page.value + 1);
                    allCategoriesCont.getCategoryList();
                  }
                },
                onSwipeRefresh: () async {
                  allCategoriesCont.page(1);
                  return allCategoriesCont.getCategoryList(showLoader: false);
                },
              ),
            ).paddingSymmetric(horizontal: 24);
          },
        ).makeRefreshable,
      ),
    );
  }
}
