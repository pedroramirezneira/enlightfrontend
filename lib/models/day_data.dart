import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/timeslot_data.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class DayData {
  final String name;
  List<TimeslotData> timeslots;
}
