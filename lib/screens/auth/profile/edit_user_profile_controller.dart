import 'dart:convert';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kivicare_clinic_admin/screens/auth/model/common_model.dart';
import 'package:kivicare_clinic_admin/screens/clinic/add_clinic_form/addresses_apis.dart';
import 'package:kivicare_clinic_admin/screens/clinic/add_clinic_form/model/city_list_response.dart';
import 'package:kivicare_clinic_admin/screens/clinic/add_clinic_form/model/country_list_response.dart';
import 'package:kivicare_clinic_admin/screens/clinic/add_clinic_form/model/state_list_response.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../api/auth_apis.dart';
import '../../../utils/colors.dart';
import '../model/login_response.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';

class EditUserProfileController extends GetxController {
  //Constructor region
  EditUserProfileController({this.isProfilePhoto = false});

  bool isProfilePhoto;

  //Constructor endregion
  RxBool isLoading = false.obs;
  Rx<File> imageFile = File("").obs;
  XFile? pickedFile;
  Rx<CMNModel> selectedGender = CMNModel().obs;

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController phoneCodeCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController countryCont = TextEditingController();
  TextEditingController stateCont = TextEditingController();
  TextEditingController cityCont = TextEditingController();
  TextEditingController postalCont = TextEditingController();
  TextEditingController dateCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneCodeFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode postalFocus = FocusNode();

  Rx<Country> pickedPhoneCode = defaultCountry.obs;

  // Address Details
  RxList<CountryData> countryList = RxList();
  RxList<StateData> stateList = RxList();
  RxList<CityData> cityList = RxList();

  Rx<CountryData> selectedCountry = CountryData().obs;
  Rx<StateData> selectedState = StateData().obs;
  Rx<CityData> selectedCity = CityData().obs;

  //Error Country
  RxBool hasErrorFetchingCountry = false.obs;
  RxString errorMessageCountry = "".obs;

  //Error State
  RxBool hasErrorFetchingState = false.obs;
  RxString errorMessageState = "".obs;

  //Error City
  RxBool hasErrorFetchingCity = false.obs;
  RxString errorMessageCity = "".obs;
  RxString errorDateOfBirth = "".obs;

  RxInt countryId = 0.obs;
  RxInt stateId = 0.obs;
  RxInt cityId = 0.obs;

  @override
  void onInit() {
    _bootstrap();
    super.onInit();
  }

