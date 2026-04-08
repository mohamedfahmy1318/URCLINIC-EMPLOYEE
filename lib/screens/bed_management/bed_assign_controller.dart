import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/utils/common_base.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/network/network_utils.dart';
import 'package:kivicare_clinic_admin/utils/api_end_points.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import '../../api/clinic_api.dart';
import '../bed_management/bed_type/model/bed_type_model.dart';
import '../clinic/model/clinics_res_model.dart';
import 'package:intl/intl.dart';
import '../Encounter/add_encounter/model/patient_model.dart';
import '../Encounter/model/encounters_list_model.dart';
import 'bed_status_controller.dart';
import 'model/bed_allocation_model.dart';
import 'model/bed_master_model.dart';

class BedAssignController extends GetxController {
  bool _shouldPersist = true;

  bool get isBedFeatureAvailable => CoreServiceApis.isBedFeatureAvailable;

  final formKey = GlobalKey<FormState>();

  FocusNode clinicFocus = FocusNode();
  FocusNode patientFocus = FocusNode();
  FocusNode encounterFocus = FocusNode();
  FocusNode bedTypeFocus = FocusNode();
  FocusNode roomFocus = FocusNode();
  FocusNode admissionDateFocus = FocusNode();
  FocusNode dischargeDateFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode weightFocus = FocusNode();
  FocusNode heightFocus = FocusNode();
  FocusNode bloodPressureFocus = FocusNode();
  FocusNode heartRateFocus = FocusNode();
  FocusNode bloodGroupFocus = FocusNode();
  FocusNode temperatureFocus = FocusNode();
  FocusNode symptomsFocus = FocusNode();
  FocusNode notesFocus = FocusNode();

  RxBool isLoading = false.obs;
  RxBool isAssigning = false.obs;
  RxBool isPatientSelectionEnabled = true.obs;
  RxBool isClinicSelectionEnabled = true.obs;
  RxBool isEncounterSelectionEnabled = true.obs;
  RxBool isClinicLoading = false.obs;

  RxBool get isAnyLoading => (isLoading.value || isAssigning.value).obs;

  TextEditingController patientController = TextEditingController();

  TextEditingController bedTypeController = TextEditingController();
  TextEditingController bedController = TextEditingController();
  TextEditingController admissionDateController = TextEditingController();
  TextEditingController dischargeDateController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController bloodPressureController = TextEditingController();
  TextEditingController heartRateController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  TextEditingController symptomsController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController encounterController = TextEditingController();
  TextEditingController clinicCont = TextEditingController();
  TextEditingController clinicSearchCont = TextEditingController();

  RxInt descriptionCharCount = 0.obs;

  Rx<PatientModel?> selectedPatient = Rx<PatientModel?>(null);
  Rx<PatientModel?> selectedPatientFromEncounter = Rx<PatientModel?>(null);
  Rx<BedTypeElement?> selectedBedType = BedTypeElement().obs;
  Rx<BedAllocationModel> selectedBed = BedAllocationModel().obs;
  RxInt selectedEncounterId = RxInt(-1);
  Rx<EncounterElement?> selectedEncounter = Rx<EncounterElement?>(null);

  RxBool isEditMode = false.obs;
  RxInt bedAllocationId = RxInt(-1);

  RxList<PatientModel> patientList = <PatientModel>[].obs;
  RxList<BedTypeElement> bedTypeList = <BedTypeElement>[].obs;
  RxList<BedAllocationModel> bedList = <BedAllocationModel>[].obs;
  RxList<EncounterElement> encounterList = <EncounterElement>[].obs;
  RxList<ClinicData> clinicList = RxList();
  RxInt selectedClinic = 0.obs;
  Rx<Future<RxList<ClinicData>>> getClinics =
      Future(() => RxList<ClinicData>()).obs;

  RxInt patientPage = 1.obs;
  RxInt clinicPage = 1.obs;
  RxBool isPatientLastPage = false.obs;
  RxString searchPatientQuery = "".obs;
  DateTime? tempDate;

  @override
  void onInit() {
    super.onInit();
    descriptionController.addListener(() {
      descriptionCharCount.value = descriptionController.text.length;
    });
    if (!isBedFeatureAvailable) {
      return;
    }
    if (!isPatientSelectionEnabled.value) {
      initializeData();
    }
  }

