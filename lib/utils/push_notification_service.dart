import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../configs.dart';
import '../main.dart';
import '../screens/appointment/appointment_detail.dart';
import '../screens/appointment/model/appointments_res_model.dart';
import 'app_common.dart';
import 'common_base.dart';
import 'constants.dart';

class PushNotificationService {
// It is assumed that all messages contain a data field with the key 'type'

  static final Set<String> _allowedNotificationHosts = <String>{
    Uri.parse(DOMAIN_URL).host,
    'play.google.com',
    'apps.apple.com',
    'meet.google.com',
    'zoom.us',
  };

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

  Map<String, dynamic> _getAdditionalData(RemoteMessage message) {
    final dynamic rawAdditionalData =
        message.data[FirebaseTopicConst.additionalDataKey];
    if (rawAdditionalData is! String || rawAdditionalData.trim().isEmpty) {
      return const <String, dynamic>{};
    }

    final dynamic decoded = jsonDecode(rawAdditionalData);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);

    return const <String, dynamic>{};
  }

  Future<void> initFirebaseMessaging() async {
    try {
      final NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(
              alert: true, badge: true, sound: true, provisional: true);
      String? token = await FirebaseMessaging.instance.getToken();
      if (!kReleaseMode) {
        log('FCM Token: $token');
      }
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await registerNotificationListeners().then((value) {}).catchError((e) {
          log('------Notification Listener REGISTRATION ERROR-----------');
        });

        FirebaseMessaging.onBackgroundMessage(
            firebaseMessagingBackgroundHandler);

        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
                alert: true, badge: true, sound: true)
            .then((value) {})
            .catchError((e) {
          log('------setForegroundNotificationPresentationOptions ERROR-----------');
        });
      }
    } catch (e) {
      log('------Request Notification Permission ERROR: $e-----------');
    }
  }

  Future<void> registerFCMandTopics() async {
    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken == null) {
        await Future<void>.delayed(const Duration(seconds: 3));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      }
      if (apnsToken == null) return;
    }
    await subScribeToTopic();
  }

  Future<void> subScribeToTopic() async {
    await FirebaseMessaging.instance
        .subscribeToTopic(appNameTopic)
        .whenComplete(() {});

    if (loginUserData.value.userRole.isNotEmpty &&
        loginUserData.value.userRole.first.isNotEmpty) {
      await FirebaseMessaging.instance
          .subscribeToTopic(
              getUserRoleTopic(loginUserData.value.userRole.first))
          .then((value) {});
    }
    await FirebaseMessaging.instance
        .subscribeToTopic(
            "${FirebaseTopicConst.userWithUnderscoreKey}${loginUserData.value.id}")
        .then((value) {});
  }

  Future<void> unsubscribeFirebaseTopic() async {
    await FirebaseMessaging.instance
        .unsubscribeFromTopic(appNameTopic)
        .whenComplete(() {});
    if (loginUserData.value.userRole.isNotEmpty &&
        loginUserData.value.userRole.first.isNotEmpty) {
      await FirebaseMessaging.instance
          .unsubscribeFromTopic(
              getUserRoleTopic(loginUserData.value.userRole.first))
          .whenComplete(() {});
    }
    await FirebaseMessaging.instance
        .unsubscribeFromTopic(
            '${FirebaseTopicConst.userWithUnderscoreKey}${loginUserData.value.id}')
        .whenComplete(() {});
  }

  void handleNotificationClick(RemoteMessage message,
      {bool isForeGround = false}) {
    if (message.data['url'] != null && message.data['url'] is String) {
      _launchSafeNotificationUrl(message.data['url']);
    }
    printLogsNotificationData(message);
    // NotificationData notificationData = NotificationData.fromJson(message.data);
    if (isForeGround) {
      final String title = message.notification?.title ??
          message.data[FirebaseTopicConst.notificationTitleKey]?.toString() ??
          APP_NAME;
      final String body = message.notification?.body ??
          message.data[FirebaseTopicConst.notificationBodyKey]?.toString() ??
          '';

      showNotification(currentTimeStamp(), title, body, message);
    } else {
      try {
        final Map<String, dynamic> additionalData = _getAdditionalData(message);
        if (additionalData.isNotEmpty) {
          final int? notId = _toInt(additionalData['id']);
          if (notId != null) {
            Get.to(
              () => AppointmentDetail(),
              arguments: AppointmentData(id: notId),
            );
          }
        }
      } catch (e) {
        log('${FirebaseTopicConst.notificationErrorKey}: $e');
      }
    }
  }

  Future<void> registerNotificationListeners() async {
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
        if (message != null) {
          handleNotificationClick(message);
        }
      },
      onError: (e) {
        log("${FirebaseTopicConst.onGetInitialMessage} $e");
      },
    );
  }

  Future<void> showNotification(
      int id, String title, String message, RemoteMessage remoteMessage) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    //code for background notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      FirebaseTopicConst.notificationChannelIdKey,
      FirebaseTopicConst.notificationChannelNameKey,
      importance: Importance.high,
      enableLights: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_notification');

    const iOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const macOS = iOS;

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: iOS, macOS: macOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        handleNotificationClick(remoteMessage);
      },
    );

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      FirebaseTopicConst.notificationChannelIdKey,
      FirebaseTopicConst.notificationChannelNameKey,
      importance: Importance.high,
      visibility: NotificationVisibility.public,
      priority: Priority.high,
      icon: '@drawable/ic_stat_notification',
      colorized: true,
    );

    const darwinPlatformChannelSpecifics = DarwinNotificationDetails(
      presentSound: true,
      presentBanner: true,
      presentBadge: true,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
      macOS: darwinPlatformChannelSpecifics,
    );

    flutterLocalNotificationsPlugin.show(
        id, title, message, platformChannelSpecifics);
  }

  void printLogsNotificationData(RemoteMessage message) {}
}
