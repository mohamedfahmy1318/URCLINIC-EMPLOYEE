import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kivicare_clinic_admin/api/clinic_api.dart';
import 'package:kivicare_clinic_admin/api/pharma_apis.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/auth/model/common_model.dart';
import 'package:kivicare_clinic_admin/screens/doctor/model/commission_list_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/suppliers/controller/pharma_controller.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../utils/colors.dart';
import '../clinic/model/clinics_res_model.dart';

class AddPharmaController extends GetxController {
  final GlobalKey<FormState> addPharmaForm = GlobalKey<FormState>();

  final TextEditingController pharmaCont = TextEditingController();
  final TextEditingController searchPharmaCont = TextEditingController();
  final TextEditingController firstNameCont = TextEditingController();
  final TextEditingController lastNameCont = TextEditingController();
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController phoneCont = TextEditingController();
  final TextEditingController passwordCont = TextEditingController();
  final TextEditingController confirmPasswordCont = TextEditingController();
  final TextEditingController dobCont = TextEditingController();
  final TextEditingController addressCont = TextEditingController();
  final TextEditingController commissionCont = TextEditingController();
  final TextEditingController clinicCenterCont = TextEditingController();
  final TextEditingController searchCont = TextEditingController();

  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode passWordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();
  final FocusNode dobFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode commissionFocus = FocusNode();
  final FocusNode clinicCenterFocus = FocusNode();

  final ScrollController scrollController = ScrollController();

  RxBool isLoading = false.obs;
  RxBool isEdit = false.obs;
  RxBool showPassword = false.obs;
  RxBool showConfirmPassword = false.obs;
  RxBool hasUppercase = false.obs;
  RxBool hasNumber = false.obs;
  RxBool hasSpecial = false.obs;
  RxBool hasLetter = false.obs;
  RxBool passContHasFocus = false.obs;
  RxBool status = true.obs;

  Rx<File> imageFile = File("").obs;
  XFile? pickedFile;

  Rx<Country> pickedPhoneCode = defaultCountry.obs;
  Rx<CMNModel> selectedGender = CMNModel().obs;
  Rx<ClinicData?> selectedClinic = Rx<ClinicData?>(null);
  Rx<Pharma> selectedPharma = Pharma.fromJson({}).obs;

  RxList<Pharma> pharmaList = <Pharma>[].obs;
  RxList<ClinicData> clinicList = <ClinicData>[].obs;
  RxList<CommissionElement> commissionList = <CommissionElement>[].obs;
  RxList<CommissionElement> commissionFilterList = <CommissionElement>[].obs;

  RxString commissionIds = "".obs;

  RxBool hasErrorFetchingPharma = false.obs;
  RxBool hasErrorFetchingCommission = false.obs;
  RxBool isPharmaLoading = false.obs;
  RxString errorMessagePharma = "".obs;
  RxString errorMessageCommission = "".obs;

  bool get isShowFullList => commissionFilterList.isEmpty && searchCont.text.trim().isEmpty;

  @override
  Future<void> onInit() async {
    if (Get.arguments is Pharma) {
      selectedPharma.value = Get.arguments as Pharma;
      isEdit(true);
      _populatePharmaData();
    }

    await Future.wait([
      fetchClinics(),
      getCommission(isInit: true),
    ]);

    _applySelectedCommission();
    super.onInit();
  }

  Future<void> _populatePharmaData() async {
    final pharma = selectedPharma.value;
    firstNameCont.text = pharma.firstName.validate();
    lastNameCont.text = pharma.lastName.validate();
    emailCont.text = pharma.email.validate();
    dobCont.text = pharma.dateOfBirth.validate();
    addressCont.text = pharma.address;

    try {
      final phoneData = selectedPharma.value.contactNumber.extractPhoneCodeAndNumber;
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
      phoneCont.text = selectedPharma.value.contactNumber.trim();
      log('CountryParser.parsePhoneCode Err: $e');
    }
  }

