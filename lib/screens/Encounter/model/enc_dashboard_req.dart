import 'package:kivicare_clinic_admin/screens/Encounter/add_encounter/model/prescription_model.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/app_common.dart';
import 'problems_observations_model.dart';

class EncounterDashboardReq {
  int encounterId;
  int userId;
  List<CMNElement> problems;
  List<CMNElement> observations;
  List<CMNElement> notes;
  List<Prescription> prescriptions;
  String otherInformation;
  int pharmaId;

  EncounterDashboardReq({
    required this.encounterId,
    required this.userId,
    required this.problems,
    required this.observations,
    required this.prescriptions,
    required this.notes,
    this.otherInformation = "",
    required this.pharmaId
  });

  Map<String, dynamic> toJson() {
    return {
      'encounter_id': encounterId,
      'user_id': userId,
      'problems': problems
          .map(
            (e) => {
              'problem_id': e.id.isNegative ? "" : "${e.id}",
              'problem_name': e.name,
            },
          )
          .toList(),
      'observations': observations
          .map(
            (e) => {
              'observation_id': e.id.isNegative ? "" : "${e.id}",
              'observation_name': e.name,
            },
          )
          .toList(),
      'prescriptions': prescriptions
          .map(
            (e) => {
              'frequency': e.frequency,
              'duration': e.duration,
              'instruction': e.instruction,
                'name': appConfigs.value.isPharma.getBoolInt() ? e.medicine.name : e.name,
                if (appConfigs.value.isPharma.getBoolInt()) "medicine_id": e.medicine.id,
                if (appConfigs.value.isPharma.getBoolInt()) "quantity": e.quantity,
              })
          .toList(),
      'notes': notes.map((e) => e.name).toList(),
      'other_information': otherInformation,
      'pharma_id': pharmaId,
    };
  }
}
