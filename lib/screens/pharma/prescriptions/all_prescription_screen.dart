import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../medicine/components/search_prescription_widget.dart';
import 'controller/all_prescription_controller.dart';
import 'component/prescription_card_component.dart';

class AllPrescriptionsScreen extends StatelessWidget {
  final bool hasLeadingWidget;

  const AllPrescriptionsScreen({super.key, this.hasLeadingWidget = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AllPrescriptionsController(),
      builder: (allPrescriptionsCont) {
        return AppScaffoldNew(
          appBartitleText: locale.value.prescription,
          isLoading: allPrescriptionsCont.isLoading,
          appBarVerticalSize: Get.height * 0.12,
          hasLeadingWidget: hasLeadingWidget,
          actions: [
            ///Add filter count

            Stack(
              children: [
                RawMaterialButton(
                  fillColor: Color(0xFFACB9E6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                  onPressed: () {
                    allPrescriptionsCont.getDoctorList();
                    allPrescriptionsCont.getPatientList();
                    showFilterBottomSheet(context: context, allPrescriptionsCont: allPrescriptionsCont);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, size: 22, color: Colors.white),
                      10.width,
                      Text(
                        locale.value.filter,
                        style: primaryTextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ).paddingOnly(right: 8, top: 8, bottom: 8),
                Positioned(
                  right: 6,
                  top: 4,
                  child: Obx(
                    () => allPrescriptionsCont.count.value > 0
                        ? Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              allPrescriptionsCont.count.value.toString(),
                              style: primaryTextStyle(color: Colors.white, size: 12),
                            ),
                          )
                        : const Offstage(),
                  ),
                ),
              ],
            ),
          ],
          body: SizedBox(
            height: Get.height,
            child: Column(
              children: [
                SearchPrescriptionWidget(
                    allPrescriptionsCont: allPrescriptionsCont,
                    onFieldSubmitted: (p0) {
                      hideKeyboard(context);
                    },
                    onClearButton: () {
                      allPrescriptionsCont.searchPrescriptionCont.clear();
                      allPrescriptionsCont.getPrescriptions();
                    }).paddingSymmetric(horizontal: 16),
                16.height,
                Obx(
                  () => SnapHelperWidget(
                    future: allPrescriptionsCont.prescriptionListFuture.value,
                    loadingWidget: allPrescriptionsCont.isLoading.value ? const Offstage() : const LoaderWidget(),
                    errorBuilder: (error) {
                      return NoDataWidget(
                        title: error,
                        retryText: locale.value.reload,
                        imageWidget: const ErrorStateWidget(),
                        onRetry: () {
                          allPrescriptionsCont.page(1);
                          allPrescriptionsCont.getPrescriptions();
                        },
                      );
                    },
                    onSuccess: (res) {
                      return Obx(
                        () => AnimatedListView(
                          shrinkWrap: true,
                          itemCount: allPrescriptionsCont.prescriptionList.length,
                          padding: const EdgeInsets.only(bottom: 80),
                          physics: const AlwaysScrollableScrollPhysics(),
                          listAnimationType: ListAnimationType.Slide,
                          emptyWidget: NoDataWidget(
                            title: locale.value.noPrescriptionFound,
                            imageWidget: const EmptyStateWidget(),
                          ).paddingSymmetric(horizontal: 32).visible(!allPrescriptionsCont.isLoading.value),
                          onSwipeRefresh: () async {
                            allPrescriptionsCont.page(1);
                            return await allPrescriptionsCont.getPrescriptions(
                                showLoader: false,
                                bookingStatusList: allPrescriptionsCont.bookingStatusList,
                                paymentStatusList: allPrescriptionsCont.paymentStatusList,
                                doctorListName: allPrescriptionsCont.doctorListName,
                                patientListName: allPrescriptionsCont.patientListName);
                          },
                          onNextPage: () async {
                            if (!allPrescriptionsCont.isLastPage.value) {
                              allPrescriptionsCont.page++;
                              allPrescriptionsCont.getPrescriptions();
                            }
                          },
                          itemBuilder: (ctx, index) {
                            return PrescriptionCardWidget(
                              prescriptionData: allPrescriptionsCont.prescriptionList[index],
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
      },
    );
  }

  void showFilterBottomSheet({required BuildContext context, required AllPrescriptionsController allPrescriptionsCont}) {
    allPrescriptionsCont.selectedTabIndex(0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${locale.value.filter} ', style: boldTextStyle(size: 16)),
                          TextButton(
                            onPressed: () {
                              // Reset all filters
                              allPrescriptionsCont.bookingStatusList.clear();
                              allPrescriptionsCont.paymentStatusList.clear();
                              allPrescriptionsCont.selectedTabIndex(0);
                              allPrescriptionsCont.doctorListName.clear();
                              allPrescriptionsCont.patientListName.clear();
                              allPrescriptionsCont.count.value = 0;
                              Get.back();
                              allPrescriptionsCont.getPrescriptions();
                            },
                            child: Text(locale.value.reset, style: primaryTextStyle(color: Colors.red)),
                          ).visible(allPrescriptionsCont.count > 0),
                        ],
                      ),
                      16.height,

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            tabButton(locale.value.prescriptionStatus, allPrescriptionsCont.selectedTabIndex.value == 0, () {
                              allPrescriptionsCont.selectedTabIndex(0);
                            }),
                            8.width,
                            tabButton(locale.value.paymentStatus, allPrescriptionsCont.selectedTabIndex.value == 1, () {
                              allPrescriptionsCont.selectedTabIndex(1);
                            }),
                            8.width,
                            tabButton(locale.value.doctor, allPrescriptionsCont.selectedTabIndex.value == 2, () {
                              allPrescriptionsCont.selectedTabIndex(2);
                            }),
                            8.width,
                            tabButton(locale.value.patient, allPrescriptionsCont.selectedTabIndex.value == 3, () {
                              allPrescriptionsCont.selectedTabIndex(3);
                            }),
                          ],
                        ),
                      ),
                      16.height,

                      // Dynamic content based on tab
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(10)),
                        child: Obx(() {
                          switch (allPrescriptionsCont.selectedTabIndex.value) {
                            case 0:
                              return Container(
                                decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: BorderRadiusGeometry.circular(10)),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => SizedBox(
                                          height: 300,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: allPrescriptionsCont.prescriptionStatusTypeList.map((type) {
                                                bool isSelected = allPrescriptionsCont.bookingStatusList.contains(type);

                                                return CheckboxListTile(
                                                  value: isSelected,
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  contentPadding: EdgeInsets.zero,
                                                  title: Text(type, style: primaryTextStyle()),
                                                  onChanged: (val) {
                                                    if (val == true) {
                                                      if (!allPrescriptionsCont.bookingStatusList.contains(type)) {
                                                        allPrescriptionsCont.bookingStatusList.add(type);
                                                      }
                                                      if (allPrescriptionsCont.bookingStatusList.length == 1) {
                                                        allPrescriptionsCont.count.value++;
                                                      }
                                                    } else {
                                                      allPrescriptionsCont.bookingStatusList.remove(type);
                                                      if (allPrescriptionsCont.bookingStatusList.isEmpty) {
                                                        allPrescriptionsCont.count.value--;
                                                      }
                                                    }
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              );
                            case 1:
                              return Container(
                                decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: BorderRadiusGeometry.circular(10)),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Filtered list with checkboxes
                                    Obx(() => SizedBox(
                                          height: 300,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: allPrescriptionsCont.prescriptionPaymentStatusTypeList.map((type) {
                                                bool isSelected = allPrescriptionsCont.paymentStatusList.contains(type);

                                                return CheckboxListTile(
                                                  value: isSelected,
                                                  controlAffinity: ListTileControlAffinity.leading,
                                                  contentPadding: EdgeInsets.zero,
                                                  title: Text(type, style: primaryTextStyle()),
                                                  onChanged: (val) {
                                                    if (val == true) {
                                                      if (!allPrescriptionsCont.paymentStatusList.contains(type)) {
                                                        allPrescriptionsCont.paymentStatusList.add(type);
                                                      }
                                                      if (allPrescriptionsCont.paymentStatusList.length == 1) {
                                                        allPrescriptionsCont.count.value++;
                                                      }
                                                    } else {
                                                      allPrescriptionsCont.paymentStatusList.remove(type);
                                                      if (allPrescriptionsCont.paymentStatusList.isEmpty) {
                                                        allPrescriptionsCont.count.value--;
                                                      }
                                                    }
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              );
                            case 2:
                              return Container(
                                decoration: BoxDecoration(
                                  color: context.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Filtered list with checkboxes
                                    Obx(() => SizedBox(
                                      height: 300,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: allPrescriptionsCont.doctorList.map((type) {
                                            bool isSelected = allPrescriptionsCont.doctorListName.contains(type.doctorId); // ✅ Check by ID

                                            return CheckboxListTile(
                                              value: isSelected,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(
                                                "${type.firstName} ${type.lastName}",
                                                style: primaryTextStyle(),
                                              ),
                                              onChanged: (val) {
                                                if (val == true) {
                                                  if (!allPrescriptionsCont.doctorListName.contains(type.doctorId)) {
                                                    allPrescriptionsCont.doctorListName.add(type.doctorId); // ✅ Add ID
                                                  }
                                                  if (allPrescriptionsCont.doctorListName.length == 1) {
                                                    allPrescriptionsCont.count.value++;
                                                  }
                                                } else {
                                                  allPrescriptionsCont.doctorListName.remove(type.doctorId); // ✅ Remove ID
                                                  if (allPrescriptionsCont.doctorListName.isEmpty) {
                                                    allPrescriptionsCont.count.value--;
                                                  }
                                                }
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              );

                            case 3:
                              return Container(
                                decoration: BoxDecoration(
                                  color: context.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => SizedBox(
                                      height: 300,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: allPrescriptionsCont.patientList.map((type) {
                                            bool isSelected = allPrescriptionsCont.patientListName.contains(type.id); // ✅ Check using ID

                                            return CheckboxListTile(
                                              value: isSelected,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              contentPadding: EdgeInsets.zero,
                                              title: Text("${type.firstName} ${type.lastName}", style: primaryTextStyle()),
                                              onChanged: (val) {
                                                if (val == true) {
                                                  if (!allPrescriptionsCont.patientListName.contains(type.id)) {
                                                    allPrescriptionsCont.patientListName.add(type.id); // ✅ Add ID
                                                  }
                                                  if (allPrescriptionsCont.patientListName.length == 1) {
                                                    allPrescriptionsCont.count.value++;
                                                  }
                                                } else {
                                                  allPrescriptionsCont.patientListName.remove(type.id); // ✅ Remove ID
                                                  if (allPrescriptionsCont.patientListName.isEmpty) {
                                                    allPrescriptionsCont.count.value--;
                                                  }
                                                }
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              )
                              ;
                            default:
                              return SizedBox();
                          }
                        }),
                      ),
                      16.height,

                      // Show Result Button
                      AppButton(
                        text: locale.value.showResult,
                        width: Get.width,
                        color: appColorPrimary,
                        textStyle: boldTextStyle(color: white),
                        onTap: () async {
                          if (allPrescriptionsCont.count.value == 0) {
                            toast(locale.value.pleaseSelectAtLeastOneFilterOption);
                            return;
                          } else {
                            allPrescriptionsCont.isFilterLoading(true);
                            // Handle the filter logic here
                            await allPrescriptionsCont
                                .getPrescriptions(
                                    bookingStatusList: allPrescriptionsCont.bookingStatusList,
                                    paymentStatusList: allPrescriptionsCont.paymentStatusList,
                                    doctorListName: allPrescriptionsCont.doctorListName,
                                    patientListName: allPrescriptionsCont.patientListName,
                                    showLoader: true)
                                .then((value) {
                              allPrescriptionsCont.isFilterLoading(false);
                            });

                            Get.back();
                          }
                          // Apply filter logic
                        },
                      ).visible(allPrescriptionsCont.count > 0),
                    ],
                  )),
            ),
            Obx(() => Positioned(
                  left: 0,
                  right: 0,
                  bottom: 50,
                  child: LoaderWidget().visible(allPrescriptionsCont.isFilterLoading.value),
                ))
          ],
        );
      },
    );
  }

  // Tab Button Widget
  Widget tabButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? appColorPrimary
              : isDarkMode.value
                  ? Colors.grey.shade800
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: boldTextStyle(
              color: isSelected
                  ? Colors.white
                  : isDarkMode.value
                      ? Colors.white
                      : Colors.black),
        ),
      ),
    );
  }
}
