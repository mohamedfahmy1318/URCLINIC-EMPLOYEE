import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/clinic_api.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../api/core_apis.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import 'addresses_apis.dart';
import 'model/add_clinic_req.dart';
import 'model/city_list_response.dart';
import 'model/country_list_response.dart';
import 'model/specialization_resp.dart';
import 'model/state_list_response.dart';
import 'model/time_slote.dart';

class AddClinicController extends GetxController {
  RxList<CountryData> countryList = RxList();
  RxList<StateData> stateList = RxList();
  RxList<CityData> cityList = RxList();

  Rx<CountryData> selectedCountry = CountryData().obs;
  Rx<StateData> selectedState = StateData().obs;
  Rx<CityData> selectedCity = CityData().obs;

  TextEditingController clinicNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController clinicPhoneCodeCont = TextEditingController();
  TextEditingController clinicPhoneCont = TextEditingController();
  TextEditingController specializationCont = TextEditingController();

  // TextEditingController timeSlotCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController countryCont = TextEditingController();
  TextEditingController stateCont = TextEditingController();
  TextEditingController cityCont = TextEditingController();
  TextEditingController latCont = TextEditingController();
  TextEditingController lonCont = TextEditingController();
  TextEditingController postalCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode clinicNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode clinicPhoneCodeFocus = FocusNode();
  FocusNode clinicPhoneFocus = FocusNode();
  FocusNode specializationFocus = FocusNode();

  // FocusNode timeSlotFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode countryFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode latFocus = FocusNode();
  FocusNode lonFocus = FocusNode();
  FocusNode postalFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  Rx<Country> pickedPhoneCode = defaultCountry.obs;

  RxBool isEdit = false.obs;

  RxInt countryId = 0.obs;
  RxInt stateId = 0.obs;
  RxInt cityId = 0.obs;

  TextEditingController searchCont = TextEditingController();

  //Specialization
  Rx<Future<RxList<SpecializationModel>>> getSpecialization = Future(() => RxList<SpecializationModel>()).obs;
  RxInt page = 1.obs;
  RxList<SpecializationModel> specializationList = RxList();
  RxBool isLastPage = false.obs;
  Rx<SpecializationModel> selectSpecialization = SpecializationModel().obs;
  RxBool hasErrorFetchingSpecialization = false.obs;
  RxString errorMessageSpecialization = "".obs;

  //Time in Slot
  RxList<TimeSlotMinResponse> timeSloteList = RxList();
  Rx<TimeSlotMinResponse> selectTimeSlot = TimeSlotMinResponse().obs;
  RxString searchTimeSlot = "".obs;

  Rx<ClinicData> clinicData = ClinicData().obs;

  RxBool isLoading = false.obs;

  //Active/In-active Status
  RxBool status = true.obs;

  //Error Country
  RxBool hasErrorFetchingCountry = false.obs;
  RxString errorMessageCountry = "".obs;

  //Error State
  RxBool hasErrorFetchingState = false.obs;
  RxString errorMessageState = "".obs;

  //Error City
  RxBool hasErrorFetchingCity = false.obs;
  RxString errorMessageCity = "".obs;

  RxString clinicImage = "".obs;

  RxList<PlatformFile> clincFiles = RxList();

  // RxList<XFile> pickedFile = RxList();
  Rx<File> imageFile = File("").obs;
  XFile? pickedFile;

