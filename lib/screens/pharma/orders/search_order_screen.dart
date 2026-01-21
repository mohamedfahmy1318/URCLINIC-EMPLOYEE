import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/controller/order_controller.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchOrderWidget extends StatelessWidget {
  final OrderController controller;

  const SearchOrderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller.searchOrderCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.search,
      textStyle: primaryTextStyle(),
      onChanged: (val) {
        controller.isSearchOrderText(val.trim().isNotEmpty);
        controller.getOrders(showLoader: true);
      },
      suffix: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => appCloseIconButton(
              context,
              onPressed: () {
                controller.searchOrderCont.clear();
                controller.isSearchOrderText(false);
                controller.getOrders();
                hideKeyboard(context);
              },
              size: 10,
            ).visible(controller.isSearchOrderText.value),
          ),
        ],
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: locale.value.egMedicines,
        filled: true,
        fillColor: context.cardColor,
        prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 18).paddingAll(14),
      ),
    );
  }
}
