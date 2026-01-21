// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import '../configs.dart';
import '../main.dart';
import '../api/auth_apis.dart';
import '../screens/auth/profile/profile_controller.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/common_base.dart';
import '../utils/constants.dart';
import '../utils/local_storage.dart';

Map<String, String> buildHeaderTokens({
  Map? extraKeys,
  String? endPoint,
}) {
  /// Initialize & Handle if key is not present
  if (extraKeys == null) {
    extraKeys = {};
    extraKeys.putIfAbsent('isFlutterWave', () => false);
    extraKeys.putIfAbsent('isAirtelMoney', () => false);
  }
  final Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
    'Accept': "application/json",
    'global-localization': selectedLanguageCode.value,
  };

  if (endPoint == APIEndPoints.register) {
    header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json');
  }
  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');

  if (isLoggedIn.value && extraKeys.containsKey('isFlutterWave') && extraKeys['isFlutterWave']) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer ${extraKeys!['flutterWaveSecretKey']}");
  } else if (isLoggedIn.value && extraKeys.containsKey('isAirtelMoney') && extraKeys['isAirtelMoney']) {
    header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${extraKeys!['access_token']}');
    header.putIfAbsent('X-Country', () => '${extraKeys!['X-Country']}');
    header.putIfAbsent('X-Currency', () => '${extraKeys!['X-Currency']}');
  } else if (isLoggedIn.value) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${loginUserData.value.apiToken}');
  }

  // log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  if (!endPoint.startsWith('http')) {
    return Uri.parse('$BASE_URL$endPoint');
  } else {
    return Uri.parse(endPoint);
  }
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  Map? extraKeys,
}) async {
  final headers = buildHeaderTokens(extraKeys: extraKeys, endPoint: endPoint);
  final Uri url = buildBaseUrl(endPoint);

  Response response;
  log('URL (${method.name}): $url');
  log('Headers: $headers');

  try {
    if (method == HttpMethodType.POST) {
      log('Request: ${jsonEncode(request)}');
      response = await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      log('Making GET request to: $url');
      response = await get(url, headers: headers);
      log('GET request completed with status code: ${response.statusCode}');
    }
    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == HttpMethodType.POST || method == HttpMethodType.PUT,
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body.trim(),
      methodtype: method.name,
    );
    log('Response status code: ${response.statusCode}');
    log('Response body: ${response.body.trim()}');

    if (isLoggedIn.value && response.statusCode == 401 && !endPoint.startsWith('http')) {
      log('Token expired, regenerating...');
      return await reGenerateToken().then((value) async {
        return buildHttpResponse(endPoint, method: method, request: request, extraKeys: extraKeys);
      }).catchError((e) async {
        if (!await isNetworkAvailable()) {
          throw errorInternetNotAvailable;
        } else {
          log('URL value  1 (${method.name}): $url :: $errorSomethingWentWrong');

          throw errorSomethingWentWrong;
        }
      });
    } else {
      return response;
    }
  } on Exception catch (e) {
    log('Error in buildHttpResponse: $e');
    throw errorInternetNotAvailable;
  }
}

Future<void> reGenerateToken() async {
  log('Regenerating Token');
  final userPASSWORD = getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);

  final Map req = {
    UserKeys.email: loginUserData.value.email,
    UserKeys.userType: loginUserData.value.userRole.isNotEmpty ? loginUserData.value.userRole.first : loginUserData.value.userType,
  };
  if (loginUserData.value.isSocialLogin) {
    log('LOGINUSERDATA.VALUE.ISSOCIALLOGIN: ${loginUserData.value.isSocialLogin}');
    req[UserKeys.loginType] = loginUserData.value.loginType;
  } else {
    req[UserKeys.password] = userPASSWORD;
  }
  return AuthServiceApis.loginUser(request: req, isSocialLogin: loginUserData.value.isSocialLogin).then((value) async {
    loginUserData.value.apiToken = value.userData.apiToken;
  }).catchError((e) {
    ProfileController().handleLogout();
  });
}

