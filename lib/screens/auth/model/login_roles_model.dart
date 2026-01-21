import '../../../utils/constants.dart';

class LoginRoleData {
  int id;
  String roleName;
  String email;
  String password;
  String icon;
  String userType;

  LoginRoleData({
    this.id = -1,
    this.roleName = "",
    this.email = "",
    this.password = "",
    this.icon = "",
    this.userType = "",
  });

  factory LoginRoleData.fromJson(Map<String, dynamic> json) {
    return LoginRoleData(
      id: json['id'] is int ? json['id'] : -1,
      roleName: json['serviceName'] is String ? json['serviceName'] : "",
      email: json['serviceName'] is String ? json['email'] : "",
      password: json['password'] is String ? json['password'] : "",
      icon: json['icon'] is String ? json['icon'] : "",
      userType: json[UserKeys.userType] is String ? json[UserKeys.userType] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': roleName,
      'email': email,
      'password': password,
      'icon': icon,
      UserKeys.userType: userType,
    };
  }
}
