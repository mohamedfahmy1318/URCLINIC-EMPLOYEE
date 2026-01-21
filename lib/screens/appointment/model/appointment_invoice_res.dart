class AppointmentInvoiceResp {
  bool status;
  String link;

  AppointmentInvoiceResp({
    this.status = false,
    this.link = "",
  });

  factory AppointmentInvoiceResp.fromJson(Map<String, dynamic> json) {
    return AppointmentInvoiceResp(
      status: json['status'] is bool ? json['status'] : false,
      link: json['link'] is String ? json['link'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'link': link,
    };
  }
}
