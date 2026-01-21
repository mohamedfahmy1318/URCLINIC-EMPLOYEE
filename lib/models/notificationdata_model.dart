class NotificationData {
  NotificationData({
    required this.app,
    required this.discription,
    required this.date,
  
  });

  String app;
  String discription;
  String date;


  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        app: json["app"] ?? '',
        discription: json["discription"] ?? '',
        date: json["date"] ?? '',
   
      );

  Map<String, dynamic> toJson() => {
        "app": app,
        "discription": discription,
        "date": date,
      
      };
}
