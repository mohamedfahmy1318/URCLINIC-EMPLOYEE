// ignore_for_file: body_might_complete_normally_catch_error

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../components/new_update_dialog.dart';
import '../configs.dart';
import '../generated/assets.dart';
import '../main.dart';
import '../screens/auth/sign_in_sign_up/signin_screen.dart';
import '../screens/clinic/add_clinic_form/model/clinic_session_response.dart';
import 'app_common.dart';
import 'colors.dart';
import 'constants.dart';
import 'local_storage.dart';
import 'package:path/path.dart' as path;

Widget get commonDivider => Column(
      children: [
        Divider(
          height: 1,
          thickness: 1.5,
          color: isDarkMode.value
              ? borderColor.withValues(alpha: 0.1)
              : borderColor.withValues(alpha: 0.5),
        ),
      ],
    );

final fontFamilyWeight700 =
    GoogleFonts.interTight(fontWeight: FontWeight.w700).fontFamily;

Future<void> handleRate() async {
  if (isAndroid) {
    if (appConfigs.value.clinicadminAppUrl.clinicadminAppPlayStore
        .trim()
        .isNotEmpty) {
      commonLaunchUrl(
          appConfigs.value.clinicadminAppUrl.clinicadminAppPlayStore.trim(),
          launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl(
          '${getSocialMediaLink(LinkProvider.PLAY_STORE)}${await getPackageName()}',
          launchMode: LaunchMode.externalApplication);
    }
  } else if (isIOS) {
    if (appConfigs.value.clinicadminAppUrl.clinicadminAppAppStore
        .trim()
        .isNotEmpty) {
      commonLaunchUrl(
          appConfigs.value.clinicadminAppUrl.clinicadminAppAppStore.trim(),
          launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl(APP_APPSTORE_URL,
          launchMode: LaunchMode.externalApplication);
    }
  }
}

void hideKeyBoardWithoutContext() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

void toggleThemeMode({required int themeId}) {
  if (themeId == THEME_MODE_SYSTEM) {
    Get.changeThemeMode(ThemeMode.system);
    isDarkMode(Get.isPlatformDarkMode);
  } else if (themeId == THEME_MODE_LIGHT) {
    Get.changeThemeMode(ThemeMode.light);
    isDarkMode(false);
  } else if (themeId == THEME_MODE_DARK) {
    Get.changeThemeMode(ThemeMode.dark);
    isDarkMode(true);
  }

  setValueToLocal(SettingsLocalConst.THEME_MODE, themeId);
  if (isDarkMode.value) {
    textPrimaryColorGlobal = Colors.white;
    textSecondaryColorGlobal = Colors.white70;
  } else {
    textPrimaryColorGlobal = primaryTextColor;
    textSecondaryColorGlobal = secondaryTextColor;
  }
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
        id: 1,
        name: 'English',
        languageCode: 'en',
        fullLanguageCode: 'en-US',
        flag: Assets.flagsIcUs),
    LanguageDataModel(
        id: 3,
        name: 'Arabic',
        languageCode: 'ar',
        fullLanguageCode: 'ar-AR',
        flag: Assets.flagsIcAr),
  ];
}

Widget appCloseIconButton(BuildContext context,
    {required void Function() onPressed, double size = 12}) {
  return IconButton(
    iconSize: size,
    padding: EdgeInsets.zero,
    onPressed: onPressed,
    icon: Container(
      padding: EdgeInsets.all(size - 8),
      decoration: boxDecorationDefault(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(size - 4),
          border: Border.all(color: iconColor)),
      child: Icon(
        Icons.close_rounded,
        size: size,
        color: iconColor,
      ),
    ),
  );
}

Widget commonLeadingWid(
    {required String imgPath, Color? color, double size = 20}) {
  return Image.asset(
    imgPath,
    width: size,
    height: size,
    color: color,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) => Icon(
      Icons.now_wallpaper_outlined,
      size: size,
      color: color ?? appColorSecondary,
    ),
  );
}

Future<void> commonLaunchUrl(String address,
    {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('${locale.value.invalidUrl}: $address');
  });
}

void viewFiles(String url) {
  if (url.isNotEmpty) {
    commonLaunchUrl(url, launchMode: LaunchMode.externalApplication);
  }
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS) {
      commonLaunchUrl('tel://${url!}',
          launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl('tel:${url!}',
          launchMode: LaunchMode.externalApplication);
    }
  }
}

