import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/pharma/manufacturer/add_manufacturer.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../components/bottom_selection_widget.dart';
import '../../../../components/decimal_input_formater.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import '../../../../utils/view_all_label_component.dart';
import '../controller/add_stock_controller.dart';
import '../../medicine/model/medicine_resp_model.dart';

class AddInventoryInfoForm extends StatelessWidget {
  const AddInventoryInfoForm({
    super.key,
    required this.addStockCont,
  });

  final AddStockController addStockCont;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: addStockCont.addInventoryInfoFormKey,
      child: AnimatedScrollView(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        listAnimationType: ListAnimationType.None,
        children: [
          ViewAllLabel(label: locale.value.basicInventoryDetail, isShowAll: false),
          // Start Serial Number Input
          AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: addStockCont.startSerialNoCont,
            textFieldType: TextFieldType.NUMBER,
            focus: addStockCont.startSerialNoFocus,
            isValidationRequired: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            decoration: inputDecoration(
              context,
              fillColor: context.cardColor,
              filled: true,
              hintText: locale.value.startSerialNumber,
            ),
            validator: (value) {
              log("start----${addStockCont.startSerialNoCont.text}");
              if (addStockCont.startSerialNoCont.text.isEmpty) {
                log("empty");
                addStockCont.quantityCont.clear();
                return locale.value.thisFieldIsRequired;
              } else if (addStockCont.endSerialNoCont.text.isNotEmpty) {
                int start = int.tryParse(addStockCont.startSerialNoCont.text) ?? 0;
                int end = int.tryParse(addStockCont.endSerialNoCont.text) ?? 0;
                if (end < start) {
                  addStockCont.quantityCont.clear();
                  addStockCont.errorMessageSerialNumber.value = "End serial number cannot be less than start serial number.";
                } else {
                  addStockCont.errorMessageSerialNumber.value = "";
                }
              }
              return null;
            },
            onChanged: (value) {
              //when end serial number is smaller than start serial number, clear quantity
              // Update quantity based on serial number range
              if (addStockCont.endSerialNoCont.text.isNotEmpty && value.isNotEmpty) {
                int start = int.tryParse(value) ?? 0;
                int end = int.tryParse(addStockCont.endSerialNoCont.text) ?? 0;
                if (end < start) {
                  addStockCont.quantityCont.clear();
                  addStockCont.errorMessageSerialNumber.value = "End serial number cannot be less than start serial number.";
                } else {
                  addStockCont.quantityCont.text = ((end - start) + 1).toString();
                  addStockCont.errorMessageSerialNumber.value = "";
                }
              } else {
                addStockCont.quantityCont.clear();
              }
            },
            suffix: commonLeadingWid(imgPath: Assets.iconsIcListNumbers, color: iconColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
          ),
          // End Serial Number Input
          Obx(
            () => AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: addStockCont.endSerialNoCont,
              textFieldType: TextFieldType.NUMBER,
              focus: addStockCont.endSerialNoFocus,
              isValidationRequired: true,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              decoration: inputDecoration(
                context,
                fillColor: context.cardColor,
                filled: true,
                hintText: locale.value.endSerialNumber,
                errorText: addStockCont.errorMessageSerialNumber.value.isNotEmpty ? addStockCont.errorMessageSerialNumber.value : null,
              ),
              onChanged: (value) {
                //when end serial number is smaller than start serial number, clear quantity
                // Update quantity based on serial number range
                if (addStockCont.startSerialNoCont.text.isNotEmpty) {
                  int start = int.tryParse(addStockCont.startSerialNoCont.text) ?? 0;
                  int end = int.tryParse(value) ?? 0;
                  if (end < start) {
                    addStockCont.quantityCont.clear();
                    addStockCont.errorMessageSerialNumber.value = "End serial number cannot be less than start serial number.";
                  } else {
                    addStockCont.errorMessageSerialNumber.value = "";
                  }
                } else {
                  addStockCont.quantityCont.clear();
                }
              },
              suffix: commonLeadingWid(imgPath: Assets.iconsIcListNumbers, color: iconColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
            ).paddingTop(16),
          ),
          // Quantity Input
          AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: addStockCont.quantityCont,
            focus: addStockCont.quantityFocus,
            nextFocus: addStockCont.sellingPriceFocus,
            textFieldType: TextFieldType.NUMBER,
            /*    isValidationRequired: true,
            onChanged: (value) {
              addStockCont.stockValueCont.text = (double.parse(addStockCont.quantityCont.text) * double.parse(addStockCont.purchasePriceCont.text)).toStringAsFixed(2);
            },*/
            decoration: inputDecoration(
              context,
              hintText: locale.value.quantity,
              fillColor: context.cardColor,
              filled: true,
            ),
            suffix: commonLeadingWid(imgPath: Assets.iconsIcListNumbers, color: iconColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
          ).paddingTop(16),
          // Date Input
          AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: addStockCont.expiryDateCont,
            textFieldType: TextFieldType.NAME,
            readOnly: true,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(Duration(days: 0)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );

              if (selectedDate != null) {
                addStockCont.expiryDateCont.text = selectedDate.formatDateYYYYmmdd();
              } else {
                log(locale.value.dateIsNotSelected);
              }
            },
            decoration: inputDecoration(
              context,
              hintText: locale.value.expiryDate1,
              fillColor: context.cardColor,
              filled: true,
            ),
            suffix: commonLeadingWid(
              imgPath: Assets.iconsIcCalendar,
              color: iconColor.withValues(alpha: 0.6),
              size: 12,
            ).paddingAll(16),
          ).paddingTop(16),

