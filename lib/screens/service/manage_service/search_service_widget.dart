import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import '../all_service_list_controller.dart';

class SearchServiceWidget extends StatelessWidget {
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final Function()? onClearButton;
  final AllServicesController allServicesCont;

  const SearchServiceWidget({
    super.key,
    this.hintText,
    this.onTap,
    this.onFieldSubmitted,
    this.onClearButton,
    required this.allServicesCont,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: allServicesCont.searchServiceCont,
      textFieldType: TextFieldType.OTHER,
      textInputAction: TextInputAction.done,
      textStyle: primaryTextStyle(),
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (p0) {
        allServicesCont.isSearchServiceText(allServicesCont.searchServiceCont.text.trim().isNotEmpty);
        allServicesCont.searchServiceStream.add(p0);
      },
      suffix: Obx(
        () => appCloseIconButton(
          context,
          onPressed: () {
            if (onClearButton != null) {
              onClearButton!.call();
            }
            hideKeyboard(context);
            allServicesCont.searchServiceCont.clear();
            allServicesCont.isSearchServiceText(allServicesCont.searchServiceCont.text.trim().isNotEmpty);
            allServicesCont.page(1);
            allServicesCont.getAllServices();
          },
          size: 11,
        ).visible(allServicesCont.isSearchServiceText.value),
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
