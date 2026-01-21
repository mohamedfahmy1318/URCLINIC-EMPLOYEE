import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/screens/auth/model/common_model.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import 'package:kivicare_clinic_admin/screens/receptionist/model/receptionist_res_model.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/app_common.dart';

class AddReceptionistController extends GetxController {
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController clinicCenterCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController phoneCodeCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  final GlobalKey<FormState> addReqFormKey = GlobalKey();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode clinicCenterFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneCodeFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  RxBool passContHasFocus = false.obs;
  RxBool hasUppercase = false.obs;
  RxBool hasNumber = false.obs;
  RxBool hasSpecial = false.obs;
  RxBool hasLetter = false.obs;

  Rx<ClinicData> selectedClinic = ClinicData().obs;

  Rx<Country> pickedPhoneCode = defaultCountry.obs;

  Rx<CMNModel> selectedGender = CMNModel().obs;

  RxBool isLoading = false.obs;
  RxBool isEdit = false.obs;
  Rx<ReceptionistData> receptionistData = ReceptionistData().obs;

  @override

  Future<void> onInit() async {
    super.onInit();
    if (Get.arguments is ReceptionistData) {
      receptionistData(Get.arguments);
      isEdit(true);
      await getReceptionistDetail();
    }
  }

  Future<void> getReceptionistDetail() async {
    isLoading(true);
    await CoreServiceApis.getReceptionistDetail(receptionistId: receptionistData.value.id).then((res) {
      receptionistData(res.value);
      initializeFormData(receptionistData);
    });
  }

  void initializeFormData(Rx<ReceptionistData> receptionistData) {
    if (isEdit.value) {
      firstNameCont.text = receptionistData.value.firstName;
      lastNameCont.text = receptionistData.value.lastName;
      emailCont.text = receptionistData.value.email;
      try {
        final phoneData = receptionistData.value.mobile.extractPhoneCodeAndNumber;
        phoneCont.text = phoneData.$2;
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
        phoneCont.text = loginUserData.value.mobile.trim();
        log('CountryParser.parsePhoneCode Err: $e');
      }
      addressCont.text = receptionistData.value.address;
      clinicCenterCont.text = receptionistData.value.clinicName;
      selectedGender(genders.firstWhere((element) => element.slug == receptionistData.value.gender.toLowerCase(), orElse: () => CMNModel()));
    }
    isLoading(false);
  }

  void selectClinics({required ClinicData clinic}) {
    clinicCenterCont.clear();
    selectedClinic(clinic);
    clinicCenterCont.text = clinic.name;
  }

  void clearConts() {
    firstNameCont.clear();
    lastNameCont.clear();
    emailCont.clear();
    phoneCodeCont.clear();
    phoneCont.clear();
    passwordCont.clear();
    clinicCenterCont.clear();
    selectedGender();
    addressCont.clear();
    confirmPasswordCont.clear();
  }

  Future<void> saveReceptionist() async {
    isLoading(true);

    final Map<String, dynamic> req = {
      'first_name': firstNameCont.text.trim(),
      'last_name': lastNameCont.text.trim(),
      'email': emailCont.text.trim(),
      'password': passwordCont.text.trim(),
      'confirm_password': confirmPasswordCont.text.trim(),
      'gender': selectedGender.value.slug,
      'mobile': "+${phoneCont.text.trim().formatPhoneNumber(pickedPhoneCode.value.phoneCode)}",
      'address': addressCont.text.trim(),
      'clinic_id': isEdit.value? receptionistData.value.clinicId : selectedClinic.value.id,
    };
    log("----------------$req");
    CoreServiceApis.saveReceptionist(request: req, isEdit: isEdit.value,id: receptionistData.value.receptionistId).then((value) async {
      clearConts();
      Get.back(result: true);
    }).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
  }

  void checkPasswordRules(String password) {
    hasUppercase.value = RegExp('[A-Z]').hasMatch(password);
    hasNumber.value = RegExp('[0-9]').hasMatch(password);
    hasSpecial.value = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    hasLetter.value = RegExp('[a-z]').hasMatch(password);
  }
}
