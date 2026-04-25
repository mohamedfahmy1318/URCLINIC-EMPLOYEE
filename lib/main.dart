import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/locale/language_en.dart';
import 'app_theme.dart';
import 'configs.dart';
import 'firebase_options.dart';
import 'locale/app_localizations.dart';
import 'locale/languages.dart';
import 'screens/splash_screen.dart';
import 'utils/app_common.dart';
import 'utils/colors.dart';
import 'utils/common_base.dart';
import 'utils/constants.dart';
import 'utils/local_storage.dart';
import 'utils/notification_controller.dart';
import 'utils/push_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    final dynamic raw =
        message.data['unreadCount'] ?? message.data['unread_count'];
    final int parsed =
        raw is int ? raw : int.tryParse(raw?.toString() ?? '') ?? -1;

    if (parsed >= 0) {
      await GetStorage.init();
      await GetStorage()
          .write(NotificationController.pendingUnreadStorageKey, parsed);

      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        try {
          if (await AppBadgePlus.isSupported()) {
            await AppBadgePlus.updateBadge(parsed < 0 ? 0 : parsed);
          }
        } catch (_) {
          // Method channel may be unavailable in the bg isolate on some OEMs.
        }
      }
    }
  } catch (e) {
    if (!kReleaseMode) log('bg handler error: $e');
  }

  if (!kReleaseMode) {
    final RemoteNotification? notification = message.notification;
    log('${FirebaseTopicConst.notificationDataKey}: ${message.data}');
    log('${FirebaseTopicConst.notificationKey} -->: $notification');
    log('${FirebaseTopicConst.notificationTitleKey} -->: ${notification?.title ?? ''}');
    log('${FirebaseTopicConst.notificationBodyKey} -->: ${notification?.body ?? ''}');
  }
}

Rx<BaseLanguage> locale = Rx<BaseLanguage>(LanguageEn());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    Get.put(NotificationController(), permanent: true);
    await PushNotificationService().setupFirebaseMessaging();
    if (kReleaseMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
    }
  } catch (e) {
    if (!kReleaseMode) log('Firebase init error: $e');
  }
  //
  fontFamilyPrimaryGlobal =
      GoogleFonts.interTight(fontWeight: FontWeight.w500).fontFamily;
  textPrimarySizeGlobal = 14;
  fontFamilySecondaryGlobal =
      GoogleFonts.interTight(fontWeight: FontWeight.w400).fontFamily;
  textSecondarySizeGlobal = 12;
  fontFamilyBoldGlobal =
      GoogleFonts.interTight(fontWeight: FontWeight.w600).fontFamily;
  //
  defaultBlurRadius = 0;
  defaultRadius = 12;
  defaultSpreadRadius = 0;
  appButtonBackgroundColorGlobal = appColorPrimary;
  defaultAppButtonRadius = defaultRadius;
  defaultAppButtonElevation = 0;
  defaultAppButtonTextColorGlobal = Colors.white;
  //minimum passoword length validation
  passwordLengthGlobal = 8;

  selectedLanguageCode(
      getValueFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);

  await initialize(
      aLocaleLanguageList: languageList(),
      defaultLanguage: selectedLanguageCode.value);

  locale.value =
      await const AppLocalizations().load(Locale(selectedLanguageCode.value));

  try {
    final getThemeFromLocal = getValueFromLocal(SettingsLocalConst.THEME_MODE);
    if (getThemeFromLocal is int) {
      toggleThemeMode(themeId: getThemeFromLocal);
    } else {
      toggleThemeMode(themeId: THEME_MODE_LIGHT);
    }
  } catch (e) {
    log('getThemeFromLocal from cache E: $e');
  }

  if (!kReleaseMode) {
    HttpOverrides.global = MyHttpOverrides();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
      child: Obx(
        () => GetMaterialApp(
          navigatorKey: navigatorKey,
          title: APP_NAME,
          debugShowCheckedModeBanner: false,
          supportedLocales: LanguageDataModel.languageLocales(),
          localizationsDelegates: const [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
          localeResolutionCallback: (locale, supportedLocales) =>
              Locale(selectedLanguageCode.value),
          fallbackLocale: const Locale(DEFAULT_LANGUAGE),
          locale: Locale(selectedLanguageCode.value),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          initialBinding: BindingsBuilder(() {
            //initialBinding logic
            setStatusBarColor(transparentColor);
          }),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
