import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../screens/appointment/appointment_detail.dart';
import '../screens/appointment/model/appointments_res_model.dart';
import 'app_common.dart';
import 'common_base.dart';
import 'constants.dart';

class PushNotificationService {
// It is assumed that all messages contain a data field with the key 'type'

  Future<void> initFirebaseMessaging() async {
    try {
      final NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, provisional: true);
      String? token = await FirebaseMessaging.instance.getToken();
      log("✅ FCM Token: $token");
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await registerNotificationListeners().then((value) {}).catchError((e) {
          log('------Notification Listener REGISTRATION ERROR-----------');
        });

        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

        await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true).then((value) {}).catchError((e) {
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
      if (apnsToken != null) {
        subScribeToTopic();
      } else {
        Future.delayed(const Duration(seconds: 3), () async {
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          if (apnsToken != null) {
            subScribeToTopic();
          }
        });
      }
    }
    FirebaseMessaging.instance.getToken().then((token) {});
    subScribeToTopic();
  }

  Future<void> subScribeToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic(appNameTopic).whenComplete(() {});

    if (loginUserData.value.userRole.isNotEmpty && loginUserData.value.userRole.first.isNotEmpty) {
      await FirebaseMessaging.instance.subscribeToTopic(getUserRoleTopic(loginUserData.value.userRole.first)).then((value) {});
    }
    await FirebaseMessaging.instance.subscribeToTopic("${FirebaseTopicConst.userWithUnderscoreKey}${loginUserData.value.id}").then((value) {});
  }

  Future<void> unsubscribeFirebaseTopic() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(appNameTopic).whenComplete(() {});
    if (loginUserData.value.userRole.isNotEmpty && loginUserData.value.userRole.first.isNotEmpty) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(getUserRoleTopic(loginUserData.value.userRole.first)).whenComplete(() {});
    }
    await FirebaseMessaging.instance.unsubscribeFromTopic('${FirebaseTopicConst.userWithUnderscoreKey}${loginUserData.value.id}').whenComplete(() {});
  }

  void handleNotificationClick(RemoteMessage message, {bool isForeGround = false}) {
    if (message.data['url'] != null && message.data['url'] is String) {
      commonLaunchUrl(message.data['url'], launchMode: LaunchMode.externalApplication);
    }
    printLogsNotificationData(message);
    // NotificationData notificationData = NotificationData.fromJson(message.data);
    if (isForeGround) {
      showNotification(currentTimeStamp(), message.notification!.title.validate(), message.notification!.body.validate(), message);
    } else {
      try {
        final Map<String, dynamic> additionalData = jsonDecode(message.data[FirebaseTopicConst.additionalDataKey]) ?? {};
        if (additionalData.isNotEmpty) {
          final int? notId = additionalData["id"];
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

  Future<void> showNotification(int id, String title, String message, RemoteMessage remoteMessage) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //code for background notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      FirebaseTopicConst.notificationChannelIdKey,
      FirebaseTopicConst.notificationChannelNameKey,
      importance: Importance.high,
      enableLights: true,
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_stat_notification');

    const iOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const macOS = iOS;

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: iOS, macOS: macOS);
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

    flutterLocalNotificationsPlugin.show(id, title, message, platformChannelSpecifics);
  }

  void printLogsNotificationData(RemoteMessage message) {}
}
