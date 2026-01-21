import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';

class OrderModel {
  int orderId;
  Medicine medicine;

  String quantity;
  String deliveryDate;
  String orderDate;
  num? totalAmount;
  String paymentStatus;
  String orderStatus;

  OrderModel({
    required this.orderId,
    required this.quantity,
    required this.deliveryDate,
    required this.paymentStatus,
    required this.orderStatus,
    this.totalAmount,
    required this.medicine,
    this.orderDate = '',
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final medicine = json['medicine'] ?? {};

    return OrderModel(
      orderId: json['id'] is int ? json['id'] : -1,
      medicine: Medicine.fromJson(medicine),
      quantity: json['quantity'] ?? '',
      deliveryDate: json['delivery_date'] ?? '',
      totalAmount: json['total_amount'] is num
          ? json['total_amount']
          : json['total_amount'] is String
              ? num.tryParse(json['total_amount'])
              : null,
      paymentStatus: json['payment_status'] is String ? json['payment_status'] : '',
      orderStatus: json['order_status'] is String ? json['order_status'] : '',
      orderDate: json['created_at'] is String ? json['created_at'] : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "quantity": quantity,
      "delivery_date": deliveryDate,
      "payment_status": paymentStatus,
      'order_date' : orderDate,
    };
  }
}

class OrderListRes {
  int code;
  bool status;
  String message;
  List<OrderModel> data;

  OrderListRes({
    this.code = -1,
    this.status = false,
    this.message = "",
    this.data = const <OrderModel>[],
  });

  factory OrderListRes.fromJson(Map<String, dynamic> json) {
    final ordersJson = json['data']?['orders'];

    return OrderListRes(
      code: json['code'] is int ? json['code'] : -1,
      status: json['status'] == true,
      message: json['message'] ?? "",
      data: ordersJson is List ? ordersJson.map((x) => OrderModel.fromJson(x)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
