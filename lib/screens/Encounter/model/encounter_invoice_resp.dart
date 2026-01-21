class EncounterInvoiceResp {
  bool status;
  String link;

  EncounterInvoiceResp({
    this.status = false,
    this.link = "",
  });

  factory EncounterInvoiceResp.fromJson(Map<String, dynamic> json) {
    return EncounterInvoiceResp(
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
