import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/clinical_details/components/prescription_form_data.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/model/enc_dashboard_detail_res.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../api/core_apis.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../pharma/medicine/model/medicine_resp_model.dart';
import '../../bed_management/model/bed_allocation_model.dart';
import '../../bed_management/model/bed_master_model.dart';
import '../add_encounter/model/prescription_model.dart';
import '../model/enc_dashboard_req.dart';
import '../model/encounter_invoice_resp.dart';
import '../model/encounters_list_model.dart';
import '../model/problems_observations_model.dart';


class ClinicalDetailsController extends GetxController {
  //TextField Controller
  final GlobalKey<FormState> clinicalDetailsFormKey = GlobalKey();

  TextEditingController otherInfoCont = TextEditingController();

  //Bill TextField Controller
  final GlobalKey<FormState> addPrescriptionFormKey = GlobalKey();
  TextEditingController nameCont = TextEditingController();
  TextEditingController frequencyCont = TextEditingController();
  TextEditingController durationCont = TextEditingController();
  TextEditingController instructionCont = TextEditingController();
  final TextEditingController quantityCont = TextEditingController();
  final TextEditingController dosageCont = TextEditingController();
  final TextEditingController formCont = TextEditingController();

  //FocusNode
  FocusNode nameFocus = FocusNode();
  FocusNode frequencyFocus = FocusNode();
  FocusNode durationFocus = FocusNode();
  FocusNode instructionFocus = FocusNode();
  final FocusNode quantityFocus = FocusNode();
  final FocusNode dosageFocus = FocusNode();
  final FocusNode formFocus = FocusNode();

  //Clinic
  Rx<Future<RxList<CMNElement>>> getProblems = Future(() => RxList<CMNElement>()).obs;
  Rx<Future<RxList<CMNElement>>> getObservations = Future(() => RxList<CMNElement>()).obs;
  RxBool isLoading = false.obs;
  RxBool isIPD = false.obs;
  RxBool hasAllocatedBed = false.obs;
  Rx<BedAllocationModel?> bedAllocationDetails = Rx<BedAllocationModel?>(null);
  Rx<BedMasterModel?> allocatedBedDetails = Rx<BedMasterModel?>(null);

  Rx<EncounterElement> encounterData = EncounterElement().obs;

  RxList<CMNElement> observations = RxList();
  RxList<CMNElement> selectedObservation = RxList();

  RxList<CMNElement> problems = RxList();
  RxList<CMNElement> selectedProblems = RxList();

  RxList<CMNElement> notes = RxList();
  RxList<CMNElement> selectedNotes = RxList();

  //Get Prescription
  RxList<Prescription> prescriptionList = RxList();
  Rx<EncounterInvoiceResp> downloadPrescriptionRes = EncounterInvoiceResp().obs;

  //Medicine
  //Rx<Medicine> selectedMedicine = Medicine.fromJson({}).obs;
  RxList<Medicine> selectedMedicines = <Medicine>[].obs;

  Rx<Pharma> selectedPharma = Pharma().obs;

  ///Search
  TextEditingController searchCont = TextEditingController();
  RxBool isSearchText = false.obs;
  StreamController<String> searchStream = StreamController<String>();
  final _scrollController = ScrollController();

  RxBool isBedAssigned = false.obs;
  Rx<BedMasterModel?> bedDetails = Rx<BedMasterModel?>(null);

  Rx<EncounterDashboardDetail?> encounterDashboardDetail = Rx<EncounterDashboardDetail?>(null);

  void savePrescription() {
    prescriptionList.add(
      Prescription(
        name: nameCont.text.trim(),
        frequency: frequencyCont.text.trim(),
        duration: durationCont.text.trim(),
        instruction: instructionCont.text.trim(),
        // if Pharma is active
        medicine: selectedMedicines.isNotEmpty ? selectedMedicines.first : Medicine.fromJson({}),
        quantity: quantityCont.text.trim().toInt(),
      ),
    );
    Get.back();
  }

  void getClearPrescription() {
    // if Pharma is active
    dosageCont.clear();
    formCont.clear();
    quantityCont.clear();
    // if Pharma inactive
    nameCont.clear();
    frequencyCont.clear();
    durationCont.clear();
    instructionCont.clear();
  }

  void setMedicineForms(List<Medicine> meds) {
    for (var med in meds) {
      final index = prescriptionFormDataList.indexWhere((p0) => p0.medicine.id == med.id);
      if (index == -1) prescriptionFormDataList.add(PrescriptionFormData(medicine: med));
    }
    selectedMedicines.assignAll(meds);
  }

  void saveMultiplePrescription() {
    for (final form in prescriptionFormDataList) {
      final index = prescriptionList.indexWhere((prescription) => prescription.medicine.id == form.medicine.id);
      if (index != -1) {
        prescriptionList[index].frequency = form.frequencyCont.text.trim();
        prescriptionList[index].duration = form.durationCont.text.trim();
        prescriptionList[index].quantity = form.quantityCont.text.trim().toInt();
        prescriptionList[index].instruction = form.instructionCont.text.trim();
      } else {
        prescriptionList.add(
          Prescription(
            name: form.medicine.name,
            frequency: form.frequencyCont.text.trim(),
            duration: form.durationCont.text.trim(),
            instruction: form.instructionCont.text.trim(),
            medicine: form.medicine,
            quantity: form.quantityCont.text.trim().toInt(),
          ),
        );
      }
    }
    Get.back();
    prescriptionList.refresh();
  }