void launchMap(String? url) {
  if (url.validate().isNotEmpty) {
    final encodedQuery = Uri.encodeComponent(url.validate());
    final String newURL =
        (isIOS ? Constants.mapLinkForIOS : Constants.googleMapPrefix) +
            encodedQuery;
    commonLaunchUrl(newURL, launchMode: LaunchMode.externalApplication);
  }
}

void launchMail(String url) {
  if (url.validate().isNotEmpty) {
    launchUrl(mailTo(to: [url]), mode: LaunchMode.externalApplication);
  }
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

///
/// Date format extension for format datetime in different formats,
/// e.g. 1) dd-MM-yyyy, 2) yyyy-MM-dd, etc...
///
extension DateData on String {
  /// Formats the given [DateTime] object in the [dd-MM-yy] format.
  ///
  /// Returns a string representing the formatted date.
  DateTime get dateInyyyyMMddFormat {
    try {
      return DateFormat(DateFormatConst.yyyy_MM_dd).parse(this);
    } catch (e) {
      return DateTime.now();
    }
  }

  String get dateInMMMMDyyyyFormat {
    try {
      return DateFormat(DateFormatConst.MMMM_D_yyyy)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dateInEEEEDMMMMAtHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.EEEE_D_MMMM_At_HH_mm_a)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dateInDMMMMyyyyFormat {
    try {
      return DateFormat(DateFormatConst.D_MMMM_yyyy)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dateInDMMMyyyyFormat {
    try {
      return DateFormat(DateFormatConst.D_MMM_yyyy)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dayFromDate {
    try {
      return dateInyyyyMMddHHmmFormat.day.toString();
    } catch (e) {
      return "";
    }
  }

  String get monthMMMFormat {
    try {
      return dateInyyyyMMddHHmmFormat.month.toMonthName(isHalfName: true);
    } catch (e) {
      return "";
    }
  }

  String get dateInMMMMDyyyyAtHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.MMMM_D_yyyy_At_HH_mm_a)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  String get dateInddMMMyyyyHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.dd_MMM_y_HH_mm_a)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      try {
        return "$dateInyyyyMMddHHmmFormat";
      } catch (e) {
        return this;
      }
    }
  }

  String get dateInddMMMyyyyAtHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.dd_MMM_yyyy_At_HH_mm_a)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      try {
        return "$dateInyyyyMMddHHmmFormat";
      } catch (e) {
        return this;
      }
    }
  }

  DateTime get dateInyyyyMMddHHmmFormat {
    try {
      return DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm).parse(this);
    } catch (e) {
      try {
        try {
          if (DateTime.parse(this).isUtc) {
            return DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm)
                .parse(DateTime.parse(this).toLocal().toString());
          } else {
            return DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm)
                .parse(DateTime.parse(this).toString());
          }
        } catch (e) {
          log('dateInyyyyMMddHHmmFormat Check isUtc Error in $this: $e');
          return DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm)
              .parse(DateTime.parse(this).toString());
        }
      } catch (e) {
        log('dateInyyyyMMddHHmmFormat Error in $this: $e');
        return DateTime.now();
      }
    }
  }

  DateTime get dateInHHmm24HourFormat {
    return DateFormat(DateFormatConst.HH_mm24Hour).parse(this);
  }

  String get timeInHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.HH_mm12Hour)
          .format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      return this;
    }
  }

  TimeOfDay get timeOfDay24Format {
    return TimeOfDay.fromDateTime(
        DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm).parse(this));
  }

  String get amPMto24HourFormat {
    try {
      final format12 = DateFormat('h:mm a');
      final format24 = DateFormat('HH:mm');
      final time = format12.parse(this);
      return format24.format(time);
    } catch (e) {
      return "";
    }
  }

  String get format24HourtoAMPM {
    try {
      final format12 = DateFormat('h:mm a');
      final format24 = DateFormat('HH:mm');
      final time = format24.parse(this);
      return format12.format(time);
    } catch (e) {
      return "";
    }
  }

  bool get isValidTime {
    return DateTime.tryParse("1970-01-01 $this") != null;
  }

  bool get isValidDateTime {
    return DateTime.tryParse(this) != null;
  }

  bool get isAfterCurrentDateTime {
    return dateInyyyyMMddHHmmFormat.isAfter(DateTime.now());
  }

  bool get isToday {
    try {
      return "$dateInyyyyMMddFormat" == DateTime.now().formatDateYYYYmmdd();
    } catch (e) {
      return false;
    }
  }

  Duration toDuration() {
    final parts = split(':');
    try {
      if (parts.length == 2) {
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        return Duration(hours: hours, minutes: minutes);
      } else {
        return Duration.zero;
      }
    } catch (e) {
      return Duration.zero;
    }
  }

  String toFormattedDuration({bool showFullTitleHoursMinutes = false}) {
    try {
      final duration = toDuration();
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);

      String formattedDuration = '';
      if (hours > 0) {
        formattedDuration +=
            "$hours ${showFullTitleHoursMinutes ? 'hour' : 'hr'} ";
      }
      if (minutes > 0) {
        formattedDuration +=
            '$minutes ${showFullTitleHoursMinutes ? 'minute' : 'min'}';
      }
      return formattedDuration.trim();
    } catch (e) {
      return "";
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    // ignore: unnecessary_this
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String formatPhoneNumber(String phoneCode) {
    final String trimmedPhoneNumber = trim();

    if (trimmedPhoneNumber.startsWith(phoneCode)) {
      return trimmedPhoneNumber;
    } else {
      return '$phoneCode $trimmedPhoneNumber';
    }
  }

  (String, String) get extractPhoneCodeAndNumber {
    // Split the string by spaces and hyphens
    final List<String> parts = trim().split(RegExp(r'[\s-]+'));

    if (parts.length > 1) {
      // Assume the first part is the phone code
      final String phoneCode = parts[0].trim().replaceAll("+", '');
      // Join the remaining parts as the phone number
      final String phoneNumber = parts.sublist(1).join().trim();
      return (phoneCode, phoneNumber);
    } else {
      // If there's no separator, treat the whole string as the number
      return ('', trim());
    }
  }
}

