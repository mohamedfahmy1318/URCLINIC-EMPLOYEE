import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/pharma_apis.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/models/order_model.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderController extends GetxController {
  Rx<Future<RxList<OrderModel>>> orderListFuture = Future(() => RxList<OrderModel>()).obs;
  RxList<OrderModel> orderList = RxList();
  final TextEditingController quantityCont = TextEditingController();
  final TextEditingController totalAmountCont = TextEditingController();
  final TextEditingController deliveryDateCont = TextEditingController();
  final TextEditingController orderDateCont = TextEditingController();
  final FocusNode quantityFocus = FocusNode();
  final FocusNode totalAmountFocus = FocusNode();
  final GlobalKey<FormState> addStockFormKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  RxInt orderId = (-1).obs;
  RxInt medicineId = 0.obs;

  TextEditingController searchOrderCont = TextEditingController();
  RxBool isSearchOrderText = false.obs;

  List<String> orderStatusList = [
    "Cancelled",
    "Delivered",
    "Pending",
  ];

  List<String> orderPaymentStatusList = [
    "Paid",
    "Unpaid",
  ];

  RxString selectedOrderStatus = "Pending".obs;
  RxString selectedPaymentStatus = "Unpaid".obs;

  @override
  void onInit() async {
    await getOrders(showLoader: true);
    super.onInit();
    quantityCont.text = "";
    deliveryDateCont.text = "";
    totalAmountCont.text = "";
  }

  Future<void> placeOrder({bool isEdit = false}) async {
    if (addStockFormKey.currentState!.validate()) {
      isLoading(true);
      var orderStatus = getOrderStatusConst(selectedOrderStatus.value);
      var paymentStatus = getPaymentStatusConst(selectedPaymentStatus.value);
      final request = {
        "medicine_id": medicineId.value,
        "quantity": quantityCont.text,
        "delivery_date": deliveryDateCont.text,
        'order_status': orderStatus,
        'payment_status': paymentStatus,
      };
      isEdit
          ? await PharmaApis.editPurchaseOrder(request: request, id: orderId.value).then((value) {
              if (value.status) {
                toast(value.message);
              }
            }).whenComplete(() {
              isLoading(false);
              if (Get.isRegistered<OrderController>()) {
                Get.find<OrderController>().getOrders();
              }
              Get.back();
            }).catchError((e) {
              isLoading(false);
              toast(e.toString());
            })
          : await PharmaApis.purchaseOrder(request: request).then((value) {
              if (value.status) {
                toast(locale.value.orderPlacedSuccessfully);
              }
            }).whenComplete(() {
              if (Get.isRegistered<OrderController>()) {
                Get.find<OrderController>().getOrders();
              }
              isLoading(false);
              Get.back();
            }).catchError((e) {
              isLoading(false);
              log(e.toString());
              toast("Failed to place order");
            });
    }
  }

  String getPaymentStatusConst(String paymentStatus) {
    if (paymentStatus.toLowerCase().contains(PaymentStatus.PAID.toLowerCase()) || paymentStatus.toLowerCase().contains(StatusConst.completed)) {
      paymentStatus = StatusConst.completed;
    } else if (paymentStatus.toLowerCase().contains(PaymentStatus.UNPAID.toLowerCase()) || paymentStatus.toLowerCase().contains(StatusConst.pending)) {
      paymentStatus = StatusConst.pending;
    }
    return paymentStatus;
  }

  String getOrderStatusConst(String orderStatus) {
    if (orderStatus.toLowerCase().contains(StatusConst.pending)) {
      orderStatus = StatusConst.pending;
    } else if (orderStatus.toLowerCase().contains(StatusConst.delivered)) {
      orderStatus = StatusConst.delivered;
    } else if (orderStatus.toLowerCase().contains(StatusConst.cancelled)) {
      orderStatus = StatusConst.cancelled;
    }
    return orderStatus;
  }

  Future<void> getOrders({bool showLoader = true}) async {
    if (showLoader) isLoading(true);

    try {
      await orderListFuture(
        PharmaApis.getOrderList(
          page: page.value,
          search: searchOrderCont.text.isNotEmpty ? searchOrderCont.text.trim() : '',
          orderList: orderList,
          // id: loginUserData.value.userRole.contains(EmployeeKeyConst.vendor) ? -1 : loginUserData.value.id,
          lastPageCallBack: (lastPage) => isLastPage(lastPage),
        ),
      );
    } catch (e) {
      log("getOrders error: $e");
      toast("Failed to load orders");
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteOrder({required BuildContext context, int id = -1}) async {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.areYouSureWantToDeleteOrder,
      positiveText: locale.value.yes,
      negativeText: locale.value.no,
      onAccept: (ctx) async {
        isLoading(true);
        PharmaApis.deletePurchaseOrder(id: id).then((value) {
          if (value.status) {
            toast(value.message);
          }
        }).whenComplete(() {
          isLoading(false);
          getOrders();
        }).catchError((e) {
          isLoading(false);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    quantityCont.dispose();
  }
}
