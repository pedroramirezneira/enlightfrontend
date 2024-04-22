import 'package:enlight/models/timeslot_data.dart';

class DayData {
  final String name;
  List<TimeslotData> timeslots;

  DayData({
    required this.name,
    required this.timeslots,
  });

  factory DayData.fromJson(Map<String, dynamic> json) {
    List<dynamic> timeslots = json["timeslots"];
    return DayData(
      name: json["name"],
      timeslots:
          timeslots.map((timeslot) => TimeslotData.fromJson(timeslot)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "timeslots": timeslots.map((timeslot) => timeslot.toJson()).toList(),
    };
  }
}