  void getEditData(int index) {
    //if Pharma is active
    nameCont.text = prescriptionList[index].medicine.name;
    dosageCont.text = prescriptionList[index].medicine.dosage;
    formCont.text = prescriptionList[index].medicine.form.name;
    quantityCont.text = prescriptionList[index].quantity.toString();
    //if Pharma inactive
    nameCont.text = prescriptionList[index].name;
    frequencyCont.text = prescriptionList[index].frequency;
    durationCont.text = prescriptionList[index].duration;
    instructionCont.text = prescriptionList[index].instruction;
  }

  void saveEditData(int index) {
    final prescription = prescriptionList[index];
    prescription.name = nameCont.text;
    debugPrint('PRESCRIPTION.NAME: ${prescription.name}');
    prescription.frequency = frequencyCont.text;
    prescription.duration = durationCont.text;
    prescription.instruction = instructionCont.text;
    prescription.quantity = quantityCont.text.trim().toInt();

    if (selectedMedicines.isNotEmpty) {
      prescription.medicine = selectedMedicines.first;
    }

    prescriptionList.refresh();
    Get.back();
  }

  @override
  void onInit() {
    if (Get.arguments is EncounterElement) {
      encounterData(Get.arguments as EncounterElement);
    }
    getEncouterDetails();
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchStream.stream.debounce(const Duration(milliseconds: 750)).listen((type) {
      if (type == EncounterDropdownTypes.encounterProblem) {
        getEncProblems();
      } else if (type == EncounterDropdownTypes.encounterObservations) {
        getEncObservations();
      } else if (type == EncounterDropdownTypes.encounterNotes) {
        setSelectedValues(type: EncounterDropdownTypes.encounterNotes);
      }
    });
    getEncProblems();
    getEncObservations();
    super.onInit();
  }

  Future<void> getEncouterDetails() async {
    isLoading(true);
    await CoreServiceApis.encounterDashboardDetail(encounterData.value.id).then((res) {
      selectedProblems(res.value.problems);
      selectedObservation(res.value.observations);
      selectedNotes(res.value.notes);
      prescriptionList(res.value.prescriptions);
      otherInfoCont.text = res.value.otherDetails;
      encounterDashboardDetail(res.value);
      if (res.value.bedAllocations.isNotEmpty) {
        hasAllocatedBed(true);
        encounterData.value.allocatedBed = res.value.bedAllocations.first.bedTypeName;
        encounterData.refresh();
        allocatedBedDetails(BedMasterModel(
          id: res.value.bedAllocations.first.bedMasterId,
          patientId: res.value.bedAllocations.first.patientId,
          // Add more mappings as needed
        ));
      } else {
        hasAllocatedBed(false);
        encounterData.value.allocatedBed = null;
        encounterData.refresh();
        allocatedBedDetails(null);
      }
    }).catchError((e) {
      log("getEncouterDetails Err : $e");
      isBedAssigned(false);
      bedDetails(null);
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getEncProblems({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await getProblems(CoreServiceApis.getEncProblems(search: searchCont.text.trim())).then((value) {
      for (var element in value) {
        if (problems.indexWhere((p0) => element.id == p0.id).isNegative) {
          problems.add(element);
        }
      }
      setSelectedValues(type: EncounterDropdownTypes.encounterProblem);
    }).catchError((e) {
      log("getEncProblems err: $e");
    }).whenComplete(() => isLoading(false));
  }

  void setSelectedValues({required String type}) {
    if (type == EncounterDropdownTypes.encounterProblem) {
      for (int i = 0; i < problems.length; i++) {
        if (selectedProblems.indexWhere((element) => element.id == problems[i].id) != -1) {
          problems[i].isSelected(true);
        } else {
          problems[i].isSelected(false);
        }
      }
    } else if (type == EncounterDropdownTypes.encounterObservations) {
      for (int i = 0; i < observations.length; i++) {
        if (selectedObservation.indexWhere((element) => element.id == observations[i].id) != -1) {
          observations[i].isSelected(true);
        } else {
          observations[i].isSelected(false);
        }
      }
    } else if (type == EncounterDropdownTypes.encounterNotes) {
      for (int i = 0; i < notes.length; i++) {
        if (selectedNotes.indexWhere((element) => element.id == notes[i].id) != -1) {
          notes[i].isSelected(true);
        } else {
          notes[i].isSelected(false);
        }
      }
    }
  }

  Future<void> getEncObservations({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await getObservations(CoreServiceApis.getEncObservations(search: searchCont.text.trim())).then((value) {
      observations(value);
      for (int i = 0; i < observations.length; i++) {
        if (selectedObservation.indexWhere((element) => element.id == observations[i].id) != -1) {
          observations[i].isSelected(true);
        } else {
          observations[i].isSelected(false);
        }
      }
    }).catchError((e) {
      log("getEncObservations err: $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> saveEncounterDashboard() async {
    isLoading(true);
    EncounterDashboardReq encounterDashboardReq = EncounterDashboardReq(
      encounterId: encounterData.value.id,
      userId: encounterData.value.userId,
      problems: selectedProblems,
      observations: selectedObservation,
      notes: selectedNotes,
      prescriptions: prescriptionList,
      otherInformation: otherInfoCont.text.trim(),
      pharmaId: selectedPharma.value.id,
    );

    CoreServiceApis.saveEncounterDashboard(request: encounterDashboardReq.toJson()).then((value) {
      toast(value.message);
      Get.back();
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getDownloadPrescription({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await CoreServiceApis.downloadPrescription(encounterData.value.id).then((res) {
      downloadPrescriptionRes(res.value);
      if (res.value.status == true && res.value.link.isNotEmpty) {
        viewFiles(res.value.link);
      }
    }).catchError((e) {
      log("getEncounterDashboardDetail Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  @override
  void onClose() {
    searchStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}
