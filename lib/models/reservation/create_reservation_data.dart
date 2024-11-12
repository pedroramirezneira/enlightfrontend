import 'package:enlight/macros/data_class.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class CreateReservationData {
  final int timeslotId;
  final String date;
  final String modality;
}
