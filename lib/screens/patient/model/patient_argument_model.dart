import '../../Encounter/add_encounter/model/patient_model.dart';

class PatientArgumentModel {
  bool isFromPatientDetail;
  PatientModel patientModel;

  PatientArgumentModel({
    this.isFromPatientDetail = false,
    required this.patientModel,
  });
}
