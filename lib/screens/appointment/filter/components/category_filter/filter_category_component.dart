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
import '../../../../category/model/all_category_model.dart';
import '../../filter_controller.dart';
import 'filter_search_category_componet.dart';

class FilterCategoryComponent extends StatelessWidget {
  final FilterController filterCont;
  const FilterCategoryComponent({super.key, required this.filterCont});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        FilterSearchCategoryComponent(
          filterCategoryController: filterCont,
          hintText: locale.value.searchForCategory,
          onFieldSubmitted: (p0) {
            hideKeyboard(context);
          },
        ).paddingSymmetric(horizontal: 16),
        12.height,
        Obx(
          () => SnapHelperWidget(
            future: filterCont.categoryListFuture.value,
            errorBuilder: (error) {
              return AnimatedScrollView(
                padding: const EdgeInsets.all(16),
                children: [
                  NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      filterCont.categoryPage(1);
                      filterCont.getCategoryList();
                    },
                  ),
                ],
              ).paddingSymmetric(horizontal: 32);
            },
            loadingWidget: const LoaderWidget(),
            onSuccess: (data) {
              if (filterCont.categoryList.isEmpty) {
                return AnimatedScrollView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    NoDataWidget(
                      title: locale.value.noCategoryFound,
                      retryText: locale.value.reload,
                      imageWidget: const EmptyStateWidget(),
                      onRetry: () async {
                        filterCont.categoryPage(1);
                        filterCont.getCategoryList();
                      },
                    ),
                  ],
                ).paddingSymmetric(horizontal: 32).visible(!filterCont.isCategoryLoading.value);
              } else {
                return Obx(
                  () => Stack(
                    children: [
                      AnimatedScrollView(
                        children: List.generate(filterCont.categoryList.length, (index) {
                          final CategoryElement category = filterCont.categoryList[index];
                          return InkWell(
                            onTap: () {
                              filterCont.selectedCategory(category);
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
                                        url: category.categoryImage,
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
                                            category.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: primaryTextStyle(
                                              size: 12,
                                            ),
                                          ),
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
                                ).visible(filterCont.selectedCategory.value.id == category.id),
                              ],
                            ),
                          );
                        }),
                        onNextPage: () async {
                          if (!filterCont.isCategoryLoading.value) {
                            filterCont.categoryPage(filterCont.categoryPage.value + 1);
                            filterCont.getCategoryList();
                          }
                        },
                        onSwipeRefresh: () async {
                          filterCont.categoryPage(1);
                          return filterCont.getCategoryList();
                        },
                      ),
                      if (filterCont.isCategoryLoading.isTrue) const LoaderWidget(),
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
