import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../components/bottom_selection_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import '../controller/add_stock_controller.dart';
import '../../medicine/model/medicine_resp_model.dart';

class AddSupplierInfoForm extends StatelessWidget {
  const AddSupplierInfoForm({
    super.key,
    required this.addStockCont,
  });

  final AddStockController addStockCont;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: addStockCont.addSupplierInfoFormKey,
      child: AnimatedScrollView(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        listAnimationType: ListAnimationType.None,
        children: [
          // Supplier Selection
          Row(
            children: [
              Expanded(
                flex: 4,
                child: AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addStockCont.supplierCont,
                  focus: addStockCont.supplierFocus,
                  nextFocus: addStockCont.medicineFormFocus,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    addStockCont.getSupplierList();
                    serviceCommonBottomSheet(
                      context,
                      child: Obx(
                        () => BottomSelectionSheet(
                          title: locale.value.chooseSupplier,
                          hintText: locale.value.searchForSupplier,
                          hasError: addStockCont.hasErrorFetchingSupplier.value,
                          isEmpty: !addStockCont.isSuppliersLoading.value && addStockCont.supplierList.isEmpty,
                          errorText: addStockCont.errorMessageSupplier.value,
                          isLoading: addStockCont.isSuppliersLoading,
                          searchApiCall: (p0) {
                            log("Search Supplier ==> $p0");
                            addStockCont.getSupplierList(searchTxt: p0);
                          },
                          onRetry: () {
                            addStockCont.getSupplierList();
                          },
                          listWidget: Obx(() => supplierListWid(addStockCont.supplierList).expand()),
                        ),
                      ),
                    );
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectSupplier,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: IconButton(
                        onPressed: () {
                          addStockCont.getSupplierList();
                        },
                        icon: commonLeadingWid(imgPath: Assets.iconsIcDropdown, color: iconColor.withValues(alpha: 0.6), size: 10)
                            .scale(scale: 0.8, alignment: Alignment.centerRight)
                            .paddingSymmetric(horizontal: 16)),
                  ),
                ),
              ),
            ],
          ),
          16.height,
          Row(
            children: [
              Obx(
                () => AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  textFieldType: TextFieldType.OTHER,
                  controller: addStockCont.supplierCountryCodeCont,
                  errorThisFieldRequired: locale.value.thisFieldIsRequired,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: inputDecoration(
                    context,
                    hintText: addStockCont.pickedPhoneCode.value.phoneCode.isNotEmpty ? "+${addStockCont.pickedPhoneCode.value.phoneCode}" : "+91",
                    prefixIcon: Text(
                      addStockCont.pickedPhoneCode.value.flagEmoji,
                    ).paddingOnly(top: 2, left: 8),
                    prefixIconConstraints: BoxConstraints.tight(const Size(24, 24)),
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: dividerColor,
                      size: 22,
                    ).paddingOnly(right: 32),
                    suffixIconConstraints: BoxConstraints.tight(const Size(24, 24)),
                    fillColor: context.cardColor,
                    filled: true,
                  ),
                ),
              ).expand(flex: 3),
              10.width,
              AppTextField(
                textStyle: primaryTextStyle(size: 12),
                textFieldType: TextFieldType.PHONE,
                controller: addStockCont.supplierContactNumberCont,
                focus: addStockCont.supplierContactNumberFocus,
                nextFocus: addStockCont.paymentTermsFocus,
                // maxLength: 10,
                errorThisFieldRequired: locale.value.thisFieldIsRequired,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                readOnly: true,
                enabled: false,
                decoration: inputDecoration(
                  context,
                  hintText: locale.value.contactNumber,
                  fillColor: context.cardColor,
                  filled: true,
                ),
                suffix: commonLeadingWid(imgPath: Assets.iconsIcCall, color: iconColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
              ).expand(flex: 8),
            ],
          ),
          // Payment Terms Input
          AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: addStockCont.paymentTermsCont,
            focus: addStockCont.paymentTermsFocus,
            textFieldType: TextFieldType.NUMBER,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            isValidationRequired: true,
            readOnly: true,
            decoration: inputDecoration(
              context,
              hintText: locale.value.paymentTermsInDays,
              fillColor: context.cardColor,
              filled: true,
            ),
            suffix: commonLeadingWid(imgPath: Assets.iconsIcTotalPayout, color: iconColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
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
            addStockCont.medicineNameCont.text = list[index].name;
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
            List<String> parts = list[index].contactNumber.split(' ');
            addStockCont.supplierContactNumberCont.text = parts.length==1?parts[0]:parts[1];
            addStockCont.supplierCountryCodeCont.text = parts.length==1?'+91':parts[0];
            addStockCont.paymentTermsCont.text = list[index].paymentTerms;
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}