  final GlobalKey<FormState> addClinicformKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    if (Get.arguments is ClinicData) {
      clinicData(Get.arguments as ClinicData);
      getClinicDetail();
      isEdit(true);
      clinicNameCont.text = clinicData.value.name;
      descriptionCont.text = clinicData.value.description;
      emailCont.text = clinicData.value.email;
      clinicImage(clinicData.value.clinicImage);
      //address
      addressCont.text = clinicData.value.address;
      postalCont.text = clinicData.value.pincode;
      cityId(clinicData.value.cityId);
      stateId(clinicData.value.stateId);
      countryId(clinicData.value.countryId);
      latCont.text = clinicData.value.latitude;
      lonCont.text = clinicData.value.longitude;
      status(clinicData.value.status.getBoolInt());
      try {
        final phoneData = clinicData.value.contactNumber.extractPhoneCodeAndNumber;
        clinicPhoneCont.text = phoneData.$2;
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
        clinicPhoneCont.text = clinicData.value.contactNumber.trim();
        log('CountryParser.parsePhoneCode Err: $e');
      }

      // setSpecialization();
    }
    init();
    super.onInit();
  }

  Future<void> init() async {
    if (countryId.value != 0) {
      await getCountry();
      await getStates(countryId: countryId.value);
      if (stateId.value != 0) {
        await getCity(stateId: stateId.value);
      }
    } else {
      await getCountry();
    }
    await getSpecializationList();
    await getTimeSlot();
  }

  Future<void> getTimeSlot() async {
    timeSloteList(List.generate(12, (index) => TimeSlotMinResponse(id: index, value: "${5 * (index + 1)}", name: "${5 * (index + 1)} Min")));
    selectTimeSlot(timeSloteList.firstWhere((element) => element.value == clinicData.value.timeSlot.toString(), orElse: selectTimeSlot.call));
  }

  ///Get Clinic Detail
  Future<void> getClinicDetail({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await ClinicApis.getClinicDetails(clinicId: clinicData.value.id).then((value) {
      clinicData(value.data);
    }).catchError((e) {
      log('ClinicDetail getClinicDetail err ==> $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getSpecializationList({bool showloader = true, String searchTxt = ""}) async {
    if (showloader) {
      isLoading(true);
    }
    await getSpecialization(
      CoreServiceApis.getSpecializationList(
        specializationList: specializationList,
        page: page.value,
        search: searchTxt,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      if (isEdit.value) {
        selectSpecialization(specializationList.firstWhere((element) => element.id.toString() == clinicData.value.systemServiceCategory.toString(), orElse: () => SpecializationModel()));
        specializationCont.text = selectSpecialization.value.name;
      }
      hasErrorFetchingSpecialization(false);
    }).catchError((e) {
      hasErrorFetchingSpecialization(true);
      errorMessageSpecialization(e.toString());
      toast(e.toString());
      log("getSpecializationList err: $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getCountry({String searchTxt = ''}) async {
    isLoading(true);

    await UserAddressesApis.getCountryList(searchTxt: searchTxt).then((value) async {
      countryList.clear();
      countryList(value);

      for (final e in value) {
        if (e.id == countryId.value) {
          selectedCountry(e);
          countryCont.text = selectedCountry.value.name;
        }
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
      for (final e in value) {
        if (e.id == stateId.value) {
          selectedState(e);
          stateCont.text = selectedState.value.name;
        }
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
      for (final e in value) {
        if (e.id == cityId.value) {
          selectedCity(e);
          cityCont.text = selectedCity.value.name;
        }
      }
      hasErrorFetchingCity(false);
    }).catchError((e) {
      hasErrorFetchingCity(true);
      errorMessageCity(e.toString());
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
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

  Future<void> handleFilesPickerClick() async {
    final pickedFiles = await pickFiles();
    final Set<String> filePathsSet = clincFiles.map((file) => file.name.trim().toLowerCase()).toSet();
    for (var i = 0; i < pickedFiles.length; i++) {
      if (!filePathsSet.contains(pickedFiles[i].name.trim().toLowerCase())) {
        clincFiles.add(pickedFiles[i]);
      }
    }
  }

  Future<void> addClinic() async {
    isLoading(true);

    final AddClinicReq addClinicReq = AddClinicReq(
      clinicName: clinicNameCont.text.trim(),
      description: descriptionCont.text.trim(),
      address: addressCont.text.trim(),
      city: selectedCity.value.id.toString(),
      state: selectedState.value.id.toString(),
      country: selectedCountry.value.id.toString(),
      pincode: postalCont.text.trim(),
      contactNumber: "+${clinicPhoneCont.text.trim().formatPhoneNumber(pickedPhoneCode.value.phoneCode)}",
      latitude: latCont.text.trim(),
      longitude: lonCont.text.trim(),
      email: emailCont.text,
      timeSlot: selectTimeSlot.value.value,
      systemServiceCategory: selectSpecialization.value.id,
      status: status.value.getIntBool().toString(),
      speciality: selectSpecialization.value.id,
    );
    ClinicApis.addEditClinc(
      clinicId: isEdit.value && !clinicData.value.id.isNegative ? clinicData.value.id : null,
      isEdit: isEdit.value,
      request: addClinicReq.toJson(),
      clinicData: clinicData.value,
      onSuccess: (p0) {
        log("Clinic Added");
      },
      imageFile: imageFile.value.path.isNotEmpty ? imageFile.value : null,
    ).then((value) {
      Get.back(result: true);
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString());
    });
  }

  Future<void> _handleGalleryClick() async {
    Get.back();
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      clinicImage('');
      imageFile(File(pickedFile!.path));
    }
  }

  Future<void> _handleCameraClick() async {
    Get.back();
    pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      clinicImage('');
      imageFile(File(pickedFile!.path));
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
                _handleGalleryClick();
              },
            ),
            SettingItemWidget(
              title: locale.value.camera,
              leading: const Icon(Icons.camera, color: appColorPrimary),
              onTap: () {
                _handleCameraClick();
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
}
