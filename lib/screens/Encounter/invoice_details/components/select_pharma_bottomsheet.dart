import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/bottom_selection_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/screens/pharma/add_pharma_controller.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/common_base.dart';

class SelectPharmaBottomSheet extends StatelessWidget {
  final int clinicId;

  SelectPharmaBottomSheet({super.key, this.clinicId = 0});

  final AddPharmaController addPharmaCont = Get.put(AddPharmaController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      ),
      child: Form(
        key: addPharmaCont.addPharmaForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(locale.value.selectPharmaForMedicine, style: secondaryTextStyle(size: 16, weight: FontWeight.w600, color: isDarkMode.value ? null : darkGrayTextColor)),
            16.height,
            AppTextField(
              textStyle: primaryTextStyle(size: 12),
              controller: addPharmaCont.pharmaCont,
              textFieldType: TextFieldType.NAME,
              isValidationRequired: true,
              readOnly: true,
              errorThisFieldRequired: locale.value.thisFieldIsRequired,
              decoration: inputDecoration(
                context,
                fillColor: context.cardColor,
                filled: true,
                hintText: locale.value.selectPharma,
                suffixIcon: IconButton(
                    onPressed: () {
                      addPharmaCont.fetchPharmaList(clinicId);
                    },
                    icon: commonLeadingWid(imgPath: Assets.iconsIcDropdown, color: iconColor.withValues(alpha: 0.6), size: 10).scale(scale: 0.8, alignment: Alignment.centerRight).paddingSymmetric(horizontal: 16)),
              ),
              onTap: () {
                addPharmaCont.fetchPharmaList(clinicId);
                hideKeyboard(context);
                serviceCommonBottomSheet(
                  context,
                  child: Obx(
                    () => BottomSelectionSheet(
                      title: locale.value.choosePharma,
                      hintText: locale.value.searchForPharma,
                      searchTextCont: addPharmaCont.searchPharmaCont,
                      hasError: addPharmaCont.hasErrorFetchingPharma.value,
                      isEmpty: !addPharmaCont.isPharmaLoading.value && addPharmaCont.pharmaList.isEmpty,
                      errorText: addPharmaCont.errorMessagePharma.value,
                      isLoading: addPharmaCont.isPharmaLoading,
                      searchApiCall: (p0) {
                        addPharmaCont.fetchPharmaList(clinicId);
                      },
                      onRetry: () {
                        addPharmaCont.fetchPharmaList(clinicId);
                      },
                      onChanged: (value) {
                        addPharmaCont.pharmaCont.text = value;
                        addPharmaCont.selectedPharma.value = Pharma(firstName: value);
                      },
                      listWidget: Obx(() => pharmaListWid(addPharmaCont.pharmaList).expand()),
                    ),
                  ),
                );
              },
            ),
            // Date Input

            32.height,
            AppButton(
              width: Get.width,
              text: locale.value.save,
              color: appColorSecondary,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
              onTap: () {
                hideKeyboard(context);
                if (addPharmaCont.addPharmaForm.currentState!.validate()) {
                  Get.back(result: addPharmaCont.selectedPharma.value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget pharmaListWid(List<Pharma> list) {
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingItemWidget(
          title: "${list[index].firstName} ${list[index].lastName} ",
          titleTextStyle: primaryTextStyle(size: 14),
          onTap: () async {
            hideKeyboard(context);
            addPharmaCont.selectedPharma(list[index]);
            addPharmaCont.pharmaCont.text = "${list[index].firstName} ${list[index].lastName}";

            log("pharma id ----${addPharmaCont.selectedPharma.value.id}");
            Get.back(result: addPharmaCont.selectedPharma.value);
          },
        );
      },
      separatorBuilder: (context, index) => commonDivider.paddingSymmetric(vertical: 6),
    );
  }
}
