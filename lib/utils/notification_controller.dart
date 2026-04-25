import 'dart:async';
import 'dart:io';

import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

import '../api/core_apis.dart';
import 'app_common.dart';

/// Owns the unread-notification badge lifecycle.
///
/// State lives on the global `unreadNotificationCount` so the bell widget,
/// FCM handlers, and badge plugin all read/write a single Rx. Anything that
/// changes unread count must go through this controller — direct writes to
/// `unreadNotificationCount` will desync the badge.
class NotificationController extends GetxController {
  static NotificationController get to => Get.find<NotificationController>();

  static const String pendingUnreadStorageKey = 'pending_unread_count';

  Worker? _badgeWatcher;

  @override
  void onInit() {
    super.onInit();
    _badgeWatcher = ever<int>(unreadNotificationCount, _writeBadge);
    _drainPendingFromBackground();
  }

  @override
  void onClose() {
    _badgeWatcher?.dispose();
    _badgeWatcher = null;
    super.onClose();
  }

  Future<void> fetchUnreadCount() async {
    try {
      final int remote = await CoreServiceApis.getUnreadNotificationCount();
      unreadNotificationCount.value = remote < 0 ? 0 : remote;
    } catch (e) {
      if (kDebugMode) log('fetchUnreadCount failed: $e');
    }
  }

  void applyServerUnreadCount(int count) {
    if (count < 0) return;
    unreadNotificationCount.value = count;
  }

  void incrementLocal() {
    unreadNotificationCount.value = unreadNotificationCount.value + 1;
  }

  Future<void> markAllRead() async {
    unreadNotificationCount.value = 0;
  }

  Future<void> markAsRead(int notificationId) async {
    final int previous = unreadNotificationCount.value;
    unreadNotificationCount.value = (previous - 1).clamp(0, 1 << 31);
    try {
      await CoreServiceApis.markNotificationAsRead(notificationId);
    } catch (e) {
      if (kDebugMode) log('markAsRead($notificationId) failed: $e');
      unawaited(fetchUnreadCount());
    }
  }

  void _drainPendingFromBackground() {
    final dynamic raw = GetStorage().read(pendingUnreadStorageKey);
    final int pending =
        raw is int ? raw : int.tryParse(raw?.toString() ?? '') ?? 0;
    if (pending > 0) {
      unreadNotificationCount.value = pending;
      GetStorage().remove(pendingUnreadStorageKey);
    }
  }

  Future<void> _writeBadge(int count) async {
    if (!Platform.isAndroid) return;
    try {
      final bool supported = await AppBadgePlus.isSupported();
      if (!supported) return;
      await AppBadgePlus.updateBadge(count < 0 ? 0 : count);
    } catch (e) {
      if (kDebugMode) log('badge update failed: $e');
    }
  }
}
