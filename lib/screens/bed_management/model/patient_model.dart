class PatientModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? address;
  String? dateOfBirth;
  String? gender;
  String? bloodGroup;
  String? profileImage;

  PatientModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.profileImage,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      bloodGroup: json['blood_group'],
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['address'] = address;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['blood_group'] = bloodGroup;
    data['profile_image'] = profileImage;
    return data;
  }
}