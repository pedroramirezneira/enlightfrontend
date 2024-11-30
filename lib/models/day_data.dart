import 'package:enlight/models/timeslot_data.dart';

class DayData {
  final String name;
  List<TimeslotData> timeslots;

  DayData({
    required this.name,
    required this.timeslots,
  });

  factory DayData.fromJson(Map<String, dynamic> json) {
    return DayData(
      name: json['name'],
      timeslots: json['timeslots']
          .map<TimeslotData>((timeslot) => TimeslotData.fromJson(timeslot))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'timeslots': timeslots.map((timeslot) => timeslot.toJson()).toList(),
    };
  }
}
