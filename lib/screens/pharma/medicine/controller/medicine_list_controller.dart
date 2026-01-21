import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../../api/pharma_apis.dart';
import '../../../../utils/constants.dart';
import '../model/medicine_resp_model.dart';

enum MedicineScreenType { all, top, expired, lowStock, select }

class MedicinesListController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<Future<RxList<Medicine>>> getMedicines = Future(() => RxList<Medicine>()).obs;
  RxList<Medicine> medicineList = RxList();
  RxList<Medicine> selectedMedicines = <Medicine>[].obs;

  RxBool isMedicineLastPage = false.obs;
  RxInt medicinePage = 1.obs;

  //Search
  RxBool isSearchMedicinesText = false.obs;
  RxBool isSearchFilterMedicinesText = false.obs;
  TextEditingController searchMedicinesCont = TextEditingController();
  TextEditingController filterMedicinesCont = TextEditingController();
  TextEditingController filterFormCont = TextEditingController();
  TextEditingController filterCategoryCont = TextEditingController();
  TextEditingController filterSupplierCont = TextEditingController();

  StreamController<String> searchMedicinesStream = StreamController<String>();
  StreamController<String> searchFilterMedicinesStream = StreamController<String>();
  final _scrollController = ScrollController();

  //AppBar Title according to screen type

  RxString emptyMessageText = locale.value.noMedicineFound.obs;
  RxString emptySubMessageText = locale.value.oopsNoMedicinesFound.obs;

  RxString errorQuantityText = ''.obs;
  RxString errorDeliveryDateText = ''.obs;

  MedicineScreenType screenType = MedicineScreenType.all;
  int clinicId = 0;

  final GlobalKey<FormState> addMedicineFormKey = GlobalKey();
  TextEditingController nameCont = TextEditingController();
  TextEditingController frequencyCont = TextEditingController();
  TextEditingController durationCont = TextEditingController();
  TextEditingController instructionCont = TextEditingController();
  final TextEditingController quantityCont = TextEditingController();
  final TextEditingController dosageCont = TextEditingController();
  final TextEditingController formCont = TextEditingController();
  final TextEditingController deliveryDate = TextEditingController();

  //FocusNode
  FocusNode nameFocus = FocusNode();
  FocusNode frequencyFocus = FocusNode();
  FocusNode durationFocus = FocusNode();
  FocusNode instructionFocus = FocusNode();
  final FocusNode quantityFocus = FocusNode();
  final FocusNode dosageFocus = FocusNode();
  final FocusNode formFocus = FocusNode();
  Rx<Future<RxList<MedicineForm>>> getMedicineForms = Future(() => RxList<MedicineForm>()).obs;
  RxList<MedicineForm> medicineForms = RxList();

  Rx<Future<RxList<MedicineCategory>>> getMedCategories = Future(() => RxList<MedicineCategory>()).obs;

  RxList<MedicineCategory> medCategories = RxList();

  Rx<Future<RxList<Supplier>>> getSuppliers = Future(() => RxList<Supplier>()).obs;

  RxList<Supplier> supplierList = RxList();
  RxInt selectedFilerCount = 0.obs;

  RxList<String> selectedMedicinesList = <String>[].obs;

  RxList<String> selectedMedicineForm = <String>[].obs;
  RxList<String> selectedMedicineCategory = <String>[].obs;
  RxList<String> selectedMedicineSupplier = <String>[].obs;
  RxString searchText = "".obs;
  RxInt selectedTabIndex = 0.obs;

  RxString appBarTitle = locale.value.medicines.obs;
  RxInt pharmaId = 0.obs;
  RxList<int> medsAlreadyInPresc = RxList();

  @override
  void onInit() {
    if (Get.arguments is MedicineScreenType) {
      screenType = Get.arguments as MedicineScreenType;
    }
    if (Get.arguments is Medicine) {
      screenType = MedicineScreenType.select;
    }
    if (Get.arguments is Map) {
      Get.arguments['pharmaId'] != null ? pharmaId.value = Get.arguments['pharmaId'] as int : pharmaId.value = 0;
      if (Get.arguments['medsAlreadyInPresc'] is List<int>) {
        medsAlreadyInPresc(Get.arguments['medsAlreadyInPresc'] as List<int>);
      }
    }
    if (Get.arguments is List<int>) {
      debugPrint('GET.ARGUMENTS: ${Get.arguments}');
      medsAlreadyInPresc(Get.arguments as List<int>);
    }
    clinicId = loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? selectedAppClinic.value.id : -1;
    getAppBarTitle();
    super.onInit();
  }

  @override
  void onReady() {
    // Set the app bar title based on the screen type
    getAppBarTitle();

    // Set the empty message text based on the screen type
    getEmptyMessageText();

    // Add listener to scroll controller to hide keyboard when scrolling
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    if (!searchMedicinesStream.hasListener) {
      // Debounce the search stream to avoid too many calls
      searchMedicinesStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
        getMedicineList(clinicId: clinicId);
      });
    }
    if (searchFilterMedicinesStream.hasListener) {
      searchFilterMedicinesStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
        getMedicineList(
          clinicId: clinicId,
          searchMedicineName: selectedMedicinesList,
          searchMedicineForm: selectedMedicineForm,
          searchMedicineCategory: selectedMedicineCategory,
          searchMedicineSupplier: selectedMedicineSupplier,
        );
      });
    } else {
      searchFilterMedicinesStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
        getMedicineList(
          clinicId: clinicId,
          searchMedicineName: selectedMedicinesList,
          searchMedicineForm: selectedMedicineForm,
          searchMedicineCategory: selectedMedicineCategory,
          searchMedicineSupplier: selectedMedicineSupplier,
        );
      });
    }

    // Initialize the medicine list
    getMedicineList(clinicId: clinicId);
    super.onReady();
  }

  void getAppBarTitle() {
    switch (screenType) {
      case MedicineScreenType.top:
        appBarTitle(locale.value.topMedicines);
        break;
      case MedicineScreenType.expired:
        appBarTitle(locale.value.upcomingExpiryMedicine);
        break;
      case MedicineScreenType.lowStock:
        appBarTitle(locale.value.lowStockMedicines);
        break;
      case MedicineScreenType.select:
        appBarTitle(locale.value.selectMedicine);
        break;
      default:
        appBarTitle(locale.value.medicines);
        break;
    }
  }

  void getEmptyMessageText() {
    switch (screenType) {
      case MedicineScreenType.top:
        emptyMessageText(locale.value.noTopMedicineFound);
        emptySubMessageText(locale.value.oopsNoTopMedicines);
        break;
      case MedicineScreenType.expired:
        emptyMessageText(locale.value.noExpiredMedicineFound);
        emptySubMessageText(locale.value.oopsNoExpiredMedicines);
        break;
      case MedicineScreenType.lowStock:
        emptyMessageText(locale.value.noLowStockMedicinesFound);
        emptySubMessageText(locale.value.oopsNoLowStockMedicines);
        break;
      default:
        emptyMessageText(locale.value.noMedicineFound);
        emptySubMessageText(locale.value.oopsNoMedicinesFound);
        break;
    }
  }

  Future<void> getMedicineList({
    bool showLoader = true,
    int clinicId = 0,
    List<String> searchMedicineName = const [],
    List<String> searchMedicineForm = const [],
    List<String> searchMedicineCategory = const [],
    List<String> searchMedicineSupplier = const [],
  }) async {
    if (showLoader) {
      isLoading(true);
    }
    await getMedicines(
      PharmaApis.getMedicineList(
        search: searchMedicinesCont.text.trim(),
        screenType: screenType,
        medicineList: medicineList,
        searchMedicineName: searchMedicineName,
        searchMedicineForm: searchMedicineForm,
        searchMedicineCategory: searchMedicineCategory,
        searchMedicineSupplier: searchMedicineSupplier,
        pharmaId: pharmaId.value,
        clinicId: clinicId,
        page: medicinePage.value,
        lastPageCallBack: (p0) {
          isMedicineLastPage(p0);
        },
      ),
    ).catchError((e) {
      throw(e);
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getMedicineFormList({bool showLoader = true, String searchTxt = ''}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getMedicineForms(
      PharmaApis.getMedicineForms(medicineForms: medicineForms, search: searchTxt),
    ).then((value) async {}).catchError((e) {
      log("getMedicineFormList err: $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getMedicineCategoryList({bool showLoader = true, String searchTxt = ''}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getMedCategories(PharmaApis.getMedicineCategory(medCategoryList: medCategories, search: searchTxt)).then((value) {}).catchError((e) {
      log("getMedicineCategories err: $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getSupplierList({bool showLoader = true, String searchTxt = ''}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getSuppliers(
      PharmaApis.getSupplierList(supplierList: supplierList, search: searchTxt, status: "1"),
    ).then((value) {}).catchError((e) {
      log("getSupplierList err: $e");
    }).whenComplete(() => isLoading(false));
  }

  @override
  void onClose() {
    searchMedicinesStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}