Future handleResponse(Response response, {HttpResponseType httpResponseType = HttpResponseType.JSON, bool? avoidTokenError, bool? isFlutterWave}) async {
  if (!await isNetworkAvailable()) {
    log('No network available');
    throw errorInternetNotAvailable;
  }

  log('Handling response with status code: ${response.statusCode}');
  log('Response body: ${response.body.trim()}');

  if (response.statusCode.isSuccessful()) {
    if (response.body.trim().isJson()) {
      final Map body = jsonDecode(response.body.trim());

      if (body.containsKey('status')) {
        if (isFlutterWave.validate()) {
          if (body['status'] == 'success') {
            log('FlutterWave success response');
            return body;
          } else {
            log('FlutterWave error: ${body['message']}');
            log('URL value  9  :: $errorSomethingWentWrong');

            throw body['message'] ?? errorSomethingWentWrong;
          }
        } else {
          if (body['status'] == true) {
            log('API success response');
            return body;
          } else {
            if (body.containsKey("is_deleted") && body["is_deleted"] == true) {
              log('User account deleted');
              AuthServiceApis.clearData(isFromDeleteAcc: true);
              isLoggedIn(false);
              doIfLoggedIn(() {});
              log('URL value  7  :: $errorSomethingWentWrong');

              toast(body['message'] ?? errorSomethingWentWrong);
            } else {
              log('API error: ${body['message']}');
              log('URL value  6  :: $errorSomethingWentWrong');

              throw body['message'] ?? errorSomethingWentWrong;
            }
          }
        }
      } else {
        log('Response does not contain status field');
        return body;
      }
        } else {
      log('Response is not valid JSON');
      log('URL value  4  :: $errorSomethingWentWrong');

      throw errorSomethingWentWrong;
    }
  } else if (response.statusCode == 400) {
    try {
      final Map body = jsonDecode(response.body.trim());
      final dynamic msg = body['message'];
      if (msg is String && msg.isNotEmpty) throw msg;
    } catch (_) {
      throw locale.value.badRequest;
    }
    throw locale.value.badRequest;
  } else if (response.statusCode == 403) {
    log('Forbidden error');
    throw locale.value.forbidden;
  } else if (response.statusCode == 404) {
    log('Page not found error');
    throw locale.value.pageNotFound;
  } else if (response.statusCode == 429) {
    try {
      final Map body = jsonDecode(response.body.trim());
      final dynamic msg = body['message'];
      if (msg is String && msg.isNotEmpty) throw msg;
    } catch (_) {
      throw locale.value.tooManyRequests;
    }
    throw locale.value.tooManyRequests;
  } else if (response.statusCode == 500) {
    log('Internal server error');
    throw locale.value.internalServerError;
  } else if (response.statusCode == 502) {
    log('Bad gateway error');
    throw locale.value.badGateway;
  } else if (response.statusCode == 503) {
    log('Service unavailable error');
    throw locale.value.serviceUnavailable;
  } else if (response.statusCode == 504) {
    log('Gateway timeout error');
    throw locale.value.gatewayTimeout;
  } else {
    Map body = jsonDecode(response.body.trim());

    if (body.containsKey('status') && body['status']) {
      return body;
    } else {
      log('URL value  3  :: $errorSomethingWentWrong');

      throw (body['message'] ?? errorSomethingWentWrong);
    }
  }
}

