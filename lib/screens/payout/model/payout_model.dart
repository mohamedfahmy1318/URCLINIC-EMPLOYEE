class PayoutListModel {
  bool status;
  List<PayoutModel> data;
  String message;

  PayoutListModel({
    this.status = false,
    this.data = const <PayoutModel>[],
    this.message = "",
  });

  factory PayoutListModel.fromJson(Map<String, dynamic> json) {
    return PayoutListModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<PayoutModel>.from(json['data'].map((x) => PayoutModel.fromJson(x))) : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class PayoutModel {
  int id;
  int doctorId;
  String doctorName;
  num totalAmount;
  num commissionAmount;
  String paymentDate;
  String paymentType;
  bool status;

  PayoutModel({
    this.id = -1,
    this.doctorId = -1,
    this.doctorName = "",
    this.totalAmount = 0,
    this.commissionAmount = 0,
    this.paymentDate = "",
    this.paymentType = "",
    this.status = false,
  });

  factory PayoutModel.fromJson(Map<String, dynamic> json) {
    return PayoutModel(
      id: json['id'] is int ? json['id'] : -1,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      doctorName: json['doctor_name'] is String ? json['doctor_name'] : "",
      totalAmount: json['total_amount'] is num ? json['total_amount'] : 0,
      commissionAmount: json['commission_amount'] is num ? json['commission_amount'] : 0,
      paymentDate: json['payment_date'] is String ? json['payment_date'] : "",
      paymentType: json['payment_type'] is String ? json['payment_type'] : "",
      status: json['status'] is bool ? json['status'] : json['status'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'total_amount': totalAmount,
      'commission_amount': commissionAmount,
      'payment_date': paymentDate,
      'payment_type': paymentType,
      'status': status,
    };
  }
}
