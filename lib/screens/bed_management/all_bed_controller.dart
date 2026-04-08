// ignore_for_file: body_might_complete_normally_catch_error

import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/model/bed_master_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/bed_status_controller.dart';

class AllBedController extends GetxController {
  RxList<BedMasterModel> bedMasterList = <BedMasterModel>[].obs;
  RxList<BedMasterModel> filteredBedMasterList = <BedMasterModel>[].obs;
  RxBool isLoading = false.obs;

  RxString selectedStatus = ''.obs;
  RxString selectedBedType = ''.obs;
  RxList<String> bedTypes = <String>[].obs;
  RxList<BedMasterModel> bedList = <BedMasterModel>[].obs;

  RxString searchQuery = ''.obs;
  RxString filterType = "".obs;

  RxList filterList = [locale.value.bedType, locale.value.status].obs;

  RxInt page = 1.obs;
  RxBool isLastPage = false.obs;

  Rx<Future<RxList<BedMasterModel>>> bedsFuture =
      Future(() => RxList<BedMasterModel>()).obs;

  bool get isBedFeatureAvailable => CoreServiceApis.isBedFeatureAvailable;

  @override
  void onInit() {
    super.onInit();
    if (isBedFeatureAvailable) {
      getBedList(showloader: true);
      getBedTypes();
    }
    filterType(filterList[0]);
  }

  Future<void> getBedTypes() async {
    if (!isBedFeatureAvailable) {
      bedTypes.clear();
      return;
    }

    try {
      final types = await CoreServiceApis.getBedTypes();
      bedTypes.assignAll(types.map((type) => type.type.validate()).toList());
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(locale.value.somethingWentWrong);
      }
    }
  }

  Future<void> getBedList(
      {bool showloader = true, String searchBed = ''}) async {
    if (!isBedFeatureAvailable) {
      bedMasterList.clear();
      filteredBedMasterList.clear();
      isLastPage.value = true;
      isLoading(false);
      return;
    }

    if (showloader) {
      isLoading(true);
    }

    await bedsFuture(
      CoreServiceApis.getBedMasters(
        searchBed: searchBed,
        page: page.value,
        perPage: 10,
        bedMasterList: bedMasterList,
        lastPageCallBack: (lastPage) {
          isLastPage.value = lastPage;
        },
      ).then((beds) {
        if (page.value == 1) {
          filteredBedMasterList.clear();
        }
        _updateBedTypes();
        _applyFiltersAndSearch();
        return beds;
      }),
    ).then((value) {}).catchError((e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast(e.toString());
      }
    }).whenComplete(() {
      isLoading(false);
    });
  }

  void _updateBedTypes() {
    bedTypes.value = bedMasterList
        .map((bed) => bed.bedTypeName.validate())
        .where((type) => type.isNotEmpty)
        .toSet()
        .toList();
  }

  void filterBeds() {
    page(1);
    _applyFiltersAndSearch();
  }

  void _applyFiltersAndSearch() {
    var filtered = bedMasterList.where((bed) {
      if (searchQuery.value.isNotEmpty) {
        final searchLower = searchQuery.value.toLowerCase();

        final bedName = bed.bed.validate().toLowerCase();
        final bedId = bed.bedId.validate().toLowerCase();
        final bedType = bed.bedTypeName.validate().toLowerCase();

        if (!bedName.contains(searchLower) &&
            !bedId.contains(searchLower) &&
            !bedType.contains(searchLower)) {
          return false;
        }
      }

      if (selectedBedType.value.isNotEmpty) {
        if (!bed.bedTypeName
            .validate()
            .toLowerCase()
            .contains(selectedBedType.value.toLowerCase())) {
          return false;
        }
      }

      return true;
    }).toList();

    filteredBedMasterList.clear();
    filteredBedMasterList.addAll(filtered);
  }

  void resetFilters() {
    selectedStatus('');
    selectedBedType('');
    searchQuery('');
    page(1);
    _applyFiltersAndSearch();
  }

  Future<void> deleteBed(String id) async {
    if (!isBedFeatureAvailable) {
      return;
    }

    isLoading.value = true;
    try {
      final bedId = int.tryParse(id);
      if (bedId == null) {
        toast(locale.value.somethingWentWrong);
        return;
      }

      final bed = bedMasterList.firstWhereOrNull((bed) => bed.id == bedId);
      if (bed == null) {
        toast(locale.value.somethingWentWrong);
        return;
      }

      final response = await CoreServiceApis.deleteBed(bedId: bed.id);
      if (response.status == true) {
        page(1);
        await getBedList();

        try {
          final bedStatusController = Get.find<BedStatusController>();
          bedStatusController.forceRefreshBedCounts();
        } catch (e) {
          toast(e.toString());
        }

        toast('${locale.value.deleteBed} ${locale.value.successfully}');
        final BedStatusController bedStatusController = Get.find();
        await bedStatusController.initializeData();
      } else if (response.message.isNotEmpty) {
        toast(response.message);
      }
    } catch (e) {
      if (!CoreServiceApis.isBedFeatureUnavailableError(e)) {
        toast('${locale.value.somethingWentWrong}: ${e.toString()}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void clearFilter() {
    selectedStatus('');
    selectedBedType('');
    searchQuery('');
    page(1);
    _applyFiltersAndSearch();
  }

  BedMasterModel getBedModel(BedMasterModel bed) {
    return BedMasterModel(
      id: bed.id.validate(),
      bed: bed.bed,
      bedTypeId: bed.bedTypeId,
      bedTypeName: bed.bedTypeName,
      charges: bed.charges,
      capacity: bed.capacity,
      description: bed.description,
      status: bed.status,
      isUnderMaintenance: bed.isUnderMaintenance,
      maintenanceText: bed.isUnderMaintenance
          ? locale.value.underMaintenance
          : locale.value.available,
    );
  }

  void showDeleteConfirmation(BedMasterModel bed) {
    if (bed.id > 0) {
      toast(locale.value.somethingWentWrong);
      return;
    }

    showConfirmDialogCustom(
      Get.context!,
      primaryColor: appColorSecondary,
      title: locale.value.areYouSureYouWantToDeleteThisBed,
      onAccept: (context) {
        deleteBed(bed.id.toString());
      },
    );
  }

  void onNextPage() {
    if (!isLastPage.value) {
      page(page.value + 1);
      getBedList(showloader: false);
    }
  }

  Future<void> onRefresh() async {
    page(1);
    return await getBedList(showloader: false);
  }
}