  Future<void> fetchClinics() async {
    try {
      isLoading(true);
      final list = await ClinicApis.getClinicList(clinicList: clinicList, page: 1);
      clinicList.assignAll(list);

      selectedClinic(
        clinicList.firstWhereOrNull((c) => c.id == selectedPharma.value.clinicId),
      );
      clinicCenterCont.text = selectedClinic.value?.name ?? '';
    } catch (e) {
      log("Error fetching clinics: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> getCommission({bool isInit = false}) async {
    try {
      isLoading(true);
      final res = await PharmaApis.getPharmaCommission();
      commissionList
        ..clear()
        ..addAll(res.data);
    } catch (e) {
      log('Error fetching commission: $e');
    } finally {
      isLoading(false);
    }
  }

  void _applySelectedCommission() {
    final pharmaCommissionId = selectedPharma.value.commission.firstWhereOrNull((e) => e.commissionId != null)?.commissionId;

    for (var c in commissionList) {
      c.isSelected.value = c.id == pharmaCommissionId;
    }

    final selectedCommission = commissionList.firstWhereOrNull(
      (e) => e.id == pharmaCommissionId,
    );

    if (selectedCommission != null) {
      commissionCont.text = "${selectedCommission.title} (${selectedCommission.commissionValue} ${selectedCommission.commissionType.toLowerCase().trim().contains(TaxType.PERCENT) ? "%" : appCurrency.value.currencyName})";
    }

    setCommissionContValue(commissionList: commissionList);
  }

  void setCommissionContValue({required List<CommissionElement> commissionList}) {
    commissionIds(
      commissionList.where((item) => item.isSelected.value && !item.id.isNegative).map((item) => item.id.toString()).join(","),
    );

    commissionCont.text = commissionList
        .where((e) => e.isSelected.value)
        .map(
          (e) => "${e.title} (${e.commissionValue} ${e.commissionType.toLowerCase().trim().contains(TaxType.PERCENT) ? "%" : appCurrency.value.currencyName})",
        )
        .join(",");
  }

  void fetchPharmaList(int? clinicId) {
    isPharmaLoading(true);
    PharmaApis.getPharmaList(search: searchPharmaCont.text, pharmaList: pharmaList, clinicId: clinicId!).then((value) {
      if (value.isNotEmpty) {
        pharmaList.value = value;
        hasErrorFetchingPharma.value = false;
        errorMessagePharma.value = "";
      } else {
        hasErrorFetchingPharma.value = true;
        errorMessagePharma.value = "No Pharma found";
      }
    }).catchError((e) {
      hasErrorFetchingPharma.value = true;
      errorMessagePharma.value = e.toString();
    }).whenComplete(() {
      isPharmaLoading(false);
    });
  }

  Future<void> _handleGalleryClick() async {
    Get.back();
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) imageFile(File(pickedFile!.path));
  }

  Future<void> _handleCameraClick() async {
    Get.back();
    pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) imageFile(File(pickedFile!.path));
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingItemWidget(
            title: locale.value.gallery,
            leading: const Icon(Icons.image, color: appColorPrimary),
            onTap: _handleGalleryClick,
          ),
          SettingItemWidget(
            title: locale.value.camera,
            leading: const Icon(Icons.camera, color: appColorPrimary),
            onTap: _handleCameraClick,
          ),
        ],
      ).paddingAll(16),
    );
  }

  void checkPasswordRules(String password) {
    hasUppercase.value = RegExp(r'[A-Z]').hasMatch(password);
    hasNumber.value = RegExp(r'[0-9]').hasMatch(password);
    hasSpecial.value = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    hasLetter.value = RegExp(r'[a-z]').hasMatch(password);
  }

  void savePharma({bool isEdit = false}) async {
    if (!addPharmaForm.currentState!.validate()) return;

    if (selectedClinic.value == null) {
      toast("Please select clinic");
      return;
    }
    if (commissionIds.value.isEmpty) {
      toast("Please select commission");
      return;
    }
    if (passwordCont.text != confirmPasswordCont.text) {
      toast("Password and Confirm Password must be same");
      return;
    }

    isLoading(true);

    final req = {
      'first_name': firstNameCont.text.trim(),
      'last_name': lastNameCont.text.trim(),
      'email': emailCont.text.trim(),
      "contact_number": "+${pickedPhoneCode.value.phoneCode} ${phoneCont.text.trim()}",
      'password': passwordCont.text.trim(),
      'password_confirmation': confirmPasswordCont.text.trim(),
      "dob": dobCont.text.trim(),
      "clinic": selectedClinic.value!.id,
      "gender": selectedGender.value.slug,
      "address": addressCont.text.trim(),
      "status": status.value ? "1" : "0",
      'pharma_commission': commissionIds.value,
    };

    try {
      final api = PharmaApis();
      await api.addEditPharma(
        request: req,
        files: imageFile.value.path.isNotEmpty ? [imageFile.value] : null,
        isEdit: isEdit,
        pharmaId: isEdit ? selectedPharma.value.id : -1,
        onSuccess: (res) => toast(res.message, print: true),
      );

      await Get.find<PharmaController>().getPharmas();
      Get.back(result: true);
    } catch (e) {
      log(e.toString());
      toast(e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    pharmaCont.dispose();
  }
}
