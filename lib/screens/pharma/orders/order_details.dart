import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/app_scaffold.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/models/order_model.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import 'package:kivicare_clinic_admin/utils/view_all_label_component.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/price_widget.dart';

class OrderDetails extends StatelessWidget {
  final OrderModel order;

  const OrderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: "${locale.value.order} #${order.orderId}",
      hasLeadingWidget: true,
      appBarVerticalSize: Get.height * 0.12,
      body: AnimatedScrollView(
        listAnimationType: ListAnimationType.FadeIn,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 64),
        children: [
          ViewAllLabel(label: locale.value.aboutOrder, isShowAll: false),
          8.height,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInfoRow(title: locale.value.medicineName, value: order.medicine.name),
                buildInfoRow(title: locale.value.quantity, value: order.quantity),
                buildPriceInfoRow(title: locale.value.purchasePrice, price: order.medicine.purchasePrice.toDouble()),
                buildPriceInfoRow(title: locale.value.totalAmount, price: (order.quantity.toDouble() * order.medicine.purchasePrice.toDouble())),
                buildInfoRow(title: locale.value.orderDate, value: order.deliveryDate),
                buildInfoRow(title: locale.value.deliveryDate, value: order.deliveryDate),
                buildInfoRow(
                    title: locale.value.orderStatus,
                    value: order.orderStatus.toLowerCase().contains(StatusConst.pending)
                        ? locale.value.pending
                        : order.orderStatus.toLowerCase().contains(StatusConst.delivered)
                            ? locale.value.delivered
                            : order.orderStatus.toLowerCase().contains(StatusConst.cancelled)
                                ? locale.value.cancelled
                                : order.orderStatus),
                buildInfoRow(title: locale.value.paymentStatus, value: order.paymentStatus.toLowerCase().contains(StatusConst.completed) || order.paymentStatus.toLowerCase().contains(PaymentStatus.PAID) ? locale.value.paid : locale.value.unpaid),
              ],
            ),
          ),
          24.height,
          ViewAllLabel(label: locale.value.suppliers, isShowAll: false),
          8.height,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              children: [
                Row(
                  children: [
                    CachedImageWidget(
                      url: order.medicine.supplier.imageUrl,
                      height: 50,
                      width: 50,
                      circle: true,
                      fit: BoxFit.cover,
                    ),
                    12.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${order.medicine.supplier.firstName} ${order.medicine.supplier.lastName}", style: boldTextStyle(size: 16)),
                          Text(
                            order.medicine.supplier.email,
                            style: secondaryTextStyle(size: 14).copyWith(
                              decoration: TextDecoration.underline,
                              color: context.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                16.height,
                Divider(color: isDarkMode.value ? borderColor.withValues(alpha: 0.2) : context.dividerColor.withValues(alpha: 0.2), height: 1),
                buildInfoRow(title: locale.value.contactNumber, value: order.medicine.supplier.contactNumber),
                Divider(color: isDarkMode.value ? borderColor.withValues(alpha: 0.2) : context.dividerColor.withValues(alpha: 0.2), height: 1),
                buildInfoRow(title: locale.value.paymentTerms, value: order.medicine.supplier.paymentTerms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text("$title: ", style: secondaryTextStyle(size: 14)),
          6.width,
          Flexible(child: Text(value, style: primaryTextStyle(size: 14))),
        ],
      ),
    );
  }

  Widget buildPriceInfoRow({required String title, required num price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text("$title: ", style: secondaryTextStyle(size: 14)),
          6.width,
          Flexible(
            child: PriceWidget(price: price.toStringAsFixed(2).toDouble(), size: 14, isSemiBoldText: true),
          ),
        ],
      ),
    );
  }
}
