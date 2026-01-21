import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/add_encounter/model/patient_model.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../category/model/all_category_model.dart';
import '../../clinic/model/clinics_res_model.dart';
import '../../doctor/model/doctor_list_res.dart' hide Center;
import '../../service/model/service_list_model.dart';
import '../appointments_controller.dart';
import 'components/category_filter/filter_category_component.dart';
import 'components/clinic_filtter/clinic_component.dart';
import 'components/date_filter/filter_date_component.dart';
import 'components/doctor_filter/doctor_component.dart';
import 'components/patient_filter/patient_component.dart';
import 'components/payment_status_filter/filter_payment_status_component.dart';
import 'components/service_filter/service_component.dart';
import 'components/status_filter/status_filter.dart';
import '../../bed_management/all_bed_controller.dart';

class FilterController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  Rx<Future<RxList<PatientModel>>> gePatientFuture = Future(() => RxList<PatientModel>()).obs;
  RxList<PatientModel> patientList = RxList();
  Rx<PatientModel> selectedPatient = PatientModel().obs;
  RxInt patientPage = 1.obs;
  RxString filterType = "".obs;
  RxString screenType = "".obs;

  //Service List
  Rx<Future<RxList<ServiceElement>>> serviceListFuture = Future(() => RxList<ServiceElement>()).obs;
  RxBool isServiceLoading = false.obs;
  RxList<ServiceElement> serviceList = RxList();
  RxList<ClinicData> clinicList = RxList();
  RxList<CategoryElement> categoryList = RxList();
  RxBool isServiceLastPage = false.obs;
  RxInt servicePage = 1.obs;
  RxBool isSearchServiceText = false.obs;
  TextEditingController searchServiceCont = TextEditingController();
  StreamController<String> searchServiceStream = StreamController<String>();
  final _scrollServiceController = ScrollController();
  Rx<ServiceElement> selectedServiceData = ServiceElement(status: false.obs).obs;
  Rx<Future<RxList<ClinicData>>> clinicListFuture = Future(() => RxList<ClinicData>()).obs;
  Rx<Future<RxList<CategoryElement>>> categoryListFuture = Future(() => RxList<CategoryElement>()).obs;
  TextEditingController selectedFirstDateCont = TextEditingController();
  TextEditingController selectedLastDateCont = TextEditingController();
  RxString selectedFirstDate = ''.obs;
  RxString selectedLastDate = ''.obs;
  Rx<DateTime> tampDate = DateTime.now().obs;

  // Doctors
  Rx<Future<RxList<Doctor>>> doctorsFuture = Future(() => RxList<Doctor>()).obs;
  RxBool isDoctorLoading = false.obs;
  RxBool isClinicLoading = false.obs;
  RxBool isCategoryLoading = false.obs;
  RxList<Doctor> doctors = RxList();
  RxBool isDoctorLastPage = false.obs;
  RxInt doctorPage = 1.obs;
  RxInt clinicPage = 1.obs;
  RxInt categoryPage = 1.obs;
  Rx<Doctor> selectedDoctor = Doctor().obs;
  Rx<ClinicData> selectedClinic = ClinicData().obs;
  Rx<CategoryElement> selectedCategory = CategoryElement().obs;
  TextEditingController searchClinicCont = TextEditingController();
  TextEditingController searchCategoryCont = TextEditingController();

  ///Search
  TextEditingController searchDoctorCont = TextEditingController();
  RxBool isDoctorSearchText = false.obs;
  StreamController<String> searchDoctorStream = StreamController<String>();
  final _scrollDoctorController = ScrollController();

  ///Search
  TextEditingController patientSearchCont = TextEditingController();
  RxBool isSearchText = false.obs;
  StreamController<String> searchStream = StreamController<String>();
  final _scrollController = ScrollController();
  RxList filterList = ["Patient", "Service", "Doctor", "Status"].obs;
  RxList statusList = [
    {"title": "Pending", "value": StatusConst.pending},
    {"title": "Confirmed", "value": StatusConst.confirmed},
    {"title": "Check-in", "value": StatusConst.check_in},
    {"title": "Completed", "value": StatusConst.checkout},
    {"title": "Cancelled", "value": StatusConst.cancelled},
  ].obs;
  RxList paymentStatusList = [
    {"title": "Paid", "value": PaymentStatus.PAID},
    {"title": "Advance Paid", "value": PaymentStatus.ADVANCE_PAID},
    {"title": "Pending", "value": PaymentStatus.pending},
    {"title": "Advance Refunded", "value": PaymentStatus.ADVANCE_REFUNDED},
    {"title": "Refunded", "value": PaymentStatus.REFUNDED},
  ].obs;

  RxString status = "".obs;
  RxString paymentStatus = "".obs;

  // Bed Management
  RxString selectedBedType = ''.obs;
  RxString selectedBedStatus = ''.obs;
  RxList<String> bedTypes = <String>[].obs;

  // Use the same status list as appointments for consistency
  RxList bedStatusList = [
    {"title": "All", "value": ""},
    {"title": "Active", "value": "active"},
    {"title": "Inactive", "value": "inactive"},
    {"title": "Under Maintenance", "value": "maintenance"},
  ].obs;

  @override
  void onInit() {
    getArgs();
    if (Get.arguments != null && Get.arguments is List && Get.arguments.length == 2 && (Get.arguments[0] is String || Get.arguments[1] is String)) {
      screenType("bed_management");
      filterList = ["Bed Type"].obs;
      getBedTypes(); // Only call getBedTypes for bed management
    } else {
      screenType("appointment");
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)) {
        filterList = ["Patient", "Service", "Status"].obs;
      }
      getPatient();
      getService();
      getDoctor();
    }
    filterType(filterList[0]);
    getClinicsList();
    getCategoryList();
    super.onInit();
  }

  void getArgs() {
    // Only process bed arguments if this is bed management
    if (screenType.value == "bed_management" && Get.arguments != null && Get.arguments is List && Get.arguments.length == 2) {
      if (Get.arguments[0] != null && Get.arguments[0] is String) {
        selectedBedType(Get.arguments[0] as String);
      }
      if (Get.arguments[1] != null && Get.arguments[1] is String) {
        selectedBedStatus(Get.arguments[1] as String);
      }
    }
  }

  Future<void> getBedTypes() async {
    try {
      final types = await CoreServiceApis.getBedTypes();
      bedTypes.assignAll(types.map((type) => type.type.validate()).toList());
    } catch (e) {
      toast('Error fetching bed types: $e');
    }
  }

  Future<void> getPatientList({bool showloader = true, String search = ""}) async {
    if (showloader) {
      isLoading(true);
    }
    await gePatientFuture(
      CoreServiceApis.getPatientsList(
        page: patientPage.value,
        search: patientSearchCont.text.trim(),
        patientsList: patientList,
        clinicId: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) || loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist) ? selectedAppClinic.value.id : null,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      log('getPatientList: $e');
    }).whenComplete(() => isLoading(false));
  }

  //get patient Info
  void getPatient() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getPatientList();
    });
    getPatientList();
  }

  //get Service Info
  void getService() {
    _scrollServiceController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchServiceStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getServicesList();
    });
    getServicesList();
  }

  Future<void> getServicesList({bool showloader = true, String search = ""}) async {
    if (showloader) {
      isServiceLoading(true);
    }
    await serviceListFuture(
      CoreServiceApis.getServiceList(
        serviceList: serviceList,
        clinicId: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) || loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist) ? selectedAppClinic.value.id : null,
        search: searchServiceCont.text.trim(),
        page: servicePage.value,
        lastPageCallBack: (p0) {
          isServiceLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      log('getServiceList: $e');
    }).whenComplete(() => isServiceLoading(false));
  }

  // clinic
  Future<void> getClinicsList({bool showloader = true, String search = ""}) async {
    if (showloader) {
      isClinicLoading(true);
    }
    await clinicListFuture(
      CoreServiceApis.getClinicList(
        search: searchClinicCont.text.trim(),
        page: clinicPage.value,
        lastPageCallBack: (p0) {
          isServiceLastPage(p0);
        },
        clinicList: clinicList,
      ),
    ).then((value) {}).catchError((e) {
      log('getClinicList: $e');
    }).whenComplete(() => isClinicLoading(false));
  }

  // category
  Future<void> getCategoryList({String search = ''}) async {
    isCategoryLoading(true);
    await categoryListFuture(CoreServiceApis.getCategoryList(categories: categoryList, page: categoryPage.value, search: searchCategoryCont.text)).then((value) {}).catchError((e) {
      log('getCategoryList: $e');
    }).whenComplete(() => isCategoryLoading(false));
  }

  //Doctors
  void getDoctor() {
    _scrollDoctorController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchDoctorStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getDoctorsList();
    });
    getDoctorsList();
  }

  Future<void> getDoctorsList({bool showloader = true}) async {
    if (showloader) {
      isDoctorLoading(true);
    }
    await doctorsFuture(
      CoreServiceApis.getDoctors(
        page: doctorPage.value,
        doctors: doctors,
        clinicId: loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist) ? selectedAppClinic.value.id : null,
        search: searchDoctorCont.text.trim(),
        lastPageCallBack: (p0) {
          isDoctorLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      log("getDoctors error $e");
    }).whenComplete(() => isDoctorLoading(false));
  }

  @override
  void onClose() {
    searchStream.close();
    searchServiceStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
      _scrollServiceController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }

  void clearFilter() {
    if (screenType.value == "bed_management") {
      // Clear bed management filters
      selectedBedType("");
      selectedBedStatus("");
      final bedController = Get.find<AllBedController>();
      bedController.resetFilters();
      Get.back();
    } else {
      // Clear appointment filters
      selectedPatient(PatientModel());
      selectedDoctor(Doctor());
      selectedCategory(CategoryElement());
      selectedLastDate('');
      selectedFirstDate('');
      selectedClinic(ClinicData());
      paymentStatus('');
      selectedServiceData(ServiceElement(status: false.obs));
      status("");
      selectedFirstDateCont.text = '';
      selectedLastDateCont.text = '';

      final AppointmentsController appointmentsCont = Get.find<AppointmentsController>();
      appointmentsCont.selectedDoctor(selectedDoctor.value);
      appointmentsCont.categoryId(0);
      appointmentsCont.selectedServiceData(selectedServiceData.value);
      appointmentsCont.selectedPatient(selectedPatient.value);
      appointmentsCont.status(status.value);
      appointmentsCont.paymentStatus(paymentStatus.value);
      appointmentsCont.selectedCategory(selectedCategory.value);
      appointmentsCont.lastDate(selectedLastDate.value);
      appointmentsCont.clinicId(0);
      appointmentsCont.firstDate(selectedFirstDate.value);
      Get.back();
      appointmentsCont.getAppointmentList();
    }
  }

  Widget viewFilterWidget({required FilterController filterCont}) {
    if (screenType.value == "bed_management") {
      return _buildBedTypeFilter().expand(flex: 2);
    }

    switch (filterType.value) {
      case "Patient":
        return PatientComponent(filterCont: filterCont).expand(flex: 2);
      case "Service":
        return FilterServiceComponent(filterCont: filterCont).expand(flex: 2);
      case "Doctor":
        return FilterDoctorComponent(filterCont: filterCont).expand(flex: 2);
      case "Status":
        return FilterStatusComponent(filterCont: filterCont).expand(flex: 2);
      case "Clinic":
        return FilterClinicComponent(filterCont: filterCont).expand(flex: 2);
      case "Date":
        return FilterDateComponent(filterCont: filterCont).expand(flex: 2);
      case "Category":
        return FilterCategoryComponent(filterCont: filterCont).expand(flex: 2);
      case "Payment Status":
        return FilterPaymentStatusComponent(filterCont: filterCont).expand(flex: 2);
      default:
        getPatient();
        return PatientComponent(filterCont: filterCont).expand(flex: 2);
    }
  }

  Widget _buildBedTypeFilter() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bed Type Filter
          Text(
            locale.value.bedType,
            style: boldTextStyle(size: 16, color: Get.isDarkMode ? Colors.white : Colors.black),
          ),
          16.height,
          Obx(
            () => AnimatedWrap(
              children: [
                // All option
                InkWell(
                  onTap: () {
                    selectedBedType('');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    margin: const EdgeInsets.all(4),
                    decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(6), color: selectedBedType.value.isEmpty ? appColorPrimary : Get.context!.cardColor),
                    child: Text(
                      'All',
                      style: primaryTextStyle(
                        size: 12,
                        color: selectedBedType.value.isEmpty ? white : null,
                      ),
                    ),
                  ),
                ),
                // Bed type options
                ...bedTypes.map((type) {
                  return InkWell(
                    onTap: () {
                      selectedBedType(type);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      margin: const EdgeInsets.all(4),
                      decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(6), color: selectedBedType.value == type ? appColorPrimary : Get.context!.cardColor),
                      child: Text(
                        type,
                        style: primaryTextStyle(
                          size: 12,
                          color: selectedBedType.value == type ? white : null,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          32.height,

          24.height,
        ],
      ).paddingAll(16),
    );
  }

  Widget applyButton() {
    return AppButton(
      width: Get.width,
      text: locale.value.apply,
      color: appColorSecondary,
      textStyle: boldTextStyle(color: white),
      onTap: () {
        if (screenType.value == "bed_management") {
          // Bed Management
          final bedController = Get.find<AllBedController>();
          bedController.selectedBedType(selectedBedType.value);
          bedController.selectedStatus(selectedBedStatus.value);
          Get.back(result: true);
        } else {
          // Appointments
          AppointmentsController appointmentsCont = Get.find();
          appointmentsCont.selectedDoctor(selectedDoctor.value);
        appointmentsCont.categoryId(selectedCategory.value.id);
          appointmentsCont.selectedServiceData(selectedServiceData.value);
          appointmentsCont.selectedPatient(selectedPatient.value);
          appointmentsCont.status(status.value);
        appointmentsCont.paymentStatus(paymentStatus.value);
        appointmentsCont.selectedCategory(selectedCategory.value);
        appointmentsCont.lastDate(selectedLastDate.value);
        appointmentsCont.clinicId(selectedClinic.value.id);
        appointmentsCont.firstDate(selectedFirstDate.value);
          Get.back();
          appointmentsCont.getAppointmentList();
        }
      },
    );
  }
}
