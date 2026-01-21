import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../components/app_drop_dowm_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import '../model/request_type_model.dart';
import '../request_list_screen_controller.dart';

class AddRequestComponent extends StatelessWidget {
  AddRequestComponent({super.key});
  final RequestListController reqListCont = Get.put(RequestListController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: boxDecorationDefault(
        color: context.cardColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      ),
      child: Obx(
        () => Form(
          key: reqListCont.addReqFormKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  2.height,
                  Row(
                    children: [
                      Text(locale.value.addRequest, style: secondaryTextStyle(size: 16, weight: FontWeight.w600, color: isDarkMode.value ? whiteTextColor : darkGrayTextColor)).expand(),
                    ],
                  ),
                  16.height,
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: reqListCont.nameCont,
                    textFieldType: TextFieldType.NAME,
                    inputFormatters: [LengthLimitingTextInputFormatter(100)],
                    decoration: inputDecoration(
                      context,
                      fillColor: context.cardColor,
                      filled: true,
                      hintText: locale.value.name,
                    ),
                    suffix: commonLeadingWid(imgPath: Assets.iconsIcTextIcon, color: secondaryTextColor, size: 12).paddingAll(16),
                  ),
                  16.height,
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: reqListCont.descCont,
                    textFieldType: TextFieldType.NAME,
                    inputFormatters: [LengthLimitingTextInputFormatter(190)],
                    decoration: inputDecoration(
                      context,
                      fillColor: context.cardColor,
                      filled: true,
                      hintText: locale.value.description,
                    ),
                    suffix: commonLeadingWid(imgPath: Assets.iconsIcDollar, color: secondaryTextColor, size: 12).paddingAll(16),
                  ),
                  16.height,
                  AppDropDownWidget(
                    selectValue: reqListCont.selectedType.value.id > 0
                        ? reqListCont.selectedType.value
                        : requestTypeList.isNotEmpty
                            ? requestTypeList.first
                            : null,
                    onChanged: (value) {
                      if (value is RequestType) {
                        reqListCont.selectedType(value);
                      }
                    },
                    items: requestTypeList.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item.name),
                      );
                    }).toList(),
                    hintText: locale.value.selectType,
                  ),
                  32.height,
                  AppButton(
                    width: Get.width,
                    text: locale.value.save,
                    color: appColorSecondary,
                    textStyle: appButtonTextStyleWhite,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                    onTap: () {
                      if (reqListCont.addReqFormKey.currentState!.validate()) {
                        hideKeyboard(context);
                        reqListCont.addRequest();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
