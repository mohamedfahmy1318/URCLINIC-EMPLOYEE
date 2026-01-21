import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../generated/assets.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import 'billing_service_list_controller.dart';

class BilligSearchServiceWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final BillingServicesController billingServicesController;

  const BilligSearchServiceWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.billingServicesController,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: billingServicesController.searchServiceCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        billingServicesController.isSearchServiceText(billingServicesController.searchServiceCont.text.trim().isNotEmpty);
        billingServicesController.searchServiceStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            billingServicesController.searchServiceCont.clear();
            billingServicesController.isSearchServiceText(billingServicesController.searchServiceCont.text.trim().isNotEmpty);
            billingServicesController.page(1);
            billingServicesController.getAllServices();
          },
          size: 11,
        ).visible(billingServicesController.isSearchServiceText.value),
      ),
      decoration: inputDecorationWithOutBorder(
        context,
        hintText: hintText ?? locale.value.searchHere,
        filled: true,
        fillColor: context.cardColor,
        prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcSearch, size: 18).paddingAll(14),
      ),
    );
  }
}
