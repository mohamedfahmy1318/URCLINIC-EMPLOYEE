import 'dart:async';
import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/pharma_apis.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../utils/constants.dart';

class AddStockController extends GetxController {
  var currentStep = 0.obs;
  final PageController pageController = PageController();
  RxBool isLoading = false.obs;
  RxBool isEdit = false.obs;

  //TextFiled Controller
  final GlobalKey<FormState> addMedicineInfoFormKey = GlobalKey();
  final GlobalKey<FormState> addSupplierInfoFormKey = GlobalKey();
  final GlobalKey<FormState> addInventoryInfoFormKey = GlobalKey();
  TextEditingController medicineNameCont = TextEditingController();
  TextEditingController dosageCont = TextEditingController();
  TextEditingController categoryCont = TextEditingController();
  TextEditingController medicineFormCont = TextEditingController();
  TextEditingController noteCont = TextEditingController();
  TextEditingController supplierCont = TextEditingController();
  TextEditingController supplierContactNumberCont = TextEditingController();
  TextEditingController supplierCountryCodeCont = TextEditingController();
  TextEditingController paymentTermsCont = TextEditingController();
  TextEditingController batchNoCont = TextEditingController();
  TextEditingController startSerialNoCont = TextEditingController();
  TextEditingController endSerialNoCont = TextEditingController();
  TextEditingController purchasePriceCont = TextEditingController();
  TextEditingController sellingPriceCont = TextEditingController();
  TextEditingController expiryDateCont = TextEditingController();
  TextEditingController quantityCont = TextEditingController();
  TextEditingController reOrderLevelCont = TextEditingController();
  TextEditingController stockValueCont = TextEditingController();
  TextEditingController manufacturerCont = TextEditingController();
  TextEditingController addManufacturerCont = TextEditingController();

  FocusNode medicineNameFocus = FocusNode();
  FocusNode dosageFocus = FocusNode();
  FocusNode categoryFocus = FocusNode();
  FocusNode medicineFormFocus = FocusNode();
  FocusNode noteFocus = FocusNode();
  FocusNode supplierFocus = FocusNode();
  FocusNode supplierContactNumberFocus = FocusNode();
  FocusNode paymentTermsFocus = FocusNode();
  FocusNode batchNoFocus = FocusNode();
  FocusNode startSerialNoFocus = FocusNode();
  FocusNode endSerialNoFocus = FocusNode();
  FocusNode purchasePriceFocus = FocusNode();
  FocusNode sellingPriceFocus = FocusNode();
  FocusNode expiryDateFocus = FocusNode();
  FocusNode quantityFocus = FocusNode();
  FocusNode reOrderLevelFocus = FocusNode();
  FocusNode stockValueFocus = FocusNode();
  FocusNode manufacturerFocus = FocusNode();

  Rx<Country> pickedPhoneCode = defaultCountry.obs;

  //Error Category
  RxBool hasErrorFetchingCategory = false.obs;
  RxString errorMessageCategory = "".obs;

  //Error Medicine Form
  RxBool hasErrorFetchingMedicineForm = false.obs;
  RxString errorMessageMedicineForm = "".obs;

  //Error Manufacturer
  RxBool hasErrorFetchingManufacturer = false.obs;
  RxString errorMessageManufacturer = "".obs;

  //Error Supplier
  RxBool hasErrorFetchingSupplier = false.obs;
  RxString errorMessageSupplier = "".obs;
  RxString sellingPriceError = ''.obs;
  RxDouble purchasePrice = 0.0.obs;

  //Medicine Forms
  Rx<Future<RxList<MedicineForm>>> getMedicineForms = Future(() => RxList<MedicineForm>()).obs;
  RxBool isMedicineFormsLoading = false.obs;
  RxInt medicineFormPage = 1.obs;
  RxList<MedicineForm> medicineForms = RxList();
  RxBool isMedicineFormLastPage = false.obs;
  Rx<MedicineForm> selectedMedicineForm = MedicineForm().obs;

  //Medicine Category
  Rx<Future<RxList<MedicineCategory>>> getMedCategories = Future(() => RxList<MedicineCategory>()).obs;
  RxBool isMedCategoryLoading = false.obs;
  RxList<MedicineCategory> medCategories = RxList();
  RxBool isMedCategoryLastPage = false.obs;
  RxInt medCategoryPage = 1.obs;
  Rx<MedicineCategory> selectedMedCategory = MedicineCategory().obs;

