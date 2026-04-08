import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/model/bed_master_model.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../appointment/appointment_detail_controller.dart';
import '../../appointment/appointments_controller.dart';
import '../../bed_management/bed_status_controller.dart';
import '../../home/home_controller.dart';
import '../../service/model/service_list_model.dart';
import '../generate_invoice/model/billing_item_model.dart';
import '../generate_invoice/model/save_billing_resp.dart';
import '../model/encounters_list_model.dart';
import 'model/billing_details_resp.dart';

enum PaymentStatus { paid, unpaid }

class InvoiceDetailsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isEditBillingItemLoading = false.obs;

  Rx<num> serviceAmount = 0.obs;
  Rx<PaymentStatus> bedPaymentStatus = PaymentStatus.unpaid.obs;

  Rx<Future<BillingDetailModel>> getInvoiceDetailFuture =
      Future(() => BillingDetailModel.fromJson({})).obs;

  Rx<Future<BedMasterModel>> getBedDetailFuture =
      Future(() => BedMasterModel()).obs;
  Rx<BillingDetailModel> invoiceData = BillingDetailModel.fromJson({}).obs;
  Rx<EncounterElement> encounter = EncounterElement().obs;
  Rx<Future<RxList<ServiceElement>>> serviceListFuture =
      Future(() => RxList<ServiceElement>()).obs;
  RxList<ServiceElement> serviceList = RxList();

  Rx<BedMasterModel> bedDetail = BedMasterModel().obs;

  //Billing Item TextField Controller
  final GlobalKey<FormState> addBillFormKey = GlobalKey();
  TextEditingController servicesCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();
  TextEditingController quantityCont = TextEditingController();
  TextEditingController totalCont = TextEditingController();

  TextEditingController bedPrice = TextEditingController();

  //Discount on Billing Items TextField Controller
  final GlobalKey<FormState> finalDiscoutFormKey = GlobalKey();
  TextEditingController finalDiscoutValueCont = TextEditingController();
  RxString finalDiscoutType = DiscountType.PERCENTAGE.obs;
  RxBool enableFinalDiscount = false.obs;

  //Billing Item FocusNode
  FocusNode servicesFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode quantityFocus = FocusNode();
  FocusNode totalFocus = FocusNode();

  FocusNode bedFocus = FocusNode();

  final GlobalKey<FormState> addinvoiceFormKey = GlobalKey();
  Rx<PaymentStatus> isPaid = PaymentStatus.paid.obs;
  Rx<ServiceElement> selectService = ServiceElement(status: false.obs).obs;
  RxString tempInclusiveText = ''.obs;
  RxList<BillingItem> billingItemList = RxList();

  RxBool isEditMode = false.obs;

  @override
  void onReady() {
    log('-------------------${invoiceData.value.bedDetails.bedPaymentStatus}');
    if (Get.arguments is EncounterElement) {
      encounter(Get.arguments);
      if (encounter.value.status) {
        isEditMode(true);
      }
    }
    getInvoiceDetail();
    super.onReady();
  }

  ///Get Invoice Details
  Future<void> getInvoiceDetail({bool showLoader = false}) async {
    if (!showLoader) {
      isLoading(true);
    }
    await getInvoiceDetailFuture(
      CoreServiceApis.getBillingDetails(
        encounterId: encounter.value.id,
        billingDetails: invoiceData.value,
      ),
    ).then((value) {
      invoiceData(value);
      if (!invoiceData.value.serviceId.isNegative) {
        servicesCont.text = invoiceData.value.serviceName;
        selectService(
          ServiceElement(
            status: false.obs,
            id: invoiceData.value.serviceId,
            name: invoiceData.value.serviceName,
          ),
        );
      }
      billingItemList(invoiceData.value.billingItems);
      if (bedDetail.value.id <= 0) {
        bedPaymentStatus(PaymentStatus.paid);
      }
      setFinalDiscountFormData();
    }).catchError((e) {
      log("getBilling Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> saveGenerateInvoice({bool showLoader = false}) async {
    final SaveBillingResp saveBillingDet = SaveBillingResp(
      userId: encounter.value.userId,
      serviceId: invoiceData.value.serviceId,
      paymentStatus: invoiceData.value.paymentStatus,
      encounterId: invoiceData.value.encounterId,
      doctorId: invoiceData.value.doctorId,
      date: invoiceData.value.date,
      clinicId: invoiceData.value.clinicId,
      finalDiscountEnabled: enableFinalDiscount.value,
      finalDiscountType: finalDiscoutType.value,
      finalDiscountValue: finalDiscoutValueCont.text.toDouble(),
      bedPaymentStatus: invoiceData.value.bedDetails.bedPaymentStatus == 1,
    );

    if (showLoader) {
      isLoading(true);
    }
    await CoreServiceApis.saveInvoice(request: saveBillingDet.toJson())
        .then((value) async {
      // if (invoiceData.value.paymentStatus == 1) isEditMode(false);
      refreshAppoitmentRelatedPages();
      if (CoreServiceApis.isBedFeatureAvailable &&
          Get.isRegistered<BedStatusController>()) {
        final BedStatusController bedStatusController = Get.find();
        await bedStatusController.initializeData();
      }
      getInvoiceDetail(showLoader: true);
    }).catchError((e) {
      toast("$e");
    }).whenComplete(() => isLoading(false));
  }

  void refreshAppoitmentRelatedPages() {
    try {
      final AppointmentsController acont = Get.find();
      acont.getAppointmentList();
    } catch (e) {
      log('AppointmentDetail updateStatus acont = Get.find() E: $e');
    }

    try {
      final AppointmentDetailController appointment =
          Get.put(AppointmentDetailController());
      appointment.init(showLoader: false);
    } catch (e) {
      log('AppointmentDetailController appointment = Get.put(AppointmentDetailController()) E: $e');
    }
    try {
      final HomeController hcont = Get.find();
      hcont.getDashboardDetail();
    } catch (e) {
      log('AppointmentDetail updateStatus hcont = Get.find() E: $e');
    }
  }

  void setFinalDiscountFormData() {
    enableFinalDiscount(invoiceData.value.enableFinalBillingDiscount);
    finalDiscoutType(invoiceData.value.billingFinalDiscountType);
    finalDiscoutValueCont.text =
        "${invoiceData.value.billingFinalDiscountValue}";
  }

  void getClearBillingItem() {
    servicesCont.clear();
    quantityCont.clear();
    priceCont.clear();
  }

  Future<void> saveBillingItem(
      {BillingItem? billingItem,
      required int index,
      bool showLoader = true}) async {
    final quantity = quantityCont.text.toInt();
    final amount = serviceAmount.value.toDouble().toPrecision(2);
    final total = (quantity * amount).toPrecision(2);

    if (billingItem == null) {
      billingItem = BillingItem(
        billingId: invoiceData.value.id,
        itemId: selectService.value.id,
        itemName: servicesCont.text.trim(),
        quantity: quantity,
        serviceAmount: amount,
        totalAmount: total,
        bedPrice: bedPrice.text.toDouble(),
        discountType: selectService.value.discountType,
        discountValue: selectService.value.discountValue,
        discountAmount: selectService.value.discountAmount,
        totalInclusiveTax: selectService.value.assignDoctor.isNotEmpty
            ? selectService.value.assignDoctor
                .firstWhere((e) => e.doctorId == invoiceData.value.doctorId)
                .priceDetail
                .totalInclusiveTax
            : 0,
        inclusiveTaxJson: selectService.value.assignDoctor.isNotEmpty
            ? selectService.value.assignDoctor
                .firstWhere((e) => e.doctorId == invoiceData.value.doctorId)
                .priceDetail
                .inclusiveTaxJson
            : '',
      );
    } else {
      billingItem.quantity = quantity;
      billingItem.serviceAmount = amount;
      billingItem.totalAmount = total;
      billingItem.bedPrice = bedPrice.text.toDouble();

      billingItem.discountType = selectService.value.discountType;
      billingItem.discountValue = selectService.value.discountValue;
      billingItem.discountAmount = selectService.value.discountAmount;

      billingItem.totalInclusiveTax =
          selectService.value.assignDoctor.isNotEmpty
              ? selectService.value.assignDoctor
                  .firstWhere((e) => e.doctorId == invoiceData.value.doctorId)
                  .priceDetail
                  .totalInclusiveTax
              : billingItem.totalInclusiveTax;

      billingItem.inclusiveTaxJson = (selectService
                  .value.assignDoctor.isNotEmpty &&
              selectService.value.assignDoctor
                  .any((e) => e.doctorId == invoiceData.value.doctorId))
          ? selectService.value.assignDoctor
              .firstWhere((e) => e.doctorId == invoiceData.value.doctorId)
              .priceDetail
              .inclusiveTaxJson
          : billingItem.inclusiveTaxJson.isNotEmpty
              ? billingItem.inclusiveTaxJson
              : tempInclusiveText.value;
    }

    isLoading(showLoader);

    await CoreServiceApis.saveBillingItems(request: billingItem.toRequestJson())
        .then((value) {
      toast(value.message.trim().isNotEmpty
          ? value.message
          : "Billing Record Saved");
      getInvoiceDetail(showLoader: true);
      refreshAppoitmentRelatedPages();
    }).catchError((e) {
      toast("$e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> handleDeleteBillingItemClick(
      {required BuildContext context, required int id}) async {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.areYouSureYouWantToDeleteThisBillingItem,
      positiveText: locale.value.delete,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        if (isLoading.value) toast(locale.value.pleaseWaitWhileItsLoading);
        isLoading(true);
        CoreServiceApis.deleteBillingItems(id: id).then((value) {
          getInvoiceDetail(showLoader: true);
          toast(value.message.trim().isEmpty
              ? locale.value.billingItemRemovedSuccessfully
              : value.message.trim());
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => isLoading(false));
      },
    );
  }

  Future<RxList<ServiceElement>> getAllServices(
      {bool showloader = true, String params = '', int serviceID = 0}) async {
    if (showloader) {
      isLoading(true);
    }
    await serviceListFuture(
      CoreServiceApis.getServiceList(
        serviceList: serviceList,
        clinicId: invoiceData.value.clinicId,
        doctorId: invoiceData.value.doctorId,
        params: params,
        serviceId: serviceID > 0 ? serviceID.toString() : '',
      ),
    ).then((value) {}).catchError((e) {
      log("getServiceList Err : $e");
    }).whenComplete(() => isLoading(false));
    return serviceList;
  }
}
