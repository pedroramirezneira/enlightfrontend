import 'package:enlight/models/timeslot_data.dart';
import 'package:json/json.dart';

@JsonCodable()
class DayData {
  final String name;
  List<TimeslotData> timeslots;

  DayData({
    required this.name,
    required this.timeslots,
  });
}
