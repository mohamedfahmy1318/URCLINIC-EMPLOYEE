import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/pharma_apis.dart';
import 'package:kivicare_clinic_admin/models/base_response_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/add_medicine_to_prescription_screen.dart';
import 'package:kivicare_clinic_admin/screens/pharma/prescriptions/model/prescription_detail_res_model.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../prescriptions/controller/all_prescription_controller.dart';
import '../model/medicine_resp_model.dart';

class AddMedToPrescController extends GetxController {
  //TextField Controller
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
  RxString stockWarning = ''.obs;

  //FocusNode
  FocusNode nameFocus = FocusNode();
  FocusNode frequencyFocus = FocusNode();
  FocusNode durationFocus = FocusNode();
  FocusNode instructionFocus = FocusNode();
  final FocusNode quantityFocus = FocusNode();
  final FocusNode dosageFocus = FocusNode();
  final FocusNode formFocus = FocusNode();

  RxBool isLoading = false.obs;
  RxInt stock = 1.obs;

  //Medicine
  //Rx<Medicine> selectedMedicine = Medicine.fromJson({}).obs;
  //RxList<Medicine> selectedMedicines = <Medicine>[].obs;
  RxList<MedicineFormData> selectedMedicines = <MedicineFormData>[].obs;

  ///Search
  TextEditingController searchCont = TextEditingController();
  RxBool isSearchText = false.obs;
  StreamController<String> searchStream = StreamController<String>();
  final _scrollController = ScrollController();

  Rx<Future<PrescriptionDetail>> getPrescriptionDetails = Future(() => PrescriptionDetail.fromJson({})).obs;

  int prescriptionId = -1;
  int medicineId = -1;
  RxBool isEdit = false.obs;
  int encounterId = -1;

  int morningCount = 0;
  int afternoonCount = 0;
  int eveningCount = 0;
  int availableStock = 0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    log("init call");
    if (args == null || args is! Map<String, dynamic>) {
      log("No arguments or invalid arguments passed.");
      return;
    }

    if (args['prescriptionId'] != null) {
      prescriptionId = args['prescriptionId'];
      log("prescriptionId: $prescriptionId");
    }

    if (args['medicineInfo'] != null && args['medicineInfo'] is MedicineInfo) {
      log("edit medicine");
      isEdit(true);
      final MedicineInfo medicineInfo = args['medicineInfo'];
      nameCont.text = medicineInfo.name;
      frequencyCont.text = medicineInfo.frequency;
      // Decode frequency format "1-1-1" into morning, afternoon, evening counts
      List<String> freqParts = medicineInfo.frequency.split('-');
      if (freqParts.length == 3) {
        morningCount = int.tryParse(freqParts[0]) ?? 0;
        afternoonCount = int.tryParse(freqParts[1]) ?? 0;
        eveningCount = int.tryParse(freqParts[2]) ?? 0;
      } else {
        morningCount = 0;
        afternoonCount = 0;
        eveningCount = 0;
      }
      availableStock = medicineInfo.avilableStock.toInt();
      durationCont.text = medicineInfo.days;
      instructionCont.text = medicineInfo.instruction;
      quantityCont.text = medicineInfo.quantity.toString();
      dosageCont.text = medicineInfo.dosage;
      formCont.text = medicineInfo.form;
      medicineId = medicineInfo.medicineId;
    }

    if (args['encounter_id'] != null) {
      encounterId = args['encounter_id'];
      log("encounter id: $encounterId");
    }
  }

  Future<void> getPrescriptionDetail() async {
    isLoading(true);
    await PharmaApis.getPrescriptionDetail(prescriptionId).then((res) {
      log('value.length ==> ${res.value}');
    }).catchError((e) {
      log("getPrescriptionDetail Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  void setMedicineForms(List<Medicine> medicines) {
    selectedMedicines.assignAll(medicines.map((med) => MedicineFormData(medicine: med)));
  }

  Future<void> saveMedToPrescription() async {
    if (!addPrescriptionFormKey.currentState!.validate()) return;
    if (isEdit.value) {
      Map<String, dynamic> request = {
        'medicine_id': medicineId,
        'quantity': int.parse(quantityCont.text.trim()),
        'frequency': frequencyCont.text.trim(),
        'duration': durationCont.text.trim(),
        'instruction': instructionCont.text.trim(),
        'encounter_id': encounterId.toString(),
      };
      PharmaApis.prescriptionEditMedicine(request: request, id: encounterId).then((value) {
        toast(value.message);
        Get.back(result: true);
      }).catchError((e) {
        toast(e.toString());
      }).whenComplete(() => isLoading(false));
    } else {
      isLoading(true);
      try {
        List<Future<BaseResponseModel>> requests = selectedMedicines.map((form) {
          return PharmaApis.saveMedicineToPrescription(
            request: form.toRequest(),
            id: prescriptionId,
          );
        }).toList();

        // Wait for all to complete
        List<BaseResponseModel> responses = await Future.wait(requests);

        // You can toast the first message or a combined one
        if (responses.isNotEmpty) {
          toast(responses.first.message); // ✅ Show the first success message
        } else {
          toast("Medicines added successfully.");
        }
        AllPrescriptionsController allPrescriptionsController = Get.find();
        await allPrescriptionsController.getPrescriptions(showLoader: false);
        Get.back(result: true);
      } catch (e) {
        toast(e.toString());
      } finally {
        isLoading(false);
      }
    }
  }

  Future<void> prescriptionUpdate() async {
    isLoading(true);

    Map<String, dynamic> request = {
      'prescription_status': 1,
      'prescription_payment_status': 1,
    };

    PharmaApis.prescriptionUpdate(request: request).then((value) {
      toast(value.message);
      Get.back();
    }).catchError((e) {
      toast(e.toString());
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
