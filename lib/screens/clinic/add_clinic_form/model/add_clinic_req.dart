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
  int systemServiceCategory;
  String status;
  String timeSlot;
  String email;
  int speciality;

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
    this.systemServiceCategory = 0,
    this.status = "",
    this.timeSlot = "",
    this.email = "",
    this.speciality = 0,
  });

  factory AddClinicReq.fromJson(Map<String, dynamic> json) {
    return AddClinicReq(
      clinicName: json['name'] is String ? json['name'] : "",
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
      timeSlot: json['time_slot'] is String ? json['time_slot'] : "",
      email: json['email'] is String ? json['email'] : "",
      speciality: json['speciality'] is String ? json['speciality'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': clinicName,
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
      'time_slot': timeSlot,
      'email': email,
      'speciality': speciality,
    };
  }
}