extension DateExtension on DateTime {
  /// Formats the given [DateTime] object in the [dd-MM-yyyy] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateDDMMYYYY() {
    final formatter = DateFormat(DateFormatConst.DD_MM_YYYY);
    return formatter.format(this);
  }

  /// Formats the given [DateTime] object in the [dd-MM-yy] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateDDMMYY() {
    final formatter = DateFormat(DateFormatConst.DD_MM_YY);
    return formatter.format(this);
  }

  /// Formats the given [DateTime] object in the [DateFormatConst.yyyy_MM_dd] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateYYYYmmdd() {
    final formatter = DateFormat(DateFormatConst.yyyy_MM_dd);
    return formatter.format(this);
  }

  /// Formats the given [DateTime] object in the [DateFormatConst.yyyy_MM_dd_HH_mm] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateYYYYmmddHHmm() {
    final formatter = DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm);
    return formatter.format(this);
  }

  /// Formats the given [DateTime] object in the [DateFormatConst.yyyy_MM_dd]+[DateFormatConst.HH_mm12Hour] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateddmmYYYYHHmmAMPM() {
    final formatter = DateFormat(DateFormatConst.DD_MM_YY);
    final timeInAMPM = DateFormat(DateFormatConst.HH_mm12Hour);
    return "${formatter.format(this)} ${timeInAMPM.format(this)}";
  }

  String formatDateddmmYYYY() {
    final formatter = DateFormat(DateFormatConst.DD_MM_YYYY);
    return formatter.format(this);
  }

  /*  /// Formats the given [DateTime] object in the [DateFormatConst.yyyy_MM_dd]+[DateFormatConst.HH_mm_a] format.
  ///
  /// Returns a string representing the formatted date.
  String formatDateddmmYYYYHHmmAMPM() {
    final formatter = DateFormat("dd-MM-yyyy");
    final timeInAMPM = DateFormat(DateFormatConst.HH_mm_a);
    return "${formatter.format(this)} ${timeInAMPM.format(this)}";
  } */

  /// Formats the given [DateTime] object in the [DateFormatConst.HH_mm12Hour] format.
  ///
  /// Returns a string representing the formatted date.
  String formatTimeHHmmAMPM() {
    final formatter = DateFormat(DateFormatConst.HH_mm12Hour);
    return formatter.format(this);
  }

  /// Returns Time Ago
  String get timeAgoWithLocalization => formatTime(millisecondsSinceEpoch);
}