  Future<void> parseArguments() async {
    bool shouldPreserveData = false;

    if (Get.arguments != null && Get.arguments is Map) {
      Map<String, dynamic> args = Get.arguments;

      if (args.containsKey('isEdit') && args['isEdit'] == true) {
        shouldPreserveData = true;
        isEditMode.value = true;
        bedAllocationId.value = args['bedAllocationId'] ?? -1;

        if (bedAllocationId.value != -1) {
          await fetchAndPrefillBedAllocation(bedAllocationId.value);
        }

        if (args.containsKey('patientId') && args.containsKey('patientName')) {
          final patientId = args['patientId'] is int
              ? args['patientId']
              : int.tryParse(args['patientId']?.toString() ?? '');
          if (patientId != null) {
            final patientName = args['patientName'];
            final patient = PatientModel(id: patientId, fullName: patientName);
            selectedPatientFromEncounter.value = patient;
            selectedPatient.value = patient;
            patientController.text = patientName;
            isPatientSelectionEnabled.value = false;
            patientList.value = [patient];
          }
        }

        if (args.containsKey('encounterId')) {
          final encounterId = args['encounterId'] is int
              ? args['encounterId']
              : int.tryParse(args['encounterId']?.toString() ?? '');
          if (encounterId != null) {
            selectedEncounterId.value = encounterId;
            encounterController.text = "Encounter #$encounterId";
            isEncounterSelectionEnabled.value = false;
          }
        }

        if (args.containsKey('selectedBed')) {
          final selectedBedArg = args['selectedBed'];
          if (selectedBedArg != null) {
            final bedAllocationModel = BedAllocationModel(
              id: selectedBedArg['id'],
              bedTypeId: selectedBedArg['bedTypeName'] ?? '',
              bed: selectedBedArg['bed'] ?? '',
            );
            selectedBed.value = bedAllocationModel;
            bedController.text = selectedBedArg['bed'] ?? '';
            if (selectedBedArg['bedTypeName'] != null) {
              bedTypeController.text = selectedBedArg['bedTypeName'];
            }
          }
        }

        admissionDateController.text = args['assignDate'] != null
            ? DateTime.parse(args['assignDate'].toString()).formatDateYYYYmmdd()
            : '';
        dischargeDateController.text = args['dischargeDate'] != null
            ? DateTime.parse(args['dischargeDate'].toString())
                .formatDateYYYYmmdd()
            : '';
        descriptionController.text = args['description'] ?? '';
        temperatureController.text = args['temperature'] ?? '';
        symptomsController.text = args['symptoms'] ?? '';
        notesController.text = args['notes'] ?? '';
        weightController.text = args['weight']?.toString() ?? '';
        heightController.text = args['height']?.toString() ?? '';
        bloodPressureController.text = args['bloodPressure'] ?? '';
        heartRateController.text = args['heartRate']?.toString() ?? '';
        bloodGroupController.text = args['bloodGroup'] ?? '';
      } else if (args.containsKey('selectedBed')) {
        shouldPreserveData = true;
        final bed = args['selectedBed'];
        if (bed is BedMasterModel) {
          parseAssignArgumentsFromBedStatus(bed);
        }
      } else if (args.containsKey('encounter_id')) {
        shouldPreserveData = true;
        selectedEncounterId.value = args['encounter_id'];
        encounterController.text = "Encounter #${args['encounter_id']}";
        isEncounterSelectionEnabled.value = false;
      } else if (args.containsKey('patientId') &&
          args.containsKey('patientName')) {
        shouldPreserveData = true;
        final patient = PatientModel(
          id: args['patientId'],
          fullName: args['patientName'],
        );
        selectedPatientFromEncounter.value = patient;
        selectedPatient.value = patient;
        patientController.text = args['patientName'];
        isPatientSelectionEnabled.value = false;
        patientList.value = [patient];
        if (args.containsKey('encounter_id')) {
          selectedEncounterId.value = args['encounter_id'];
          encounterController.text = "Encounter #${args['encounter_id']}";
          isEncounterSelectionEnabled.value = false;
        }
      }

      if (args.containsKey('clinicId')) {
        selectedClinic.value = args['clinicId'];
        isClinicSelectionEnabled.value = false;
        if (args.containsKey('clinicName')) {
          clinicCont.text = args['clinicName'];
        }
      }
    }

    if (!shouldPreserveData) {
      clearAllFormFields();
    }

    if (!isBedFeatureAvailable) {
      bedTypeList.clear();
      bedList.clear();
      return;
    }

    await fetchBedTypes();
    if (bedTypeController.text.isNotEmpty) {
      final matchedBedType =
          bedTypeList.firstWhereOrNull((e) => e.type == bedTypeController.text);
      if (matchedBedType != null) {
        selectedBedType.value = matchedBedType;
        bedTypeController.text = matchedBedType.type;
        await fetchRooms();
        final roomMatch =
            bedList.firstWhereOrNull((r) => r.id == selectedBed.value.id);
        if (roomMatch != null) {
          selectedBed.value = roomMatch;
          bedController.text = roomMatch.bedTypeId;
        }
      }
    }
  }

