class RevenueResp {
  bool status;
  RevenueModel data;
  String message;

  RevenueResp({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory RevenueResp.fromJson(Map<String, dynamic> json) {
    return RevenueResp(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? RevenueModel.fromJson(json['data']) : RevenueModel(),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class RevenueModel {
  List<num> yearChartData;
  List<String> monthNames;
  List<num> monthChartData;
  List<String> weekNames;
  List<num> weekChartData;
  List<String> dayNames;

  RevenueModel({
    this.yearChartData = const <num>[],
    this.monthNames = const <String>[],
    this.monthChartData = const <num>[],
    this.weekNames = const <String>[],
    this.weekChartData = const <num>[],
    this.dayNames = const <String>[],
  });

  factory RevenueModel.fromJson(Map<String, dynamic> json) {
    return RevenueModel(
      yearChartData: json['year_chart_data'] is List
          ? List<num>.from(json['year_chart_data'].map((x) => x))
          : [],
      monthNames: json['month_names'] is List
          ? List<String>.from(json['month_names'].map((x) => x))
          : [],
      monthChartData: json['month_chart_data'] is List
          ? List<num>.from(json['month_chart_data'].map((x) => x))
          : [],
      weekNames: json['weekNames'] is List
          ? List<String>.from(json['weekNames'].map((x) => x))
          : [],
      weekChartData: json['week_chart_data'] is List
          ? List<num>.from(json['week_chart_data'].map((x) => x))
          : [],
      dayNames: json['dayNames'] is List
          ? List<String>.from(json['dayNames'].map((x) => x))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year_chart_data': yearChartData.map((e) => e).toList(),
      'month_names': monthNames.map((e) => e).toList(),
      'month_chart_data': monthChartData.map((e) => e).toList(),
      'weekNames': weekNames.map((e) => e).toList(),
      'week_chart_data': weekChartData.map((e) => e).toList(),
      'dayNames': dayNames.map((e) => e).toList(),
    };
  }
}