/// Splits a date string in the format "dd/mm/yyyy" into its constituent parts and returns a [DateTime] object.
///
/// If the input string is not a valid date format, this method returns `null`.
///
/// Example usage:
///
/// ```dart
/// DateTime? myDate = getDateTimeFromAboveFormat('27/04/2023');
/// if (myDate != null) {
///   print(myDate); // Output: 2023-04-27 00:00:00.000
/// }
/// ```
///
DateTime? getDateTimeFromAboveFormat(String date) {
  if (date.isValidDateTime) {
    return DateTime.tryParse(date);
  } else {
    final List<String> dateParts = date.split('/');
    if (dateParts.length != 3) {
      // Invalid date format handled
      return null;
    }
    final int day = int.parse(dateParts[0]);
    final int month = int.parse(dateParts[1]);
    final int year = int.parse(dateParts[2]);
    return DateTime.tryParse('$year-$month-$day');
  }
}

extension TimeExtension on TimeOfDay {
  /// Formats the given [TimeOfDay] object in the [DateFormatConst.HH_mm24Hour] format.
  ///
  /// Returns a string representing the formatted time.
  String formatTimeHHmm24Hour() {
    final timeIn24Hour = DateFormat(DateFormatConst.HH_mm24Hour);
    final tempDateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
    return timeIn24Hour.format(tempDateTime);
  }

  /// Formats the given [TimeOfDay] object in the [DateFormatConst.yyyy_MM_dd]+[DateFormatConst.HH_mm12Hour] format.
  ///
  /// Returns a string representing the formatted time.
  String formatTimeHHmmAMPM() {
    final timeInAMPM = DateFormat(DateFormatConst.HH_mm12Hour);
    final tempDateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
    return timeInAMPM.format(tempDateTime);
  }
}

TextStyle get appButtonTextStyleGray =>
    boldTextStyle(color: appColorSecondary, size: 14);

TextStyle get appButtonTextStyleWhite =>
    boldTextStyle(color: Colors.white, size: 14);

TextStyle get appButtonPrimaryColorText =>
    boldTextStyle(color: appColorPrimary);

TextStyle get appButtonFontColorText =>
    boldTextStyle(color: Colors.grey, size: 14);

InputDecoration inputDecoration(
  BuildContext context, {
  Widget? prefixIcon,
  EdgeInsetsGeometry? contentPadding,
  BoxConstraints? prefixIconConstraints,
  BoxConstraints? suffixIconConstraints,
  Widget? suffixIcon,
  String? labelText,
  String? hintText,
  double? borderRadius,
  bool? filled,
  Color? fillColor,
  String? errorText,
  bool isShowLabel = true,
  OutlineInputBorder? border,
}) {
  labelText = isShowLabel ? hintText : null;
  return InputDecoration(
    contentPadding: contentPadding ??
        const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    counterText: "",
    hintText: hintText,
    hintStyle: secondaryTextStyle(size: 12, color: secondaryTextColor),
    labelStyle: secondaryTextStyle(size: 12, color: secondaryTextColor),
    alignLabelWithHint: false,
    prefixIcon: prefixIcon,
    prefixIconConstraints: prefixIconConstraints,
    suffixIcon: suffixIcon,
    suffixIconConstraints: suffixIconConstraints,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius / 2),
      borderSide: const BorderSide(color: borderColor, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius / 2),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius / 2),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    border: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius / 2),
      borderSide: const BorderSide(color: borderColor, width: 0.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius / 2),
      borderSide: const BorderSide(color: borderColor, width: 0.0),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: border ??
        OutlineInputBorder(
          borderRadius: radius(borderRadius ?? defaultRadius / 2),
          borderSide: const BorderSide(color: appColorPrimary, width: 0.0),
        ),
    filled: filled,
    fillColor: fillColor,
    errorText: errorText,
  );
}

InputDecoration inputDecorationWithOutBorder(BuildContext context,
    {Widget? prefixIcon,
    Widget? suffixIcon,
    String? labelText,
    String? hintText,
    double? borderRadius,
    bool? filled,
    Color? fillColor}) {
  return InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    hintText: hintText,
    hintStyle: secondaryTextStyle(size: 12, color: secondaryTextColor),
    labelStyle: secondaryTextStyle(size: 12),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red),
    ),
    errorMaxLines: 2,
    border: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: appColorPrimary, width: 0.0),
    ),
    filled: filled,
    fillColor: fillColor,
  );
}

