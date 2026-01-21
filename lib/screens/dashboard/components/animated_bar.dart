import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
    required this.tabName,
  });

  final bool isActive;
  final String tabName;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      duration: const Duration(milliseconds: 300),
      height: 30,
      width: isActive ? tabName.length * 10 + 16 : 0,
      decoration: const BoxDecoration(
        color: appColorSecondary,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Text(tabName, style: primaryTextStyle(color: white)),
    );
  }
}
