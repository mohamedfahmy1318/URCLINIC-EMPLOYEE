import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/components/cached_image_widget.dart';
import 'package:kivicare_clinic_admin/generated/assets.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/models/order_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/controller/order_controller.dart';
import 'package:kivicare_clinic_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/app_common.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onEditClick;
  final VoidCallback? onDeleteClick;
  final VoidCallback? onDatePick;
  final VoidCallback? viewReport;

  OrderCard({
    super.key,
    required this.order,
    this.onEditClick,
    this.onDeleteClick,
    this.onDatePick,
    this.viewReport,
  });

  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(12),
        backgroundColor: context.cardColor,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Medicine Name + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichTextWidget(
                  list: [
                    TextSpan(text: "${locale.value.medicineName} :-", style: secondaryTextStyle(size: 14)),
                    TextSpan(text: ' ${order.medicine.name}', style: boldTextStyle(size: 14)),
                  ],
                ),
              ),
              Row(
                children: [
                  if (order.orderStatus.toLowerCase() != "delivered" || order.paymentStatus.toLowerCase() != "completed")
                    IconButton(
                      onPressed: onEditClick,
                      icon: Image.asset(Assets.iconsIcEditReview, width: 20, height: 20, color: iconColor),
                    ),
                  if (order.orderStatus.toLowerCase() != "delivered" || order.paymentStatus.toLowerCase() != "completed")
                    IconButton(
                      onPressed: onDeleteClick,
                      icon: Image.asset(Assets.iconsIcDelete, width: 20, height: 20, color: iconColor),
                    ),
                  IconButton(
                    onPressed: viewReport,
                    icon: Image.asset(Assets.iconsIcNotepad, width: 20, height: 20, color: iconColor),
                  ),
                ],
              ),
            ],
          ),

          8.height,
          const Divider(height: 1),
          16.height,

          // Section: Medicine Info
          Text(locale.value.medicineInfo, style: secondaryTextStyle(size: 14)),
          8.height,
          Container(
            width: Get.width,
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: isDarkMode.value ? cardDarkColor : Colors.grey.shade100,
              borderRadius: radius(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(icon: Icons.date_range, label: "${locale.value.orderDate}: ", value: order.orderDate.splitBefore(' '), boldRight: true),
                8.height,
                _infoRow(icon: Icons.inventory_2_outlined, label: "${locale.value.quantity}: ", value: order.quantity, boldRight: true),
                8.height,
                _infoRow(icon: Icons.local_shipping_outlined, label: "${locale.value.deliveryDate}: ", value: order.deliveryDate, boldRight: true),
                8.height,
                Row(
                  children: [
                    CachedImageWidget(
                      url: Assets.iconsIcCalendar,
                      height: 18,
                      width: 18,
                      color: isDarkMode.value ? Colors.white70 : Colors.grey,
                    ),
                    10.width,
                    Text(locale.value.orderStatus, style: secondaryTextStyle()),
                    4.width,
                    Expanded(
                      child: Text(
                        getOrderStatus(status: order.orderStatus),
                        // order.orderStatus.capitalizeFirstLetter(),
                        style: primaryTextStyle(color: getOrderStatusColor(orderStatus: order.orderStatus), size: 12),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                8.height,
                Row(
                  children: [
                    CachedImageWidget(
                      url: Assets.iconsIcCircleDollar,
                      height: 18,
                      width: 18,
                      color: isDarkMode.value ? Colors.white70 : Colors.grey,
                    ),
                    10.width,
                    Text("${locale.value.paymentStatus}: ", style: secondaryTextStyle()),
                    4.width,
                    Expanded(
                      child: Text(
                        getPrescriptionPaymentStatus(status: order.paymentStatus),
                        style: primaryTextStyle(color: getPrescriptionPaymentStatusColor(paymentStatus: order.paymentStatus), size: 12),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          32.height,
          // About Supplier
          Text(locale.value.aboutSupplier, style: secondaryTextStyle(size: 14)),
          12.height,
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                child: order.medicine.supplier.imageUrl.toString().isNotEmpty
                    ? CachedImageWidget(
                        url: order.medicine.supplier.imageUrl,
                        fit: BoxFit.cover,
                        height: 52,
                        width: 52,
                        circle: true,
                      )
                    : CachedImageWidget(
                        url: order.medicine.supplier.imageUrl.toString(),
                        fit: BoxFit.cover,
                        height: 44,
                        width: 44,
                        circle: true,
                      ),
              ),
              16.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${order.medicine.supplier.firstName} ${order.medicine.supplier.lastName}", style: boldTextStyle(size: 14)),
                    4.height,
                    Text(order.medicine.supplier.email, style: secondaryTextStyle()),
                  ],
                ),
              ),
            ],
          ),
          20.height,

          // About Manufacturer
          Text(locale.value.aboutManufacturer, style: secondaryTextStyle(size: 14)),
          12.height,
          Row(
            children: [
              Text(order.medicine.manufacturer.name, style: boldTextStyle()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow({required IconData icon, required String label, required String value, Color? valueColor, bool boldRight = false}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isDarkMode.value ? Colors.white70 : Colors.grey),
        10.width,
        Text(label, style: secondaryTextStyle()),
        4.width,
        Expanded(
          child: Text(
            value,
            style: boldRight ? primaryTextStyle(size: 12) : secondaryTextStyle(color: valueColor ?? textPrimaryColorGlobal),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
