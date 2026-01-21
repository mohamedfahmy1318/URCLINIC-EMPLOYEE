class MedicineUsageChartResp {
  bool status;
  List<ChartData> data;
  List<String> categories;

  MedicineUsageChartResp({
    this.status = false,
    this.data = const <ChartData>[],
    this.categories = const <String>[],
  });

  factory MedicineUsageChartResp.fromJson(Map<String, dynamic> json) {
    return MedicineUsageChartResp(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List
          ? List<ChartData>.from(json['data'].map((x) => ChartData.fromJson(x)))
          : [],
      categories: json['categories'] is List
          ? List<String>.from(json['categories'].map((x) => x))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e).toList(),
    };
  }
}

class ChartData {
  String name;
  List<int> data;

  ChartData({
    this.name = "",
    this.data = const <int>[],
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      name: json['name'] is String ? json['name'] : "",
      data: json['data'] is List
          ? List<int>.from(json['data'].map((x) => x))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data.map((e) => e).toList(),
    };
  }
}
