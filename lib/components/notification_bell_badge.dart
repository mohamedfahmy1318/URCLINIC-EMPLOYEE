import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../generated/assets.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import 'cached_image_widget.dart';

/// Bell icon with a live unread-count badge wired to [unreadNotificationCount].
///
/// The whole widget rebuilds inside an `Obx` so the `Positioned` offsets
/// recompute when the count's digit width changes (1 → 2 digits) — without
/// this wrapping, the badge would drift on first render of multi-digit counts.
class NotificationBellBadge extends StatelessWidget {
  const NotificationBellBadge({
    super.key,
    required this.onTap,
    this.iconColor = Colors.white,
    this.iconSize = 24,
    this.badgeColor,
  });

  final VoidCallback onTap;
  final Color iconColor;
  final double iconSize;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Obx(() {
        final int count = unreadNotificationCount.value;
        final String label = count > 99 ? '99+' : count.toString();
        final double digitOffset = -(3 * label.length).toDouble();

        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            CachedImageWidget(
              url: Assets.navigationIcNotifyOutlined,
              color: iconColor,
              height: iconSize,
            ),
            if (count > 0)
              Positioned(
                top: -8 + digitOffset,
                right: -4 + digitOffset,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: boxDecorationDefault(
                    color: badgeColor ?? appColorSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    label,
                    style: secondaryTextStyle(color: white, size: 8),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
