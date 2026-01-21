import 'encounter_details_resp.dart';

class ServiceDetailResp {
  bool status;
  ServiceDetails data;

  ServiceDetailResp({
    this.status = false,
    required this.data,
  });

  factory ServiceDetailResp.fromJson(Map<String, dynamic> json) {
    return ServiceDetailResp(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map
          ? ServiceDetails.fromJson(json['data'])
          : ServiceDetails(servicePriceData: ServicePriceData()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}