  Future<void> _bootstrap() async {
    // If Clinic Admin (vendor) or Receptionist is logged in, fetch fresh profile from server for dynamic data
    if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) ||
        loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)) {
      await _initFromServer();
    } else {
      await init();
    }
    await getData();
  }

  Future<void> userDetailAPI() async {
    if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) ||
        loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist)) {
      await _initFromServer();
    } else {
      await init();
    }
    await getData();
  }

  Future<void> init() async {

    fNameCont.text = loginUserData.value.firstName;
    lNameCont.text = loginUserData.value.lastName;
    try {
      final phoneData = loginUserData.value.mobile.extractPhoneCodeAndNumber;
      mobileCont.text = phoneData.$2;
      final phoneCode = phoneData.$1;
      if (phoneCode.isNotEmpty && phoneCode != "0") {
        try {
          pickedPhoneCode(CountryParser.parsePhoneCode(phoneCode));
        } catch (parseError) {
          final countries = CountryService().getAll();
          final matchingCountries = countries.where((c) => c.phoneCode == phoneCode).toList();

          if (matchingCountries.isNotEmpty) {
            matchingCountries.sort((a, b) => a.name.length.compareTo(b.name.length));
            pickedPhoneCode(matchingCountries.first);
          } else {
            log("No country found for phone code: $phoneCode");
          }
        }
      } else {
        log("Invalid phone code: $phoneCode");
      }
    } catch (e) {
      pickedPhoneCode(Country.from(json: defaultCountry.toJson()));
      mobileCont.text = loginUserData.value.mobile.trim();
      log('CountryParser.parsePhoneCode Err: $e');
    }
    emailCont.text = loginUserData.value.email;
    addressCont.text = loginUserData.value.address;
    selectedGender(genders.firstWhere((element) => element.slug.toLowerCase().trim() == loginUserData.value.gender.toLowerCase().trim(), orElse: () => CMNModel(id: 3, name: "Other", slug: "other")));
    dateCont.text = loginUserData.value.dateOfBirth;
    countryId(loginUserData.value.country.toInt());
    stateId(loginUserData.value.state.toInt());
    cityId(loginUserData.value.city.toInt());
    postalCont.text = loginUserData.value.pinCode;
  }

  Future<void> _initFromServer() async {
    isLoading(true);
    try {
      final UserResponse serverRes = await AuthServiceApis.viewProfile(id: loginUserData.value.id);
      final UserData serverUser = serverRes.userData;

      fNameCont.text = serverUser.firstName;
      lNameCont.text = serverUser.lastName;

      try {
        final phoneData = serverUser.mobile.extractPhoneCodeAndNumber;
        mobileCont.text = phoneData.$2;
        final phoneCode = phoneData.$1;
        if (phoneCode.isNotEmpty && phoneCode != "0") {
          try {
            pickedPhoneCode(CountryParser.parsePhoneCode(phoneCode));
          } catch (parseError) {
            final countries = CountryService().getAll();
            final matchingCountries = countries.where((c) => c.phoneCode == phoneCode).toList();

            if (matchingCountries.isNotEmpty) {
              matchingCountries.sort((a, b) => a.name.length.compareTo(b.name.length));
              pickedPhoneCode(matchingCountries.first);
            } else {
              log("No country found for phone code: $phoneCode");
            }
          }
        } else {
          log("Invalid phone code: $phoneCode");
        }
      } catch (e) {
        pickedPhoneCode(Country.from(json: defaultCountry.toJson()));
        mobileCont.text = serverUser.mobile.trim();
        log('CountryParser.parsePhoneCode Err: $e');
      }
      emailCont.text = serverUser.email;
      addressCont.text = serverUser.address;
      selectedGender(genders.firstWhere((element) => element.slug.toLowerCase().trim() == serverUser.gender.toLowerCase().trim(), orElse: () => CMNModel(id: 3, name: "Other", slug: "other")));
      dateCont.text = serverUser.dateOfBirth;
      // Pre-fill location text; IDs may not be numeric in some responses
      countryCont.text = serverUser.country;
      stateCont.text = serverUser.state;
      cityCont.text = serverUser.city;
      countryId(serverUser.country.toInt());
      stateId(serverUser.state.toInt());
      cityId(serverUser.city.toInt());
      postalCont.text = serverUser.pinCode;
    } catch (e) {
      log('[EditProfile:_initFromServer][ERR] $e');
      // Fallback to local so the screen stays usable
      await init();
    } finally {
      isLoading(false);
    }
  }

  Future<void> getData() async {
    // Additional vendor-specific data handling can be placed here if needed
    
    // Always load countries first
    await getCountry();
    
    // If we have a country ID, load states
    if (countryId.value != 0) {
      await getStates(countryId: countryId.value);
      
      // If we have a state ID, load cities
      if (stateId.value != 0) {
        await getCity(stateId: stateId.value);
      }
    }

    // If API returned names instead of IDs, try to resolve and select them
    if (countryCont.text.trim().isNotEmpty && selectedCountry.value.id == 0 && countryList.isNotEmpty) {
      final match = countryList.firstWhereOrNull((c) => c.name.trim().toLowerCase() == countryCont.text.trim().toLowerCase());
      if (match != null) {
        selectedCountry(match);
        countryId(match.id);
        countryCont.text = match.name;
        await getStates(countryId: match.id);
      }
    }

    if (stateCont.text.trim().isNotEmpty && selectedState.value.id == 0 && stateList.isNotEmpty) {
      final match = stateList.firstWhereOrNull((s) => s.name.trim().toLowerCase() == stateCont.text.trim().toLowerCase());
      if (match != null) {
        selectedState(match);
        stateId(match.id);
        stateCont.text = match.name;
        await getCity(stateId: match.id);
      }
    }

    if (cityCont.text.trim().isNotEmpty && selectedCity.value.id == 0 && cityList.isNotEmpty) {
      final match = cityList.firstWhereOrNull((c) => c.name.trim().toLowerCase() == cityCont.text.trim().toLowerCase());
      if (match != null) {
        selectedCity(match);
        cityId(match.id);
        cityCont.text = match.name;
      }
    }
  }

  Future<void> updateUserProfile() async {
    if (!isProfilePhoto) {
      hideKeyBoardWithoutContext();
    }
    isLoading(true);

    AuthServiceApis.updateProfile(
      firstName: isProfilePhoto ? loginUserData.value.firstName : fNameCont.text.trim(),
      lastName: isProfilePhoto ? loginUserData.value.lastName : lNameCont.text.trim(),
      email: isProfilePhoto ? loginUserData.value.email : emailCont.text.trim(),
      mobile: isProfilePhoto ? loginUserData.value.mobile : "+${mobileCont.text.trim().formatPhoneNumber(pickedPhoneCode.value.phoneCode)}",
      address: isProfilePhoto ? loginUserData.value.address : addressCont.text.trim(),
      imageFile: imageFile.value.path.isNotEmpty ? imageFile.value : null,
      gender: selectedGender.value.slug,
      dateOfBirth: dateCont.text.trim(),
      country: selectedCountry.value.id.toString(),
      state: selectedState.value.id.toString(),
      city: selectedCity.value.id.toString(),
      pinCode: postalCont.text.trim(),
      onSuccess: (data) {
        isLoading(false);
        if (data != null) {
          if ((data as String).isJson()) {
            log("Response: ${jsonDecode(data)}");
            final UserResponse loginResponseModel = UserResponse.fromJson(jsonDecode(data));
            loginUserData(
              UserData(
                id: loginUserData.value.id,
                firstName: loginResponseModel.userData.firstName,
                lastName: loginResponseModel.userData.lastName,
                userName: "${loginResponseModel.userData.firstName} ${loginResponseModel.userData.lastName}",
                mobile: loginResponseModel.userData.mobile,
                email: loginResponseModel.userData.email,
                gender: loginResponseModel.userData.gender,
                userRole: loginUserData.value.userRole,
                address: loginResponseModel.userData.address,
                apiToken: loginUserData.value.apiToken,
                profileImage: loginResponseModel.userData.profileImage,
                loginType: loginUserData.value.loginType,
                city: selectedCity.value.id.toString(),
                state: selectedState.value.id.toString(),
                country: selectedCountry.value.id.toString(),
                pinCode: postalCont.text.trim(),
                dateOfBirth: dateCont.text.trim(),
              ),
            );
            setValueToLocal(SharedPreferenceConst.USER_DATA, loginUserData.toJson());
            Get.back();
          }
        }
      },
    ).then((data) {
      toast(locale.value.profileUpdatedSuccessfully);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString());
    });
  }

  Future<void> _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      imageFile(File(pickedFile!.path));
      if (isProfilePhoto) {
        showConfimDialogChoosePhoto();
      }
      // setState(() {});
    }
  }

  Future<void> _getFromCamera() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      imageFile(File(pickedFile!.path));
      if (isProfilePhoto) {
        showConfimDialogChoosePhoto();
      }
    }
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: locale.value.gallery,
              leading: const Icon(Icons.image, color: appColorPrimary),
              onTap: () async {
                _getFromGallery();
                finish(context);
              },
            ),
            SettingItemWidget(
              title: locale.value.camera,
              leading: const Icon(Icons.camera, color: appColorPrimary),
              onTap: () {
                _getFromCamera();
                finish(context);
              },
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  void resetCity() {
    selectedCity(CityData());
    cityCont.clear();
    cityList.clear();
  }

  void resetState() {
    selectedState(StateData());
    stateCont.clear();
    stateList.clear();
  }

  void showConfimDialogChoosePhoto() {
    showConfirmDialogCustom(
      getContext,
      primaryColor: appColorPrimary,
      negativeText: locale.value.cancel,
      positiveText: locale.value.yes,
      onAccept: (_) {
        ifNotTester(() async {
          if (await isNetworkAvailable()) {
            updateUserProfile();
          } else {
            toast(locale.value.yourInternetIsNotWorking);
          }
        });
      },
      dialogType: DialogType.ACCEPT,
      customCenterWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(
            imageFile.value,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              alignment: Alignment.center,
              width: 100,
              height: 100,
              decoration: boxDecorationDefault(shape: BoxShape.circle, color: appColorPrimary.withValues(alpha: 0.4)),
              child: Text(
                "${loginUserData.value.firstName.firstLetter.toUpperCase()}${loginUserData.value.lastName.firstLetter.toUpperCase()}",
                style: const TextStyle(fontSize: 100 * 0.3, color: Colors.white),
              ),
            ),
          ).cornerRadiusWithClipRRect(45),
        ],
      ).paddingSymmetric(vertical: 16),
      title: locale.value.wouldYouLikeToSetProfilePhotoAs,
    );
  }

  Future<void> getCountry({String searchTxt = ''}) async {
    isLoading(true);

    await UserAddressesApis.getCountryList(searchTxt: searchTxt).then((value) async {
      countryList.clear();
      countryList(value);
      bool matched = false;
      for (final e in value) {
        if (e.id == countryId.value) {
          selectedCountry(e);
          countryCont.text = selectedCountry.value.name;
          matched = true;
          break;
        }
      }
      if (!matched) {
        log("[EditProfile:getCountry][WARN] No country matched id=${countryId.value}");
      }
      hasErrorFetchingCountry(false);
    }).catchError((e) {
      hasErrorFetchingCountry(true);
      errorMessageCountry(e.toString());
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getStates({required int countryId, String searchTxt = ''}) async {
    isLoading(true);

    await UserAddressesApis.getStateList(countryId: countryId, searchTxt: searchTxt).then((value) async {
      stateList.clear();
      stateList(value);
      bool matched = false;
      for (final e in value) {
        if (e.id == stateId.value) {
          selectedState(e);
          stateCont.text = selectedState.value.name;
          matched = true;
          log("[EditProfile:getStates] Matched state -> id=${e.id}, name=${e.name}");
          break;
        }
      }
      if (!matched) {
        log("[EditProfile:getStates][WARN] No state matched id=${stateId.value} for countryId=$countryId");
      }
      hasErrorFetchingState(false);
    }).catchError((e) {
      hasErrorFetchingState(true);
      errorMessageState(e.toString());
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getCity({required int stateId, String searchTxt = ''}) async {
    isLoading(true);

    await UserAddressesApis.getCityList(stateId: stateId, searchTxt: searchTxt).then((value) async {
      cityList.clear();
      cityList(value);
      bool matched = false;
      for (final e in value) {
        if (e.id == cityId.value) {
          selectedCity(e);
          cityCont.text = selectedCity.value.name;
          matched = true;
          break;
        }
      }
      if (!matched) {
        log("[EditProfile:getCity][WARN] No city matched id=${cityId.value} for stateId=$stateId");
      }
      hasErrorFetchingCity(false);
    }).catchError((e) {
      hasErrorFetchingCity(true);
      errorMessageCity(e.toString());
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
  }
}
