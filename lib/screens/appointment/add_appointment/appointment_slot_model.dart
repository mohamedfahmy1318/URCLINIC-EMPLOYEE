class TimeSlotsRes {
  bool status;
  String message;
  List<String> slots;

  TimeSlotsRes({
    this.status = false,
    this.message = "",
    this.slots = const <String>[],
  });

  factory TimeSlotsRes.fromJson(Map<String, dynamic> json) {
    return TimeSlotsRes(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      slots: json['data'] is List ? List<String>.from(json['data'].map((x) => x)) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': slots.map((e) => e).toList(),
    };
  }
}

class Session {
  String sessionTitle;
  List<SlotElement> slots;

  Session({
    this.sessionTitle = "",
    this.slots = const <SlotElement>[],
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionTitle: json['session_title'] is String ? json['session_title'] : "",
      slots: json['slots'] is List ? List<SlotElement>.from(json['slots'].map((x) => SlotElement.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_title': sessionTitle,
      'slots': slots.map((e) => e.toJson()).toList(),
    };
  }
}

class SlotElement {
  String time;
  bool available;

  SlotElement({
    this.time = "",
    this.available = false,
  });

  factory SlotElement.fromJson(Map<String, dynamic> json) {
    return SlotElement(
      time: json['time'] is String ? json['time'] : "",
      available: json['available'] is bool ? json['available'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'available': available,
    };
  }
}