  //Manufacturer
  Rx<Future<RxList<Manufacturer>>> getManufacturers = Future(() => RxList<Manufacturer>()).obs;
  RxBool isManufacturerLoading = false.obs;
  RxList<Manufacturer> manufacturerList = RxList();
  RxBool isManufacturerLastPage = false.obs;
  RxInt manufacturerPage = 1.obs;
  Rx<Manufacturer> selectedManufacturer = Manufacturer().obs;

  //Supplier
  Rx<Future<RxList<Supplier>>> getSuppliers = Future(() => RxList<Supplier>()).obs;
  RxBool isSuppliersLoading = false.obs;
  RxList<Supplier> supplierList = RxList();
  RxBool isSuppliersLastPage = false.obs;
  RxInt suppliersPage = 1.obs;
  Rx<Supplier> selectedSupplier = Supplier.fromJson({}).obs;

  RxBool isInclusiveTax = false.obs;
  int? medicineId;
  RxBool isPurchasePriceEntered = false.obs;
  RxString errorMessageSerialNumber = "".obs;

  @override
  void onReady() {
    if (Get.arguments is Medicine) {
      isEdit(true);
      Medicine medicine = Get.arguments as Medicine;
      medicineId = medicine.id;
      selectedMedCategory.value = medicine.category;
      selectedMedicineForm.value = medicine.form;
      selectedSupplier.value = medicine.supplier;
      selectedManufacturer.value = medicine.manufacturer;

      medicineNameCont.text = medicine.name;
      categoryCont.text = medicine.category.name;
      dosageCont.text = medicine.dosage;
      medicineFormCont.text = medicine.form.name;
      supplierCont.text = "${medicine.supplier.firstName} ${medicine.supplier.lastName}";
      noteCont.text = medicine.note;
      manufacturerCont.text = medicine.manufacturer.name;
      List<String> parts = medicine.supplier.contactNumber.split(' ');

      String countryCode = parts.length == 1 ? "+91" : parts[0]; // '+91'
      String contactNumber = parts.length == 1 ? parts[0] : parts[1];
      supplierCountryCodeCont.text = countryCode;
      supplierContactNumberCont.text = contactNumber;
      paymentTermsCont.text = medicine.supplier.paymentTerms;
      expiryDateCont.text = medicine.expiryDate.dateInyyyyMMddFormat.formatDateYYYYmmdd();
      quantityCont.text = medicine.quntity.toString();
      reOrderLevelCont.text = medicine.reOrderLevel.toString();
      batchNoCont.text = medicine.batchNo;
      startSerialNoCont.text = medicine.startSerialNo.toString();
      endSerialNoCont.text = medicine.endSerialNo.toString();
      purchasePriceCont.text = medicine.purchasePrice.toString();
      sellingPriceCont.text = medicine.sellingPrice.toString();
      isInclusiveTax.value = medicine.isInclusiveTax;
      stockValueCont.text = "";
      stockValueCont.text = (medicine.quntity.toDouble() * medicine.sellingPrice).toString();
    }
    getMedicineFormList();
    getMedicineCategoryList();
    getManufacturerList();
    getManufacturerList();
    super.onReady();
  }

  String? validateSellingPrice(String value) {
    double? selling = double.tryParse(value);
    double purchase = purchasePrice.value;

    if (selling == null) {
      sellingPriceError.value = locale.value.thisFieldIsRequired;
      return sellingPriceError.value;
    } else if (selling < purchase) {
      sellingPriceError.value = locale.value.sellingPriceCannotLess;
      return sellingPriceError.value;
    } else {
      sellingPriceError.value = '';
      return null;
    }
  }

