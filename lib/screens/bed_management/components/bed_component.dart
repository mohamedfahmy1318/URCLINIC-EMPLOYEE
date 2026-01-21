// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/add_encounter/model/patient_model.dart';
import 'package:kivicare_clinic_admin/screens/appointment/model/encounter_detail_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:get/get.dart';
import '../../../utils/common_base.dart';

class BedComponent extends StatelessWidget {
  final BedAllocation bedData;
  final int? patientId;
  final String? patientName;
  final int? encounterId;
  final bool isEncounterOpen;

  const BedComponent({
    super.key,
    required this.bedData,
    this.patientId,
    this.patientName,
    this.encounterId,
    required this.isEncounterOpen,
  });

  Future<String> getDisplayedPatientName() async {
    if (patientName != null && patientName!.isNotEmpty) {
      return patientName!;
    } else if (patientId != null) {
      final patient = await _findPatientById(patientId!);
      return patient?.fullName ?? locale.value.noPatientFound;
    } else {
      return 'N/A';
    }
  }

  Future<PatientModel?> _findPatientById(int patientId) async {
    int currentPage = 1;
    bool isLastPage = false;
    PatientModel? foundPatient;

    while (!isLastPage && foundPatient == null) {
      List<PatientModel> pagePatientList = [];
      await CoreServiceApis.getPatientsList(
        page: currentPage,
        patientsList: pagePatientList,
        lastPageCallBack: (p0) => isLastPage = p0,
      );
      foundPatient = pagePatientList.firstWhereOrNull((p) => p.id == patientId);
      if (isLastPage && foundPatient == null) break;
      currentPage++;
    }
    return foundPatient;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.height,
          Container(
            decoration: boxDecorationDefault(color: context.cardColor),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.value.roomNumber, style: secondaryTextStyle()),
                          8.height,
                          Text(bedData.bed, style: boldTextStyle(size: 12)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.value.bedType, style: secondaryTextStyle()),
                          8.height,
                          Text(bedData.bedTypeName, style: boldTextStyle(size: 12)),
                        ],
                      ),
                    )
                  ],
                ),
                8.height,
                commonDivider,
                8.height,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.value.assignDate, style: secondaryTextStyle()),
                          8.height,
                          Text(
                            bedData.assignDate,
                            style: boldTextStyle(size: 12),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.value.dischargeDate, style: secondaryTextStyle()),
                          8.height,
                          Text(
                            bedData.dischargeDate,
                            style: boldTextStyle(size: 12),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
