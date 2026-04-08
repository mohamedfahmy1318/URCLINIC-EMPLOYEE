import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../api/clinic_api.dart';
import '../../models/base_response_model.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../utils/constants.dart';
import 'bed_status_controller.dart';
import 'bed_type/model/bed_type_model.dart';
import 'model/bed_master_model.dart';

class AddEditBedController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController clinicCont = TextEditingController();
  TextEditingController clinicSearchCont = TextEditingController();
  TextEditingController bedNameCont = TextEditingController();
  TextEditingController bedTypeCont = TextEditingController();
  TextEditingController chargesCont = TextEditingController();
  TextEditingController capacityCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode clinicFocus = FocusNode();
  FocusNode bedNameFocus = FocusNode();
  FocusNode bedTypeFocus = FocusNode();
  FocusNode chargesFocus = FocusNode();
  FocusNode capacityFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  final _status = true.obs;

  bool get status => _status.value;

  set status(bool value) => _status.value = value;

  final _underMaintenance = false.obs;

  bool get underMaintenance => _underMaintenance.value;

  set underMaintenance(bool value) => _underMaintenance.value = value;

  final _bedTypes = <BedTypeElement>[].obs;

  List<BedTypeElement> get bedTypes => _bedTypes;

  final _selectedBedType = Rxn<BedTypeElement>();

  BedTypeElement? get selectedBedType => _selectedBedType.value;

  set selectedBedType(BedTypeElement? value) => _selectedBedType.value = value;

  BedMasterModel? initialBedData;

  RxBool isLoading = false.obs;

  // Add descriptionCharCount
  final _descriptionCharCount = 0.obs;

  int get descriptionCharCount => _descriptionCharCount.value;

  set descriptionCharCount(int value) => _descriptionCharCount.value = value;

  // Add isSaving
  final _isSaving = false.obs;

  bool get isSaving => _isSaving.value;

  set isSaving(bool value) => _isSaving.value = value;

  Rx<Future<RxList<ClinicData>>> getClinics =
      Future(() => RxList<ClinicData>()).obs;
  RxList<ClinicData> clinicList = RxList();
  RxInt selectedClinic = 0.obs;
  RxInt clinicPage = 1.obs;
  RxBool isClinicLoading = false.obs;

  AddEditBedController({this.initialBedData});

  bool get isBedFeatureAvailable => CoreServiceApis.isBedFeatureAvailable;

  @override
  void onInit() {
    super.onInit();
    if (isBedFeatureAvailable) {
      _loadInitialData();
    }
    if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) {
      getClinicList();
    }
  }

  Future<void> _loadInitialData() async {
    if (!isBedFeatureAvailable) return;

    isLoading(true);
    await fetchBedTypes();

    if (initialBedData != null) {
      bedNameCont.text = initialBedData!.bed.validate();
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)) {
        await getClinicList();
        final clinic = clinicList.firstWhereOrNull(
            (c) => c.id.toString() == initialBedData!.clinicId.toString());
        selectedClinic(clinic!.id);
        clinicCont.text = clinic.name;
      }
      chargesCont.text = initialBedData!.charges.validate().toString();
      capacityCont.text = initialBedData!.capacity.validate().toString();
      descriptionCont.text = initialBedData!.description.validate();
      status = initialBedData!.status == true;
      underMaintenance = initialBedData!.isUnderMaintenance ? true : false;

      final matchedType = bedTypes.firstWhereOrNull((element) {
        final typeName = initialBedData!.bedTypeName.validate();
        return element.type.trim().toLowerCase() ==
            typeName.trim().toLowerCase();
      });

      if (matchedType != null) {
        selectedBedType = matchedType;
        bedTypeCont.text = matchedType.type;
      }
    }
    isLoading(false);
  }

  Future<void> fetchBedTypes() async {
    if (!isBedFeatureAvailable) {
      _bedTypes.clear();
      return;
    }

    try {
      final fetchedTypes = await CoreServiceApis.getBedTypes();
      _bedTypes.assignAll(fetchedTypes); // this sets bedTypes observable
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(locale.value.somethingWentWrong);
      }
    }
  }

  Future<void> saveBed({bool isEdit = false}) async {
    if (!isBedFeatureAvailable) {
      return;
    }

    isLoading(true);
    if (!formKey.currentState!.validate()) {
      isLoading(false);
      return;
    }
    if (selectedBedType == null) {
      toast(locale.value.pleaseSelectRoleToRegister);
      isLoading(false);
      return;
    }
    final request = {
      'bed': bedNameCont.text,
      'bed_type_id': selectedBedType!.id.validate().toString(),
      'charges': chargesCont.text,
      'capacity': capacityCont.text,
      'description': descriptionCont.text,
      'status': status ? 1 : 0,
      'is_under_maintenance': underMaintenance,
      'clinic_id':
          loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)
              ? selectedClinic.value
              : selectedAppClinic.value.id,
      'clinic_admin_id': loginUserData.value.id.validate().toString(),
    };
    try {
      BaseResponseModel response;
      if (initialBedData == null) {
        response = await CoreServiceApis.addBed(request: request);
      } else {
        response = await CoreServiceApis.updateBed(
          bedId: initialBedData!.id,
          request: request,
        );
      }
      if (response.status == true) {
        toast(isEdit
            ? locale.value.bedEditedSuccessfully
            : locale.value.bedSavedSuccessfully);
        Get.back(result: true);
      } else if (response.message.isNotEmpty) {
        toast(response.message);
      }

      if (Get.isRegistered<BedStatusController>()) {
        final BedStatusController bedStatusController = Get.find();
        await bedStatusController.initializeData();
      }
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(locale.value.somethingWentWrong);
      }
    }
    isLoading(false);
  }

  @override
  void onClose() {
    bedNameCont.dispose();
    bedTypeCont.dispose();
    chargesCont.dispose();
    capacityCont.dispose();
    descriptionCont.dispose();
    super.onClose();
  }

  Future<void> getClinicList() async {
    isClinicLoading(true);
    await getClinics(ClinicApis.getClinicList(
      clinicList: clinicList,
      page: clinicPage.value,
      search: clinicSearchCont.text.trim(),
    )).then((value) {}).catchError((e) {
      log("getClinicList err: $e");
    }).whenComplete(() => isClinicLoading(false));
  }

  void onDescriptionChanged(String text) {
    _descriptionCharCount(text.length);
  }
}