//region CommonFunctions
Future<Map<String, String>> getMultipartFields({required Map<String, dynamic> val}) async {
  final Map<String, String> data = {};

  val.forEach((key, value) {
    data[key] = '$value';
  });

  return data;
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  final String url = baseUrl ?? buildBaseUrl(endPoint).toString();
  // log(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  final http.Response response = await http.Response.fromStream(await multiPartRequest.send());
  apiPrint(
    url: multiPartRequest.url.toString(),
    headers: jsonEncode(multiPartRequest.headers),
    request: jsonEncode(multiPartRequest.fields),
    hasRequest: true,
    statusCode: response.statusCode,
    responseBody: response.body.trim(),
    methodtype: "MultiPart",
  );
  // log("Result: ${response.statusCode} - ${multiPartRequest.fields}");
  // log(response.body.trim());
  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body.trim());
  }  else if (response.statusCode == 422) {
    // ✅ Validation error (like duplicate email)
    final errorJson = jsonDecode(response.body);
    final errorMsg = errorJson['message'] ??
        (errorJson['errors'] != null
            ? (errorJson['errors'] as Map).values.first[0]
            : "Validation error occurred");

    toast(errorMsg);
    onError?.call(errorMsg); // Pass message back to the caller
  } else {
    if (isLoggedIn.value && response.statusCode == 401) {
      return reGenerateToken().then((value) async {
        try {
          final http.Response response = await http.Response.fromStream(await multiPartRequest.send());
          if (response.statusCode.isSuccessful()) {
            onSuccess?.call(response.body.trim());
          } else {
            onError?.call(response.reasonPhrase);
          }
        } catch (e) {
          onError?.call(response.reasonPhrase);
        }
      }).catchError((e) {
        onError?.call(response.reasonPhrase);
      });
    } else {
      AuthServiceApis.clearData(isFromDeleteAcc: true);
      doIfLoggedIn(() {});
      onError?.call(response.reasonPhrase);
    }
  }
}

Future<List<MultipartFile>> getMultipartImages({required List<PlatformFile> files, required String name}) async {
  final List<MultipartFile> multiPartRequest = [];

  await Future.forEach<PlatformFile>(files, (element) async {
    final int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath('$name[$i]', element.path.validate()));
  });

  return multiPartRequest;
}

Future<List<MultipartFile>> getMultipartImages2({required List<XFile> files, required String name}) async {
  final List<MultipartFile> multiPartRequest = [];

  await Future.forEach<XFile>(files, (element) async {
    final int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath('$name[$i]', element.path.validate()));
    log('MultipartFile: $name[$i]');
  });

  return multiPartRequest;
}

String parseStripeError(String response) {
  try {
    final body = jsonDecode(response);
    return parseHtmlString(body['error']['message']);
  } on Exception catch (e) {
    log(e);

    log('URL value  2  :: $errorSomethingWentWrong');

    throw errorSomethingWentWrong;
  }
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
  bool hasRequest = false,
  bool fullLog = false,
}) {
  if (fullLog) {
    dev.log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    dev.log("\u001b[93m Url: \u001B[39m $url");
    dev.log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    dev.log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
    if (hasRequest) {
      dev.log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    dev.log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    dev.log('Response ($methodtype) $statusCode: $responseBody');
    dev.log("\u001B[0m");
    dev.log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  } else {
    log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    log("\u001b[93m Url: \u001B[39m $url");
    log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
    if (hasRequest) {
      dev.log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    log('Response ($methodtype) $statusCode: ${formatJson(responseBody)}');
    log("\u001B[0m");
    log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  }
}

String formatJson(String jsonStr) {
  try {
    final dynamic parsedJson = jsonDecode(jsonStr);
    const formatter = JsonEncoder.withIndent('  ');
    return formatter.convert(parsedJson);
  } on Exception catch (e) {
    dev.log("\x1b[31m formatJson error ::-> $e \x1b[0m");
    return jsonStr;
  }
}
String getEndPoint({required String endPoint, int? perPages, int? page, List<String>? params}) {
  String perPage = "?per_page=${perPages ?? 10}";
  String pages = "&page=$page";

  if (page != null && params.validate().isEmpty) {
    return "$endPoint$perPage$pages";
  } else if (page != null && params != null && params.validate().isNotEmpty) {
    return "$endPoint$perPage$pages&${params.validate().join('&')}";
  } else if (page == null && params != null && params.validate().isNotEmpty) {
    return "$endPoint?${params.join('&')}";
  }
  return "$endPoint";
}
