// ignore_for_file: non_constant_identifier_names

class TimeslotData {
  final int id;
  String start_time;
  String end_time;

  TimeslotData({
    required this.id,
    required this.start_time,
    required this.end_time,
  });

  factory TimeslotData.fromJson(Map<String, dynamic> json) {
    return TimeslotData(
      id: json['id'],
      start_time: json['start_time'],
      end_time: json['end_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': start_time,
      'end_time': end_time,
    };
  }
}
