class StockHistoryResp {
  bool status;
  List<MedicineHistoryElement> data;
  String message;

  StockHistoryResp({
    this.status = false,
    this.data = const <MedicineHistoryElement>[],
    this.message = "",
  });

  factory StockHistoryResp.fromJson(Map<String, dynamic> json) {
    return StockHistoryResp(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List
          ? List<MedicineHistoryElement>.from(json['data'].map((x) => MedicineHistoryElement.fromJson(x)))
          : [],
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

class MedicineHistoryElement {
  int id;
  int medicineId;
  String medicineName;
  String batchNo;
  int quantity;
  String startSerialNo;
  String endSerialNo;
  String stockValue;
  String createdAt;
  String updatedAt;

  MedicineHistoryElement({
    this.id = -1,
    this.medicineId = -1,
    this.medicineName = "",
    this.batchNo = "",
    this.quantity = -1,
    this.startSerialNo = "",
    this.endSerialNo = "",
    this.stockValue = "",
    this.createdAt = "",
    this.updatedAt = "",
  });

  factory MedicineHistoryElement.fromJson(Map<String, dynamic> json) {
    return MedicineHistoryElement(
      id: json['id'] is int ? json['id'] : -1,
      medicineId: json['medicine_id'] is int ? json['medicine_id'] : -1,
      medicineName:
          json['medicine_name'] is String ? json['medicine_name'] : "",
      batchNo: json['batch_no'] is String ? json['batch_no'] : "",
      quantity: json['quantity'] is int ? json['quantity'] : -1,
      startSerialNo:
          json['start_serial_no'] is String ? json['start_serial_no'] : "",
      endSerialNo: json['end_serial_no'] is String ? json['end_serial_no'] : "",
      stockValue: json['stock_value'] is String ? json['stock_value'] : "",
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicine_id': medicineId,
      'medicine_name': medicineName,
      'batch_no': batchNo,
      'quantity': quantity,
      'start_serial_no': startSerialNo,
      'end_serial_no': endSerialNo,
      'stock_value': stockValue,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