Future<List<PlatformFile>> pickFiles({FileType type = FileType.any}) async {
  List<PlatformFile> filePath0 = [];
  try {
    final FilePickerResult? filePickerResult =
        await FilePicker.platform.pickFiles(
      type: type,
      withData: true,
      onFileLoading: (FilePickerStatus status) => null,
    );
    if (filePickerResult != null) {
      if (Platform.isAndroid) {
        filePath0 = filePickerResult.files;
      } else {
        final Directory cacheDir = await getTemporaryDirectory();
        for (final PlatformFile file in filePickerResult.files) {
          if (file.bytes != null) {
            final String filePath = '${cacheDir.path}/${file.name}';
            final File cacheFile = File(filePath);
            await cacheFile.writeAsBytes(file.bytes!.toList());
            final PlatformFile cachedFile = PlatformFile(
              path: cacheFile.path,
              name: file.name,
              size: cacheFile.lengthSync(),
              bytes: Uint8List.fromList(cacheFile.readAsBytesSync()),
            );
            filePath0.add(cachedFile);
          }
        }
      }
    }
  } on PlatformException catch (e) {
    log('Unsupported operation$e');
  } catch (e) {
    log(e.toString());
  }
  return filePath0;
}

Widget backButton({Object? result}) {
  return IconButton(
    onPressed: () {
      Get.back(result: result);
    },
    icon: const Icon(Icons.arrow_back_ios_new_outlined,
        color: Colors.grey, size: 20),
  );
}

extension WidgetExt on Widget {
  Container shadow() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: this,
    );
  }

  Container circularLightPrimaryBg({double? padding, Color? color}) {
    return Container(
      padding: EdgeInsets.all(padding ?? 12),
      decoration: boxDecorationDefault(
          shape: BoxShape.circle,
          color: color ??
              (isDarkMode.value
                  ? Colors.grey.withValues(alpha: 0.1)
                  : extraLightPrimaryColor)),
      child: this,
    );
  }

  Widget position({
    bool? expand,
    double? size,
    double? left,
    double? right,
    double? bottom,
    double? top,
    double? height,
    double? width,
    Alignment? alignment,
  }) {
    if (alignment != null) {
      return Align(alignment: alignment, child: this);
    }
    if (expand ?? false) {
      Positioned(
        height: size,
        bottom: bottom,
        right: right,
        left: left,
        top: top,
        width: Get.width,
        child: this,
      );
    }
    return Positioned(
      height: size ?? height,
      width: size ?? width,
      bottom: bottom,
      right: right,
      left: left,
      top: top,
      child: this,
    );
  }
}

extension StrEtx on String {
  String get firstLetter => isNotEmpty ? this[0] : '';

  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 14,
      width: size ?? 14,
      fit: fit ?? BoxFit.cover,
      color: color ?? (isDarkMode.value ? Colors.white : darkGray),
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox();
      },
    );
  }

  Widget showSvg(
      {double? size, Color? color, double? width, double? height, bool? fit}) {
    if (fit ?? false) {
      return SvgPicture.asset(
        this,
        width: size ?? width ?? 35,
        height: size ?? height ?? 35,
      );
    }
    return SvgPicture.asset(
      this,
      width: size ?? width ?? 35,
      height: size ?? height ?? 35,
      fit: BoxFit.cover,
    );
  }

  String get getFileName => path.basename(Uri.parse(this).path);

  String get getFileExtension => path.extension(Uri.parse(this).path);
}

void pickCountry(BuildContext context, {required Function(Country) onSelect}) {
  showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
          textStyle: secondaryTextStyle(), searchTextStyle: primaryTextStyle()),
      showPhoneCode: true,
      onSelect: onSelect);
}

Future<void> showNewUpdateDialog(BuildContext context,
    {required int currentAppVersionCode}) async {
  final bool canClose = (isAndroid &&
          currentAppVersionCode >=
              appConfigs.value.clinicadminAndroidMinForceUpdateCode) ||
      (isIOS &&
          currentAppVersionCode >=
              appConfigs.value.clinicadminIosMinForceUpdateCode);
  showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    barrierDismissible: canClose,
    builder: (_) {
      return PopScope(
        canPop: canClose,
        child: NewUpdateDialog(canClose: canClose),
      );
    },
  );
}

