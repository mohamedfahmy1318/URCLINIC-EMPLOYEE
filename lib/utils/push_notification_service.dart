import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../configs.dart';
import '../screens/appointment/appointment_detail.dart';
import '../screens/appointment/model/appointments_res_model.dart';
import 'app_common.dart';
import 'common_base.dart';
import 'constants.dart';
import 'notification_controller.dart';

class PushNotificationService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Set<String> _handledMessageIds = <String>{};
  StreamSubscription<String>? _tokenRefreshSubscription;

  bool _listenersRegistered = false;
  bool _localNotificationsInitialized = false;

  static final Set<String> _allowedNotificationHosts = <String>{
    Uri.parse(DOMAIN_URL).host,
    'play.google.com',
    'apps.apple.com',
    'meet.google.com',
    'zoom.us',
  };

  Future<void> setupFirebaseMessaging() async {
    await _initializeLocalNotifications();
    await _requestAndroidPostNotifications();
    await initFirebaseMessaging();
    await enableIOSNotifications();
  }

  bool _isSafeNotificationUrl(String rawUrl) {
    final String value = rawUrl.trim();
    final Uri? uri = Uri.tryParse(value);

    if (uri == null) return false;
    if (uri.scheme != 'https') return false;
    if (uri.host.trim().isEmpty) return false;

    final String host = uri.host.toLowerCase();
    return _allowedNotificationHosts.any((allowedHost) {
      final String normalizedAllowedHost = allowedHost.toLowerCase();
      return host == normalizedAllowedHost ||
          host.endsWith('.$normalizedAllowedHost');
    });
  }

  void _launchSafeNotificationUrl(String rawUrl) {
    if (_isSafeNotificationUrl(rawUrl)) {
      commonLaunchUrl(rawUrl, launchMode: LaunchMode.externalApplication);
      return;
    }

    log('Blocked unsafe notification URL: $rawUrl');
  }

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value == null) return null;
    return int.tryParse(value.toString());
  }

  /// Merges flat payload keys with the legacy nested `additional_data`
  /// blob (which may arrive as a JSON string OR a Map). Flat keys always win.
  Map<String, dynamic> _resolvePayload(Map<String, dynamic> data) {
    final Map<String, dynamic> merged = <String, dynamic>{};

    final dynamic additionalRaw = data[FirebaseTopicConst.additionalDataKey];
    if (additionalRaw is String && additionalRaw.trim().isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(additionalRaw);
        if (decoded is Map) merged.addAll(Map<String, dynamic>.from(decoded));
      } catch (_) {
        // Malformed nested payload — flat keys still take precedence.
      }
    } else if (additionalRaw is Map) {
      merged.addAll(Map<String, dynamic>.from(additionalRaw));
    }

    data.forEach((String key, dynamic value) {
      if (value == null) return;
      if (value is String && value.isEmpty) return;
      merged[key] = value;
    });

    return merged;
  }

  /// Routes a tap on a notification payload to the right screen.
  ///
  /// Payload contract:
  ///   data.type : one of [NotificationConst] (string)
  ///   data.id   : resource id the notification refers to (stringified int)
  ///
  /// Flat keys win; falls back to the legacy nested `additional_data` JSON
  /// blob. Unknown / malformed payloads are logged so backend drift is
  /// visible in production traces instead of silently swallowed.
  void _routeByPayload(Map<String, dynamic> data) {
    Map<String, dynamic> resolved;
    try {
      resolved = _resolvePayload(data);
    } catch (e) {
      log('${FirebaseTopicConst.notificationErrorKey}: parse failed: $e');
      return;
    }

    final String type =
        (resolved[NotificationConst.typeKey]?.toString() ?? '').trim();
    final int? id = _toInt(resolved[FirebaseTopicConst.idKey]);

    if (type.isEmpty && id == null) {
      log('notification: empty payload — $data');
      return;
    }

    if (NotificationConst.appointmentDetailTypes.contains(type) ||
        (type.isEmpty && id != null)) {
      if (id == null) {
        log('notification: missing id for type=$type');
        return;
      }
      Get.to(
        () => AppointmentDetail(),
        arguments: AppointmentData(id: id),
      );
      return;
    }

    log('notification: unrouted type="$type" id=$id payload=$data');
  }

  Future<void> _requestAndroidPostNotifications() async {
    if (!Platform.isAndroid) return;
    try {
      final PermissionStatus status = await Permission.notification.status;
      if (status.isDenied) {
        await Permission.notification.request();
      }
    } catch (e) {
      if (!kReleaseMode) log('POST_NOTIFICATIONS request failed: $e');
    }
  }

  Future<void> initFirebaseMessaging() async {
    NotificationSettings settings;
    try {
      settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: Platform.isIOS,
      );
    } catch (e) {
      if (!kReleaseMode) log('requestPermission failed: $e');
      return;
    }

    final bool canHandleNotifications =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;

    if (!canHandleNotifications) return;

    await registerNotificationListeners();
  }

  Future<void> enableIOSNotifications() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      if (!kReleaseMode) log('setForegroundNotificationPresentationOptions: $e');
    }
  }

  Future<void> registerFCMandTopics() async {
    if (!isLoggedIn.value) return;

    if (Platform.isIOS) {
      final String? apnsToken = await _awaitApnsToken();
      if (apnsToken == null) return;
    }
    await subScribeToTopic();

    final String? token = await FirebaseMessaging.instance.getToken();
    if (!kReleaseMode) {
      log('FCM Token available: ${token != null}');
    }

    _tokenRefreshSubscription ??=
        FirebaseMessaging.instance.onTokenRefresh.listen((_) async {
      await subScribeToTopic();
    });
  }

  Future<String?> _awaitApnsToken() async {
    if (!Platform.isIOS) return null;
    // Escalating backoff: APNs registration on first launch can take 5–10s on
    // flaky networks or in Low Power Mode — a single retry isn't enough.
    const List<Duration> delays = <Duration>[
      Duration.zero,
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
      Duration(seconds: 5),
    ];
    for (final Duration delay in delays) {
      if (delay > Duration.zero) {
        await Future<void>.delayed(delay);
      }
      final String? token = await FirebaseMessaging.instance.getAPNSToken();
      if (token != null && token.isNotEmpty) return token;
    }
    return null;
  }

  Future<void> subScribeToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic(appNameTopic);

    if (loginUserData.value.userRole.isNotEmpty &&
        loginUserData.value.userRole.first.isNotEmpty) {
      await FirebaseMessaging.instance.subscribeToTopic(
          getUserRoleTopic(loginUserData.value.userRole.first));
    }
    if (loginUserData.value.id > 0) {
      await FirebaseMessaging.instance.subscribeToTopic(
          "${FirebaseTopicConst.userWithUnderscoreKey}${loginUserData.value.id}");
    }
  }

  Future<void> unsubscribeFirebaseTopic() async {
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;

    await FirebaseMessaging.instance.unsubscribeFromTopic(appNameTopic);
    if (loginUserData.value.userRole.isNotEmpty &&
        loginUserData.value.userRole.first.isNotEmpty) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(
          getUserRoleTopic(loginUserData.value.userRole.first));
    }
    if (loginUserData.value.id > 0) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(
          '${FirebaseTopicConst.userWithUnderscoreKey}${loginUserData.value.id}');
    }
  }

  void handleNotificationClick(RemoteMessage message,
      {bool isForeGround = false}) {
    final String messageId =
        message.messageId ?? message.data['message_id']?.toString() ?? '';

    if (messageId.isNotEmpty && _handledMessageIds.contains(messageId)) {
      return;
    }

    if (messageId.isNotEmpty) {
      _handledMessageIds.add(messageId);
      if (_handledMessageIds.length > 300) {
        _handledMessageIds.remove(_handledMessageIds.first);
      }
    }

    final dynamic rawUrl = message.data['url'];
    if (rawUrl is String && rawUrl.trim().isNotEmpty) {
      _launchSafeNotificationUrl(rawUrl);
    }

    printLogsNotificationData(message);
    _applyServerUnreadCount(message.data);

    if (isForeGround) {
      final String title = message.notification?.title ??
          message.data[FirebaseTopicConst.notificationTitleKey]?.toString() ??
          APP_NAME;
      final String body = message.notification?.body ??
          message.data[FirebaseTopicConst.notificationBodyKey]?.toString() ??
          '';

      if (title.isNotEmpty || body.isNotEmpty) {
        showNotification(currentTimeStamp(), title, body, message);
      }
      return;
    }

    _routeByPayload(message.data);
  }

  Future<void> registerNotificationListeners() async {
    if (_listenersRegistered) return;

    _listenersRegistered = true;

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        handleNotificationClick(message, isForeGround: true);
      },
      onError: (e) {
        log("${FirebaseTopicConst.onMessageListen} $e");
      },
    );

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        handleNotificationClick(message);
      },
      onError: (e) {
        log("${FirebaseTopicConst.onMessageOpened} $e");
      },
    );

    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message == null) return;
        // The callback can fire before GetMaterialApp mounts its navigator
        // (fast on M-series). Defer to the first frame so Get.to resolves.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          handleNotificationClick(message);
        });
      },
      onError: (e) {
        log("${FirebaseTopicConst.onGetInitialMessage} $e");
      },
    );
  }

  Future<void> _initializeLocalNotifications() async {
    if (_localNotificationsInitialized) return;

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      FirebaseTopicConst.notificationChannelIdKey,
      FirebaseTopicConst.notificationChannelNameKey,
      importance: Importance.high,
      enableLights: true,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_notification');

    const DarwinInitializationSettings iOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: iOS,
      macOS: iOS,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final String? payload = details.payload;
        if (payload == null || payload.trim().isEmpty) return;

        try {
          final dynamic decoded = jsonDecode(payload);
          if (decoded is Map) {
            _routeByPayload(Map<String, dynamic>.from(decoded));
          }
        } catch (_) {
          // Ignore malformed payloads.
        }
      },
    );

    _localNotificationsInitialized = true;
  }

  Future<void> showNotification(
    int id,
    String title,
    String message,
    RemoteMessage remoteMessage,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      FirebaseTopicConst.notificationChannelIdKey,
      FirebaseTopicConst.notificationChannelNameKey,
      importance: Importance.high,
      visibility: NotificationVisibility.public,
      priority: Priority.high,
      icon: '@drawable/ic_stat_notification',
      colorized: true,
    );

    const DarwinNotificationDetails darwinPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentSound: true,
      presentBanner: true,
      presentBadge: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
      macOS: darwinPlatformChannelSpecifics,
    );

    await _localNotificationsPlugin.show(
      id,
      title,
      message,
      platformChannelSpecifics,
      payload: jsonEncode(remoteMessage.data),
    );
  }

  void printLogsNotificationData(RemoteMessage message) {
    if (kReleaseMode) return;
    log("====================");
    log('${FirebaseTopicConst.notificationDataKey} keys: ${message.data.keys.toList()}');
    log('${FirebaseTopicConst.notificationTitleKey} available: ${message.notification?.title != null}');
    log('${FirebaseTopicConst.notificationBodyKey} available: ${message.notification?.body != null}');
    log('${FirebaseTopicConst.messageDataMessageIdKey} : ${message.messageId}');
  }

  void _applyServerUnreadCount(Map<String, dynamic> data) {
    try {
      if (!Get.isRegistered<NotificationController>()) return;
      final dynamic raw = data[NotificationConst.unreadCountCamelKey] ??
          data[NotificationConst.unreadCountKey];
      if (raw == null) {
        NotificationController.to.incrementLocal();
        return;
      }
      final int parsed = raw is int ? raw : int.tryParse(raw.toString()) ?? -1;
      if (parsed >= 0) {
        NotificationController.to.applyServerUnreadCount(parsed);
      }
    } catch (_) {
      // Never let badge plumbing break notification routing.
    }
  }
}
