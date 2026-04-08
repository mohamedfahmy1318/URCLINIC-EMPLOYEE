import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:async';

import 'bed_type/model/bed_type_model.dart';
import 'model/bed_master_model.dart';

class BedStatusController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<BedMasterModel> bedList = <BedMasterModel>[].obs;
  RxList<BedTypeElement> bedTypeList = <BedTypeElement>[].obs;
  RxList<BedMasterModel> filteredBedList = <BedMasterModel>[].obs;
  Rx<BedTypeElement?> selectedBedType = Rx<BedTypeElement?>(null);
  RxString selectedBedStatus = ''.obs;
  Rx<BedMasterModel?> selectedBed = Rx<BedMasterModel?>(null);
  RxInt totalBeds = 0.obs;
  RxInt availableBeds = 0.obs;
  RxInt occupiedBeds = 0.obs;
  RxInt unavailableBeds = 0.obs;
  RxInt maintenanceBeds = 0.obs;
  Timer? _refreshTimer;

  RxInt selectedIndex = 0.obs;

  bool get isBedFeatureAvailable => CoreServiceApis.isBedFeatureAvailable;

  @override
  void onInit() {
    super.onInit();
    if (isBedFeatureAvailable) {
      refreshAllData();
    } else {
      _resetBedData();
    }
  }

  void init() {
    if (isBedFeatureAvailable) {
      refreshAllData();
    } else {
      _resetBedData();
    }
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    if (isBedFeatureAvailable && bedList.isEmpty && !isLoading.value) {
      refreshAllData();
    }
  }

  Future<void> initializeData() async {
    if (!isBedFeatureAvailable) {
      _resetBedData();
      return;
    }

    isLoading(true);
    try {
      await fetchBedTypes();
      await fetchBedStatusSummary();
      await fetchBeds();
      if (filteredBedList.isNotEmpty && selectedBed.value == null) {
        selectedBed.value =
            filteredBedList.firstWhereOrNull((bed) => bed.status);
      }
    } catch (e) {
      if (_shouldIgnoreBedError(e)) {
        _resetBedData();
      } else {
        toast(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  void updateBedCounts() {
    int available = 0;
    int occupied = 0;
    int maintenance = 0;

    for (var bed in bedList) {
      if (bed.isUnderMaintenance || bed.bedStatus == 'maintenance') {
        maintenance++;
      } else if (bed.bedStatus == 'occupied') {
        occupied++;
      } else if (bed.bedStatus == 'available') {
        available++;
      }
    }

    totalBeds.value = bedList.length;
    availableBeds.value = available;
    occupiedBeds.value = occupied;
    maintenanceBeds.value = maintenance;
  }

  Future<void> fetchBedStatusSummary() async {
    if (!isBedFeatureAvailable) {
      totalBeds.value = 0;
      availableBeds.value = 0;
      occupiedBeds.value = 0;
      maintenanceBeds.value = 0;
      return;
    }

    try {
      final summary = await CoreServiceApis.getBedStatusSummary();
      if (summary['status'] == true && summary['data'] is Map) {
        final Map<String, dynamic> statistics =
            summary['data']['statistics'] ?? {};
        totalBeds.value = statistics['total'] ?? 0;
        availableBeds.value = statistics['available'] ?? 0;
        occupiedBeds.value = statistics['occupied'] ?? 0;
        maintenanceBeds.value = statistics['maintenance'] ?? 0;
      } else {
        updateBedCounts();
      }
    } catch (e) {
      if (_shouldIgnoreBedError(e)) {
        _resetBedData();
      } else {
        toast(e.toString());
      }
    }
  }

  Future<void> refreshBedStatusSummary() async {
    if (!isBedFeatureAvailable) {
      _resetBedData();
      return;
    }

    try {
      await fetchBedStatusSummary();
    } catch (e) {
      if (_shouldIgnoreBedError(e)) {
        _resetBedData();
      } else {
        toast(e.toString());
      }
    }
  }

  Future<void> fetchBedTypes() async {
    if (!isBedFeatureAvailable) {
      bedTypeList.clear();
      selectedBedType.value = null;
      return;
    }

    try {
      final types = await CoreServiceApis.getBedTypes();
      if (!isBedFeatureAvailable) {
        bedTypeList.clear();
        selectedBedType.value = null;
        return;
      }

      // Add "All" manually
      final allCategory = BedTypeElement(id: -1, type: 'All');
      bedTypeList.assignAll([allCategory, ...types]);

      // Set default selection to "All"
      selectedBedType.value = allCategory;
    } catch (e) {
      if (_shouldIgnoreBedError(e)) {
        bedTypeList.clear();
        selectedBedType.value = null;
      } else {
        toast(e.toString());
      }
    }
  }

  Future<void> fetchBeds() async {
    if (!isBedFeatureAvailable) {
      bedList.clear();
      filteredBedList.clear();
      selectedBed.value = null;
      return;
    }

    try {
      await CoreServiceApis.getBedList(
        bedList: bedList,
        page: 1,
        perPage: 50,
        status: null,
        lastPageCallBack: (isLastPage) {},
      );
      filterBeds();
      if (selectedBed.value == null && filteredBedList.isNotEmpty) {
        selectedBed.value =
            filteredBedList.firstWhereOrNull((bed) => bed.status == true);
      }
    } catch (e) {
      if (_shouldIgnoreBedError(e)) {
        bedList.clear();
        filteredBedList.clear();
        selectedBed.value = null;
      } else {
        toast(e.toString());
      }
    }
  }

  void filterBeds() {
    List<BedMasterModel> tempList = bedList;

    if (selectedBedType.value != null && selectedBedType.value!.id != -1) {
      tempList = tempList
          .where((bed) =>
              bed.bedTypeName.toLowerCase().trim() ==
              selectedBedType.value!.type.toLowerCase().trim())
          .toList();
    }

    filteredBedList.assignAll(tempList);
  }

  Future<void> selectBedType(BedTypeElement? bedType) async {
    if (selectedBedType.value?.id == bedType?.id) {
      selectedBedType(null);
    } else {
      selectedBedType(bedType);
    }
    filterBeds();
  }

  Future<void> selectBedStatus(String status) async {
    selectedBedStatus(status);
    await fetchBeds();
  }

  void selectBed(BedMasterModel? bed) {
    selectedBed(bed);
    final index =
        filteredBedList.indexWhere((element) => element.id == bed?.id);
    if (index != -1) {
      selectedIndex(index);
    }
  }

  Future<void> refreshAllData() async {
    if (!isBedFeatureAvailable) {
      _resetBedData();
      return;
    }

    isLoading(true);
    try {
      await Future.wait<void>([
        fetchBedTypes(),
        fetchBedStatusSummary(),
        fetchBeds(),
      ]);
    } catch (e) {
      if (_shouldIgnoreBedError(e)) {
        _resetBedData();
      } else {
        toast(e.toString());
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateBedStatus(int bedId, String status,
      {String? maintenanceNotes}) async {
    if (!isBedFeatureAvailable) {
      return;
    }

    try {
      final response = await CoreServiceApis.updateBedStatus(
        bedId: bedId,
        request: {
          'status': status,
          'maintenance_notes': maintenanceNotes,
        },
      );

      if (response.status == true) {
        toast('Bed status updated successfully');
        await refreshAllData();
      } else if (response.message.isNotEmpty) {
        toast(response.message);
      }
    } catch (e) {
      if (!_shouldIgnoreBedError(e)) {
        toast(e.toString());
      }
    }
  }

  void forceRefreshBedCounts() {
    if (isBedFeatureAvailable) {
      refreshBedStatusSummary();
    }
  }

  void forceRefreshAllData() {
    if (isBedFeatureAvailable) {
      refreshAllData();
    }
  }

  bool _shouldIgnoreBedError(Object error) {
    return CoreServiceApis.isBedFeatureUnavailableError(error) ||
        !CoreServiceApis.isBedFeatureAvailable;
  }

  void _resetBedData() {
    bedList.clear();
    bedTypeList.clear();
    filteredBedList.clear();
    selectedBedType.value = null;
    selectedBedStatus.value = '';
    selectedBed.value = null;
    selectedIndex.value = 0;
    totalBeds.value = 0;
    availableBeds.value = 0;
    occupiedBeds.value = 0;
    unavailableBeds.value = 0;
    maintenanceBeds.value = 0;
  }
}