Future<void> showForceUpdateDialog(BuildContext context) async {
  if ((isAndroid &&
          appConfigs.value.isForceUpdateforAndroid &&
          appConfigs.value.clinicadminAndroidLatestVersionUpdateCode >
              currentPackageinfo.value.versionCode.validate().toInt()) ||
      (isIOS &&
          appConfigs.value.isForceUpdateforIos &&
          appConfigs.value.clinicadminIosLatestVersionUpdateCode >
              currentPackageinfo.value.versionCode.validate().toInt())) {
    showNewUpdateDialog(context,
        currentAppVersionCode:
            currentPackageinfo.value.versionCode.validate().toInt());
  }
}

void ifNotTester(VoidCallback callback) {
  if (loginUserData.value.email != Constants.DEFAULT_EMAIL) {
    callback.call();
  } else {
    toast(locale.value.demoUserCannotBeGrantedForThis);
  }
}

Future<void> doIfLoggedIn(VoidCallback callback) async {
  if (isLoggedIn.value) {
    callback.call();
  } else {
    final bool? res = await Get.to(
      () => SignInScreen(),
      binding: BindingsBuilder(() {
        setStatusBarColor(transparentColor,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light);
      }),
    );
    if (res ?? false) {
      callback.call();
    }
  }
}

void launchUrlCustomTab(String? url) {
  if (url.validate().isNotEmpty) {
    launchUrl(Uri.parse(url!));
  }
}

String timeFormate({required String time}) {
  try {
    final DateTime startTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('hh:mm a').format(startTime);
  } catch (e) {
    log('timeFormate err $e');
    return time.isValidTime
        ? "1970-01-01 $time".timeInHHmmAmPmFormat
        : "12:00 AM";
  }
}

bool checkBreakValidationWithShift(
    {required String breakStartTime,
    required String breakEndTime,
    required String shiftStartTime,
    required String shiftEndTime}) {
  return checkBreakValidation(breakStartTime, shiftStartTime, shiftEndTime) &&
      checkBreakValidation(breakEndTime, shiftStartTime, shiftEndTime);
}

bool checkBreakValidation(String breakTime, String startTime, String endTime) {
  final DateFormat formate = DateFormat("HH:mm:ss");
  return formate.parse(breakTime).isAtSameMomentAs(formate.parse(startTime)) ||
      formate.parse(breakTime).isAtSameMomentAs(formate.parse(endTime)) ||
      (formate.parse(breakTime).isAfter(formate.parse(startTime)) &&
          formate.parse(breakTime).isBefore(formate.parse(endTime)));
}

bool checkBreakListValidation(List<BreakListModel> breakListModel,
    String breakStartTime, String breakEndTime, dynamic index, bool isAdd) {
  if (!isAdd) {
    if (breakListModel[index].breakStartTime == breakStartTime &&
        breakListModel[index].breakEndTime == breakEndTime) {
      return true;
    } else {
      return isOutsideBreakTimeList(
          breakListModel, breakStartTime, breakEndTime);
    }
  } else {
    return isOutsideBreakTimeList(breakListModel, breakStartTime, breakEndTime);
  }
}

bool isOutsideBreakTimeList(List<BreakListModel> breakListModel,
    String breakStartTime, String breakEndTime) {
  final DateTime breakStart = DateTime.parse("2024-01-01 $breakStartTime");
  final DateTime breakEnd = DateTime.parse("2024-01-01 $breakEndTime");
  for (final interval in breakListModel) {
    final DateTime startTime =
        DateTime.parse("2024-01-01 ${interval.breakStartTime}");
    final DateTime endTime =
        DateTime.parse("2024-01-01 ${interval.breakEndTime}");
    if ((breakStart.isBefore(startTime) && breakEnd.isBefore(startTime)) ||
        (breakStart.isAfter(endTime) && breakEnd.isAfter(endTime))) {
      continue;
    } else {
      return false;
    }
  }
  return true;
}

