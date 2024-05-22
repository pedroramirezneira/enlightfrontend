class TimeslotData {
  final int id;
  String startTime;
  String endTime;

  TimeslotData({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  factory TimeslotData.fromJson(Map<String, dynamic> json) {
    return TimeslotData(
      id: json["id"] ?? 0,
      startTime: json["start_time"],
      endTime: json["end_time"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "start_time": startTime,
      "end_time": endTime,
    };
  }
}
