import '../../../../clinic/add_clinic_form/model/clinic_session_response.dart';

class WeekListModel {
  String day;
  String startTime;
  String endTime;
  int isHoliday;
  List<BreakListModel> breaks;

  WeekListModel({
    this.day = "",
    this.startTime = "",
    this.endTime = "",
    this.isHoliday = 1,
    this.breaks = const <BreakListModel>[],
  });

  factory WeekListModel.fromJson(Map<String, dynamic> json) {
    return WeekListModel(
      day: json['day'] is String ? json['day'] : "",
      startTime: json['start_time'] is String ? json['start_time'] : "",
      endTime: json['end_time'] is String ? json['end_time'] : "",
      isHoliday: json['is_holiday'] is int ? json['is_holiday'] : 1,
      breaks: json['breaks'] is List ? List<BreakListModel>.from(json['breaks'].map((x) => BreakListModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'is_holiday': isHoliday,
      'breaks':  breaks.map((e) => e.toJson()).toList(),
    };
  }
}
