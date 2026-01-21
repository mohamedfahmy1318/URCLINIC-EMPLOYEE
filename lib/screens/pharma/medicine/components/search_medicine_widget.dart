import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import '../../../../generated/assets.dart';
import '../controller/medicine_list_controller.dart';

class SearchMedicineWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final MedicinesListController medicinesListCont;

  const SearchMedicineWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.medicinesListCont,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: medicinesListCont.searchMedicinesCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (query) {
        final trimmedQuery = query.trim();

        // Update search observable
        medicinesListCont.isSearchMedicinesText(trimmedQuery.isNotEmpty);

        // Reset to first page
        medicinesListCont.medicinePage(1);

        // Clear any selected filters (optional, depends on your UX)
        medicinesListCont.selectedMedicineForm.clear();
        medicinesListCont.selectedMedicineCategory.clear();
        medicinesListCont.selectedMedicineSupplier.clear();

        // Trigger search
        medicinesListCont.searchMedicinesStream.add(trimmedQuery);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            medicinesListCont.searchMedicinesCont.clear();
            medicinesListCont.isSearchMedicinesText(false);
            medicinesListCont.medicinePage(1);
            medicinesListCont.getMedicineList(); // Full list without any search
          },
          size: 11,
        ).visible(medicinesListCont.isSearchMedicinesText.value),
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText ?? locale.value.searchMedicineHere,
        filled: true,
        fillColor: context.cardColor,
        prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 18).paddingAll(14),
      ),
    );
  }
}
