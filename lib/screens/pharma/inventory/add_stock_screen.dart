import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import 'components/add_inventory_info_form.dart';
import 'components/add_medicine_info_form.dart';
import 'controller/add_stock_controller.dart';
import 'components/add_supplier_info_form.dart';

class AddStockScreen extends StatelessWidget {
  AddStockScreen({super.key});

  final AddStockController addStockCont = Get.put(AddStockController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffoldNew(
          appBartitleText: addStockCont.isEdit.value ? locale.value.editMedicineStock : locale.value.addNewMedicineStock,
          appBarVerticalSize: Get.height * 0.12,
          isBlurBackgroundinLoader: true,
          isLoading: addStockCont.isLoading,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    buildStepHeader(
                        context: context,
                        title: locale.value.medicineInfo,
                        index: 0,
                        onTap: () {
                          addStockCont.pageController.jumpToPage(0);
                        }),
                    SizedBox(width: 8),
                    buildStepHeader(
                        context: context,
                        title: locale.value.supplierInfo,
                        index: 1,
                        onTap: () {
                          if (addStockCont.currentStep.value == 0 && addStockCont.addMedicineInfoFormKey.currentState!.validate()) {
                            addStockCont.pageController.jumpToPage(1);
                          }
                        }),
                    SizedBox(width: 8),
                    buildStepHeader(
                        context: context,
                        title: locale.value.inventoryInfo,
                        index: 2,
                        onTap: () {
                          if (addStockCont.currentStep.value == 0 && addStockCont.addMedicineInfoFormKey.currentState!.validate()) {
                            addStockCont.pageController.jumpToPage(2);
                          } else if (addStockCont.currentStep.value == 1 && addStockCont.addSupplierInfoFormKey.currentState!.validate()) {
                            addStockCont.pageController.jumpToPage(2);
                          }
                        }),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: addStockCont.pageController,
                  onPageChanged: (value) {
                    addStockCont.currentStep(value);
                  },
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    AddMedicineInfoForm(addStockCont: addStockCont),
                    AddSupplierInfoForm(addStockCont: addStockCont),
                    AddInventoryInfoForm(addStockCont: addStockCont),
                  ],
                ),
              ),
            ],
          ),
          widgetsStackedOverBody: [
            Positioned(
              bottom: 16,
              height: 50,
              width: Get.width,
              child: Obx(
                () => Row(
                  children: [
                    if (addStockCont.currentStep.value != 0)
                      AppButton(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: Get.width,
                        text: locale.value.previous,
                        color: appColorSecondary,
                        textStyle: appButtonTextStyleWhite,
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                        onTap: handlePreviousBtnClick,
                      ).paddingRight(16).expand(),
                    AppButton(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: Get.width,
                      text: addStockCont.currentStep.value == 2 ? locale.value.save : locale.value.next,
                      color: appColorSecondary,
                      textStyle: appButtonTextStyleWhite,
                      shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                      onTap: () {
                        if (addStockCont.currentStep.value == 2) {
                          handleSaveBtnClick();
                        } else {
                          handleNextBtnClick();
                        }
                      },
                    ).expand(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void handlePreviousBtnClick() {
    addStockCont.previousPage();
  }

  void handleSaveBtnClick() {
    if (addStockCont.addInventoryInfoFormKey.currentState!.validate()) {
      addStockCont.saveMedicineToStock();
    }
  }

  void handleNextBtnClick() {
    if (addStockCont.currentStep.value == 0 && addStockCont.addMedicineInfoFormKey.currentState!.validate()) {
      addStockCont.nextPage();
    } else if (addStockCont.currentStep.value == 1 && addStockCont.addSupplierInfoFormKey.currentState!.validate()) {
      addStockCont.nextPage();
    }
  }

  Widget buildStepHeader({required BuildContext context, required String title, required int index, void Function()? onTap}) {
    return Expanded(
      child: Obx(
        () => GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: addStockCont.currentStep.value == index ? appColorSecondary : context.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: primaryTextStyle(
                size: 14,
                color: addStockCont.currentStep.value == index
                    ? Colors.white
                    : isDarkMode.value
                        ? secondaryTextColor
                        : primaryTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
