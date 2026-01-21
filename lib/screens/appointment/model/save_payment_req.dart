import '../../home/model/dashboard_res_model.dart';

class SavePaymentReq {
  int id;
  // int paymentID;
  String externalTransactionId;
  String transactionType;
  // num discountPercentage;
  // num discountAmount;
  List<TaxPercentage> taxPercentage;
  int paymentStatus;
  int advancePaymentStatus;
  num advancePaymentAmount;
  // num totalAmount;
  num remainingPaymentAmount;

  SavePaymentReq({
    this.id = -1,
    // this.paymentID = -1,
    this.externalTransactionId = "",
    this.transactionType = "",
    // this.discountPercentage = -1,
    // this.discountAmount = -1,
    this.taxPercentage = const <TaxPercentage>[],
    this.paymentStatus = -1,
    this.advancePaymentStatus = 0,
    this.advancePaymentAmount = 0,
    this.remainingPaymentAmount = 0,
    // this.totalAmount = -1,
  });

  factory SavePaymentReq.fromJson(Map<String, dynamic> json) {
    return SavePaymentReq(
      id: json['id'] is int ? json['id'] : -1,
      // paymentID: json['id'] is int ? json['id'] : -1,
      externalTransactionId: json['external_transaction_id'] is String ? json['external_transaction_id'] : "",
      transactionType: json['transaction_type'] is String ? json['transaction_type'] : "",
      // discountPercentage: json['discount_percentage'] is num ? json['discount_percentage'] : -1,
      // discountAmount: json['discount_amount'] is num ? json['discount_amount'] : -1,
      taxPercentage: json['tax_percentage'] is List ? List<TaxPercentage>.from(json['tax_percentage'].map((x) => TaxPercentage.fromJson(x))) : [],
      paymentStatus: json['payment_status'] is int ? json['payment_status'] : 0,
      advancePaymentStatus: json['advance_payment_status'] is int ? json['advance_payment_status'] : 0,
      advancePaymentAmount: json['advance_payment_amount'] is num ? json['advance_payment_amount'] : 0,
      remainingPaymentAmount: json['remaining_payment_amount'] is num ? json['remaining_payment_amount'] : 0,
      // totalAmount: json['total_amount'] is num ? json['total_amount'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      if (externalTransactionId.trim().isNotEmpty) 'external_transaction_id': externalTransactionId,
      'transaction_type': transactionType,
      // if (!discountPercentage.isNegative) 'discount_percentage': discountPercentage,
      // if (!discountAmount.isNegative) 'discount_amount': discountAmount,
      // 'tax_percentage': jsonEncode(taxPercentage.map((e) => e.toJson()).toList()),
      'tax_percentage': taxPercentage,
      'payment_status': paymentStatus,
      'advance_payment_status': advancePaymentStatus,
      'advance_payment_amount': advancePaymentAmount,
      'remaining_payment_amount': remainingPaymentAmount,
      // 'total_amount': totalAmount,
    };
  }
}
