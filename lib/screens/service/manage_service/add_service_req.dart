class AddClinicReq {
  String clinicName;
  String description;
  String address;
  String city;
  String state;
  String country;
  String pincode;
  String contactNumber;
  String latitude;
  String longitude;
  String systemServiceCategory;
  String status;

  AddClinicReq({
    this.clinicName = "",
    this.description = "",
    this.address = "",
    this.city = "",
    this.state = "",
    this.country = "",
    this.pincode = "",
    this.contactNumber = "",
    this.latitude = "",
    this.longitude = "",
    this.systemServiceCategory = "",
    this.status = "",
  });

  factory AddClinicReq.fromJson(Map<String, dynamic> json) {
    return AddClinicReq(
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : "",
      description: json['description'] is String ? json['description'] : "",
      address: json['address'] is String ? json['address'] : "",
      city: json['city'] is String ? json['city'] : "",
      state: json['state'] is String ? json['state'] : "",
      country: json['country'] is String ? json['country'] : "",
      pincode: json['pincode'] is String ? json['pincode'] : "",
      contactNumber: json['contact_number'] is String ? json['contact_number'] : "",
      latitude: json['latitude'] is String ? json['latitude'] : "",
      longitude: json['longitude'] is String ? json['longitude'] : "",
      systemServiceCategory: json['system_service_category'] is String ? json['system_service_category'] : "",
      status: json['status'] is String ? json['status'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinic_name': clinicName,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'contact_number': contactNumber,
      'latitude': latitude,
      'longitude': longitude,
      'system_service_category': systemServiceCategory,
      'status': status,
    };
  }
}
