import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import '../../../../api/pharma_apis.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';
import '../../../../utils/constants.dart';

class AddSupplierController extends GetxController {
  final GlobalKey<FormState> addSupplierFormKey = GlobalKey();

  TextEditingController firstNameCont = TextEditingController();
  TextEditingController selectedPharmacyNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController phoneCodeCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController paymentTermsCont = TextEditingController();
  TextEditingController supplierTypeCont = TextEditingController();

  FocusNode firstNameFocus = FocusNode();
  FocusNode selectedPharmacyNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneCodeFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode paymentTermsFocus = FocusNode();
  FocusNode supplierTypeFocus = FocusNode();

  RxBool hasErrorFetchingSupplierType = false.obs;
  RxString errorMessageSupplierType = "".obs;

  Rx<Future<RxList<SupplierType>>> getSupplierTypes = Future(() => RxList<SupplierType>()).obs;
  RxBool isSupplierTypesLoading = false.obs;
  RxInt supplierTypePage = 1.obs;
  RxList<SupplierType> supplierTypes = RxList();
  RxBool isSupplierTypeLastPage = false.obs;
  Rx<SupplierType> selectedSupplierType = SupplierType().obs;

  Rx<Country> pickedPhoneCode = defaultCountry.obs;
  RxBool isEdit = false.obs;

  RxBool isLoading = false.obs;
  RxString doctorImage = "".obs;

  Rx<File> imageFile = File("").obs;
  XFile? pickedFile;

  RxBool status = true.obs;

  final ScrollController scrollController = ScrollController();

  Rx<Supplier> supplierData = Supplier.fromJson({}).obs;
  RxBool isInitialized = false.obs;

  RxBool isPharmaLoading = false.obs;
  RxList<Pharma> pharmaList = RxList();
  RxBool hasErrorFetchingPharma = false.obs;
  RxString errorMessagePharma = "".obs;

  RxString? selectedPharmacyId = ''.obs;

  @override
  void onInit() async {
    if (Get.arguments is Supplier) {
      supplierData(Get.arguments as Supplier);
      isEdit(true);

      firstNameCont.text = supplierData.value.firstName;
      lastNameCont.text = supplierData.value.lastName;
      emailCont.text = supplierData.value.email;
      paymentTermsCont.text = supplierData.value.paymentTerms;

      doctorImage(supplierData.value.imageUrl);

      selectedSupplierType(supplierData.value.supplierType);
      supplierTypeCont.text = supplierData.value.supplierType.name;

      imageFile.value = File('');

      try {
        final phoneData = supplierData.value.contactNumber.extractPhoneCodeAndNumber;
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
            }
          }
        }
      } catch (e) {
        pickedPhoneCode(Country.from(json: defaultCountry.toJson()));
        phoneCont.text = supplierData.value.contactNumber.trim();
      }

      status(supplierData.value.status.getBoolInt());
    }

    isInitialized.value = true;

    fetchPharmaList(); // Load list and set selection after load
    getSupplierTypeList();

    super.onInit();
  }

  Future<void> fetchPharmaList() async {
    log("clinic id----------------*${selectedAppClinic.value.id}");
    isPharmaLoading(true);

    PharmaApis.getPharmaList(
      pharmaList: pharmaList,
      clinicId: loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)
          ? -1
          : loginUserData.value.id,
    ).then((value) {
      if (value.isNotEmpty) {
        pharmaList.clear();
        pharmaList.addAll(value);

        hasErrorFetchingPharma.value = false;
        errorMessagePharma.value = "";

        if (isEdit.value) {
          final match = pharmaList.firstWhereOrNull(
                (pharma) => pharma.id.toString() == supplierData.value.pharmaId.toString(),
          );

          if (match != null) {
            selectedPharmacyId!.value = match.id.toString();
            selectedPharmacyNameCont.text = match.fullName.validate();
          }
        }

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

  Future<void> getSupplierTypeList({bool showLoader = true, String searchTxt = ''}) async {
    if (showLoader) isSupplierTypesLoading(true);

    await getSupplierTypes(
      PharmaApis.getSupplierTypes(
        supplierTypes: supplierTypes,
        page: supplierTypePage.value,
        search: searchTxt,
        lastPageCallBack: (p0) => isSupplierTypeLastPage(p0),
      ),
    ).then((value) {
      hasErrorFetchingSupplierType(false);
    }).catchError((e) {
      hasErrorFetchingSupplierType(true);
      errorMessageSupplierType(e.toString());
    }).whenComplete(() => isSupplierTypesLoading(false));
  }

  Future<void> saveSupplier() async {
    isLoading(true);
    hideKeyBoardWithoutContext();

    if (selectedSupplierType.value.id.isNegative) {
      toast(locale.value.pleaseSelectSupplierType);
      return;
    }

    final request = {
      if (isEdit.value) 'supplier_id': supplierData.value.id,
      'first_name': firstNameCont.text.trim(),
      'last_name': lastNameCont.text.trim(),
      'email': emailCont.text.trim(),
      'contact_number':
      "+${pickedPhoneCode.value.phoneCode} ${phoneCont.text.trim()}",
      "supplier_type_id": selectedSupplierType.value.id,
      'payment_terms': paymentTermsCont.text.trim(),
      'status': status.value == true ? 1 : 0,
    };

    PharmaApis.addEditSupplier(
      request: request,
      imageFile: imageFile.value.path.isNotEmpty ? imageFile.value : null,
      onSuccess: (value) {},
    ).then((value) {
      Get.back(result: true);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() => isLoading(false));
  }

  Future<void> _handleGalleryClick() async {
    Get.back();
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      doctorImage('');
      imageFile(File(pickedFile!.path));
    }
  }

  Future<void> _handleCameraClick() async {
    Get.back();
    pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      doctorImage('');
      imageFile(File(pickedFile!.path));
    }
  }

  void showImagePicker(BuildContext context) {
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
              onTap: () => _handleGalleryClick(),
            ),
            SettingItemWidget(
              title: locale.value.camera,
              leading: const Icon(Icons.camera, color: appColorPrimary),
              onTap: () => _handleCameraClick(),
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }
}
