import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../components/app_shader_widget.dart';
import 'menu.dart';

class BtmNavItem extends StatelessWidget {
  const BtmNavItem({
    super.key,
    required this.navBar,
    required this.press,
    required this.selectedNav,
    this.isLast = false,
    this.isFirst = false,
  });

  final BottomBarItem navBar;
  final VoidCallback press;
  final BottomBarItem selectedNav;
  final bool isLast;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      duration: const Duration(milliseconds: 300),
      height: Get.height * 0.06,
      width: selectedNav == navBar ? (Get.width / 3) : 52,
      decoration: selectedNav == navBar
          ? const BoxDecoration(
              color: appColorPrimary,
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            )
          : null,
      child: selectedNav == navBar
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: AppShaderWidget(
                    color: white,
                    child: Image.asset(
                      navBar.activeIcon,
                    ),
                  ),
                ),
                5.width,
                Marquee(child: Text(navBar.title.value, overflow: TextOverflow.ellipsis, style: primaryTextStyle(color: white, size: 14))).flexible(),
              ],
            ).paddingSymmetric(horizontal: 6)
          : IconButton(
              onPressed: press,
              icon: AppShaderWidget(
                color: white.withValues(alpha: 0.5),
                child: Image.asset(
                  navBar.icon,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                ),
              ),
            ).paddingOnly(left: isFirst ? 8 : 0, right: isLast ? 8 : 0),
    );
  }
}
