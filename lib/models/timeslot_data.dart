import 'package:enlight/macros/data_class.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class TimeslotData {
  final int id;
  // ignore: non_constant_identifier_names
  String start_time;
  // ignore: non_constant_identifier_names
  String end_time;
}