          // Reorder Level Input
          AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: addStockCont.reOrderLevelCont,
            textFieldType: TextFieldType.NUMBER,
            focus: addStockCont.reOrderLevelFocus,
            isValidationRequired: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            decoration: inputDecoration(
              context,
              fillColor: context.cardColor,
              filled: true,
              hintText: locale.value.reorderLevel,
            ),
            suffix: commonLeadingWid(imgPath: Assets.iconsIcListNumbers, color: iconColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
          ).paddingTop(16),
          ViewAllLabel(label: locale.value.otherDetail, isShowAll: false),
          // Manufacturer Selection
          Row(
            children: [
              Expanded(
                flex: 4,
                child: AppTextField(
                  textStyle: primaryTextStyle(size: 12),
                  controller: addStockCont.manufacturerCont,
                  focus: addStockCont.manufacturerFocus,
                  nextFocus: addStockCont.supplierFocus,
                  textFieldType: TextFieldType.NAME,
                  readOnly: true,
                  onTap: () async {
                    addStockCont.getManufacturerList();
                    serviceCommonBottomSheet(
                      context,
                      child: Obx(
                        () => BottomSelectionSheet(
                          title: locale.value.chooseManufacturer,
                          hintText: locale.value.searchForManufacturer,
                          hasError: addStockCont.hasErrorFetchingManufacturer.value,
                          isEmpty: !addStockCont.isManufacturerLoading.value && addStockCont.manufacturerList.isEmpty,
                          errorText: addStockCont.errorMessageManufacturer.value,
                          isLoading: addStockCont.isManufacturerLoading,
                          searchApiCall: (p0) {
                            log("Search Manufacturer ==> $p0");
                            addStockCont.getManufacturerList(searchTxt: p0);
                          },
                          onRetry: () {
                            addStockCont.getManufacturerList();
                          },
                          listWidget: Obx(() => manufacturerListWid(addStockCont.manufacturerList).expand()),
                        ),
                      ),
                    );
                  },
                  decoration: inputDecoration(
                    context,
                    hintText: locale.value.selectManufacturer,
                    fillColor: context.cardColor,
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        addStockCont.getManufacturerList();
                      },
                      icon: commonLeadingWid(imgPath: Assets.iconsIcDropdown, color: iconColor.withValues(alpha: 0.6), size: 10).scale(scale: 0.8, alignment: Alignment.centerRight).paddingSymmetric(horizontal: 16),
                    ),
                  ),
                ),
              ),
              10.width,

