import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/timeslot_data.dart';

@DataClass()
class TimeslotMenuData {
  List<String> days;
  TimeslotData timeslot;
}
