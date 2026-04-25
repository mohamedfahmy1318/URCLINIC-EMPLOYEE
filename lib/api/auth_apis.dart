import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import '../models/base_response_model.dart';
import '../network/network_utils.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';
import '../utils/local_storage.dart';
import '../utils/secure_storage_helper.dart';
import '../screens/auth/model/about_page_res.dart';
import '../screens/auth/model/app_configuration_res.dart';
import '../screens/auth/model/change_password_res.dart';
import '../screens/auth/model/login_response.dart';
import '../screens/auth/model/notification_model.dart';
import '../utils/push_notification_service.dart';

class AuthServiceApis {
  static Future<UserResponse> createUser({required Map request}) async {
    return UserResponse.fromJson(await handleResponse(await buildHttpResponse(
        APIEndPoints.register,
        request: request,
        method: HttpMethodType.POST)));
  }

  static Future<UserResponse> loginUser(
      {required Map request, bool isSocialLogin = false}) async {
    return UserResponse.fromJson(await handleResponse(await buildHttpResponse(
        isSocialLogin ? APIEndPoints.socialLogin : APIEndPoints.login,
        request: request,
        method: HttpMethodType.POST)));
  }

  static Future<ChangePassRes> changePasswordAPI({required Map request}) async {
    return ChangePassRes.fromJson(await handleResponse(await buildHttpResponse(
        APIEndPoints.changePassword,
        request: request,
        method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> forgotPasswordAPI(
      {required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.forgotPassword,
            request: request, method: HttpMethodType.POST)));
  }

  static Future<List<NotificationData>> getNotificationDetail({
    int page = 1,
    int perPage = 10,
    bool isReadAll = false,
    required List<NotificationData> notifications,
    Function(bool)? lastPageCallBack,
  }) async {
    if (isLoggedIn.value) {
      String readAll = isReadAll ? '&type=mark_as_read' : '';
      final notificationRes = NotificationRes.fromJson(await handleResponse(
          await buildHttpResponse(
              "${APIEndPoints.getNotification}?per_page=$perPage&page=$page$readAll")));
      if (page == 1) notifications.clear();
      notifications.addAll(notificationRes.notificationData);
      lastPageCallBack
          ?.call(notificationRes.notificationData.length != perPage);
      return notifications;
    } else {
      return [];
    }
  }

  static Future<NotificationData> clearAllNotification() async {
    return NotificationData.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.clearAllNotification)));
  }

  static Future<NotificationData> removeNotification(
      {required String notificationId}) async {
    return NotificationData.fromJson(await handleResponse(
        await buildHttpResponse(
            '${APIEndPoints.removeNotification}?id=$notificationId')));
  }

  static Future<void> clearData({bool isFromDeleteAcc = false}) async {
    GoogleSignIn.instance.signOut();
    await PushNotificationService().unsubscribeFirebaseTopic();
    if (isFromDeleteAcc) {
      localStorage.erase();
      removeValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
      await SecureStorageHelper.clearUserPassword();
      isLoggedIn(false);
      loginUserData(UserData());
    } else {
      final tempEmail = loginUserData.value.email;
      final tempPASSWORD = await SecureStorageHelper.getUserPassword();
      final tempIsRemeberMe =
          getValueFromLocal(SharedPreferenceConst.IS_REMEMBER_ME);
      final tempTheme = getValueFromLocal(SettingsLocalConst.THEME_MODE);
      final tempLang = getValueFromLocal(SELECTED_LANGUAGE_CODE);
      final tempUserName = loginUserData.value.userName;

      localStorage.erase();
      isLoggedIn(false);
      loginUserData(UserData());
      selectedAppClinic(ClinicData());
      selectedAppCommission([]);

      setValueToLocal(SharedPreferenceConst.FIRST_TIME, true);
      setValueToLocal(SharedPreferenceConst.USER_EMAIL, tempEmail);
      setValueToLocal(SharedPreferenceConst.USER_NAME, tempUserName);
      setValueToLocal(SettingsLocalConst.THEME_MODE, tempTheme);
      setValueToLocal(SELECTED_LANGUAGE_CODE, tempLang);

      removeValueFromLocal(SharedPreferenceConst.USER_PASSWORD);

      if (tempIsRemeberMe is bool &&
          tempIsRemeberMe &&
          tempPASSWORD.isNotEmpty) {
        await SecureStorageHelper.saveUserPassword(tempPASSWORD);
      } else {
        await SecureStorageHelper.clearUserPassword();
      }
      if (tempIsRemeberMe is bool) {
        setValueToLocal(SharedPreferenceConst.IS_REMEMBER_ME, tempIsRemeberMe);
      }
    }
  }

  static Future<BaseResponseModel> logoutApi() async {
    return BaseResponseModel.fromJson(
        await handleResponse(await buildHttpResponse(APIEndPoints.logout)));
  }

  static Future<BaseResponseModel> deleteAccountCompletely() async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.deleteUserAccount,
            request: {}, method: HttpMethodType.POST)));
  }

  static Future<ConfigurationResponse> getAppConfigurations() async {
    final response = await handleResponse(await buildHttpResponse(
      '${APIEndPoints.appConfiguration}?is_authenticated=${(getValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN) == true).getIntBool()}',
      request: {},
    ));
    final config = ConfigurationResponse.fromJson(response);
    setValueToLocal(SELECTED_LANGUAGE_CODE, config.applicationLanguage);
    return config;
  }

  static Future<UserResponse> viewProfile({int? id}) async {
    final res = UserResponse.fromJson(await handleResponse(
        await buildHttpResponse(
            '${APIEndPoints.userDetail}?id=${id ?? loginUserData.value.id}')));
    return res;
  }

  static Future<dynamic> updateProfile({
    File? imageFile,
    String firstName = '',
    String lastName = '',
    String email = '',
    String mobile = '',
    String address = '',
    String gender = '',
    String playerId = '',
    String dateOfBirth = '',
    String country = '',
    String state = '',
    String city = '',
    String pinCode = '',
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      final MultipartRequest multiPartRequest =
          await getMultiPartRequest(APIEndPoints.updateProfile);
      if (firstName.isNotEmpty) {
        multiPartRequest.fields[UserKeys.firstName] = firstName;
      }
      if (lastName.isNotEmpty) {
        multiPartRequest.fields[UserKeys.lastName] = lastName;
      }
      if (email.isNotEmpty) {
        multiPartRequest.fields[UserKeys.email] = email;
      }
      if (mobile.isNotEmpty) {
        multiPartRequest.fields[UserKeys.mobile] = mobile;
      }
      if (address.isNotEmpty) {
        multiPartRequest.fields[UserKeys.address] = address;
      }
      if (gender.isNotEmpty) {
        multiPartRequest.fields[UserKeys.gender] = gender;
      }
      if (dateOfBirth.isNotEmpty) {
        multiPartRequest.fields[UserKeys.dateOfBirth] = dateOfBirth;
      }
      if (country.isNotEmpty) {
        multiPartRequest.fields[UserKeys.country] = country;
      }
      if (state.isNotEmpty) {
        multiPartRequest.fields[UserKeys.state] = state;
      }
      if (city.isNotEmpty) {
        multiPartRequest.fields[UserKeys.city] = city;
      }
      if (pinCode.isNotEmpty) {
        multiPartRequest.fields[UserKeys.pinCode] = pinCode;
      }

      if (imageFile != null) {
        multiPartRequest.files.add(await MultipartFile.fromPath(
            UserKeys.profileImage, imageFile.path));
      }
      multiPartRequest.headers.addAll(buildHeaderTokens());

      await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          onSuccess?.call(data);
        },
        onError: (error) {
          throw error;
        },
      ).catchError((error) {
        throw error;
      });
    }
  }

  static Future<AboutPageRes> getAboutPageData() async {
    return AboutPageRes.fromJson(
        await handleResponse(await buildHttpResponse(APIEndPoints.aboutPages)));
  }
}
