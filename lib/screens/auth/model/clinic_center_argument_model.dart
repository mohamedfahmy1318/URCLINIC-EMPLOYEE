import '../../clinic/model/clinics_res_model.dart';

class ClinicCenterArgumentModel {
  bool isReceptionistRegister;
  bool isDoctorRegister;
  ClinicData selectedClinc;

  ClinicCenterArgumentModel({
    this.isReceptionistRegister = false,
    this.isDoctorRegister = false,
    required this.selectedClinc,
  });
}