              ///Create Add button
              Expanded(
                child: RawMaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  fillColor: appColorSecondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                  onPressed: () {
                    Get.bottomSheet(AddManufacturerComponent()).then((value) {
                      addStockCont.getManufacturerList();
                    });
                  },
                  child: Text(
                    locale.value.add,
                    style: primaryTextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          // Batch Number Input
          AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: addStockCont.batchNoCont,
            textFieldType: TextFieldType.NAME,
            focus: addStockCont.batchNoFocus,
            isValidationRequired: true,
            decoration: inputDecoration(
              context,
              fillColor: context.cardColor,
              filled: true,
              hintText: locale.value.batchNumber,
            ),
            suffix: commonLeadingWid(imgPath: Assets.iconsIcListNumbers, color: iconColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
          ).paddingTop(16),

          ViewAllLabel(label: locale.value.pricing, isShowAll: false),
          // Purchase Price Input
// Purchase Price Input
          AppTextField(
            textStyle: primaryTextStyle(size: 12),
            controller: addStockCont.purchasePriceCont,
            textFieldType: TextFieldType.NUMBER,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
              DecimalTextInputFormatter(decimalRange: 2),
            ],
            focus: addStockCont.purchasePriceFocus,
            isValidationRequired: true,
            decoration: inputDecoration(
              context,
              fillColor: context.cardColor,
              filled: true,
              hintText: locale.value.purchasePrice,
            ),
            onChanged: (value) {
              double purchase = double.tryParse(value) ?? 0.0;
              addStockCont.purchasePrice.value = purchase;
              addStockCont.isPurchasePriceEntered.value = value.isNotEmpty;

              // Re-validate selling price if already entered
              if (addStockCont.sellingPriceCont.text.isNotEmpty) {
                addStockCont.validateSellingPrice(addStockCont.sellingPriceCont.text);
              }
            },
            suffix: commonLeadingWid(imgPath: Assets.iconsIcTotalPayout, color: iconColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
          ).paddingOnly(bottom: 16),
          // Selling Price Input

          Obx(
            () => AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: addStockCont.sellingPriceCont,
              textFieldType: TextFieldType.NUMBER,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                DecimalTextInputFormatter(decimalRange: 2),
              ],
              focus: addStockCont.sellingPriceFocus,
              isValidationRequired: true,
              decoration: inputDecoration(
                context,
                fillColor: context.cardColor,
                filled: true,
                hintText: locale.value.sellingPrice,
                errorText: addStockCont.sellingPriceError.value.isNotEmpty ? addStockCont.sellingPriceError.value : null,
              ),
              validator: (value) {
                addStockCont.validateSellingPrice(value!);
                if (addStockCont.sellingPriceError.value.isNotEmpty) {
                  return addStockCont.sellingPriceError.value;
                }
                if (addStockCont.sellingPriceCont.text.isEmpty) {
                  return locale.value.thisFieldIsRequired;
                }

                return null;
              },
              onChanged: (value) {
                if (addStockCont.sellingPriceCont.text.isNotEmpty) {
                  addStockCont.validateSellingPrice(addStockCont.sellingPriceCont.text);
                }

                double sell = double.tryParse(value) ?? 0.0;
                double quantity = double.tryParse(addStockCont.quantityCont.text) ?? 0.0;
                addStockCont.stockValueCont.text = (quantity * sell).toStringAsFixed(2);
              },
              suffix: commonLeadingWid(
                imgPath: Assets.iconsIcTotalPayout,
                color: iconColor.withValues(alpha: 0.6),
                size: 12,
              ).paddingAll(16),
            ).paddingOnly(bottom: 16),
          ),

          // Stock value Input
          AppTextField(
            textStyle: secondaryTextStyle(
              size: 12,
            ),
            controller: addStockCont.stockValueCont,
            textFieldType: TextFieldType.NUMBER,
            readOnly: true,
            decoration: InputDecoration(
                hintText: locale.value.stockValue,
                fillColor: context.cardColor,
                filled: true,
                hintStyle: secondaryTextStyle(size: 12, color: secondaryTextColor.withValues(alpha: 0.6)),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: borderColor.withValues(alpha: 0.5), width: 1),
                )),
            suffix: commonLeadingWid(imgPath: Assets.iconsIcStock, color: iconColor.withValues(alpha: 0.6), size: 12).paddingAll(16),
          ),
          // Inclusive Tax Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.value.inclusiveTax,
                style: secondaryTextStyle(size: 14),
              ),
              Obx(
                () => Transform.scale(
                  scale: 0.75,
                  child: Switch(
                    activeTrackColor: switchActiveTrackColor,
                    value: addStockCont.isInclusiveTax.value,
                    activeThumbColor: switchActiveColor,
                    inactiveTrackColor: switchColor.withValues(alpha: 0.2),
                    onChanged: (bool value) {
                      log('VALUE: $value');
                      addStockCont.isInclusiveTax(value);
                    },
                  ),
                ),
              ),
            ],
          ),

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
            Get.back();
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}
