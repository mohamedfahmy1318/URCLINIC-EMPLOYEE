// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';

import '../generated/assets.dart';

class AppDropDownWidget extends StatelessWidget {
  final dynamic selectValue;
  final String? hintText;
  final List<DropdownMenuItem<Object>> items;
  final String? suffixIcon;
  final bool isValidationRequired;
  void Function(dynamic)? onChanged;

  AppDropDownWidget({super.key, required this.selectValue, this.hintText, required this.items, this.isValidationRequired = false, required this.onChanged, this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      padding: EdgeInsets.symmetric(vertical: 8),
      initialValue: selectValue == null || selectValue.toString().isEmpty ? null : selectValue,
      style: primaryTextStyle(size: 12),
      hint: Text(
        hintText.toString(),
        style: primaryTextStyle(size: 12, color: iconColor.withValues(alpha: 0.5)),
      ),
      icon: const Offstage(),
      decoration: InputDecoration(
        fillColor: context.cardColor,
        filled: true,
        suffixIcon:
            suffixIcon == null ? Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: iconColor.withValues(alpha: 0.6)) : commonLeadingWid(imgPath: suffixIcon ?? Assets.iconsIcDropdown, color: iconColor, size: 10).paddingSymmetric(vertical: 16),
        isDense: true,
        // important line,
        contentPadding: const EdgeInsets.only(bottom: 6, left: 12, right: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius(8),
          borderSide: const BorderSide(color: borderColor, width: 0.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius(8),
          borderSide: const BorderSide(color: Colors.red, width: 0.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorMaxLines: 2,
        border: OutlineInputBorder(
          borderRadius: radius(8),
          borderSide: const BorderSide(color: borderColor, width: 0.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: radius(8),
          borderSide: const BorderSide(color: borderColor, width: 0.0),
        ),
        errorStyle: primaryTextStyle(color: Colors.red, size: 12),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius(8),
          borderSide: const BorderSide(color: appColorPrimary, width: 0.0),
        ),
      ),
      items: items,
      validator: !isValidationRequired
          ? (value) {
              return null;
            }
          : (value) => value == null ? 'This field is required' : null,
      onChanged: onChanged,
    );
  }
}