  void clearAllFormFields() {
    patientController.clear();
    bedTypeController.clear();
    bedController.clear();
    admissionDateController.clear();
    dischargeDateController.clear();
    weightController.clear();
    heightController.clear();
    bloodPressureController.clear();
    heartRateController.clear();
    bloodGroupController.clear();
    temperatureController.clear();
    symptomsController.clear();
    notesController.clear();
    descriptionController.clear();
    encounterController.clear();

    selectedPatient.value = null;
    selectedPatientFromEncounter.value = null;
    selectedBedType.value = null;
    selectedBed.value = BedAllocationModel();
    selectedEncounterId.value = -1;
    selectedEncounter.value = null;
  }

  @override
  void onClose() {
    if (_shouldPersist) {
      return;
    }
    patientFocus.dispose();
    encounterFocus.dispose();
    bedTypeFocus.dispose();
    roomFocus.dispose();
    admissionDateFocus.dispose();
    dischargeDateFocus.dispose();
    descriptionFocus.dispose();
    weightFocus.dispose();
    heightFocus.dispose();
    bloodPressureFocus.dispose();
    heartRateFocus.dispose();
    bloodGroupFocus.dispose();
    temperatureFocus.dispose();
    symptomsFocus.dispose();
    notesFocus.dispose();
    patientController.dispose();
    bedTypeController.dispose();
    bedController.dispose();
    admissionDateController.dispose();
    dischargeDateController.dispose();
    weightController.dispose();
    heightController.dispose();
    bloodPressureController.dispose();
    heartRateController.dispose();
    bloodGroupController.dispose();
    temperatureController.dispose();
    symptomsController.dispose();
    notesController.dispose();
    descriptionController.dispose();
    encounterController.dispose();
    super.onClose();
  }

