import 'package:nb_utils/nb_utils.dart';

class MedicineListRes {
  int code;
  bool status;
  String message;
  List<Medicine> data;

  MedicineListRes({
    this.code = -1,
    this.status = false,
    this.message = "",
    this.data = const <Medicine>[],
  });

  factory MedicineListRes.fromJson(Map<String, dynamic> json) {
    return MedicineListRes(
      code: json['code'] is int ? json['code'] : -1,
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List ? List<Medicine>.from(json['data'].map((x) => Medicine.fromJson(x))) : [],
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

class Medicine {
  int id;
  String name;
  String dosage;
  MedicineCategory category;
  MedicineForm form;
  String expiryDate;
  String note;
  Supplier supplier;
  String contactNumber;
  String paymentTerms;
  String quntity;
  String reOrderLevel;
  Manufacturer manufacturer;
  String batchNo;
  String startSerialNo;
  String endSerialNo;
  num purchasePrice;
  num sellingPrice;
  String stockValue;
  bool isInclusiveTax;

  Medicine({
    this.id = -1,
    this.name = "",
    this.dosage = "",
    required this.category,
    required this.form,
    this.expiryDate = "",
    this.note = "",
    required this.supplier,
    this.contactNumber = "",
    this.paymentTerms = "",
    this.quntity = "",
    this.reOrderLevel = "",
    required this.manufacturer,
    this.batchNo = "",
    this.startSerialNo = "",
    this.endSerialNo = "",
    this.purchasePrice = 0,
    this.sellingPrice = 0,
    this.stockValue = "",
    this.isInclusiveTax = false,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      dosage: json['dosage'] is String ? json['dosage'] : "",
      category: json['category'] is Map ? MedicineCategory.fromJson(json['category']) : MedicineCategory(),
      form: json['form'] is Map ? MedicineForm.fromJson(json['form']) : MedicineForm(),
      expiryDate: json['expiry_date'] is String ? json['expiry_date'] : "",
      note: json['note'] is String ? json['note'] : "",
      supplier: json['supplier'] is Map ? Supplier.fromJson(json['supplier']) : Supplier(supplierType: SupplierType(), imageUrl: ''),
      contactNumber: json['contact_number'] is String ? json['contact_number'] : "",
      paymentTerms: json['payment_terms'] is String ? json['payment_terms'] : "",
      quntity: json['quntity'] is String
          ? json['quntity']
          : json['quntity'] is int
              ? json['quntity'].toString()
              : "",
      reOrderLevel: json['re_order_level'] is String ? json['re_order_level'] : "",
      manufacturer: json['manufacturer'] is Map ? Manufacturer.fromJson(json['manufacturer']) : Manufacturer(),
      batchNo: json['batch_no'] is String ? json['batch_no'] : "",
      startSerialNo: json['start_serial_no'] is String ? json['start_serial_no'] : "",
      endSerialNo: json['end_serial_no'] is String ? json['end_serial_no'] : "",
      purchasePrice: json['purchase_price'] is num
          ? json['purchase_price']
          : json['purchase_price'] is String
              ? (json['purchase_price'] as String).toDouble()
              : 0,
      sellingPrice: json['selling_price'] is num
          ? json['selling_price']
          : json['selling_price'] is String
              ? (json['selling_price'] as String).toDouble()
              : 0,
      stockValue: json['stock_value'] is String ? json['stock_value'] : "",
      isInclusiveTax: json['is_inclusive_tax'] is bool ? json['is_inclusive_tax'] : json['is_inclusive_tax'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'category': category.toJson(),
      'form': form.toJson(),
      'expiry_date': expiryDate,
      'note': note,
      'supplier': supplier.toJson(),
      'contact_number': contactNumber,
      'payment_terms': paymentTerms,
      'quntity': quntity,
      're_order_level': reOrderLevel,
      'manufacturer': manufacturer.toJson(),
      'batch_no': batchNo,
      'start_serial_no': startSerialNo,
      'end_serial_no': endSerialNo,
      'purchase_price': purchasePrice,
      'selling_price': sellingPrice,
      'stock_value': stockValue,
      'is_inclusive_tax': isInclusiveTax,
    };
  }
}

class MedicineCategory {
  int id;
  String name;
  int status;
  String createdAt;
  String updatedAt;

  MedicineCategory({
    this.id = -1,
    this.name = "",
    this.status = -1,
    this.createdAt = "",
    this.updatedAt = "",
  });

  factory MedicineCategory.fromJson(Map<String, dynamic> json) {
    return MedicineCategory(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      status: json['status'] is int ? json['status'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class MedicineForm {
  int id;
  String name;
  int status;

  MedicineForm({
    this.id = -1,
    this.name = "",
    this.status = -1,
  });

  factory MedicineForm.fromJson(Map<String, dynamic> json) {
    return MedicineForm(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      status: json['status'] is int ? json['status'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }
}

class Supplier {
  int id;
  String firstName;
  String? supplierFullName;
  String lastName;
  String email;
  String contactNumber;
  SupplierType supplierType;
  int pharmaId;
  String paymentTerms;
  String imageUrl;
  int status;
  int unit;

  Supplier({
    this.id = -1,
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.contactNumber = "",
    required this.supplierType,
    this.pharmaId = -1,
    this.paymentTerms = "",
    required this.imageUrl,
    this.status = -1,
    this.supplierFullName = "",
    this.unit = 0,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] is int ? json['id'] : -1,
      firstName: json['first_name'] is String ? json['first_name'] : "",
      lastName: json['last_name'] is String ? json['last_name'] : "",
      email: json['email'] is String ? json['email'] : "",
      contactNumber: json['contact_number'] is String ? json['contact_number'] : "",
      supplierType: json['supplier_type'] is Map ? SupplierType.fromJson(json['supplier_type']) : SupplierType(),
      pharmaId: json['pharma_id'] is int ? json['pharma_id'] : -1,
      paymentTerms: json['payment_terms'] is String ? json['payment_terms'] : "",
      imageUrl: json['image_url'] is String ? json['image_url'] : "",
      status: json['status'] is int
          ? json['status']
          : json['status'] is String
              ? int.parse(json['status'])
              : -1,
      supplierFullName: json['full_name'] is String ? json['full_name'] : "",
      unit: json['unit'] is int ? json['unit'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'contact_number': contactNumber,
      'supplier_type': supplierType.toJson(),
      'pharma_id': pharmaId,
      'payment_terms': paymentTerms,
      'image_url': imageUrl,
      'status': status,
    };
  }

  String get fullName => '$firstName $lastName';
}

class SupplierType {
  int id;
  String name;
  int status;

  SupplierType({
    this.id = -1,
    this.name = "",
    this.status = -1,
  });

  factory SupplierType.fromJson(Map<String, dynamic> json) {
    return SupplierType(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      status: json['status'] is int ? json['status'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }
}

class Manufacturer {
  int id;
  String name;
  dynamic status;

  Manufacturer({
    this.id = -1,
    this.name = "",
    this.status,
  });

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }
}

class Pharma {
  int id = -1;
  String fullName = "";
  String firstName = "";
  String email = "";
  String lastName = "";
  String imageUrl = "";
  String contactNumber = "";
  String? gender;
  String dateOfBirth = "";
  String address = "";
  String image = "";
  int status;
  int clinicId = -1;
  List<PharmaCommission> commission;

  Pharma({
    this.id = -1,
    this.fullName = "",
    this.firstName = "",
    this.email = "",
    this.lastName = "",
    this.imageUrl = "",
    this.contactNumber = "",
    this.image = "",
    this.address = "",
    this.dateOfBirth = "",
    this.gender = "",
    this.status = 0,
    this.clinicId = -1,
    this.commission = const [],
  });

  factory Pharma.fromJson(Map<String, dynamic> json) {
    return Pharma(
      id: json['id'] is int ? json['id'] : -1,
      fullName: json['full_name'] is String ? json['full_name'] : "",
      firstName: json['first_name'] is String ? json['first_name'] : "",
      email: json['email'] is String ? json['email'] : "",
      lastName: json['last_name'] is String ? json['last_name'] : "",
      imageUrl: json['profile_image'] is String ? json['profile_image'] : "",
      contactNumber: json['mobile'] is String ? json['mobile'] : "",
      image: json['avatar'] is String ? json['avatar'] : "",
      address: json['address'] is String ? json['address'] : "",
      dateOfBirth: json['date_of_birth'] is String ? json['date_of_birth'] : "",
      status: json['status'] is int ? json['status'] : 0,
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      commission: json['commission'] is List ? List<PharmaCommission>.from(json['commission'].map((x) => PharmaCommission.fromJson(x))) : [],
    );
  }
}

class PharmaCommission {
  int? id;
  int? employeeId;
  int? commissionId;
  String? title;
  String? commissionType;
  num? commissionValue;
  num? charges;
  String? name;

  PharmaCommission({
    this.id,
    this.employeeId,
    this.commissionId,
    this.title,
    this.commissionType,
    this.commissionValue,
    this.charges,
    this.name,
  });

  factory PharmaCommission.fromJson(Map<String, dynamic> json) {
    return PharmaCommission(
      id: json['id'],
      employeeId: json['employee_id'],
      commissionId: json['commission_id'],
      title: json['title'],
      commissionType: json['commission_type'],
      commissionValue: json['commission_value'],
      charges: json['charges'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'commission_id': commissionId,
      'title': title,
      'commission_type': commissionType,
      'commission_value': commissionValue,
      'charges': charges,
      'name': name,
    };
  }
}