/// Routes name to directly navigate the route by its name

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Color getEncounterStatusLightColor({required String encounterStatus}) {
  if (encounterStatus.toLowerCase().contains(EncounterStatus.ACTIVE)) {
    return greenColor.withValues(alpha: 0.1);
  } else if (encounterStatus.toLowerCase().contains(EncounterStatus.CLOSED)) {
    return lightSecondaryColor;
  } else {
    return defaultStatusColor;
  }
}

Color getEncounterStatusColor({required String encounterStatus}) {
  if (encounterStatus.toLowerCase().contains(EncounterStatus.ACTIVE)) {
    return completedStatusColor;
  } else if (encounterStatus.toLowerCase().contains(EncounterStatus.CLOSED)) {
    return pendingStatusColor;
  } else {
    return defaultStatusColor;
  }
}

String getEncounterStatus({required String status}) {
  if (status.toLowerCase().contains(EncounterStatus.ACTIVE)) {
    return 'ACTIVE';
  } else if (status.toLowerCase().contains(EncounterStatus.CLOSED)) {
    return 'CLOSED';
  } else {
    return "";
  }
}

Widget detailWidget({
  CrossAxisAlignment? crossAxisAlignment,
  String? title,
  String? value,
  Color? textColor,
  Widget? leadingWidget,
  Widget? trailingWidget,
  TextStyle? leadingTextStyle,
  TextStyle? trailingTextStyle,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
    children: [
      leadingWidget ??
          Text(title.validate(),
                  style: leadingTextStyle ?? secondaryTextStyle())
              .expand(),
      trailingWidget ??
          Text(value.validate(),
                  textAlign: TextAlign.right,
                  style: trailingTextStyle ??
                      primaryTextStyle(size: 12, color: textColor))
              .expand(),
    ],
  )
      .paddingBottom(10)
      .visible(trailingWidget != null || value.validate().isNotEmpty);
}

String getAppointmentNotification({required String notification}) {
  if (notification.toLowerCase().contains(NotificationConst.newAppointment)) {
    return 'New Appointment Booked';
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.checkoutAppointment)) {
    return 'Appointment Completed';
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.rejectAppointment)) {
    return 'Appointment Rejected';
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.cancelAppointment)) {
    return 'Appointment Cancelled';
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.rescheduleAppointment)) {
    return 'Appointment Rescheduled';
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.acceptAppointment)) {
    return 'Appointment Accepted';
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.changePassword)) {
    return locale.value.changePassword;
  } else if (notification
      .toLowerCase()
      .contains(NotificationConst.forgetEmailPassword)) {
    return 'Forget Email Password';
  } else {
    return "";
  }
}

class ClinicStatus {
  static const open = 'open';
  static const close = 'close';
}

Color getClinicStatusLightColor({required String clinicStatus}) {
  if (clinicStatus.toLowerCase().contains(ClinicStatus.open)) {
    return isDarkMode.value
        ? lightGreenColor.withValues(alpha: 0.1)
        : lightGreenColor;
  } else if (clinicStatus.toLowerCase().contains(ClinicStatus.close)) {
    return isDarkMode.value
        ? lightSecondaryColor.withValues(alpha: 0.1)
        : lightSecondaryColor;
  } else {
    return defaultStatusColor;
  }
}

String getClinicStatus({required String status}) {
  if (status.toLowerCase().contains(ClinicStatus.open)) {
    return locale.value.open;
  } else if (status.toLowerCase().contains(ClinicStatus.close)) {
    return locale.value.close;
  } else {
    return "";
  }
}

//region Bed Styles
BoxDecoration bedStatusDecoration({required Color color, bool isDark = false}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: isDark ? Colors.white12 : Colors.grey.shade300,
    ),
  );
}

TextStyle bedStatusTextStyle({required Color color, double size = 14}) {
  return TextStyle(
    fontSize: size,
    fontWeight: FontWeight.bold,
    color: color,
  );
}

InputDecoration bedInputDecoration({
  required BuildContext context,
  String? labelText,
  Widget? suffixIcon,
  String? hintText,
  double? borderRadius,
}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: context.cardColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      borderSide: BorderSide(color: appColorPrimary),
    ),
  );
}
//endregion

// Bed Management Common Styles
class BedManagementStyles {
  static final bedCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        // ignore: deprecated_member_use
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static final bedStatusTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static final bedNameTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final bedTypeTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey[600],
  );

  static const List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
}