  Future<void> initializeData() async {
    if (!isBedFeatureAvailable) {
      bedTypeList.clear();
      bedList.clear();
      return;
    }

    isLoading(true);
    try {
      await parseArguments();
      if (Get.arguments != null && Get.arguments is Map) {
        Map<String, dynamic> args = Get.arguments;

        if (args.containsKey('patientId') && args.containsKey('patientName')) {
          final int patientId = args['patientId'];
          final String patientName = args['patientName'];
          final patient = PatientModel(
              id: patientId,
              firstName: patientName.split(' ').first,
              lastName: patientName.split(' ').last);
          selectedPatientFromEncounter(patient);
          selectedPatient(patient);
          patientController.text = patientName;
          isPatientSelectionEnabled.value = false;
          patientList.value = [patient];

          if (args.containsKey('encounter_id')) {
            selectedEncounterId.value = args['encounter_id'];
            encounterController.text = "Encounter #${args['encounter_id']}";
            isEncounterSelectionEnabled.value = false;
          }
        } else if (args.containsKey('isFromBedStatus') == true) {
          isPatientSelectionEnabled(true);
          await fetchPatients(showloader: false);
        } else if (args.containsKey('selectedBed')) {
          await fetchPatients(showloader: false);
        }
      } else {
        isPatientSelectionEnabled(true);
        await fetchPatients(showloader: false);
      }
      await fetchBedTypes();
      if (bedTypeController.text.isNotEmpty) {
        final bedTypeName = bedTypeController.text;
        final matchedBedType =
            bedTypeList.firstWhereOrNull((e) => e.type == bedTypeName);

        if (matchedBedType != null) {
          selectedBedType.value = matchedBedType;
          bedTypeController.text = matchedBedType.type;
          selectedBed.value.bedTypeId = matchedBedType.type;

          await fetchRooms();
          final roomMatch =
              bedList.firstWhereOrNull((r) => r.id == selectedBed.value.id);
          if (roomMatch != null) {
            selectedBed.value = roomMatch;
            bedController.text = roomMatch.bed ?? '';
          }
        } else {
          selectedBedType.value = null;
          bedTypeController.clear();
          bedList.clear();
        }
      } else if (selectedBedType.value != null) {
        final match = bedTypeList
            .firstWhereOrNull((e) => e.id == selectedBedType.value!.id);
        if (match != null) {
          selectedBedType.value = match;
          bedTypeController.text = match.type;
        }
        await fetchRooms();
        final roomMatch =
            bedList.firstWhereOrNull((r) => r.id == selectedBed.value.id);
        if (roomMatch != null) {
          selectedBed.value = roomMatch;
          bedController.text = roomMatch.bed ?? '';
        }
      } else {
        bedList.clear();
      }
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        throw (e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchPatients({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    try {
      await CoreServiceApis.getPatientsList(
        patientsList: patientList,
        page: patientPage.value,
        search: searchPatientQuery.value,
        clinicId: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)
            ? selectedAppClinic.value.id
            : null,
        lastPageCallBack: (p0) {
          isPatientLastPage(p0);
        },
      );
      patientList.refresh();
    } catch (e) {
      toast(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchBedTypes() async {
    if (!isBedFeatureAvailable) {
      bedTypeList.clear();
      return;
    }

    try {
      final types = await CoreServiceApis.getBedTypes();
      bedTypeList.assignAll(types);
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(e.toString());
      }
    }
  }

  Future<void> fetchRooms() async {
    if (!isBedFeatureAvailable) {
      bedList.clear();
      bedList.refresh();
      return;
    }

    try {
      if (selectedBedType.value == null || selectedBedType.value!.id == 0) {
        toast(locale.value.pleaseSelectBedType);
        bedList.clear();
        bedList.refresh();
        return;
      }
      isLoading(true);

      final int? clinicId =
          loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)
              ? selectedAppClinic.value.id
              : null;

      final bedsRx = await CoreServiceApis.getBedList(
        bedList: <BedMasterModel>[],
        page: 1,
        perPage: 50,
        bedTypeId: selectedBedType.value!.id,
        clinicId: clinicId,
      );

      bedList.value = bedsRx
          .map(
            (bed) => BedAllocationModel.fromJson(bed.toJson()),
          )
          .where((bed) =>
              bed.bedTypeName == selectedBedType.value?.type &&
              bed.bedStatus == 'available' &&
              (bed.isUnderMaintenance == null ||
                  bed.isUnderMaintenance == false))
          .toList();
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchEncounters(int patientId) async {
    try {
      isLoading(true);
      final response = await buildHttpResponse(
        '${APIEndPoints.getEncounterList}?patient_id=$patientId',
        method: HttpMethodType.GET,
      );
      final result = await handleResponse(response);
      if (result != null) {
        var allEncounters = EncounterListRes.fromJson(result).data;
        encounterList.value = allEncounters
            .where((encounter) => encounter.userId == patientId)
            .toList();
      }
    } catch (e) {
      toast(e.toString());
    } finally {
      isLoading(false);
    }
  }

  void selectPatient(PatientModel patient) {
    selectedPatient.value = patient;
    patientController.text = patient.fullName.validate();
    encounterController.clear();
    selectedEncounterId.value = -1;
    selectedEncounter.value = null;
    fetchEncounters(patient.id);
  }

  void selectBedType(BedTypeElement bedType) {
    selectedBedType.value = bedType;
    bedTypeController.text = bedType.type;
    selectedBed.value = BedAllocationModel();
    bedController.text = '';
    fetchRooms();
  }

  void selectBed(BedAllocationModel bed) {
    selectedBed.value = bed;
    bedController.text = bed.bed.validate();
  }

  void selectEncounter(EncounterElement encounter) {
    selectedEncounterId.value = encounter.id;
    selectedEncounter.value = encounter;
    encounterController.text = "Encounter #${encounter.id}";

    if (selectedPatient.value == null) {
      selectedPatient.value = PatientModel(
        id: encounter.userId,
        fullName: encounter.userName,
      );
      patientController.text = encounter.userName;
      isPatientSelectionEnabled.value = false;
    }
  }

  Future<void> pickAssignDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();

    if (admissionDateController.text.isNotEmpty) {
      try {
        initialDate =
            DateFormat('dd-MM-yyyy').parse(admissionDateController.text);
      } catch (e) {
        initialDate = DateTime.now();
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      admissionDateController.text = picked.formatDateDDMMYYYY();
      tempDate = picked.add(const Duration(days: 1));
    }
  }

  Future<void> pickDischargeDate(BuildContext context) async {
    if (admissionDateController.text.isEmpty) {
      return toast(locale.value.pleaseSelectAdmissionDateFirst);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tempDate,
      firstDate: tempDate!,
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      dischargeDateController.text = picked.formatDateDDMMYYYY();
    }
  }

  Future<int?> getBedIdFromBedName(String bedName) async {
    if (!isBedFeatureAvailable) return null;

    try {
      int? bedId = await CoreServiceApis.getBedIdByName(bedName);

      bedId ??= await CoreServiceApis.getBedIdByNameFromBedList(bedName);
      return bedId;
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(e.toString());
      }
    }
    return null;
  }

  Future bedAllocation() async {
    if (!isBedFeatureAvailable) {
      return;
    }

    isLoading(true);
    try {
      isLoading(true);
      if (selectedBedType.value == null || selectedBedType.value!.id == 0) {
        toast(locale.value.pleaseSelectBedType);
        return;
      }

      int? bedId;
      if (selectedBed.value.bed != null) {
        bedId = await getBedIdFromBedName(selectedBed.value.bed!);
      }

      if (bedId == null) {
        toast(locale.value.couldNotFindBedId);
        return;
      }

      Map<String, dynamic> request = {
        'clinic_id':
            loginUserData.value.userRole.contains(EmployeeKeyConst.vendor)
                ? selectedClinic.value
                : selectedAppClinic.value.id,
        'encounter_id': selectedEncounterId.value.toString(),
        'clinic_admin_id': loginUserData.value.id.toString(),
        'bed_type_id': selectedBedType.value!.id.toString(),
        'room_no': bedId.toString(),
        'assign_date': admissionDateController.text,
        'discharge_date': dischargeDateController.text,
        'description': descriptionController.text,
        'weight': weightController.text.isEmpty ? "" : weightController.text,
        'height': heightController.text.isEmpty ? "" : heightController.text,
        'blood_pressure': bloodPressureController.text.isEmpty
            ? ""
            : bloodPressureController.text,
        'heart_rate':
            heartRateController.text.isEmpty ? "" : heartRateController.text,
        'blood_group':
            bloodGroupController.text.isEmpty ? "" : bloodGroupController.text,
        'temperature': temperatureController.text.isEmpty
            ? ""
            : temperatureController.text,
        'symptoms': symptomsController.text,
        'notes': notesController.text,
        'patient_encounter_id': selectedEncounterId.value.toString(),
        'patientName': selectedPatient.value?.fullName,
      };
      await CoreServiceApis.bedAllocationApi(request: request);
      toast(locale.value.bedAssignedSuccessfully);
      if (Get.isRegistered<BedStatusController>()) {
        final BedStatusController bedStatusController = Get.find();
        await bedStatusController.initializeData();
      }
      isLoading(false);
      Get.back();
    } catch (e) {
      isLoading(false);
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  void searchPatient(String query) {
    if (query.isEmpty) {
      fetchPatients();
    } else {
      patientList.value = patientList
          .where((patient) =>
              patient.fullName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void searchEncounter(String query) {
    if (query.isEmpty) {
      fetchEncounters(selectedPatient.value!.id);
    } else {
      encounterList.value = encounterList
          .where((encounter) =>
              encounter.userName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void searchBedTypes(String query) {
    if (!isBedFeatureAvailable) {
      bedTypeList.clear();
      return;
    }

    if (query.isEmpty) {
      fetchBedTypes();
    } else {
      bedTypeList.value = bedTypeList
          .where((bedType) =>
              bedType.type.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> refreshData() async {
    if (!isBedFeatureAvailable) {
      bedTypeList.clear();
      bedList.clear();
      return;
    }

    if (isLoading.value) return;

    isLoading(true);
    try {
      await Future.wait([
        fetchPatients(showloader: false),
        fetchBedTypes(),
      ]);
      if (selectedBedType.value != null) {
        await fetchRooms();
      }
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  bool get hasFormData {
    return selectedPatient.value != null ||
        selectedBedType.value != null ||
        selectedBed.value.id > 0 ||
        patientController.text.isNotEmpty ||
        bedTypeController.text.isNotEmpty ||
        bedController.text.isNotEmpty ||
        admissionDateController.text.isNotEmpty ||
        dischargeDateController.text.isNotEmpty ||
        weightController.text.isNotEmpty ||
        heightController.text.isNotEmpty ||
        bloodPressureController.text.isNotEmpty ||
        heartRateController.text.isNotEmpty ||
        bloodGroupController.text.isNotEmpty ||
        temperatureController.text.isNotEmpty ||
        symptomsController.text.isNotEmpty ||
        notesController.text.isNotEmpty ||
        descriptionController.text.isNotEmpty ||
        encounterController.text.isNotEmpty;
  }

  bool get isFormEmpty {
    return !hasFormData;
  }

  void setPersistence(bool persist) {
    _shouldPersist = persist;
  }

  void forceDispose() {
    _shouldPersist = false;
  }

  void onScreenExit() {
    clearAllFormFields();
  }

  Future<void> onScreenVisible() async {
    if (!isBedFeatureAvailable) {
      bedTypeList.clear();
      bedList.clear();
      return;
    }

    if (isLoading.value) {
      return;
    }
    try {
      await fetchBedTypes();
      if (selectedBedType.value != null) {
        await fetchRooms();
      } else {
        bedList.clear();
      }
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(e.toString());
      }
    }
  }

  String? getPatientNameById(int? id) {
    if (id == null) return null;
    return patientList.firstWhereOrNull((p) => p.id == id)?.fullName;
  }

  Future<void> fetchAndPrefillBedAllocation(int id) async {
    if (!isBedFeatureAvailable) {
      return;
    }

    try {
      isLoading(true);
      final response = await buildHttpResponse(
        "${APIEndPoints.bedAllocation}/$id",
        method: HttpMethodType.GET,
      );

      final result = await handleResponse(response);
      if (result != null && result['data'] != null) {
        final data = result['data'];
        patientController.text = data['patientName'] ?? '';
        bedTypeController.text = data['bedTypeName'] ?? '';
        bedController.text = data['bed'] ?? '';
        admissionDateController.text = data['assignDate'] ?? '';
        dischargeDateController.text = data['dischargeDate'] ?? '';
        descriptionController.text = data['description'] ?? '';
        weightController.text = data['weight']?.toString() ?? '';
        heightController.text = data['height']?.toString() ?? '';
        bloodPressureController.text = data['bloodPressure'] ?? '';
        heartRateController.text = data['heartRate']?.toString() ?? '';
        bloodGroupController.text = data['bloodGroup'] ?? '';
        temperatureController.text = data['temperature']?.toString() ?? '';
        symptomsController.text = data['symptoms'] ?? '';
        notesController.text = data['notes'] ?? '';
        encounterController.text = data['encounterId'] != null
            ? 'Encounter #${data['encounterId']}'
            : '';
        selectedEncounterId.value = data['encounterId'] ?? -1;
      }
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  void parseAssignArgumentsFromBedStatus(BedMasterModel bed) {
    final bedTypeName = bed.bedTypeId;
    final bedName = bed.bed;
    final bedId = bed.id;
    final bedAllocationModel = BedAllocationModel(
      id: bedId,
      bedTypeId: bedTypeName,
      bed: bedName,
    );
    selectedBed.value = bedAllocationModel;
    bedController.text = bedName;
    bedTypeController.text = bedTypeName;
  }

  Future<void> getClinicList() async {
    isClinicLoading(true);
    await getClinics(
      ClinicApis.getClinicList(
        clinicList: clinicList,
        page: clinicPage.value,
        search: clinicSearchCont.text.trim(),
      ),
    ).catchError((e) {
      throw (e);
    }).whenComplete(() => isClinicLoading(false));
  }

  @override
  void onReady() {
    super.onReady();
    if (isBedFeatureAvailable) {
      initializeData();
    }
  }
}
