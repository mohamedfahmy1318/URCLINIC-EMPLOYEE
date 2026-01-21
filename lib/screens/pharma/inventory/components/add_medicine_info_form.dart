import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../components/bottom_selection_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import '../controller/add_stock_controller.dart';
import '../../medicine/model/medicine_resp_model.dart';

class AddMedicineInfoForm extends StatelessWidget {
  const AddMedicineInfoForm({
    super.key,
    required this.addStockCont,
  });

  final AddStockController addStockCont;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: addStockCont.addMedicineInfoFormKey,
      child: AnimatedScrollView(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        listAnimationType: ListAnimationType.None,
        children: [
          AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: addStockCont.medicineNameCont,
            focus: addStockCont.medicineNameFocus,
            nextFocus: addStockCont.dosageFocus,
            textFieldType: TextFieldType.NAME,
            errorThisFieldRequired: locale.value.thisFieldIsRequired,
            decoration: inputDecoration(
              context,
              hintText: locale.value.medicineNameHint,
              fillColor: context.cardColor,
              filled: true,
            ),
            suffix: commonLeadingWid(imgPath: Assets.navigationIcMedicineOutlined, color: iconColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
          ).paddingTop(16),
          // Dosage Input
          AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: addStockCont.dosageCont,
            focus: addStockCont.dosageFocus,
            nextFocus: addStockCont.categoryFocus,
            textFieldType: TextFieldType.NAME,
            errorThisFieldRequired: locale.value.thisFieldIsRequired,
            decoration: inputDecoration(
              context,
              hintText: locale.value.dosageHint,
              fillColor: context.cardColor,
              filled: true,
              suffixIcon: commonLeadingWid(imgPath: Assets.iconsIcDrop, color: iconColor.withValues(alpha: 0.6), size: 10).paddingSymmetric(vertical: 16),
            ),
          ).paddingTop(16),
          // Category Selection
          AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: addStockCont.categoryCont,
            focus: addStockCont.categoryFocus,
            nextFocus: addStockCont.manufacturerFocus,
            textFieldType: TextFieldType.NAME,
            errorThisFieldRequired: locale.value.thisFieldIsRequired,
            readOnly: true,
            onTap: () async {
              addStockCont.getMedicineCategoryList();
              serviceCommonBottomSheet(
                context,
                child: Obx(
                  () => BottomSelectionSheet(
                    title: locale.value.chooseCategory,
                    hintText: locale.value.searchForCategory,
                    hasError: addStockCont.hasErrorFetchingCategory.value,
                    isEmpty: !addStockCont.isMedCategoryLoading.value && addStockCont.medCategories.isEmpty,
                    errorText: addStockCont.errorMessageCategory.value,
                    isLoading: addStockCont.isMedCategoryLoading,
                    searchApiCall: (p0) {
                      addStockCont.getMedicineCategoryList(searchTxt: p0);
                    },
                    onRetry: () {
                      addStockCont.getMedicineCategoryList();
                    },
                    listWidget: Obx(() => medicineCategoryListWid(addStockCont.medCategories).expand()),
                  ),
                ),
              );
            },
            decoration: inputDecoration(
              context,
              hintText: locale.value.selectCategory,
              fillColor: context.cardColor,
              filled: true,
              suffixIcon: commonLeadingWid(imgPath: Assets.iconsIcDropdown, color: iconColor.withValues(alpha: 0.6), size: 10)
                  .scale(scale: 0.8, alignment: Alignment.centerRight)
                  .paddingSymmetric(horizontal: 16),
            ),
          ).paddingTop(16),
          // Medicine Form Selection
          AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: addStockCont.medicineFormCont,
            focus: addStockCont.medicineFormFocus,
            nextFocus: addStockCont.noteFocus,
            textFieldType: TextFieldType.NAME,
            errorThisFieldRequired: locale.value.thisFieldIsRequired,
            readOnly: true,
            onTap: () async {
              serviceCommonBottomSheet(
                context,
                child: Obx(
                  () => BottomSelectionSheet(
                    title: locale.value.chooseMedicineForm,
                    hintText: locale.value.searchForMedicineForm,
                    hasError: addStockCont.hasErrorFetchingMedicineForm.value,
                    isEmpty: !addStockCont.isMedicineFormsLoading.value && addStockCont.medicineForms.isEmpty,
                    errorText: addStockCont.errorMessageMedicineForm.value,
                    isLoading: addStockCont.isMedicineFormsLoading,
                    searchApiCall: (p0) {
                      addStockCont.getMedicineFormList(searchTxt: p0);
                    },
                    onRetry: () {
                      addStockCont.getMedicineFormList();
                    },
                    listWidget: Obx(() => medicineFormListWid(addStockCont.medicineForms).expand()),
                  ),
                ),
              );
            },
            decoration: inputDecoration(
              context,
              hintText: locale.value.selectMedicineForm,
              fillColor: context.cardColor,
              filled: true,
              suffixIcon: commonLeadingWid(imgPath: Assets.iconsIcDropdown, color: iconColor.withValues(alpha: 0.6), size: 10)
                  .scale(scale: 0.8, alignment: Alignment.centerRight)
                  .paddingSymmetric(horizontal: 16),
            ),
          ).paddingTop(16),
          // Notes Input
          AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: addStockCont.noteCont,
            minLines: 3,
            textFieldType: TextFieldType.MULTILINE,
            errorThisFieldRequired: locale.value.thisFieldIsRequired,
            isValidationRequired: false,
            decoration: inputDecoration(
              context,
              hintText: locale.value.notes,
              fillColor: context.cardColor,
              filled: true,
            ),
          ).paddingTop(16),
          62.height
        ],
      ),
    );
  }

  /// Widget to display the list of medicine categories
  Widget medicineCategoryListWid(List<MedicineCategory> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].name,
          titleTextStyle: primaryTextStyle(size: 14),
          onTap: () async {
            hideKeyboard(context);
            addStockCont.selectedMedCategory(list[index]);
            addStockCont.categoryCont.text = list[index].name;
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }

  /// Widget to display the list of medicine forms
  Widget medicineFormListWid(List<MedicineForm> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].name,
          titleTextStyle: primaryTextStyle(size: 14),
          onTap: () async {
            hideKeyboard(context);
            addStockCont.selectedMedicineForm(list[index]);
            addStockCont.medicineFormCont.text = list[index].name;
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }

  /// Widget to display the list of manufacturers
  Widget manufacturerListWid(List<Manufacturer> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: list[index].name,
          titleTextStyle: primaryTextStyle(size: 14),
          onTap: () async {
            hideKeyboard(context);
            addStockCont.selectedManufacturer(list[index]);
            addStockCont.manufacturerCont.text = list[index].name;
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }

  /// Widget to display the list of suppliers
  Widget supplierListWid(List<Supplier> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: "${list[index].firstName} ${list[index].lastName}",
          titleTextStyle: primaryTextStyle(size: 14),
          onTap: () async {
            hideKeyboard(context);
            addStockCont.selectedSupplier(list[index]);
            addStockCont.supplierCont.text = "${list[index].firstName} ${list[index].lastName}";
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}
