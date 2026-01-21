import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/loader_widget.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/add_purchase_order.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/order_card.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/controller/order_controller.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/order_details.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/search_order_screen.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/utils/empty_error_state_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common_base.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
        init: OrderController(),
        builder: (controller) {
          return AppScaffoldNew(
            appBartitleText: locale.value.allOrders,
            hasLeadingWidget: true,
            isLoading: controller.isLoading,
            appBarVerticalSize: Get.height * 0.12,
            body: Column(
              children: [
                SearchOrderWidget(controller: controller).paddingSymmetric(horizontal: 16),
                /* 32.height,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    locale.value.allPurchaseOrder,
                    style: boldTextStyle(size: 18),
                  ),
                ).paddingOnly(
                  left: 16,
                ), */
                16.height,
                Obx(
                  () => SnapHelperWidget(
                    future: controller.orderListFuture.value,
                    loadingWidget: controller.isLoading.value ? const Offstage() : const LoaderWidget(),
                    errorBuilder: (error) => Text("Error: $error").center(),
                    onSuccess: (res) {
                      return Obx(() {
                        return AnimatedListView(
                          itemCount: controller.orderList.length,
                          listAnimationType: ListAnimationType.FadeIn,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          physics: const AlwaysScrollableScrollPhysics(),
                          emptyWidget: NoDataWidget(
                            title: locale.value.noOrdersFound,
                            subTitle: locale.value.youHaveNotPlacedAnyOrder,
                            titleTextStyle: primaryTextStyle(),
                            imageWidget: const EmptyStateWidget(),
                            retryText: locale.value.reload,
                            onRetry: () async {
                              await controller.getOrders(showLoader: false);
                            },
                          ),
                          onSwipeRefresh: () async {
                            await controller.getOrders(showLoader: false);
                          },
                          itemBuilder: (_, index) {
                            final order = controller.orderList[index];
                            return OrderCard(
                              order: controller.orderList[index],
                              onEditClick: () {
                                if (Get.isRegistered<OrderController>()) {
                                  final orderCtrl = Get.find<OrderController>();
                                  orderCtrl.quantityCont.text = controller.orderList[index].quantity;
                                  orderCtrl.deliveryDateCont.text = controller.orderList[index].deliveryDate;
                                  orderCtrl.totalAmountCont.text = controller.orderList[index].totalAmount.toString();
                                  orderCtrl.orderId.value = controller.orderList[index].orderId;
                                  orderCtrl.orderDateCont.text = controller.orderList[index].orderDate.dateInyyyyMMddFormat.toString().splitBefore(' ');
                                  // Order Status
                                  final status = order.orderStatus.trim().toLowerCase();
                                  orderCtrl.selectedOrderStatus.value = status == 'cancelled'
                                      ? 'Cancelled'
                                      : status == 'pending'
                                          ? 'Pending'
                                          : 'Delivered';

                                  // Payment Status
                                  orderCtrl.selectedPaymentStatus.value = order.paymentStatus.trim().toLowerCase() == 'completed' ? 'Paid' : 'Unpaid';

                                  Get.bottomSheet(
                                    AddPurchaseOrder(
                                      medicineData: controller.orderList[index].medicine,
                                      isEdit: true,
                                    ),
                                    isScrollControlled: true,
                                  );
                                }
                              },
                              onDeleteClick: () {
                                controller.deleteOrder(id: controller.orderList[index].orderId, context: context);
                              },
                              viewReport: () {
                                Get.to(() => OrderDetails(order: controller.orderList[index]));
                              },
                            ).paddingBottom(16);
                          },
                        );
                      });
                    },
                  ).expand(),
                ),
              ],
            ).paddingOnly(top: 16, bottom: 70),
          );
        });
  }
}