  void nextPage() {
    if (currentStep.value < 2) {
      currentStep.value++;
      pageController.animateToPage(currentStep.value, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void previousPage() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.animateToPage(currentStep.value, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Future<void> getMedicineFormList({bool showLoader = true, String searchTxt = ''}) async {
    if (showLoader) {
      isMedicineFormsLoading(true);
    }
    await getMedicineForms(PharmaApis.getMedicineForms(
      medicineForms: medicineForms,
      page: medicineFormPage.value,
      search: searchTxt,
      lastPageCallBack: (p0) {
        isMedicineFormLastPage(p0);
      },
    )).then((value) async {
      log("Value is ==> $value");
      hasErrorFetchingMedicineForm(false);
    }).catchError((e) {
      hasErrorFetchingMedicineForm(true);
      errorMessageMedicineForm(e.toString());
      log("getMedicineForms err: $e");
    }).whenComplete(() => isMedicineFormsLoading(false));
  }

  Future<void> getMedicineCategoryList({bool showLoader = true, String searchTxt = ''}) async {
    if (showLoader) {
      isMedCategoryLoading(true);
    }
    await getMedCategories(PharmaApis.getMedicineCategory(
      medCategoryList: medCategories,
      page: medCategoryPage.value,
      search: searchTxt,
      lastPageCallBack: (p0) {
        isMedCategoryLastPage(p0);
      },
    )).then((value) {
      hasErrorFetchingCategory(false);
    }).catchError((e) {
      hasErrorFetchingCategory(true);
      errorMessageCategory(e.toString());
      log("getMedicineCategories err: $e");
    }).whenComplete(() => isMedCategoryLoading(false));
  }

  Future<void> getManufacturerList({bool showLoader = true, String searchTxt = ''}) async {
    if (showLoader) {
      isManufacturerLoading(true);
    }
    await getManufacturers(PharmaApis.getManufacturerList(
      manufacturerList: manufacturerList,
      page: manufacturerPage.value,
      search: searchTxt,
      lastPageCallBack: (p0) {
        isManufacturerLastPage(p0);
      },
    )).then((value) {
      hasErrorFetchingManufacturer(false);
    }).catchError((e) {
      hasErrorFetchingManufacturer(true);
      errorMessageManufacturer(e.toString());
      log("getManufacturerList err: $e");
    }).whenComplete(() => isManufacturerLoading(false));
  }

  Future<void> getSupplierList({bool showLoader = true, String searchTxt = ''}) async {
    if (showLoader) {
      isSuppliersLoading(true);
    }
    await getSuppliers(PharmaApis.getSupplierList(
      supplierList: supplierList,
      page: suppliersPage.value,
      search: searchTxt,
      lastPageCallBack: (p0) {
        isSuppliersLastPage(p0);
      },
    )).then((value) {
      hasErrorFetchingSupplier(false);
    }).catchError((e) {
      hasErrorFetchingSupplier(true);
      errorMessageSupplier(e.toString());
      log("getSupplierList err: $e");
    }).whenComplete(() => isSuppliersLoading(false));
  }

  Future<void> saveMedicineToStock({bool showLoader = true}) async {
    Map<String, dynamic> request = {
      "name": medicineNameCont.text.trim(),
      "dosage": dosageCont.text.trim(),
      "form_id": selectedMedicineForm.value.id.toString(),
      "medicine_category_id": selectedMedCategory.value.id.toString(),
      "supplier_id": selectedSupplier.value.id.toString(),
      "contact_number": selectedSupplier.value.contactNumber,
      "payment_terms": selectedSupplier.value.paymentTerms,
      "expiry_date": expiryDateCont.text.trim(),
      "quntity": quantityCont.text.toInt(),
      "re_order_level": reOrderLevelCont.text.toInt(),
      "manufacturer": selectedManufacturer.value.id.toString(),
      "batch_no": batchNoCont.text,
      "start_serial_no": startSerialNoCont.text.toInt(),
      "end_serial_no": endSerialNoCont.text.toInt(),
      "purchase_price": purchasePriceCont.text.toDouble(),
      "selling_price": sellingPriceCont.text.toDouble(),
      "is_inclusive_tax": isInclusiveTax.value ? 1 : 0,
      "stock_value": stockValueCont.text.toDouble(),
      "note": noteCont.text.trim(),
    };

    if (showLoader) {
      isLoading(true);
    }
    log('saveMedicineToStock REQUEST: ${jsonEncode(request)}');

    await PharmaApis.saveMedicineToStock(request: request, id: medicineId).then((value) {
      toast(value.message.trim().isEmpty ? locale.value.medicineAddedToStockSuccessfully : value.message.trim());
      Get.back(result: true);
    }).catchError((e) {
      toast("Error: $e");
      log("saveMedicineToStock err: $e");
    }).whenComplete(() => isLoading(false));
  }

  @override
  void dispose() {
    super.dispose();
    medicineNameCont.dispose();
    dosageCont.dispose();
    categoryCont.dispose();
    medicineFormCont.dispose();
    noteCont.dispose();
    supplierCont.dispose();
    supplierContactNumberCont.dispose();
    supplierCountryCodeCont.dispose();
    paymentTermsCont.dispose();
    batchNoCont.dispose();
    startSerialNoCont.dispose();
    endSerialNoCont.dispose();
    purchasePriceCont.dispose();
    sellingPriceCont.dispose();
    expiryDateCont.dispose();
    quantityCont.dispose();
    reOrderLevelCont.dispose();
    stockValueCont.dispose();
    manufacturerCont.dispose();
    addManufacturerCont.dispose();
  }
}
