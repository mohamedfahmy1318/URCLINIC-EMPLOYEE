import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';

class PrescriptionFormData {
  final Medicine medicine;
  final TextEditingController dosageCont;
  final TextEditingController formCont;
  final TextEditingController quantityCont;
  final TextEditingController frequencyCont;
  final TextEditingController durationCont;
  final TextEditingController instructionCont;

  int morningCount = 0;
  int afternoonCount = 0;
  int eveningCount = 0;
  final RxString stockWarning = ''.obs;

  PrescriptionFormData({
    required this.medicine,
    String? dosage,
    String? form,
    String? frequency,
  })  : dosageCont = TextEditingController(text: dosage ?? medicine.dosage),
        formCont = TextEditingController(text: form ?? medicine.form.name),
        quantityCont = TextEditingController(),
        frequencyCont = TextEditingController(text: frequency ?? ''),
        durationCont = TextEditingController(),
        instructionCont = TextEditingController() {
    _parseFrequency();
    // Listen for changes to frequencyCont and update counts
    frequencyCont.addListener(_parseFrequency);
  }

  void _parseFrequency() {
    final freq = frequencyCont.text.trim();
    final parts = freq.split('-');
    if (parts.length == 3) {
      morningCount = int.tryParse(parts[0]) ?? 0;
      afternoonCount = int.tryParse(parts[1]) ?? 0;
      eveningCount = int.tryParse(parts[2]) ?? 0;
    } else {
      morningCount = 0;
      afternoonCount = 0;
      eveningCount = 0;
    }
  }
}

RxList<PrescriptionFormData> prescriptionFormDataList = <PrescriptionFormData>[].obs;

/*
void updateFormDataFromMedicines(List<Medicine> selected) {
  prescriptionFormDataList.clear();
  for (var med in selected) {
    prescriptionFormDataList.add(PrescriptionFormData(medicine: med));
  }
}
*/
