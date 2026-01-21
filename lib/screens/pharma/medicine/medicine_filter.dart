import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../main.dart';
import 'controller/medicine_list_controller.dart';
import '../../../components/loader_widget.dart';

void showFilterBottomSheet({
  required BuildContext context,
  required MedicinesListController medicinesListCont,
}) {
  medicinesListCont.getMedicineFormList();
  medicinesListCont.getMedicineCategoryList();
  medicinesListCont.getSupplierList();
  medicinesListCont.selectedTabIndex.value = 0; // Default to Form tab

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
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(locale.value.filter, style: boldTextStyle(size: 16)),
                      TextButton(
                        onPressed: () {
                          medicinesListCont.selectedMedicineForm.clear();
                          medicinesListCont.selectedMedicineCategory.clear();
                          medicinesListCont.selectedMedicineSupplier.clear();
                          medicinesListCont.searchText.value = "";
                          medicinesListCont.selectedFilerCount.value = 0;
                          Get.back();
                          medicinesListCont.getMedicineList();
                        },
                        child: Text(locale.value.reset, style: primaryTextStyle(color: Colors.red)),
                      ).visible(medicinesListCont.selectedFilerCount.value > 0),
                    ],
                  ),
                  16.height,

                  /// Tab Switcher
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        tabButton(locale.value.form1, medicinesListCont.selectedTabIndex.value == 0, () {
                          medicinesListCont.selectedTabIndex(0);
                        }),
                        8.width,
                        tabButton(locale.value.category, medicinesListCont.selectedTabIndex.value == 1, () {
                          medicinesListCont.selectedTabIndex(1);
                        }),
                        8.width,
                        tabButton(locale.value.suppliers, medicinesListCont.selectedTabIndex.value == 2, () {
                          medicinesListCont.selectedTabIndex(2);
                        }),
                      ],
                    ),
                  ),
                  16.height,

                  /// Dynamic Filter Container (fixed height)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Obx(() {
                      switch (medicinesListCont.selectedTabIndex.value) {
                        case 0:
                          return _buildCheckboxList(
                            titleList: medicinesListCont.medicineForms.map((e) => e.name).toList(),
                            selectedList: medicinesListCont.selectedMedicineForm,
                            count: medicinesListCont.selectedFilerCount,
                          );
                        case 1:
                          return _buildCheckboxList(
                            titleList: medicinesListCont.medCategories.map((e) => e.name).toList(),
                            selectedList: medicinesListCont.selectedMedicineCategory,
                            count: medicinesListCont.selectedFilerCount,
                          );
                        case 2:
                          return _buildCheckboxList(
                            titleList: medicinesListCont.supplierList.map((e) => "${e.firstName} ${e.lastName}").toList(),
                            selectedList: medicinesListCont.selectedMedicineSupplier,
                            count: medicinesListCont.selectedFilerCount,
                          );
                        default:
                          return const SizedBox();
                      }
                    }),
                  ).withHeight(300),

                  16.height,

                  /// Show Result Button
                  AppButton(
                    text: locale.value.showResult,
                    width: Get.width,
                    color: appColorPrimary,
                    textStyle: boldTextStyle(color: white),
                    onTap: () async {
                      if (medicinesListCont.selectedFilerCount.value == 0) {
                        toast(locale.value.pleaseSelectAtLeastOneFilterOption);
                        return;
                      } else {
                        medicinesListCont.isLoading(true);
                        await medicinesListCont
                            .getMedicineList(
                          clinicId: medicinesListCont.clinicId,
                          searchMedicineName: medicinesListCont.selectedMedicinesList,
                          searchMedicineCategory: medicinesListCont.selectedMedicineCategory,
                          searchMedicineForm: medicinesListCont.selectedMedicineForm,
                          searchMedicineSupplier: medicinesListCont.selectedMedicineSupplier,
                        )
                            .then((value) {
                          medicinesListCont.isLoading(false);
                        });
                        Get.back();
                      }
                    },
                  ).visible(medicinesListCont.selectedFilerCount.value > 0),
                ],
              ),
            ),
          ),

          /// Loader Overlay (like prescription filter)
          Obx(
            () => Positioned(
              left: 0,
              right: 0,
              bottom: 50,
              child: LoaderWidget().visible(medicinesListCont.isLoading.value),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildCheckboxList({
  required List<String> titleList,
  required RxList<String> selectedList,
  required RxInt count,
}) {
  return SizedBox(
    height: 300,
    child: SingleChildScrollView(
      child: Column(
        children: titleList.map((name) {
          bool isSelected = selectedList.contains(name);
          return CheckboxListTile(
            value: isSelected,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text(name, style: primaryTextStyle()),
            onChanged: (val) {
              if (val == true) {
                if (!selectedList.contains(name)) {
                  selectedList.add(name);
                }
                if (selectedList.length == 1) count.value++;
              } else {
                selectedList.remove(name);
                if (selectedList.isEmpty) count.value--;
              }
            },
          );
        }).toList(),
      ),
    ),
  );
}

Widget tabButton(String title, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? appColorPrimary : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: isSelected ? boldTextStyle(color: Colors.white) : primaryTextStyle(color: isDarkMode.value ? Colors.black : null),
      ),
    ),
  );
}
